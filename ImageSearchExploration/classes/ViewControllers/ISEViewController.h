//
//  ISEViewController.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISEGoogleImageAPIBatchLoader.h"
#import "ISESearchHistoryViewController.h"

@interface ISEViewController : UIViewController <ISEGoogleImageAPIBatchLoaderDelegate, UICollectionViewDataSource,
UICollectionViewDelegate, UISearchBarDelegate, ISESearchHistoryViewControllerDelegate>

@end
