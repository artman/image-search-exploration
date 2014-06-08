//
//  ISESearchHistoryTableViewCell.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISESearchHistoryTableViewCell.h"

@interface ISESearchHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *queryLabel;

@end

@implementation ISESearchHistoryTableViewCell

- (void)setQuery:(NSString *)query {
    _query = query;
    self.queryLabel.text = query;
}

@end
