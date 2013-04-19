//
//  ImageCache.h
//  MapProject2
//
//  Created by Khue TD on 4/10/13.
//  Copyright (c) 2013 Khue TD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WMImageCacheResultBlock)(UIImage *image, NSData *data, NSError *error);

@interface ImageCache : NSObject

+ (ImageCache *)sharedInstance;

- (UIImage *)cachedImageWithPath:(NSString *)path;
- (UIImage *)imageWithURL:(NSURL *)URL block:(WMImageCacheResultBlock)block;
- (UIImage *)imageWithURL:(NSURL *)URL defaultImage:(UIImage *)defaultImage block:(WMImageCacheResultBlock)block;

- (void)storeImage:(UIImage *)image data:(NSData *)data path:(NSString *)path;
- (void)purgeMemoryCache;
- (void)deleteAllCacheFiles;

@end
