//
//  TrackingDetail.m
//  WareHouse
//
//  Created by Gerry Gao on 28/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "TrackingDetail.h"


@interface TrackingDetail ()

@end

@implementation TrackingDetail
@synthesize appDelegate;


- (void)showBasicDetails{
    self.numberOfPackages.text = [NSString stringWithFormat:@"%ld", (long)self.appDelegate.numberOfPackages];
    self.trackingNumber.text = [self.appDelegate.trackingNum uppercaseString];
    self.status.text = self.appDelegate.displayStatus;
    self.cusNameLabel.text = self.appDelegate.cusName;
    
    //display the process bar regarding to the status.
    if([self.appDelegate.status isEqualToString:@"Package Delivery"]) {
        //display entire process bar as it has been finished.
        for(UIView* subView in self.view.subviews) {
            subView.alpha = 1.0;
        }
    }else if([self.appDelegate.status isEqualToString:@"Load Packages to a Van"]) {
        for(UIView* subView in self.view.subviews) {
            subView.alpha = 1.0;
        }
        self.bar2.alpha = 0;
        self.receivedLabel.alpha = 0;
        self.receivedImageView.alpha = 0;
    }else{
        self.bar1.alpha = 0;
        self.inTransitImageView.alpha = 0;
        self.inTransitLabel.alpha = 0;
        self.bar2.alpha = 0;
        self.receivedImageView.alpha = 0;
        self.receivedLabel.alpha = 0;
    }
    
    NSString *fileURL = appDelegate.imgSignaiture;
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    UIImage* result = [UIImage imageWithData:data];
    
    [self.signatureImg setImage:result];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    //change the style of button
    _backBtn.layer.cornerRadius = 8;
    
    //Scroll the page
    self.myscroll.contentSize = CGSizeMake(300, 700);
    //Hide the scroll indicator for Vertical side
    [self.myscroll setShowsVerticalScrollIndicator:NO];
    //show the basic detail.
    [self showBasicDetails];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
