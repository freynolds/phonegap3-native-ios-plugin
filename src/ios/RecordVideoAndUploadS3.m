#import "RecordVideoAndUploadS3.h"
#import <Cordova/CDV.h>

@implementation RecordVideoAndUploadS3

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

        if ([videoMediaTypesOnly count] == 0)		//Is movie output possible?
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
		videoRecorder.videoMaximumDuration = 60;			//Specify in seconds (600 is default)

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

@end