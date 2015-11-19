//
//  InboxViewController.h
//  Moustache
//
//  Created by Saksham Saini on 6/28/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
@interface InboxViewController : UITableViewController
- (IBAction)logout:(id)sender;
@property(nonatomic,strong) NSArray *messages;
@property(nonatomic,strong) PFObject *selectedMessage;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@end
