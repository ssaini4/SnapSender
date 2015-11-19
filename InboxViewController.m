//
//  InboxViewController.m
//  Moustache
//
//  Created by Saksham Saini on 6/28/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import "InboxViewController.h"
#import"ImageViewController.h"
@interface InboxViewController ()

@end

@implementation InboxViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moviePlayer=[[MPMoviePlayerViewController alloc]init];
    PFUser *currentUser= [PFUser currentUser];
    if(currentUser)
    {
        NSLog(@"Current user:%@",currentUser.username);
        
    }
    else
    {

    [self performSegueWithIdentifier:@"showLogin" sender:self];
    }}

#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([PFUser currentUser]){
    PFQuery *query= [PFQuery queryWithClassName:@"Messages"];
    if(query!=NULL)
    { [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];}
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            NSLog(@"Error: %@ %@",error,[error userInfo]);
            
        }
        else
        {
            self.messages=objects;
            [self.tableView reloadData];
            NSLog(@"Retrieved %d messages",[self.messages count]);
            
        }
        
    
    }];}
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    PFObject *message=[self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text=[message objectForKey:@"senderName"];
    NSString *fileType =[message objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"])
    {
        cell.imageView.image =[UIImage imageNamed:@"image"];
    }
    else{
        cell.imageView.image=[UIImage imageNamed:@"video"];
    }
    return cell;
}
- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showLogin"])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if([segue.identifier isEqualToString:@"showImage"])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController = (ImageViewController *) segue.destinationViewController;
        imageViewController.message=self.selectedMessage;
    }
}
-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   self.selectedMessage=[self.messages objectAtIndex:indexPath.row];
    NSString *fileType =[self.selectedMessage objectForKey:@"fileType"];

    if([fileType isEqualToString:@"image"])
    {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else{
        PFFile *videoFile= [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl= [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL=fileUrl;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
        
        
    }
    NSMutableArray *recipientIds= [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"Recipients: %@",recipientIds);
    if([recipientIds count]==1)
    {
        [self.selectedMessage deleteInBackground];
        //delete it
    }
    else{
        [recipientIds removeObject:[[PFUser currentUser]objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }

}
@end
