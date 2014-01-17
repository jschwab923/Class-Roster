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
{
    CGPoint _scrollViewOrigin;
}
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *personImageView;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (weak, nonatomic) IBOutlet UITextField *githubTextField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIToolbar *buttonToolbar;

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
    
    [self registerForKeyboardNotifications];
    
    self.title = self.selectedPerson.name;
    self.personImageView.layer.cornerRadius = 120;
    self.personImageView.layer.masksToBounds = YES;
    
    self.twitterTextField.text = self.selectedPerson.twitter;
    self.githubTextField.text = self.selectedPerson.github;
    
    [self.redSlider setThumbImage:[UIImage imageNamed:@"RSliderButton.png"] forState:UIControlStateNormal];
    [self.greenSlider setThumbImage:[UIImage imageNamed:@"GSliderButton.png"] forState:UIControlStateNormal];
    [self.blueSlider setThumbImage:[UIImage imageNamed:@"BSliderButton.png"] forState:UIControlStateNormal];
    
    self.redSlider.value = [self.selectedPerson.favoriteColor[0] floatValue];
    self.greenSlider.value = [self.selectedPerson.favoriteColor[1] floatValue];
    self.blueSlider.value = [self.selectedPerson.favoriteColor[2] floatValue];
    
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.selectedPerson.imagePath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:self.selectedPerson.imagePath];
        UIImage *image = [UIImage imageWithData:imageData];
        self.personImageView.image = image;
    } else {
        self.personImageView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollViewOrigin = self.detailScrollView.frame.origin;
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
    
    // Save image to device for use in other classes
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:self.selectedPerson.name];
    [compressedImage writeToFile:imagePath atomically:YES];
    self.selectedPerson.imagePath = imagePath;
    
    self.personImageView.image = [UIImage imageWithData:UIImagePNGRepresentation(image)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_IMAGE_ADDED object:nil userInfo:@{USER_INFO_KEY_UPDATED_PERSON:self.selectedPerson}];

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    self.selectedPerson.twitter = self.twitterTextField.text;
    self.selectedPerson.github = self.githubTextField.text;
    [textField endEditing:YES];
    return YES;
}

#pragma mark - Slider Changed Handler
- (IBAction)sliderChanged:(id)sender
{
    
    CGFloat redColor = self.redSlider.value;
    CGFloat greenColor = self.greenSlider.value;
    CGFloat blueColor = self.blueSlider.value;
    
    self.view.backgroundColor = [UIColor colorWithRed:redColor
                                                green:greenColor
                                                 blue:blueColor alpha:1];
}

#pragma mark - Keyboard Handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.detailScrollView.contentInset = contentInsets;
    self.detailScrollView.scrollIndicatorInsets = contentInsets;
}

// Called When the UIKeyboardWillHideNotification is sent.
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    self.detailScrollView.contentInset = UIEdgeInsetsZero;
    [self.detailScrollView setContentOffset:CGPointMake(0, -60) animated:YES];
}

@end
