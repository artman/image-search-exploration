//
//  ISEImageCache.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^completionBlock) (UIImage *image);

/**
 * A simple image loader that can cache images in memory with optional resizing.
 */
@interface ISEImageCache : NSObject

/**
 * The shared singleton instance.
 */
+ (instancetype)sharedManager;

/**
 * Scales down a size to fit a max size retaining it's aspect ratio.
 * @param size The size to scale down.
 * @param maxSize The maximum width and height to fit the size into.
 */
+ (CGSize)resizeSizeRetainingAspectRatio:(CGSize)size withMaxSize:(CGSize)maxSize;

/**
 * Loads an image from a URL string and optionally caches it in memory. Returns instantly for subsequent 
 * requests on cached images as identified by the same URL string.
 * @param url The URL to load the image from.
 * @param cache Whether to cache the image.
 * @param completionBlock Invoked when the load completes. The image parameter will be nil if the load failed.
 * @return The operation that is responsible for loading the image or nil, if the image retreived from cache.
 */
- (AFHTTPRequestOperation *)loadImageFromURL:(NSString *)url cache:(BOOL)cache completion:(completionBlock)completionBlock;

/**
 * Loads am image from given URL, scales it down to a maximum width and height and optionally caches it in memory.
 * Returns instantly for subsequent requests on cached images identified the same URL string and size.
 * @param url The URL to load the image from.
 * @param maxSize The maximum size of the resulting image. The image will be resized maintaining aspect ratio.
 * @param cache Whether to cache the image
 * @param completionBlock Invoked when the load completes. The image parameter will be nil if the load failed.
 * @return The operation that is responsible for loading the image or nil, if the image was already retreived from cache.
 */
- (AFHTTPRequestOperation *)loadImageFromURL:(NSString *)url maxSize:(CGSize)maxSize cache:(BOOL)cache  completion:(completionBlock)completionBlock;

@end
