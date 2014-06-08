//
//  ISEImageMetadata.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISEImageMetadata : NSObject

/**
 * The url of the image
 */
@property (copy, nonatomic) NSString *url;

/**
 * The size of the iamge
 */
@property (assign, nonatomic) CGSize size;

/**
 * Initializes the image metadata
 */
- (id)initWithURL:(NSString *)url size:(CGSize)size;

@end
