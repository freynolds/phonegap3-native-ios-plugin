#import <Cordova/CDV.h>

@interface DAXPlugin : CDVPlugin
{
    BOOL    inited;
}

- (void) initDAX:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) exitDAX: (NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) trackEvent:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) trackPage:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
