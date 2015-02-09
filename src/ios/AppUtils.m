#import "AppUtils.h"
#import <Cordova/CDV.h>

@implementation AppUtils

- (void)sayHello:(CDVInvokedUrlCommand*)command {
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Hello - that's your plugin :)"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getAppVersion:(CDVInvokedUrlCommand*)command {

    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getBundleId:(CDVInvokedUrlCommand*)command {

    NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: bundle];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) sendToApp:(CDVInvokedUrlCommand*)command {
    
    NSString* appStoreUrlString = [command.arguments objectAtIndex:0];
    NSString* appUriString = [command.arguments objectAtIndex:1];
    
    if ([appStoreUrlString isEqual:@""] || [appUriString isEqual:@""]) {
        return;
    }
    
    NSURL* appStoreUrl = [NSURL URLWithString:appStoreUrlString];
    NSURL* appUri = [NSURL URLWithString:appUriString];
    
    UIApplication *ourApplication = [UIApplication sharedApplication];

    if ([ourApplication canOpenURL:appUri]) {
        [ourApplication openURL:appUri];
        NSLog(@"Open app");
    } else if ([ourApplication canOpenURL:appStoreUrl]) {
        [ourApplication openURL:appStoreUrl];
        NSLog(@"Open app store");
    } else {
        NSLog(@"Can't open both");
    }
    
}

@end