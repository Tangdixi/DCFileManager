//
//  DCFileManager.m
//  Example
//
//  Created by Paul on 6/11/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "DCFileManager.h"
#import "NSString+Extension.h"

@interface DCFileManager ()

@property (strong, nonatomic) NSFileManager *fileManager;

@end

@implementation DCFileManager

#pragma mark - Singleton Method

+ (instancetype)shareDCFileManager {
    
    static DCFileManager *dcFileManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dcFileManager = [[self alloc]init];
    });
    
    return dcFileManager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        // Init a file manager
        //
        _fileManager = [[NSFileManager alloc]init];
        
        // Create all directory Application directory
        //
        _applicationSupportDirectory = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).lastObject;
        _documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        _libraryDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
        _cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
        _tempDirectory = NSTemporaryDirectory();
        
    }
    
    return self;
}

- (BOOL)createDirectory:(NSString *)directory {
    
    return [self createDirectory:nil inDirectory:directory];
    
}

- (BOOL)createDirectory:(NSString *)directory
            inDirectory:(NSString *)superDirectory {
    
    NSString *destinateDirectory = [superDirectory stringByAppendingPathComponent:directory];
    
    if (! [self.fileManager fileExistsAtPath:destinateDirectory]) {
        
        NSError *error = nil;
        
        return [self.fileManager createDirectoryAtPath:destinateDirectory
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:&error];
        
    }
    
    return YES;
}

- (BOOL)saveFileUsingMD5HashPathByString:(NSString *)sourceString
                                withData:(NSData *)data
                             inDirectory:(NSString *)directory {
    
    // MD5 hash
    //
    NSString *md5String = [sourceString MD5Hash];
    
    // Create first and second directory
    //
    NSString *superDirectory = [md5String substringWithRange:NSMakeRange(0, 2)];
    NSString *childDirectory = [md5String substringWithRange:NSMakeRange(2, 2)];
    NSString *fileName = [md5String substringWithRange:NSMakeRange(4, md5String.length - 4)];
    
    // Create file path
    //
    NSString *md5FilePath = [NSString stringWithFormat:@"MD5Hash/%@/%@", superDirectory, childDirectory];
    NSString *filePath = [directory stringByAppendingPathComponent:md5FilePath];
    
    // Save the file
    //
    [self saveFileWithName:fileName withData:data toDirectory:filePath];
    
    return NO;
    
}

- (BOOL)saveFileWithName:(NSString *)name
                withData:(NSData *)data
             toDirectory:(NSString *)directory {
    
    // Create directory only if the directory is not wxist
    //
    if ([self createDirectory:directory]) {
        
        NSString *filePath = [directory stringByAppendingPathComponent:name];
        
        return [self.fileManager createFileAtPath:filePath
                                         contents:data
                                       attributes:nil];
        
    }
    
    return NO;
}

- (BOOL)deleteFileUsingMD5HashPathByString:(NSString *)sourceString
                               inDirectory:(NSString *)directory {
    
    // MD5 hash
    //
    NSString *md5String = [sourceString MD5Hash];
    
    // Create first and second directory
    //
    NSString *superDirectory = [md5String substringWithRange:NSMakeRange(0, 2)];
    NSString *childDirectory = [md5String substringWithRange:NSMakeRange(2, 2)];
    NSString *fileName = [md5String substringWithRange:NSMakeRange(4, md5String.length - 4)];
    
    // Create file path
    //
    NSString *md5FilePath = [NSString stringWithFormat:@"MD5Hash/%@/%@", superDirectory, childDirectory];
    NSString *filePath = [directory stringByAppendingPathComponent:md5FilePath];
    
    // Delete the file
    //
    [self deleteFileWithName:fileName inDirectory:filePath];
    
    return NO;
    
}

- (BOOL)deleteFileWithName:(NSString *)name
               inDirectory:(NSString *)directory {
    
    NSString *filePath = [directory stringByAppendingPathComponent:name];
    
    if ([self.fileManager fileExistsAtPath:filePath]) {
        
        NSError *error = nil;
        
        return [self.fileManager removeItemAtPath:filePath
                                            error:&error];
        
    }
    
    return NO;
}

- (BOOL)moveFileWithName:(NSString *)name
           fromDirectory:(NSString *)originDirectory
             toDirectory:(NSString *)destinateDirectory {
    
    NSString *originPath = [originDirectory stringByAppendingPathComponent:name];
    NSString *destinatePath = [destinateDirectory stringByAppendingPathComponent:name];
    
    if ([self.fileManager fileExistsAtPath:originDirectory]) {
        
        NSError *error = nil;
        
        return [self.fileManager moveItemAtPath:originPath
                                         toPath:destinatePath
                                          error:&error];
        
    }
    
    return NO;
}

- (NSData *)fetchFileUsingMD5Hash:(NSString *)sourceString
                      inDirectory:(NSString *)directory {
    
    // MD5 hash
    //
    NSString *md5String = [sourceString MD5Hash];
    
    // Create first and second directory
    //
    NSString *superDirectory = [md5String substringWithRange:NSMakeRange(0, 2)];
    NSString *childDirectory = [md5String substringWithRange:NSMakeRange(2, 2)];
    NSString *fileName = [md5String substringWithRange:NSMakeRange(4, md5String.length - 4)];
    
    // Create file path
    //
    NSString *md5FilePath = [NSString stringWithFormat:@"MD5Hash/%@/%@/%@", superDirectory, childDirectory, fileName];
    NSString *filePath = [directory stringByAppendingPathComponent:md5FilePath];
    
    // Fetch the data
    //
    return [self fetchFileInDirectory:filePath];
    
}

- (NSData *)fetchFileInDirectory:(NSString *)directory {
    
    return [[NSData alloc]initWithContentsOfFile:directory];
    
}

- (NSArray *)fetchFilesInDirectory:(NSString *)directory {
    
    NSError *error = nil;
    
    return [self.fileManager contentsOfDirectoryAtPath:directory
                                                 error:&error];
    
}

- (void)cleanCacheDirectory {
    
    // fetch all directories
    //
    NSArray *subDirectorys = [self.fileManager contentsOfDirectoryAtPath:self.cacheDirectory error:nil];
    
    for (NSString *subPath in subDirectorys) {
        
        NSError *error = nil;
        
        [self.fileManager removeItemAtPath:[self.cacheDirectory stringByAppendingPathComponent:subPath] error:&error];
        
    }

}

@end
