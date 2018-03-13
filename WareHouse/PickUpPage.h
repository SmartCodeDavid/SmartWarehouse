//
//  PickUpPage.h
//  WareHouse
//
//  Created by Gerry Gao on 18/6/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "UIKit/UIKit.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface PickUpPage : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextField *suburbField;
@property (weak, nonatomic) IBOutlet UITextField *packageTypeField;
@property (weak, nonatomic) IBOutlet UITextField *numberPackageField;
@property (weak, nonatomic) IBOutlet UIScrollView *myscroll;
@property (weak, nonatomic) IBOutlet UIButton *sendMail;
@property (weak, nonatomic) IBOutlet UITextField *additionalMessage;
@property (assign,nonatomic) BOOL SHOWALERT;

- (IBAction)backBtn:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)sendMail:(id)sender;
@end
