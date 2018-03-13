//
//  Scanner.m
//  WareHouse
//
//  Created by David Lan on 15/6/17.
//  Copyright © 2017 David Lan. All rights reserved.
//

#import "Scanner.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"


//the new process queue indentifier
const char *kScanCodeQueueName = "ScanCodeQueue";

@interface Scanner () <AVCaptureMetadataOutputObjectsDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>
{
    //the session of captrue
    AVCaptureSession *session;
    BOOL isLightOpen;
}

@end

@implementation Scanner
@synthesize wkWebView;
@synthesize sound;
@synthesize sound2;

- (IBAction)lightBtnPressDown:(id)sender {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //trigger the light
    isLightOpen = !isLightOpen;
    
    //turn on or off the light
    if([device hasTorch])
    {
        [device lockForConfiguration:nil];
        //Two image for light turn on and off
        UIImage *dotImage = [UIImage imageNamed:@"dot"];
        UIImage *lightImage = [UIImage imageNamed:@"dark-ray"];
        if(isLightOpen)
        {
            [device setTorchMode:AVCaptureTorchModeOn];
            //Set image for light status
            [self.LightBtn setImage:dotImage forState:UIControlStateNormal];
        }
        else
        {
            [device setTorchMode:AVCaptureTorchModeOff];
            //set image for light status
            [self.LightBtn setImage:lightImage forState:UIControlStateNormal];
        }
        
        [device unlockForConfiguration];
    }
}

- (IBAction)CameraPressDown:(id)sender {
    if(!self.cameraView.isHidden) {
        [self.cameraView setHidden:YES];
        [self.LightBtn setTitle:@"Light On" forState:UIControlStateNormal];
        isLightOpen = NO;
        //move up the webview
        CGRect frame = self.webView.frame;
        frame.origin.y -= self.cameraView.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.frame = frame;
        }];
        [session stopRunning];
    }else{
        //hide the keyboard prsent in the webview.
        NSString* hideKeyboardJs = @"document.getElementsByTagName('input')[0].blur();";
        [self.wkWebView evaluateJavaScript: hideKeyboardJs completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            NSLog(@"%@", result);
            if(error != NULL) {
                NSLog(@"%@", error.description);
            }
        }];
        //move down the webview
        CGRect frame = self.webView.frame;
        frame.origin.y += self.cameraView.frame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.webView.frame = frame;
        }];
        
        [self.cameraView setHidden:NO];
        [session startRunning];
    }
}

#pragma mark - WKScriptMessageHandler
- (void) userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"AppModel"]) {
        // 打印所传过来的参数，只支持NSNumber, NSString, NSDate, NSArray,
        // NSDictionary, and NSNull类型
        NSLog(@"%@", message.body);
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSLog(@"Allowing all");
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions (serverTrust);
    SecTrustSetExceptions (serverTrust, exceptions);
    CFRelease (exceptions);
    completionHandler (NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
}

//webview decidepolicy

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"213");
    NSString* currentUrl = webView.URL.absoluteString;
    /*if([currentUrl containsString:@"redirect"]) {        //走手机网站
        [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://empirecouriers.willowit.net.au:8443/web/driverlogin"]]];
    }*/
    NSLog(@"%@", currentUrl);
}

//WKUIDelegate implementation
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    NSLog(@"123");
}


- (void) webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    NSLog(@"%@", prompt);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    MBProgressHUD* mpHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mpHUD.label.text= @"Loading";
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;{
    
    
    NSString* currentURL = webView.URL.absoluteString;
    NSLog(@"%@",currentURL);
    //scan page -- show camera button
    if([currentURL containsString:@"/driver/web"]){
        self.CameraBtn.alpha = 1.0;
    }else if([currentURL containsString:@"redirect"]){ //走手机网站
        [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://empirecouriers.willowit.net.au:8443/web/driverlogin"]]];
    }else if([currentURL isEqualToString:@"https://empirecouriers.willowit.net.au:8443/web"]) { //走错了，走手机页面
        [wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://empirecouriers.willowit.net.au:8443/web/driverlogin"]]];
    }else{
        self.CameraBtn.alpha = 0;
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) executeJS: (WKWebView *)webView Timer:(NSTimer*)timer{
    [webView evaluateJavaScript:@"myFunc();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", result);
        if(error != NULL) {
            NSLog(@"%@", error.description);
        }
    }];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}

- (IBAction)backBtnPressDown:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Back to Home Page?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //back to home page
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //turn off the light anyway
        if([device hasTorch])
        {
            [device lockForConfiguration:nil];
            
            UIImage *lightImage = [UIImage imageNamed:@"dark-ray"];
            [device setTorchMode:AVCaptureTorchModeOff];
            //set image for light status
            [self.LightBtn setImage:lightImage forState:UIControlStateNormal];
            
            [device unlockForConfiguration];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view removeFromSuperview];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //js
    NSString* jsStr = @"function myFunc(){document.getElementsByClassName('username')[0].innerHTML = 'fuck';} function myFunc2(){document.getElementsByClassName('tt-button-pickup')[0].addEventListener('click', function(){document.getElementsByClassName('username')[0].innerHTML = 'fuck';}, false)} function parseValue(){document.getElementsByTagName('input')[0].value = '123\\r';}";
    
    //set webview
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    [config.userContentController addScriptMessageHandler:self name:@"AppModel"];
    WKUserScript *script = [[WKUserScript alloc]initWithSource:jsStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:script];
    
    wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.webView.frame.size.width, self.webView.frame.size.height) configuration:config];
    
    wkWebView.navigationDelegate = self;
    wkWebView.UIDelegate = self;
    
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://empirecouriers.willowit.net.au:8443/web/driverlogin"]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://empirecouriers.willowit.net.au:8443/driver/web"]];
    //https://empirecouriers.willowit.net.au:8443/driver/web
    //https://empirecouriers.willowit.net.au:8443/web/driverlogin
    //https://empirecouriers.willowit.net.au:8443/driver/web#action=driver.ui
    //https://empirecouriers.willowit.net.au:8443/web/driverlogin?db=live
    [wkWebView loadRequest:request];
    [self.webView addSubview:wkWebView];
    
    [self.cameraView setHidden:YES];
    
    //start capture
    [self initCapture];
    
    //init sound
    sound = [[Sound alloc] initSystemSoundWithName:@"shake" SoundType:@"caf"];
    sound2 = [[Sound alloc] initSystemShake];
    
    //[session startRunning];
}

#pragma mark - capture delegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0)
    {
        //stop the capture
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //do sth to handle the capture result
        [self performSelectorOnMainThread:@selector(handleResult:) withObject:metadataObject waitUntilDone:NO];
        //start the capture
        [session startRunning];
        
        //Identify if the light up or not.
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil];
        if([device hasTorch]){
            if(isLightOpen) {
                [device setTorchMode:AVCaptureTorchModeOn];
            }
        }
        [device unlockForConfiguration];
    }
}

- (void)handleResult:(AVMetadataMachineReadableCodeObject *)metadataObject
{
    NSLog(@"%@", metadataObject.type);
    if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode])
    {
        NSLog(@"QR code");
    }
    else
    {
        NSLog(@"other code");
        
    }
    NSString *captureStr = metadataObject.stringValue;
    NSLog(@"%@",captureStr);
    
    NSString* js4 = [NSString stringWithFormat:@"var inputEle = document.getElementsByTagName('input')[0];inputEle.value = '%@';var event1 = document.createEvent('HTMLEvents');  event1.initEvent('change', true, true); event1.eventType = 'change'; inputEle.dispatchEvent(event1);", captureStr] ;
    [self.wkWebView evaluateJavaScript: js4 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", result);
        if(error != NULL) {
            NSLog(@"%@", error.description);
        }else{
            //play sound
            [sound play];
            [sound2 play];
        }
    }];
    
}


#pragma mark - helper funtions
- (void)initCapture
{
    //get the camera device
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //create the session
    session = [[AVCaptureSession alloc]init];
    
    //create input
    NSError *error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        return;
    }
    [session addInput:input];
    
    //create output
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [session addOutput:output];
    
    //make it run at a new process
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanCodeQueueName, NULL);
    [output setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //set the sampling rate
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //set the code type ,ex:QR and bar code
    if([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
    {
        [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code, nil]];
    }
    
    //add the camera layer
    AVCaptureVideoPreviewLayer *captureLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    captureLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    captureLayer.frame=self.cameraView.layer.bounds;
    [self.cameraView.layer insertSublayer:captureLayer atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
