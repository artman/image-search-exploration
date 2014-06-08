//
//  ISEImageSearchCollectionViewFooter.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISEImageSearchCollectionFooterView.h"

@interface ISEImageSearchCollectionFooterView ()

@property (weak, nonatomic) IBOutlet UIView *loadingMoreView;
@property (weak, nonatomic) IBOutlet UIView *doneLoadingView;

@end

@implementation ISEImageSearchCollectionFooterView

- (void)setLoading:(BOOL)loadingMore {
    _loading = loadingMore;
    self.loadingMoreView.hidden = !loadingMore;
    self.doneLoadingView.hidden = loadingMore;
}

@end
