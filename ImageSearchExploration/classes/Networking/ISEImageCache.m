//
//  ISEImageCache.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISEImageCache.h"

@interface ISEImageCache ()

@property (strong, nonatomic) NSMutableDictionary *cache;

@end

@implementation ISEImageCache

+ (instancetype)sharedManager {
    static ISEImageCache *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (CGSize)resizeSizeRetainingAspectRatio:(CGSize)size withMaxSize:(CGSize)maxSize {
    if (size.width > maxSize.width || size.height > maxSize.height) {
        CGFloat widthRatio = maxSize.width / size.width;
        CGFloat heightRatio = maxSize.height / size.height;
        if (widthRatio < heightRatio) {
            size.width = maxSize.width;
            size.height = size.height * widthRatio;
        } else {
            size.height = maxSize.height;
            size.width = size.width * heightRatio;
        }
    }
    return size;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [NSMutableDictionary dictionary];
    }
    return self;
}

- (AFHTTPRequestOperation *)loadImageFromURL:(NSString *)url cache:(BOOL)cache completion:(completionBlock)completionBlock  {
    if (self.cache[url]) {
        completionBlock(self.cache[url]);
        return nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // No need to weakify self, cache is expected to live forever
        if (cache) {
            self.cache[url] = responseObject;
        }
        completionBlock(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (!operation.isCancelled) {
            completionBlock(nil);
        }
    }];
    [operation start];
    return operation;
}

- (AFHTTPRequestOperation *)loadImageFromURL:(NSString *)url maxSize:(CGSize)maxSize cache:(BOOL)cache completion:(completionBlock)completionBlock {
    NSString *key = [NSString stringWithFormat:@"%@|%f|%f", url, maxSize.width, maxSize.height];
    
    if (self.cache[key]) {
        completionBlock(self.cache[key]);
        return nil;
    }
    return [self loadImageFromURL:url cache:NO completion:^(UIImage *image) {
        if (image) {
            // Resize image to maintaining aspect ratio
            CGSize size = [ISEImageCache resizeSizeRetainingAspectRatio:image.size withMaxSize:maxSize];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                CGRect rect = CGRectMake(0, 0, size.width, size.height);
                UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
                [image drawInRect:rect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (cache) {
                        self.cache[key] = resizedImage;
                    }
                    completionBlock(resizedImage);
                });
            });
        } else {
            completionBlock(nil);
        }
    }];
}

@end
