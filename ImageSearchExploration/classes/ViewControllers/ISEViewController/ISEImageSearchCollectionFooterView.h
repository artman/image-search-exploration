//
//  ISEImageSearchCollectionViewFooter.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISEImageSearchCollectionFooterView : UICollectionReusableView

/**
 * Whether to display a loading state (YES) or that all results have been loaded (NO)
 */
@property (assign, nonatomic) BOOL loading;

@end
