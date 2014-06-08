//
//  ISEImageMetadata.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISEImageMetadata.h"

@implementation ISEImageMetadata

- (id)initWithURL:(NSString *)url size:(CGSize)size {
    self = [super init];
    if (self) {
        self.url = url;
        self.size = size;
    }
    return self;
}

@end
