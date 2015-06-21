//
//  DCFileManager.h
//  Example
//
//  Created by Paul on 6/11/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

@import Foundation;

@interface DCFileManager : NSObject

@property (readonly, nonatomic) NSString *documentsDirectory;
@property (readonly, nonatomic) NSString *libraryDirectory;
@property (readonly, nonatomic) NSString *tempDirectory;
@property (readonly, nonatomic) NSString *cacheDirectory;
@property (readonly, nonatomic) NSString *applicationSupportDirectory;

+ (instancetype)shareDCFileManager;

- (BOOL)createDirectory:(NSString *)directory;

- (BOOL)createDirectory:(NSString *)directory
            inDirectory:(NSString *)superDirectory;

- (BOOL)saveFileWithName:(NSString *)name
                withData:(NSData *)data
             toDirectory:(NSString *)directory;

- (BOOL)deleteFileWithName:(NSString *)name
               inDirectory:(NSString *)directory;

- (BOOL)deleteFileUsingMD5HashPathByString:(NSString *)sourceString
                               inDirectory:(NSString *)directory;

- (BOOL)moveFileWithName:(NSString *)name
           fromDirectory:(NSString *)originDirectory
             toDirectory:(NSString *)destinateDirectory;

- (BOOL)saveFileUsingMD5HashPathByString:(NSString *)sourceString
                                withData:(NSData *)data
                             inDirectory:(NSString *)directory;

- (NSData *)fetchFileUsingMD5Hash:(NSString *)sourceString
                      inDirectory:(NSString *)directory;

- (NSData *)fetchFileInDirectory:(NSString *)directory;

- (void)cleanCacheDirectory;

- (void)cleanTempDirectory;

- (void)cleanMD5HashDirectory:(NSString *)sourceDirectory;

@end

#define kDCFileDocumentsDirectory ([DCFileManager shareDCFileManager].documentsDirectory)
#define kDCFileLibraryDirectory ([DCFileManager shareDCFileManager].libraryDirectory)
#define kDCFileTempDirectory ([DCFileManager shareDCFileManager].tempDirectory)
#define kDCFileCacheDirectory ([DCFileManager shareDCFileManager].cacheDirectory)
#define kDCFileApplicationSupportDirectory ([DCFileManager shareDCFileManager].applicationSupportDirectory)
