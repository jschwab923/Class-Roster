//
//  NAYDetailViewController.m
//  FirstDayDemo
//
//  Created by Jeff Schwab on 1/13/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "NAYDetailViewController.h"
#import "NAYTableViewController.h"


@import AssetsLibrary;

@interface NAYDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *personImageView;

@end

@implementation NAYDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.selectedPerson.name;
    self.personImageView.layer.cornerRadius = 120;
    self.personImageView.layer.masksToBounds = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.selectedPerson.imagePath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:self.selectedPerson.imagePath];
        UIImage *image = [UIImage imageWithData:imageData];
        self.personImageView.image = image;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    // TODO: Try and find a cleaner way to do this. Don't want to abuse notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMAGE_ADDED object:nil userInfo:@{USER_INFO_KEY_UPDATED_PERSON: self.selectedPerson}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
- (IBAction)checkForCamera:(id)sender
{
    UIAlertView *alertView;
    
    // Check for camera
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // If no camera check for photo library access
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied ||
            [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
            // If no photo library access inform them that functionality is unavailable
            alertView = [[UIAlertView alloc] initWithTitle:ALERTVIEW_NO_PHOTO_OPTION
                                                   message:@"App needs access to photo library or camera for this functionality"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Ok", nil];
            [alertView show];
        } else {
            //Alert user that device does not have a camera and only show the Photo Library option
            alertView = [[UIAlertView alloc] initWithTitle:ALERTVIEW_NO_CAMERA
                                                   message:@"Camera option not available"
                                                  delegate:self
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
            [alertView show];
        }
    // Alert that there is no option for photos
    } else {
        [self showActionSheetWithCameraOption:YES];
    }
}


- (void)showActionSheetWithCameraOption:(BOOL)hasCamera
{
    UIActionSheet *photoPickerActionSheet;
    if (hasCamera) {
        photoPickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Camera", @"Photo Library", nil];
    } else {
        photoPickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Photo Library", nil];
    }
    [photoPickerActionSheet showInView:self.view];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:ALERTVIEW_NO_CAMERA]) {
        [self showActionSheetWithCameraOption:NO];
    } else if ([alertView.title isEqualToString:ALERTVIEW_NO_PHOTO_OPTION]) {
        return;
    }
}

#pragma mark - UIActionSheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:ACTIONSHEET_CAMERA]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:ACTIONSHEET_PHOTO_LIBRARY]) {
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    } else {
        return;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImageData = info[UIImagePickerControllerEditedImage];
    NSData *compressedImage = UIImageJPEGRepresentation(editedImageData, .80);
    UIImage *image = [UIImage imageWithData:compressedImage];
    
// TODO: Figure out how to get the path of an object after saving it with ALAsset library
//    // Save image to default photo album
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    [assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage
//                                       metadata:nil
//                                completionBlock:nil];
    
    // Save image to device for use in other classes
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:self.selectedPerson.name];
    [compressedImage writeToFile:imagePath atomically:YES];
    self.selectedPerson.imagePath = imagePath;
    
    self.personImageView.image = [UIImage imageWithData:UIImagePNGRepresentation(image)];
    
// TODO: Try and find a cleaner way to do this. Don't want to abuse notifications
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMAGE_ADDED object:nil userInfo:@{USER_INFO_KEY_UPDATED_PERSON:self.selectedPerson}];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
