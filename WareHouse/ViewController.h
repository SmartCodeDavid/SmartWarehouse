//
//  ViewController.h
//  WareHouse
//
//  Created by David Lan on 12/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Canvas.h"



@interface ViewController : UIViewController <UITextFieldDelegate, NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *trackingNumber;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIButton *mainBtn;
@property (retain, nonatomic) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *labelOrder;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
@property (weak, nonatomic) IBOutlet UIButton *pickBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *myscroll;
@property (strong, nonatomic) IBOutlet UIView *pageSize;
@property (weak, nonatomic) IBOutlet CSAnimationView *myAnimation;
- (IBAction)play:(id)sender;
@end



