//
//  ViewController.m
//  WareHouse
//
//  Created by David Lan on 12/5/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "ViewController.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "AppDelegate.h"
#import "TrackingDetail.h"
#import "MBProgressHUD.h"
#import "Scanner.h"

@interface ViewController ()

@end

@implementation ViewController



//Btn to Scan page
- (IBAction)scannerPressDown:(id)sender {
    //present new view
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Scanner* scanner = [story instantiateViewControllerWithIdentifier:@"Scanner"];
    scanner.appDelegate = self.appDelegate;
    [self presentViewController:scanner animated:YES completion:nil];
}

//Hidden Keyboard when touch outside of the textfiled
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.trackingNumber resignFirstResponder];
    return YES;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSLog(@"Allowing all");
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions (serverTrust);
    SecTrustSetExceptions (serverTrust, exceptions);
    CFRelease (exceptions);
    completionHandler (NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
}

//Tracking page Btn
- (IBAction)BtnPressDown:(id)sender {
    //resign the resignFirstResponder
    [self.trackingNumber resignFirstResponder];
    
    //user input tracking number with incorrect format.
    if([self.trackingNumber.text isEqualToString:@""] || [self.trackingNumber.text containsString:@" "]) {
        [self alertShow:@"Please enter tracking number"];
        self.trackingNumber.text = @"";
    }else{
        //Initialise the activity indicator
        MBProgressHUD* mpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mpHUD.label.text= @"Tracking";
        
        //set up the connection
        NSString *postString = @"https://empirecouriers.willowit.net.au:8443/parcel_track_details";
        NSURL* url = [NSURL URLWithString:postString];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
        request.HTTPMethod = @"POST";
        request.HTTPBody = [[NSString stringWithFormat:@"parcel_num=%@", self.trackingNumber.text]  dataUsingEncoding:NSUTF8StringEncoding];
        
        //NSURLSession *session = [NSURLSession sharedSession];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
        
        NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //hide the activity indicator view
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
            //determine whether there have errors in relation to the network.
            if(!error) {
                NSInteger i = 1;
                NSMutableArray* infoArray = [NSMutableArray array];
                HTMLParser *parser = [[HTMLParser alloc] initWithData:data error:&error];
                HTMLNode* bodyNode = [parser body];
                NSArray *trNodeArray = [[bodyNode findChildTag:@"tbody"] findChildTags:@"tr"];
                NSArray *h4NodeArray = [bodyNode findChildTags:@"h4"];
                
                //if nothing parses to trNodeArray, this order number should be not exist.
                if(!trNodeArray) {
                    [self alertShow:[NSString stringWithFormat:@"The following Tracking Number(s) were not found: %@", self.trackingNumber.text]];
                }else{
                    NSString* imgUrl;
                    NSArray* arraySpans;
                    self.appDelegate.displayStatus = [[h4NodeArray[1] findChildTag:@"span"] contents];
                    
                    for(HTMLNode* node in trNodeArray) {
                        i = 1;
                        //grab the image of signature if there have one.
                        imgUrl =  ([node findChildTag:@"img"] != nil)? [[node findChildTag:@"img"] getAttributeNamed:@"src"] : nil;
                        
                        //grab grab text in span at each row
                        arraySpans = [node findChildTags:@"span"];
                        for(HTMLNode *span in arraySpans) { //insert the six elements to array
                            NSString* str = ([span contents] == nil)? @" " : [span contents];
                            if(i == 6 && ![str isEqualToString:@" "]) { //if there has name
                                self.appDelegate.cusName = str;
                            }else{
                                self.appDelegate.cusName = @" ";
                            }
                            if(i > 6) {
                                break;
                            }else{
                                [infoArray addObject:str];
                                i++;
                            }
                        }
                    }
                    
                    self.appDelegate.imgSignaiture = imgUrl;
                    self.appDelegate.numberOfPackages = [[infoArray objectAtIndex:4] intValue];
                    self.appDelegate.trackingNum = self.trackingNumber.text;
                    if([[bodyNode rawContents] containsString:@"Package Delivery"]) {
                        self.appDelegate.status = @"Package Delivery";
                    }else if([[bodyNode rawContents] containsString:@"Load Packages to a Van"]){
                        self.appDelegate.status = @"Load Packages to a Van";
                    }else if([[bodyNode rawContents] containsString:@"Package Pickup"]){
                        self.appDelegate.status = @"Package Pickup";
                    }else{
                    }
                    
                    //when the data have been grab, presenting the new view.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //present new view
                        UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        TrackingDetail* tdView = [story instantiateViewControllerWithIdentifier:@"TrackingDetail"];
                        tdView.appDelegate = self.appDelegate;
                        [self presentViewController:tdView animated:YES completion:nil];
                    });
                }
            }else{ //connection fail.
                if([error.localizedDescription isEqualToString:@"The request timed out."]) {
                    NSLog(@"timed out");
                    [self alertShow:@"Timed out"];
                }else if([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
                    NSLog(@"offline");
                    [self alertShow:@"Please connect the internet"];
                }else{
                    NSLog(@"unknow error");
                    [self alertShow:@"Unknow error"];
                }
            }
        }];
        [dataTask resume];
    }
    
    
    
}

//Alert view for tracking
- (void) alertShow:(NSString*) message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Try again" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.trackingNumber.delegate = self;
    self.trackingNumber.returnKeyType = UIReturnKeyDone;
    _mainBtn.layer.cornerRadius = 3;
    _labelOrder.layer.cornerRadius = 3;
    _pickBtn.layer.cornerRadius = 3;
    _scanBtn.layer.cornerRadius = 3;
    _trackingNumber.layer.cornerRadius = 1;
    _trackingNumber.placeholder = @"Enter Label Number";
    
    //set gesturerecognizer
    UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [self.myscroll addGestureRecognizer:recognizer];
    
    //Set appdelegate
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appDelegate.trackingNum = @"";
    appDelegate.numberOfPackages = 0;
    appDelegate.status = @"";
    
    self.appDelegate = appDelegate;
    
    self.myscroll.contentSize = CGSizeMake(300, 700);
    
    [self.myscroll setShowsVerticalScrollIndicator:NO];
}

- (void) closeKeyboard{
    [self.trackingNumber resignFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.trackingNumber resignFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated{
    _trackingNumber.text=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    [self.myAnimation startCanvasAnimation];
}
@end
