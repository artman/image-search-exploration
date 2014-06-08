//
//  ISEImageQueryManager.m
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import "ISEGoogleImageAPIBatchLoader.h"
#import "AFNetworking.h"
#import "ISEAlertHelper.h"

@interface ISEGoogleImageAPIBatchLoader ()

@property (copy, nonatomic) NSString *query;
@property (strong, nonatomic) dispatch_group_t requestGroup;
@property (strong, nonatomic) NSMutableArray *mutableFoundImages;
@property (strong, nonatomic) NSMutableArray *operations;
@property (assign, nonatomic) NSUInteger queryOffset;
@property (assign, nonatomic) BOOL queryRunning;
@property (assign, nonatomic) BOOL moreImagesAvailable;
@property (assign, nonatomic) BOOL cancelled;

@end

@implementation ISEGoogleImageAPIBatchLoader

const NSUInteger MaxImagesPerPage = 8;

- (id)initWithQuery:(NSString *)query imageCount:(NSUInteger)imageCount {
    self = [super init];
    if (self) {
        self.query = query;
        self.mutableFoundImages = [NSMutableArray array];
        self.requestGroup = dispatch_group_create();
        self.operations = [NSMutableArray array];
        self.moreImagesAvailable = YES;
        self.queryOffset = 0;
        
        if (imageCount > 0) {
            [self queryMore:imageCount];
        }
    }
    return self;
}

- (void)queryMore:(NSUInteger)count {
    NSAssert(count > 0, @"Query count needs to be > 0");
    
    self.queryRunning = YES;

    while(count > 0) {
        NSUInteger imagesToLoad = MIN(count, MaxImagesPerPage);
        count -= imagesToLoad;
        
        dispatch_group_enter(self.requestGroup);
        
        NSString *queryString = [self.query stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        
        NSString *string = [NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/"
                            "images?v=1.0&rsz=%i&q=%@&start=%i&&imgsz=medium", imagesToLoad, queryString, self.queryOffset];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:string]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_group_leave(self.requestGroup);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_group_leave(self.requestGroup);
        }];
        
        [self.operations addObject:operation];
        [operation start];
        self.queryOffset += imagesToLoad;
    }
    
    // Wait until all operations have finished, the get results in order
    dispatch_group_notify(self.requestGroup, dispatch_get_main_queue(), ^{
        if (!self.queryRunning) {
            // Query has been cancelled
            return;
        }
        
        self.queryRunning = NO;
        NSMutableArray *loadedUrls = [NSMutableArray array];
        for (AFHTTPRequestOperation *operation in self.operations) {
            if ([operation.responseObject isKindOfClass:[NSDictionary class]] && operation.responseObject[@"responseData"]) {
                NSDictionary *responseObject = operation.responseObject;
                if ([responseObject[@"responseData"] isKindOfClass:[NSDictionary class]]) {
                    for (NSDictionary *response in responseObject[@"responseData"][@"results"]) {
                        if (response[@"unescapedUrl"] && response[@"width"] && response[@"height"]) {
                            CGFloat width = ((NSNumber *)response[@"width"]).floatValue;
                            CGFloat height = ((NSNumber *)response[@"height"]).floatValue;
                            
                            ISEImageMetadata *image = [[ISEImageMetadata alloc] initWithURL:response[@"unescapedUrl"] size:CGSizeMake(width, height)];
                            [loadedUrls addObject:image];
                        }
                    }
                } else {
                    // Hitting errors, better throttle
                    self.moreImagesAvailable = NO;
                }
            }
        }
        
        if (loadedUrls.count == 0) {
            // No more results available
            self.moreImagesAvailable = NO;
        }
        
        [self.operations removeAllObjects];
        [self.mutableFoundImages addObjectsFromArray:loadedUrls];
        if ([self.delegate respondsToSelector:@selector(googleImageBatchLoaderHasResults:)]) {
            [self.delegate googleImageBatchLoaderHasResults:self];
        }
    });
}

- (void)cancel {
    self.queryRunning = NO;
    for (AFHTTPRequestOperation *operation in self.operations) {
        if(!operation.isFinished) {
            [operation cancel];
        }
    }
    [self.operations removeAllObjects];
}

- (NSArray *)foundImages {
    return [NSArray arrayWithArray:self.mutableFoundImages];
}

@end
