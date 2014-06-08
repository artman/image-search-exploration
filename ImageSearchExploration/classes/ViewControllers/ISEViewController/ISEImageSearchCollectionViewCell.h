//
//  ISEImageSearchCollectionViewCell.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISEImageMetadata.h"

@interface ISEImageSearchCollectionViewCell : UICollectionViewCell

/**
 * The image metadata to load and display.
 */
@property (copy, nonatomic) ISEImageMetadata *image;

@end
