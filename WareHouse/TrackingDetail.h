//
//  TrackingDetail.h
//  WareHouse
//
//  Created by Gerry Gao on 28/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TrackingDetail : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *packageImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UILabel *trackingNumber;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPackages;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *pickUpImageView;
@property (weak, nonatomic) IBOutlet UILabel *pickUpLabel;
@property (weak, nonatomic) IBOutlet UIImageView *inTransitImageView;
@property (weak, nonatomic) IBOutlet UILabel *inTransitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receivedImageView;
@property (weak, nonatomic) IBOutlet UILabel *receivedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bar1;
@property (weak, nonatomic) IBOutlet UIImageView *bar2;
@property (weak, nonatomic) IBOutlet UIImageView *signatureImg;
@property (strong, nonatomic) IBOutlet UILabel *cusNameLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myscroll;

- (IBAction)backBtn:(id)sender;
@end
