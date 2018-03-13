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
}

@end

@implementation Scanner
@synthesize wkWebView;

- (IBAction)CameraPressDown:(id)sender {
    if(!self.cameraView.isHidden) {
        [self.cameraView setHidden:YES];
        [session stopRunning];
    }else{
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

//webview decidepolicy

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"213");
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(executeJS:Timer:) userInfo:nil repeats:NO   ];
//
    [webView evaluateJavaScript:@"myFunc();" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", result);
        if(error != NULL) {
            NSLog(@"%@", error.description);
        }
    }];
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
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int flag = 1;
    
    if(flag == 1)
    {
        [self setNeedsStatusBarAppearanceUpdate];
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
        
        ;
        
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://empirecouriers.willowit.net.au:8443/driver/web"]];
        [wkWebView loadRequest:request];
        [self.webView addSubview:wkWebView];
        
        [self.cameraView setHidden:YES];
        
        //start capture
        [self initCapture];
        //[session startRunning];
    }else{
        [self alerView];
    }
}

-(void)alerView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please log in first" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log in", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    
    [alert show];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"scan result" message:captureStr delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];*/
    
    //js execution
    /*NSString* js = [NSString stringWithFormat:@"document.getElementsByTagName('input')[0].value = '%@';", captureStr];
    
    NSString* js2 = @"document.getElementsByClassName('new-order-buttons')[0].setAttribute('class', 'new-order-buttons');";
    NSString* js3 = [NSString stringWithFormat:@"var parent = document.getElementsByClassName('orderlines')[0];var emptyElement = document.getElementsByClassName('orderline empty')[0];if(emptyElement){parent.removeChild(emptyElement);}var son_li = document.createElement('li');son_li.setAttribute('class','orderline selected');son_li.innerHTML = \"<span class='scan-code'>%@</span><ul class='info-list'></ul>\"; parent.appendChild(son_li); document.getElementsByClassName('new-order-buttons')[0].setAttribute('class', 'new-order-buttons');", captureStr];*/
    
    NSString* js4 = [NSString stringWithFormat:@"var inputEle = document.getElementsByTagName('input')[0];inputEle.value = '%@';var event1 = document.createEvent('HTMLEvents');  event1.initEvent('change', true, true); event1.eventType = 'change'; inputEle.dispatchEvent(event1);", captureStr] ;
    [self.wkWebView evaluateJavaScript: js4 completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@", result);
        if(error != NULL) {
            NSLog(@"%@", error.description);
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
        [output setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, nil]];
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
