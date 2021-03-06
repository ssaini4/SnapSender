//
//  EditFriendsTableViewController.m
//  Moustache
//
//  Created by Saksham Saini on 7/1/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import "EditFriendsTableViewController.h"
@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query= [PFUser query];
   [ query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if(error)
        {
            NSLog(@"%@ %@",error,[error userInfo]);
        }
        else{
            self.allUsers=objects;
            [self.tableView reloadData];
        }
    }];
    self.currentUser=[PFUser currentUser];

   }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    PFUser *user= [self.allUsers objectAtIndex:indexPath.row];
     PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    if([self isFriend:user])
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
        for(PFUser *friend in self.friends)
        {
            if([friend.objectId isEqualToString:user.objectId])
            {
                [self.friends removeObject:friend];
                break;
            }
        }
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;

        [friendsRelation addObject:user];
        [self.friends addObject:user];
    }
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            NSLog(@"%@ %@",error,[error userInfo]);
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [self.allUsers count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFUser *user= [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text=user.username;
    if([self isFriend:user])
    {
        cell.accessoryType= UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    return cell;
}
-(BOOL) isFriend:(PFUser *)user{
    for(PFUser *friend in self.friends)
    {
        if([friend.objectId isEqualToString:user.objectId])
            return YES;
    }
    return NO;
}

@end
