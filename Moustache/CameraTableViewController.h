//
//  CameraTableViewController.h
//  Moustache
//
//  Created by Saksham Saini on 7/2/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<Parse/Parse.h>


@interface CameraTableViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic,strong) UIImagePickerController *imagePicker;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)NSString *videoFilePath;
@property(nonatomic,strong) NSArray *friends;
@property(nonatomic,strong) PFRelation *friendsRelation;
-(void) uploadMessage;
@property(nonatomic,strong) NSMutableArray *recipients;
- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height;

@end
