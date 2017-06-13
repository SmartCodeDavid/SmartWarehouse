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
#import "OrderDetail.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)BtnPressDown:(id)sender {
    
    NSString *postString = @"https://empirecouriers.willowit.net.au:8443/parcel_track_details";
    
    NSURL* url = [NSURL URLWithString:postString];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [[NSString stringWithFormat:@"parcel_num=%@", self.trackingNumber.text]  dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(!error) {
            
            NSInteger i = 1;
            
            NSMutableArray* infoArray = [NSMutableArray array];
            
            HTMLParser *parser = [[HTMLParser alloc] initWithData:data error:&error];
            
            HTMLNode* bodyNode = [parser body];
            
            NSArray *trNodeArray = [[bodyNode findChildTag:@"tbody"] findChildTags:@"tr"];
            
            for(HTMLNode* node in trNodeArray) {
                i = 1;
                NSArray* arraySpans = [node findChildTags:@"span"];
                
                for(HTMLNode *span in arraySpans) { //insert the six elements to array
                    NSString* str = ([span contents] == nil)? @" " : [span contents];
                    
                    if(i > 6) {
                        break;
                    }else{
                        [infoArray addObject:str];
                        i++;
                    }
                }
            }
            
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSLog(@"%@", [NSThread currentThread]);
        }else{
            NSLog(@"error!");
        }
        
    }];
    
    [dataTask resume];
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _mainBtn.layer.cornerRadius =5;
    
    NSString *fileURL = @"data:image/png;base64,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";
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    //UIImage* result = [UIImage imageWithData:data];
    
    //[self.img setImage:result];
    
    OrderDetail *order = [OrderDetail new];
    
    [order showMyObject];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    _trackingNumber.text=nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
