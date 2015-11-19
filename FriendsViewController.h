//
//  FriendsViewController.h
//  Moustache
//
//  Created by Saksham Saini on 7/2/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<Parse/Parse.h>

@interface FriendsViewController : UITableViewController
@property (nonatomic, strong) PFRelation *friendsRelation;
@property(nonatomic,strong) NSArray *friends;
@end
