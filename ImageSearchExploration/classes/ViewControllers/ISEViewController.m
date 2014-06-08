//
//  ISEViewController.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISEViewController.h"
#import "ISEImageSearchCollectionViewCell.h"
#import "ISEGoogleImageAPIBatchLoader.h"
#import "ISEImageSearchCollectionFooterView.h"
#import "UIView+Geometry.h"
#import "ISEImageCache.h"
#import "ISEAlertHelper.h"

@interface ISEViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *searchHistoryContainerView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchHistoryHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sarchBarCenterConstraint;

@property (strong, nonatomic) ISEImageSearchCollectionFooterView *footerView;
@property (strong, nonatomic) ISESearchHistoryViewController *searchHistoryViewController;
@property (strong, nonatomic) ISEGoogleImageAPIBatchLoader *imageQuery;
@property (copy, nonatomic) NSString *activeQuery;

@end

@implementation ISEViewController

static NSString * const ImageSearchCellIdentifier = @"ISEImageSearchCollectionViewCell";
static NSString * const FooterViewIndetifier = @"ISEImageSearchCollectionFooterView";
static NSString * const SearchHistorySegueIdentifier = @"searchHistorySegue";
static const CGSize MaxImageCellSize = {94, 180};
static const CGFloat KeyboardHeight = 220;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.layer.cornerRadius = 6;
    self.searchBar.layer.masksToBounds = YES;
    self.searchHistoryHeightContraint.constant = 0;
    self.navigationBar.alpha = 0;
    self.imageCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(self.searchBar.bottom, 0, 0, 0);
}

- (void)startNewQuery:(NSString *)query {
    [self.imageQuery cancel];
    
    self.activeQuery = query;
    self.searchBar.text = query;
    self.imageQuery = [[ISEGoogleImageAPIBatchLoader alloc] initWithQuery:query imageCount:18];
    self.imageQuery.delegate = self;
    
    [self.imageCollectionView reloadData];
    [self.searchHistoryViewController addQuery:query];
    [self.searchBar resignFirstResponder];
}

- (void)checkQueryStatus {
    if (!self.imageQuery.queryRunning && self.imageQuery.moreImagesAvailable) {
        if (self.imageCollectionView.contentSize.height - self.imageCollectionView.contentOffset.y < self.imageCollectionView.height) {
            [self.imageQuery queryMore:18];
        }
    }
}

#pragma mark - UICollectionView datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (!self.imageQuery) {
        return 0;
    }
    return self.imageQuery.foundImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ISEImageSearchCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageSearchCellIdentifier
                                                                                       forIndexPath:indexPath];
    ISEImageMetadata *image = self.imageQuery.foundImages[indexPath.row];
    cell.image = image;
    
    [self checkQueryStatus];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionFooter) {
        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                             withReuseIdentifier:FooterViewIndetifier
                                                                    forIndexPath:indexPath];
        [self updateFooterView];
        return self.footerView;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
 sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ISEImageMetadata *image = self.imageQuery.foundImages[indexPath.row];
    CGSize size = [ISEImageCache resizeSizeRetainingAspectRatio:image.size withMaxSize:MaxImageCellSize];
    size.width = MaxImageCellSize.width;
    return size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self checkQueryStatus];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self showSearchHistory];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    if (self.navigationBar.alpha == 0) {
        // First time selection, animate bar up
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            // Animate search bar to top of window
            self.navigationBar.alpha = 1;
            self.searchBarTopConstraint.priority = 750;
            [self.view removeConstraint:self.sarchBarCenterConstraint];
            [self.view layoutIfNeeded];
            
        } completion:nil];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self hideSearchHistory];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startNewQuery:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    self.searchBar.text = self.activeQuery;
    [self.searchBar resignFirstResponder];
}

#pragma mark - ISESearchHistoryViewControllerDelegate

- (void)searchHistoryViewController:(ISESearchHistoryViewController *)viewController didSelectQuery:(NSString *)query {
    [self startNewQuery:query];
}

- (void)showSearchHistory {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.imageCollectionView.alpha = 0.5;
        
        CGFloat historyHeight = [self.searchHistoryViewController contentHeight];
        CGFloat maxHistoryHeight = self.view.bottom - self.searchHistoryContainerView.top - KeyboardHeight;
        self.searchHistoryHeightContraint.constant = MIN(historyHeight, maxHistoryHeight);
        [self.searchHistoryContainerView layoutIfNeeded];
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

- (void)hideSearchHistory {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.searchHistoryHeightContraint.constant = 0;
        self.imageCollectionView.alpha = 1.0;
        [self.searchHistoryContainerView layoutIfNeeded];
        
    } completion:nil];
}

#pragma mark - ISEImageQueryManagerDelegate

- (void)googleImageBatchLoaderHasResults:(ISEGoogleImageAPIBatchLoader *)batchLoader {
    [self updateFooterView];
    if (batchLoader.foundImages.count == 0) {
        // No images found, display alert
        NSString *message = [NSString stringWithFormat:@"Couldn't find any images for search query '%@'", self.activeQuery];
        [ISEAlertHelper showAlertWithTitle:@"Not found" message:message buttonTitle:@"Damn..."];
        
    } else {
        // Add as many sections to the collectionView as we need to
        NSUInteger lastIndex = [self.imageCollectionView numberOfItemsInSection:0];
        NSUInteger count = batchLoader.foundImages.count - lastIndex;
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i=0; i<count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:lastIndex + i inSection:0];
            [indexPaths addObject:indexPath];
            
        }
        [self.imageCollectionView insertItemsAtIndexPaths:indexPaths];
        [self checkQueryStatus];
    }
}

- (void)updateFooterView {
    self.footerView.loading = self.imageQuery.moreImagesAvailable;
    self.footerView.hidden = self.imageQuery == nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SearchHistorySegueIdentifier]) {
        self.searchHistoryViewController = segue.destinationViewController;
        self.searchHistoryViewController.delegate = self;
    }
}

@end
