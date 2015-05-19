#import <Cordova/CDV.h>

@interface RecordVideoAndUploadS3 : CDVPlugin
	<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)sayHello:(CDVInvokedUrlCommand*)command;

@end