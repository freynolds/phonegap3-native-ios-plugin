//
//  SharePlugin.h
//  GoSocial
//
//  Created by Francisco Reynolds on 05/02/2014.
//  Copyright (c) 2012 Adobe Systems, Inc. All rights reserved.
//

#import <Cordova/CDV.h>

@interface SharePlugin : CDVPlugin <UIActionSheetDelegate>
{
    NSMutableArray *self_arguments;
}

- (void) show:(CDVInvokedUrlCommand*)command;

@end
