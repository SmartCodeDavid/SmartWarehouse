//
//  PickUpPage.m
//  WareHouse
//
//  Created by Gerry Gao on 18/6/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "PickUpPage.h"

@interface PickUpPage ()

@end

@implementation PickUpPage
@synthesize SHOWALERT;

-(int)getRandomNumber: (int)from to:(int)to{
    return (int)from + arc4random() % (to-from+1);
}

- (void)viewDidAppear:(BOOL)animated{
    if(!self.SHOWALERT) {
        NSLog(@"dont display");
    }else{
        self.SHOWALERT = NO;
        
        // close the current page.
        [self dismissViewControllerAnimated:YES completion:nil];
        
        /*UIAlertController* uiAlert = [UIAlertController alertControllerWithTitle:@"Email" message:@"Email has been sent" preferredStyle:UIAlertControllerStyleAlert];
        [uiAlert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //close current view
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [self presentViewController:uiAlert animated:YES completion:nil];*/ //04/07/2017 -- this code is used to let user know what's going on after sending the email.
    }
}

- (void) closeKeyboard{
    [self.nameField resignFirstResponder];
    [self.numberField resignFirstResponder];
    [self.packageTypeField resignFirstResponder];
    [self.numberPackageField resignFirstResponder];
    [self.suburbField resignFirstResponder];
    [self.additionalMessage resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.myscroll addGestureRecognizer:recognizer];
    
    
    _nameField.placeholder = @"Business Name";
    _numberField.placeholder = @"Contact Number";
    _suburbField.placeholder = @"Suburb";
    _packageTypeField.placeholder = @"Package Type";
    _numberPackageField.placeholder = @"Number Of Packages";
    _additionalMessage.placeholder = @"Additional info";
    _myscroll.contentSize = CGSizeMake(300, 690);
    _sendMail.layer.cornerRadius = 3;
    [_myscroll setShowsVerticalScrollIndicator:NO];
    
    self.SHOWALERT = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)dismissKeyboard:(id)sender{
    [self resignFirstResponder];
}

- (IBAction)backBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
}

- (IBAction)sendMail:(id) sender{
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    int orderRef = [self getRandomNumber:100000 to:999999];
    
    if([MFMailComposeViewController canSendMail]){
        [composer setToRecipients:[NSArray arrayWithObjects:@"admin@empirecouriers.com.au", nil]];
        [composer setSubject:[NSString stringWithFormat:@"Pick Up Require: %d", orderRef]];
        [composer setMessageBody:[NSString stringWithFormat:@"Name: %@ \nContact Number: %@\nNumber Of Package: %@\nPackage Type: %@\nPick Up Suburb: %@\nMessage: %@",_nameField.text,_numberField.text,_numberPackageField.text,_packageTypeField.text,_suburbField.text,_additionalMessage.text] isHTML:NO];
        
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composer animated:YES completion:NULL];
    }
    
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error  {
    if(error){
        NSLog(@"Error, didn't send");
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.SHOWALERT = YES;
}


@end
