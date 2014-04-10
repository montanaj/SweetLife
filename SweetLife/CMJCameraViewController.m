//
//  CMJCameraViewController.m
//  EwwKittens
//
//  Created by Jaime Hernandez on 4/8/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "CMJCameraViewController.h"
#import <Parse/Parse.h>

@interface CMJCameraViewController ()

@end

@implementation CMJCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Im here at the camera .. .. .");
    
    // Need to dismiss the toolbar thingy -> also small screen?
    
    // Does this device have a camera? If no hardware support is there message and exit - this is
    // for testing basically
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        [myAlertView show];
    }
}


- (IBAction)takePhoto:(id)sender
{
    
    // prepare controller to take picture
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // lets get the image and pass it along
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    // Persist data to local device in the photo album - do I really need all these nil's .. .. .
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, nil, nil, nil);
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(chosenImage)];
    
    PFObject *object = [PFObject objectWithClassName:@"Photo"];
    PFFile   *file   = [PFFile fileWithData:imageData];
    
    [object setObject:[PFUser currentUser] forKey:@"user"];
    
    [object setObject:file forKey:@"image"];
    [object saveInBackground];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
