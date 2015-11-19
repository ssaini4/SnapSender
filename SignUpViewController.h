//
//  SignUpViewController.h
//  Moustache
//
//  Created by Saksham Saini on 6/30/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
- (IBAction)signUpButton:(id)sender;

@end
