//
//  DetailPage.h
//  WareHouse
//
//  Created by kit305 on 15/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface DetailPage : UIViewController <MFMailComposeViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UILabel *labelField;
@property (strong, nonatomic) IBOutlet UITextField *quantityField;
@property (strong, nonatomic) IBOutlet UIPickerView *pickView;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIButton *sendMail;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIScrollView *myscroll;
@property (assign,nonatomic) BOOL SHOWALERT;

- (IBAction)sendMail:(id)sender;
- (IBAction)pressDown:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

-(int)getRandomNumber: (int)from to:(int)to;


@end
