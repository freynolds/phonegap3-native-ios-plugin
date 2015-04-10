//
//  DAXPlugin.m
//  GA
//
//  Created by Bob Easterday on 10/9/12.
//  Copyright (c) 2012 Adobe Systems, Inc. All rights reserved.
//

#import "SharePlugin.h"
#import "AppDelegate.h"
#import "Social/Social.h"

@implementation SharePlugin

- (void) show:(CDVInvokedUrlCommand*)command
{
    
    self_arguments = [[NSMutableArray alloc]initWithArray:command.arguments];
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Compartir en:" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:
                            @"Facebook",
                            @"Twitter",
                            @"WhatsApp",
                            nil];
    
    [popup showInView:self.viewController.view];
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *text = [[self_arguments objectAtIndex:0] objectForKey:@"text"];
    NSString *urlAttach = [[self_arguments objectAtIndex:0] objectForKey:@"urlAttach"];
    NSString *imageAttach = [[self_arguments objectAtIndex:0] objectForKey:@"imageAttach"];
    
    switch (buttonIndex) {
        case 0: {
            NSLog(@"Facebook");
            dispatch_async(dispatch_get_main_queue(), ^ {
                
                SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                
                SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                    
                    [fbController dismissViewControllerAnimated:YES completion:nil];
                    
                    switch(result){
                        case SLComposeViewControllerResultCancelled:
                        default:
                        {
                            NSLog(@"Cancelled.....");
                            
                        }
                            break;
                        case SLComposeViewControllerResultDone:
                        {
                            NSLog(@"Posted....");
                        }
                            break;
                    }};
                [fbController setInitialText:text];
                if(imageAttach != nil){
                    [fbController addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageAttach]]]];
                }
                if(urlAttach != nil && imageAttach == nil){
                    [fbController addURL:[NSURL URLWithString:urlAttach]];
                }
                [fbController setCompletionHandler:completionHandler];
                [self.viewController presentViewController:fbController animated:YES completion:nil];
            });
            
            break;
        }
        case 1: {
            NSLog(@"Twitter");
            dispatch_async(dispatch_get_main_queue(), ^ {
                
                SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                    
                    [tweetViewController dismissViewControllerAnimated:YES completion:nil];
                    
                    switch(result){
                        case SLComposeViewControllerResultCancelled:
                        default:
                        {
                            NSLog(@"Cancelled.....");
                            
                        }
                            break;
                        case SLComposeViewControllerResultDone:
                        {
                            NSLog(@"Posted....");
                        }
                            break;
                    }};
                
                
                BOOL ok = YES;
                NSString *errorMessage;
                
                if(text != nil){
                    ok = [tweetViewController setInitialText:text];
                    if(!ok){
                        errorMessage = @"Tweet is too long";
                    }
                }
                
                
                
                if(imageAttach != nil){
                    // Note that the image is loaded syncronously
                    if([imageAttach hasPrefix:@"http://"]){
                        UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageAttach]]];
                        ok = [tweetViewController addImage:img];
                    }
                    else{
                        ok = [tweetViewController addImage:[UIImage imageNamed:imageAttach]];
                    }
                    if(!ok){
                        errorMessage = @"Image could not be added";
                    }
                }
                
                if(urlAttach != nil){
                    ok = [tweetViewController addURL:[NSURL URLWithString:urlAttach]];
                    if(!ok){
                        errorMessage = @"URL too long";
                    }
                }
                
                
                
                if(!ok){
                    NSLog(@"%@",errorMessage);
                }
                else{
                    
                    [tweetViewController setCompletionHandler:completionHandler];
                    [self.viewController presentViewController:tweetViewController animated:YES completion:nil];
                }
                
            });
            break;
        }
        case 2: {
            NSLog(@"Whatsapp");
            
            NSString *unescapedString = [NSString stringWithFormat:@"%@ %@",text, urlAttach];
            
            NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                            NULL,
                                                                                                            (CFStringRef)unescapedString,
                                                                                                            NULL,
                                                                                                            CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                            kCFStringEncodingUTF8));
            
            NSString *whastappURLString = [@"whatsapp://send?text=" stringByAppendingString:escapedString];
            
            NSURL *whatsappURL = [NSURL URLWithString:whastappURLString];
            
            
            if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
                [[UIApplication sharedApplication] openURL: whatsappURL];
            }
        }
        default:
            break;
    }
}


@end
