//
//  Scanner.h
//  WareHouse
//
//  Created by David Lan on 15/6/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "Sound.h"

@interface Scanner : UIViewController
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (retain, nonatomic) AppDelegate* appDelegate;
@property (weak, nonatomic) IBOutlet UIView *webView;
@property (weak, nonatomic) IBOutlet UIButton *CameraBtn;
@property (retain, nonatomic) WKWebView* wkWebView;
@property (weak, nonatomic) IBOutlet UIButton *LightBtn;
@property (retain, nonatomic) Sound* sound;
@property (retain, nonatomic) Sound* sound2;
@property (weak, nonatomic) IBOutlet UIImageView *scanBox;

@end
