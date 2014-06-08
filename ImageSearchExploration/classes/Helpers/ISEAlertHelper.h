//
//  ISEAlertManager.h
//  ImageSearchExploration
//
//  Created by Tuomas Artman on 6/7/2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Helper methods to show alerts.
 */
@interface ISEAlertHelper : NSObject

/**
 * Displays an alert.
 * @param title The title for the alert.
 * @param message The message for the alert.
 * @param buttonTitle The title for the alert dialog button.
 */
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;

@end
