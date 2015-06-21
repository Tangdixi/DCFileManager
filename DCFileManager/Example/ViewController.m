//
//  ViewController.m
//  Example
//
//  Created by Paul on 6/9/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "ViewController.h"

#import "DCFileManager.h"
#import "DCNetworkReactor.h"

#define kImageURL @"http://image.baidu.com/i?tn=download&word=download&ie=utf8&fr=detail&url=http%3A%2F%2Fimg22.mtime.cn%2Fup%2F2010%2F07%2F27%2F102335.10556166_500.jpg&thumburl=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D2628545004%2C2424342616%26fm%3D21%26gp%3D0.jpg"

@interface ViewController ()<NSFileManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)show:(id)sender {
    
    UIImage *image = [UIImage imageWithData:[[DCFileManager shareDCFileManager] fetchFileUsingMD5Hash:kImageURL
                                                                                          inDirectory:kDCFileTempDirectory]];
    _imageView.image = image;
                      
}

- (IBAction)dwonload:(id)sender {

    [[DCNetworkReactor shareDCNetworkReactor]GET:kImageURL
                                  withParameters:nil
                                         success:^(id responseObject) {
                                             
                                             [[DCFileManager shareDCFileManager]saveFileUsingMD5HashPathByString:kImageURL
                                                                                                        withData:responseObject
                                                                                                     inDirectory:kDCFileTempDirectory];
                                         }
                                         faliure:^(NSError *error) {
                                             
                                         }];
    
}

- (IBAction)delete:(id)sender {
    
//    [[DCFileManager shareDCFileManager]deleteFileUsingMD5HashPathByString:kImageURL inDirectory:kDCFileTempDirectory];
    
    [[DCFileManager shareDCFileManager]cleanCacheDirectory];
    
}

@end
