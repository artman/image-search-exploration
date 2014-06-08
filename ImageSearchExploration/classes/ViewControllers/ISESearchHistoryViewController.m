//
//  ISESearchHistoryViewController.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISESearchHistoryViewController.h"
#import "ISESearchHistoryTableViewCell.h"
#import "UIView+Geometry.h"

@interface ISESearchHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property NSMutableArray *queries;

@end

@implementation ISESearchHistoryViewController

static const CGFloat TableViewTopMargin = 18.0;
static const NSUInteger QueriesToKeep = 2;
static NSString * const SarchHistoryCellIdentifier = @"ISESearchHistoryTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queries = [NSMutableArray array];
    self.searchHistoryTableView.contentInset = UIEdgeInsetsMake(TableViewTopMargin, 0, 0, 0);
    
    CALayer *layer = self.view.layer;
    layer.cornerRadius = 6;
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    layer.borderWidth = .5;
}

- (void)addQuery:(NSString *)query {
    [self.queries removeObject:query];
    [self.queries insertObject:query atIndex:0];
    if (self.queries.count > QueriesToKeep) {
        [self.queries removeLastObject];
    }
    [self.searchHistoryTableView reloadData];
}

- (CGFloat)contentHeight {
    if (self.queries.count) {
        return self.searchHistoryTableView.contentSize.height + TableViewTopMargin;
    } else {
        return 0;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ISESearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SarchHistoryCellIdentifier];
    cell.query = self.queries[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(searchHistoryViewController:didSelectQuery:)]) {
        [self.delegate searchHistoryViewController:self didSelectQuery:self.queries[indexPath.row]];
    }
}

@end
