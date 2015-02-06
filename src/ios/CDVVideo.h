//
//  CDVVideo.h
//
//
//  Created by Peter Robinett on 2012-10-15.
//
//

#import <Cordova/CDV.h>

@interface CDVVideo : CDVPlugin {
    NSString *callback;
    NSString *movie;
    NSInteger width;
    NSInteger height;
    BOOL restart;
}

- (void)play:(CDVInvokedUrlCommand*)command;

@end