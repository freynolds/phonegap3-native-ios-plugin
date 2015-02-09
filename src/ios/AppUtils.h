#import <Cordova/CDV.h>

@interface AppUtils : CDVPlugin

- (void) getAppVersion:(CDVInvokedUrlCommand*)command;
- (void) getBundleId:(CDVInvokedUrlCommand*)command;
- (void) sendToApp:(CDVInvokedUrlCommand*)command;
@end