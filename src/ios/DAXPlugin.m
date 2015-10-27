#import "DaxPlugin.h"
#import "AppDelegate.h"
#import "CSComScore.h"
#import <Cordova/CDV.h>

@implementation DaxPlugin
- (void) initDAX: (CDVInvokedUrlCommand*)command;
{
    NSString    *callbackId = command.callbackId;
    
    [CSComScore setAppContext];
    [CSComScore setCustomerC2:@"17502533"];
    [CSComScore setPublisherSecret:@"5cd879f6af29490ad5a396777016c33f"];
    [CSComScore setAppName:@"FansWorld"];
    [CSComScore allowLiveTransmission:CSDEFAULTMODE];
    [CSComScore allowOfflineTransmission:CSDEFAULTMODE];
    [CSComScore setLabel:@"ns_site" value:@"fwtvmobile"];
    [CSComScore start];
    
    inited = YES;
    
    [self successWithMessage: @"ok" toID:callbackId];
}

-(void) exitDAX: (CDVInvokedUrlCommand*)command;
{
    NSString    *callbackId = command.callbackId;
    
    
    [self successWithMessage:@"nothing" toID:callbackId];
}

- (void) trackEvent: (CDVInvokedUrlCommand*)command;
{
    NSString            *callbackId = command.callbackId;
    NSMutableDictionary *data = [command.arguments objectAtIndex:0];
    
    
    [CSComScore hiddenWithLabels: data];
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:callbackId];
}

- (void) trackPage: (CDVInvokedUrlCommand*)command;
{
    NSString            *callbackId = command.callbackId;
    NSMutableDictionary *data = [command.arguments objectAtIndex:0];
    
    
    [CSComScore viewWithLabels: data];
    
    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:callbackId];
    
}

-(void)successWithMessage:(NSString *)message toID:(NSString *)callbackID
{
    // CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    
    // [self writeJavascript:[commandResult toSuccessCallbackString:callbackID]];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
}

-(void)failWithMessage:(NSString *)message toID:(NSString *)callbackID withError:(NSError *)error
{
    // CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
    
    // [self writeJavascript:[commandResult toErrorCallbackString:callbackID]];
    
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
}

@end
