//
//  DetailPage.m
//  WareHouse
//
//  Created by kit305 on 15/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "DetailPage.h"

@interface DetailPage ()

    

@end

NSArray *_pickerViewArray;

@implementation DetailPage
@synthesize SHOWALERT;

-(int)getRandomNumber: (int)from to:(int)to{
    return (int)from + arc4random() % (to-from+1);
}

//Col of the pickerView
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//Row of the pickerView
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerViewArray.count;
}

//Info shows on the pickerView
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _pickerViewArray[row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *labelselected = [_pickerViewArray objectAtIndex:row];
    _labelField.text = labelselected;
    _labelContent.text = labelselected;
}



- (void) closeKeyboard{
    [self.nameField resignFirstResponder];
    [self.numberField resignFirstResponder];
    [self.quantityField resignFirstResponder];
    [self.descriptionField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    _labelField.text = @"Please select label type";
    _sendMail.layer.cornerRadius = 3;
    self.myscroll.contentSize = CGSizeMake(300, 690);
    
    [self.myscroll setShowsVerticalScrollIndicator:NO];
    
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.myscroll addGestureRecognizer:recognizer];
    
    
    _nameField.placeholder = @"Business Name";
    _numberField.placeholder = @"Contact Number";
    _quantityField.placeholder = @"Label Quantity";
    _descriptionField.placeholder = @"Additional info";
    _pickerViewArray = @[@"Next Day",@"NW/HBT",@"Local",@"Country",@"Freight Forward",@"Pallet",@"Other"];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    
    self.SHOWALERT = NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMail:(id)sender {
    
    MFMailComposeViewController* composer = [[MFMailComposeViewController alloc] init];
    
    [composer setMailComposeDelegate:self];
    
     int orderRef = [self getRandomNumber:100000 to:999999];
    
    if ([MFMailComposeViewController canSendMail]) {
        [composer setToRecipients:[NSArray arrayWithObjects:@"admin@empirecouriers.com.au", nil]];
        [composer setSubject:[NSString stringWithFormat:@"Order Number: %d",orderRef]];
        [composer setMessageBody:[NSString stringWithFormat:@"Name: %@ \nContact Number: %@\nQuantity Ordered: %@\nLabel Type: %@\nAddtional require: %@",_nameField.text,_numberField.text,_quantityField.text,_labelContent.text,_descriptionField.text] isHTML: NO];
        
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



- (IBAction)pressDown:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self resignFirstResponder];
}
@end
