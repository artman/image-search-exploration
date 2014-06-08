//
//  ISEImageQueryManager.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISEImageMetadata.h"

@class ISEGoogleImageAPIBatchLoader;

@protocol ISEGoogleImageAPIBatchLoaderDelegate <NSObject>

@optional

/**
 * Called on the delegate when the batch loader has retreived a pagefull of image data
 */
- (void)googleImageBatchLoaderHasResults:(ISEGoogleImageAPIBatchLoader *)batchLoader;

@end

/**
 * A simple batch loader that fetched image metadata from Google's old Image Search API. The batch loader breaks
 * up a query into multiple subqueries to overcome Google's max limit of 8 images per page.
 */
@interface ISEGoogleImageAPIBatchLoader : NSObject

/**
 * The delegate that will be notified about query results.
 */
@property (weak, nonatomic) id<ISEGoogleImageAPIBatchLoaderDelegate> delegate;

/**
 * An array of found images of type IESImageMetadata.
 */
@property (readonly, nonatomic) NSArray *foundImages;

/**
 * Whether a query is currently running.
 */
@property (readonly, nonatomic) BOOL queryRunning;

/**
 * Whether there are more images available to query. If YES, the queryMore: method can be invoked to fetch
 * more images.
 */
@property (readonly, nonatomic) BOOL moreImagesAvailable;

/**
 * Initializes and starts a new query.
 * @param query The query to execute.
 * @param imageCount The number of images to start fetching.
 */
- (id)initWithQuery:(NSString *)query imageCount:(NSUInteger)imageCount;

/**
 * Instructs to fetch more images.
 * @param count The number of images to fetch.
 */
- (void)queryMore:(NSUInteger)count;

/**
 * Cancels all outstanding requests.
 */
- (void)cancel;

@end
