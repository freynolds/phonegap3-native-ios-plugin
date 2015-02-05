//
//  CDVVideo.m
//
//
//  Created by Peter Robinett on 2012-10-15.
//	Modifed by Francis Reynolds on 2014-02-05
//
//

#import "CDVVideo.h"
#import "MediaPlayer/MPMoviePlayerViewController.h"
#import "MediaPlayer/MPMoviePlayerController.h"
#import <Cordova/CDV.h>

@implementation CDVVideo


- (void)pluginInitialize {
    
    if (CDV_IsIPad()) {
        width = 730;
        height = 412;
    } else {
        width = 320;
        height = 180;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MovieDidExitFullScreen:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
    
    self.player.view.frame = CGRectMake(0, 61, width, height);
    self.player.view.hidden = true;
    self.player.moviePlayer.fullscreen = false;
    self.player.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    
    [self.viewController.view addSubview:self.player.view];
    
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(keyboardWillShowOrHide:)
               name:UIKeyboardWillShowNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(keyboardWillShowOrHide:)
               name:UIKeyboardWillHideNotification
             object:nil];
    
}

- (void)play:(CDVInvokedUrlCommand*)command {
    
    callback = command.callbackId;
    movie = [command.arguments objectAtIndex:0];
    if (self.player) {
        self.player.moviePlayer.contentURL = [NSURL URLWithString:movie];
        [self.player.moviePlayer play];
        self.player.view.hidden = FALSE;
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        return;
    } else {
        self.player =  [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:movie]];
    }
}

- (void)MovieDidFinish:(NSNotification *)notification {
    if (![callback isEqualToString:@"INVALID"]) {
        [super writeJavascript:[[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1] toSuccessCallbackString:callback]];
    }
}

- (void)MovieDidExitFullScreen:(NSNotification *)notification {
    self.player.view.frame = CGRectMake(0, 61, width, height);
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)show:(CDVInvokedUrlCommand*)command {
    if (!self.player) {
        return;
    }
    self.player.view.hidden = FALSE;
    [self.player.moviePlayer play];
}

- (void)hide:(CDVInvokedUrlCommand*)command {
    if (!self.player) {
        return;
    }
    self.player.view.hidden = TRUE;
    [self.player.moviePlayer pause];
}

- (void)destroy:(CDVInvokedUrlCommand*)command {
    if (!self.player) {
        return;
    }
    NSLog(@"Destroy video player");
    [self.player.view removeFromSuperview];
    self.player = nil;
}

- (void)keyboardWillShowOrHide:(NSNotification*)notif
{
    NSLog(@"Show/Hide Keyboard");
    BOOL showEvent = [notif.name isEqualToString:UIKeyboardWillShowNotification];
    
    CGRect keyboardFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [self.viewController.view convertRect:keyboardFrame fromView:nil];
    
    CGRect newPlayerFrame = self.player.view.frame;
    
    if (showEvent) {
        newPlayerFrame.origin.y = 61 - keyboardFrame.size.height;
    } else {
        newPlayerFrame.origin.y = 61;
    }
    
    self.player.view.frame = newPlayerFrame;
}

@end