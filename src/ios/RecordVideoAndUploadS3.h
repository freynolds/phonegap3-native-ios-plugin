#import <Cordova/CDV.h>

@interface RecordVideoAndUploadS3 : CDVPlugin
	<UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

- (void)open:(CDVInvokedUrlCommand*)command;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionUploadTask *uploadTask;
@property (strong, nonatomic) NSURL *uploadFileURL;
@property (strong, nonatomic) NSString *uploadFileName;
@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) NSString *callbackId;

@end