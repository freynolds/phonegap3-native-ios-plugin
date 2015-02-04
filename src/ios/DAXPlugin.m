#import "DAXPlugin.h"
#import "AppDelegate.h"
#import "CSComScore.h"
#import <Cordova/CDV.h>

@implementation DAXPlugin
- (void) initDAX:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString    *callbackId = [arguments pop];
    
    
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

-(void) exitDAX: (NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString    *callbackId = [arguments pop];
    
	
    [self successWithMessage:@"nothing" toID:callbackId];
}

- (void) trackEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString        *callbackId = [arguments pop];
    NSString        *eventLabel = [arguments objectAtIndex:2];
    NSInteger       eventValue = [[arguments objectAtIndex:3] intValue];
    
    
    [CSComScore hiddenWithLabels:[NSDictionary dictionaryWithObjectsAndKeys:
                                  eventLabel, eventValue,
                                  nil]];
    

    [self successWithMessage:[NSString stringWithFormat:@"trackEvent: label = %@; value = %d", eventLabel, eventValue] toID:callbackId];
}

- (void) trackPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options
{
    NSString            *callbackId = [arguments pop];
    NSString            *pageURL = [arguments objectAtIndex:0];

    [CSComScore viewWithLabels:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"my.view.name", pageURL,
                                nil]];
    
    [self successWithMessage:[NSString stringWithFormat:@"trackPage: url = %@", pageURL] toID:callbackId];

}

-(void)successWithMessage:(NSString *)message toID:(NSString *)callbackID
{
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    
    [self writeJavascript:[commandResult toSuccessCallbackString:callbackID]];
}

-(void)failWithMessage:(NSString *)message toID:(NSString *)callbackID withError:(NSError *)error
{
    NSString        *errorMessage = (error) ? [NSString stringWithFormat:@"%@ - %@", message, [error localizedDescription]] : message;
    CDVPluginResult *commandResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
    
    [self writeJavascript:[commandResult toErrorCallbackString:callbackID]];
}

@end
