//
//  UIView+Geometry.h
//  Extensions
//
//  Created by Tuomas Artman on 7/18/2013.
//  Copyright (c) 2013 Tuomas Artman. All rights reserved.
//

@interface UIView (Geometry)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (void)roundToFullPoints;

@end
