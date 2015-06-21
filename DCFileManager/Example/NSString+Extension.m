//
//  NSString+Extension.m
//  
//
//  Created by Paul on 6/21/15.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)MD5Hash {
    
    const char *stringPointer = [self UTF8String];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(stringPointer, strlen(stringPointer), md5Buffer);
    
    NSMutableString *md5String = [[NSMutableString alloc]initWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int index = 0; index < CC_MD5_DIGEST_LENGTH; index++) {
        
        [md5String appendFormat:@"%02x", md5Buffer[index]];
        
    }
    
    return md5String;
}

@end
