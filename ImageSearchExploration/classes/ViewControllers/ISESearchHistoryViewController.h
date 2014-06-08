//
//  ISESearchHistoryViewController.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ISESearchHistoryViewController;

@protocol ISESearchHistoryViewControllerDelegate <NSObject>

@optional
/**
 * Invoked on the delegate when a query is selected.
 * @param viewController The search history view controller delegate whose query was selected.
 * @param query The query string that was selected.
 */
- (void)searchHistoryViewController:(ISESearchHistoryViewController *)viewController didSelectQuery:(NSString *)query;

@end

@interface ISESearchHistoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

/**
 * The delegate.
 */
@property (weak, nonatomic) id<ISESearchHistoryViewControllerDelegate> delegate;

/**
 * Adds a query to the list of items to display.
 */
- (void)addQuery:(NSString *)query;

/**
 * The height of the view controller needs to be in order to display the full history of search queries.
 */
- (CGFloat)contentHeight;

@end
