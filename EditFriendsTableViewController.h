//
//  EditFriendsTableViewController.h
//  Moustache
//
//  Created by Saksham Saini on 7/1/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface EditFriendsTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
- (BOOL)isFriend:(PFUser *)user;
@property (nonatomic,strong) NSMutableArray *friends;

@end
