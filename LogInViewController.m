//
//  LogInViewController.m
//  Moustache
//
//  Created by Saksham Saini on 6/30/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
@interface LogInViewController ()

@end

@implementation LogInViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES;
    // Do any additional setup after loading the view.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logInButton:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password= [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    if([username length]==0||[password length]==0)
    {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
        
    }
    else{
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            if(error){
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            }
            else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}
@end
