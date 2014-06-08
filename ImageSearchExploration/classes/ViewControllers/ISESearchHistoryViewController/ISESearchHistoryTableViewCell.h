//
//  ISESearchHistoryTableViewCell.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ISESearchHistoryTableViewCell : UITableViewCell

/**
 * The query string to display
 */
@property (copy, nonatomic) NSString *query;

@end
