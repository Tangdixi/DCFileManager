//
//  DCNetworkReactor.h
//  DCNetworkReactor
//
//  Created by tang dixi on 10/14/14.
//  Copyright (c) 2014 tang dixi. All rights reserved.
//


@import UIKit;
@import Foundation;

@class AFHTTPRequestOperation;

@interface DCNetworkReactor : NSObject

typedef void (^successBlock)(id responseObject);
typedef void (^faliureBlock)(NSError *error);

+ (instancetype)shareDCNetworkReactor;

- (AFHTTPRequestOperation *)GET:(NSString *)urlString
                 withParameters:(NSDictionary *)parameters
                        success:(successBlock)success
                        faliure:(faliureBlock)failure;

- (AFHTTPRequestOperation *)POST:(NSString *)urlString
                  withParameters:(NSDictionary *)parameters
                         success:(successBlock)success
                         failure:(faliureBlock)failure;

- (AFHTTPRequestOperation *)POST:(NSString *)urlString
                       withImage:(UIImage *)image
              withAvatarDominate:(NSString *)avatarDominate
                  withParameters:(NSDictionary *)parameters
                         success:(successBlock)success
                         failure:(faliureBlock)failure;

@end
