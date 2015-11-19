//
//  CameraTableViewController.m
//  Moustache
//
//  Created by Saksham Saini on 7/2/14.
//  Copyright (c) 2014 Sworks. All rights reserved.
//

#import "CameraTableViewController.h"
#import<MobileCoreServices/MobileCoreServices.h>
@interface CameraTableViewController ()

@end

@implementation CameraTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation=[[PFUser currentUser]objectForKey:@"friendsRelation"];
    self.recipients=[[NSMutableArray alloc]init];
   }

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PFQuery *query= [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error)
        {
            NSLog(@"%@ %@",error, [error userInfo]);
        }
        else{
            self.friends=objects;
            [self.tableView reloadData];
        }
    }];
    if(self.image==nil && [self.videoFilePath length]==0)
    {
        self.imagePicker=[[UIImagePickerController alloc] init];
        self.imagePicker.delegate=self;
        self.imagePicker.allowsEditing=NO;
        self.imagePicker.videoMaximumDuration= 10;

        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            self.imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes=[UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser *user= [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text=user.username;
    if([self.recipients containsObject:user.objectId])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        
    }
    else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    // Configure the cell...
    
    return cell;
}


-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user=[self.friends objectAtIndex:indexPath.row];
    if(cell.accessoryType==UITableViewCellAccessoryNone)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
        
    }
    else{
        cell.accessoryType= UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Image Picker Controller Delegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}
-(void ) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        //photo was taken or selected
        self.image= [info objectForKey:UIImagePickerControllerOriginalImage];
        if(self.imagePicker.sourceType==UIImagePickerControllerSourceTypeCamera)
        {
            //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
            
        }
        
    }
    else{
        self.videoFilePath=(__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL ]path]);
        if(self.imagePicker.sourceType==UIImagePickerControllerSourceTypeCamera)
        { if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath))
            //save the image
            {
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark IBActions

- (IBAction)cancel:(id)sender {
    [self reset];
    [self.tabBarController setSelectedIndex:0];
    
}

- (IBAction)send:(id)sender {
    if(self.image==nil && [self.videoFilePath length]==0)
    {
        UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"Try Again!" message:@"Please capture or select a photo or video to share!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
        
    }
    else
    {
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
        
    }
}
+(void) login{
    
}
#pragma mark - Helper Functions
-(void) uploadMessage{
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    if(self.image!=nil) {
        UIImage *newImage= [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData =UIImagePNGRepresentation(newImage);
        fileName=@"image.png";
        fileType=@"image";
    }
    else{
        fileData=[NSData dataWithContentsOfFile:self.videoFilePath];
        fileName=@"video.mov";
        fileType=@"video";
        
    }
    PFFile *file= [PFFile fileWithName:fileName data:fileData];

    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            PFObject *message= [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(error)
                {UIAlertView *alertView= [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                }
                else{
                    [self reset];

                }
            }];
            
            
        }
    }];
    //Check if image or video
    //If image, shrink it
    //Upload file itself
    //Upload message details
    
}
- (void)reset {
    self.image=nil;
    self.videoFilePath=nil;
    [self.recipients removeAllObjects];
}
-(UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height
{
    CGSize newSize=CGSizeMake(width, height);
    CGRect newRect= CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRect];
    UIImage *resizedImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;

    
}
@end
