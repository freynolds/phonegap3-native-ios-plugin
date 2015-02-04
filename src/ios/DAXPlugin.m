#import "DAXPlugin.h"
#import "AppDelegate.h"
#import "CSComScore.h"
#import <Cordova/CDV.h>

@implementation DAXPlugin
- (void) initDAX: (CDVInvokedUrlCommand*)command;
{
    NSString    *callbackId = command.callbackId;
    
    
    [CSComScore setCustomerC2:@"17502533"];
    [CSComScore setPublisherSecret:@"5cd879f6af29490ad5a396777016c33f"];
    [CSComScore setAppName:@"FansWorld"];
    [CSComScore allowLiveTransmission:CSDEFAULTMODE];
    [CSComScore allowOfflineTransmission:CSDEFAULTMODE];
    [CSComScore setAppContext];
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
    NSString        *callbackId = command.callbackId;
    NSString        *eventLabel = [command.arguments objectAtIndex:2];
    NSInteger       eventValue = [[command.arguments objectAtIndex:3] intValue];
    
    
    [CSComScore hiddenWithLabels:[NSDictionary dictionaryWithObjectsAndKeys:
                                  eventLabel, eventValue,
                                  nil]];
    

    [self successWithMessage:[NSString stringWithFormat:@"trackEvent: label = %@; value = %d", eventLabel, eventValue] toID:callbackId];
}

- (void) trackPage: (CDVInvokedUrlCommand*)command;
{
    NSString            *callbackId = command.callbackId;
    NSString            *pageURL = [command.arguments objectAtIndex:0];

    [CSComScore viewWithLabels:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"my.view.name", pageURL,
                                nil]];
    
    [self successWithMessage:[NSString stringWithFormat:@"trackPage: url = %@", pageURL] toID:callbackId];

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
