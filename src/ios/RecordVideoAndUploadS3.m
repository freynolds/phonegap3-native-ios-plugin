#import "RecordVideoAndUploadS3.h"
#import <Cordova/CDV.h>
#import "AWSS3.h"
#import <AVFoundation/AVFoundation.h>

@implementation RecordVideoAndUploadS3


- (void)pluginInitialize {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    
    
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    
    if (uuid) {
        self.uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        CFRelease(uuid);
    }

    
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                    identityPoolId:@"us-east-1:f3e85ccf-981f-4385-91bc-baa3f539b76c"];
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                         credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"com.fwtv.client"];
        session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    });
    self.session = session;
}

// - (void)sayHello:(CDVInvokedUrlCommand*)command
// {
//   CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Hello - that's your plugin :)"];
//   [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
// }


//*****************************************
//*****************************************
//********** RECORD VIDEO BUTTON **********
//*****************************************
//*****************************************
// - (IBAction)RecordVideoButton:(id)sender
- (void)open:(CDVInvokedUrlCommand*)command
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *videoRecorder = [[UIImagePickerController alloc] init];
        videoRecorder.sourceType = UIImagePickerControllerSourceTypeCamera;
        videoRecorder.delegate = self;

        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        NSArray *videoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"movie"]];

        if ([videoMediaTypesOnly count] == 0)       //Is movie output possible?
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sorry but your device does not support video recording"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet showInView:self.viewController.view];
    }
    else
    {
        //Select front facing camera if possible
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
            videoRecorder.cameraDevice = UIImagePickerControllerCameraDeviceFront;

        videoRecorder.mediaTypes = videoMediaTypesOnly;
        videoRecorder.videoQuality = UIImagePickerControllerQualityType640x480;
        videoRecorder.videoMaximumDuration = 60;            //Specify in seconds (600 is default)

            [self.viewController presentViewController:videoRecorder animated:YES completion:nil];
        }
    }
    else
    {
        //No camera is availble
        NSLog(@"No camera is availble");
    }
}

//***************************************
//***************************************
//********** RECORD VIDEO DONE **********
//***************************************
//***************************************
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    //Save the movie
    NSLog(@"Video recorded: %@", info);
    
    NSURL *file_url = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSString *videoPath1 = @"";
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:file_url options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:AVAssetExportPresetPassthrough];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        // NSTimeInterval is defined as double
        NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        
        self.uploadFileName = [NSString stringWithFormat:@"%@-%@%@", self.uuid, timeStampObj, @".mp4"];
        
        videoPath1 = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], self.uploadFileName];
        exportSession.outputURL = [NSURL fileURLWithPath:videoPath1];
        NSLog(@"videopath of your mp4 file = %@",videoPath1);  // PATH OF YOUR .mp4 FILE
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        //  CMTime start = CMTimeMakeWithSeconds(1.0, 600);
        //  CMTime duration = CMTimeMakeWithSeconds(3.0, 600);
        //  CMTimeRange range = CMTimeRangeMake(start, duration);
        //   exportSession.timeRange = range;
        //  UNCOMMENT ABOVE LINES FOR CROP VIDEO
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            
            switch ([exportSession status]) {
                    
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"Export failed: %@", [[exportSession error] localizedDescription]);
                    
                    break;
                    
                case AVAssetExportSessionStatusCancelled:
                    
                    NSLog(@"Export canceled");
                    
                    break;
                    
                default:
                    NSLog(@"Export success!");
                    self.uploadFileURL = exportSession.outputURL;
                    [self uploadVideo];
                    break;
                    
            }
            UISaveVideoAtPathToSavedPhotosAlbum(videoPath1, self, nil, nil);
            
        }];
        
    }
    
    
    
}

//*****************************************
//*****************************************
//********** RECORD VIDEO CANCEL **********
//*****************************************
//*****************************************
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



//*****************************************
//*****************************************
//********** UPLOAD STATUS STUFF **********
//*****************************************
//*****************************************

- (void)uploadVideo {
    if (self.uploadTask)
    {
        return;
    }
    
    AWSS3GetPreSignedURLRequest *getPreSignedURLRequest = [AWSS3GetPreSignedURLRequest new];
    getPreSignedURLRequest.bucket = @"fwtv-recordings";
    getPreSignedURLRequest.key = self.uploadFileName,
    getPreSignedURLRequest.HTTPMethod = AWSHTTPMethodPUT;
    getPreSignedURLRequest.expires = [NSDate dateWithTimeIntervalSinceNow:3600];
    
    //Important: must set contentType for PUT request
    NSString *fileContentTypeStr = @"text/plain";
    getPreSignedURLRequest.contentType = fileContentTypeStr;
    
    [[[AWSS3PreSignedURLBuilder defaultS3PreSignedURLBuilder] getPreSignedURL:getPreSignedURLRequest] continueWithBlock:^id(BFTask *task) {
        
        if (task.error) {
            NSLog(@"Error: %@",task.error);
        } else {
            
            NSURL *presignedURL = task.result;
            NSLog(@"upload presignedURL is: \n%@", presignedURL);
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:presignedURL];
            request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
            [request setHTTPMethod:@"PUT"];
            [request setValue:fileContentTypeStr forHTTPHeaderField:@"Content-Type"];
            
            self.uploadTask = [self.session uploadTaskWithRequest:request fromFile:self.uploadFileURL];
            [self.uploadTask resume];
            
        }
        
        return nil;
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
    double progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
    
    NSLog(@"UploadTask progress: %lf", progress);
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.progressView.progress = progress;
//        self.statusLabel.text = @"Uploading...";
//    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    
    if (!error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.statusLabel.text = @"Upload successfully";
//        });
        NSLog(@"S3 UploadTask: %@ completed successfully", task);
    }else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.statusLabel.text = @"Upload failed.";
//        });
        NSLog(@"S3 UploadTask: %@ completed with error: %@", task, [error localizedDescription]);
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.progressView.progress = (double)task.countOfBytesSent / (double)task.countOfBytesExpectedToSend;;
//    });
    
    self.uploadTask = nil;
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    if (appDelegate.backgroundUploadSessionCompletionHandler) {
//        void (^completionHandler)() = appDelegate.backgroundUploadSessionCompletionHandler;
//        appDelegate.backgroundUploadSessionCompletionHandler = nil;
//        completionHandler();
//    }
    
    NSLog(@"Completion Handler has been invoked, background upload task has finished.");
}




@end