//
//  NAYDetailViewController.h
//  FirstDayDemo
//
//  Created by Jeff Schwab on 1/13/14.
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAYPerson.h"

@interface NAYDetailViewController : UIViewController
<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NAYPerson *selectedPerson;

@end
