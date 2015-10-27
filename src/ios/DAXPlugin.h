#import <Cordova/CDV.h>

@interface DaxPlugin : CDVPlugin
{
    BOOL    inited;
}

- (void) initDAX: (CDVInvokedUrlCommand*)command;
- (void) exitDAX: (CDVInvokedUrlCommand*)command;
- (void) trackEvent: (CDVInvokedUrlCommand*)command;
- (void) trackPage: (CDVInvokedUrlCommand*)command;

@end