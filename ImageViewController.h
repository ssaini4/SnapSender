//
//  ImageViewController.h
//  Moustache
//
//  Created by Saksham Saini on 7/12/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ImageViewController : UIViewController
@property(nonatomic,strong)PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
