//
//  ISEImageSearchCollectionViewCell.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISEImageSearchCollectionViewCell.h"
#import "ISEImageCache.h"

@interface ISEImageSearchCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundWidthConstraint;

@property (weak, nonatomic) AFHTTPRequestOperation *pendingLoadingOperation;

@end

@implementation ISEImageSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CALayer *layer = self.backgroundView.layer;
    layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    layer.borderWidth = 1;
    layer.cornerRadius = 4;
    layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    [self.pendingLoadingOperation cancel];
}

- (void)setImage:(ISEImageMetadata *)image {
    _image = image;
    CGSize imageSize = [ISEImageCache resizeSizeRetainingAspectRatio:image.size withMaxSize:self.frame.size];
    self.backgroundWidthConstraint.constant = imageSize.width;
    
    __block BOOL didFetchImmediatelyFromCache = YES;
    self.pendingLoadingOperation = [[ISEImageCache sharedManager] loadImageFromURL:image.url maxSize:self.frame.size cache:YES completion:^(UIImage *image) {
        if (image) {
            self.imageView.image = image;
            self.imageView.contentMode = UIViewContentModeScaleToFill;
            
            if (!didFetchImmediatelyFromCache) {
                // Did require load from the network, animate in as we've got the cell already on screen
                self.imageView.alpha = 0;
                self.imageView.transform = CGAffineTransformMakeScale(1.15, 1.15);
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.imageView.alpha = 1;
                    self.imageView.transform = CGAffineTransformIdentity;
                } completion:nil];
            }
        } else {
            self.imageView.image = [UIImage imageNamed:@"notfound"];
            self.imageView.contentMode = UIViewContentModeCenter;
        }
    }];
    didFetchImmediatelyFromCache = NO;
}

@end
