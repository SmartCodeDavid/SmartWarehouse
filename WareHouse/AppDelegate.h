//
//  AppDelegate.h
//  WareHouse
//
//  Created by David Lan on 12/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic) NSInteger numberOfPackages;
@property (retain, nonatomic) NSString* trackingNum;
@property (retain, nonatomic) NSString* status;
@property (retain, nonatomic) NSString* imgSignaiture;
@property (retain, nonatomic) NSString* cusName;
@property (retain, nonatomic) NSString* displayStatus;

@end

