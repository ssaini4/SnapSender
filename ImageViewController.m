//
//  ImageViewController.m
//  Moustache
//
//  Created by Saksham Saini on 7/12/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFFile *imageFile= [self.message objectForKey:@"file"];
    NSURL *imageFileUrl=[[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData=[NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image=[UIImage imageWithData:imageData];
   
    NSString *senderName= [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"Send from %@", senderName];
    self.navigationItem.title=title;
    
    // Do any additional setup after loading the view.
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timeOut) userInfo:nil repeats:NO];
}
#pragma mark - Helper methods
-(void) timeOut
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
