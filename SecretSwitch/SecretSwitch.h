//
//  SecretSwitch.h
//  SecretSwitch
//
//  Created by croath on 1/22/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class provides methodology for masking sensitive content in the snapshots that iOS7 takes when an app becomes inactive.
*/
@interface SecretSwitch : NSObject

/** Sets up the singleton SecretSwitch object and hooks it up to willResignActive and didBecomeActive notifications. All you need to get going!
 */
+ (void)protectSecret;

/**
 Sets the degree to which the screen is blurred.
 @param factor The value will be clipped between 1 and 100.
 */
+ (void)setBlurFactor:(CGFloat)factor;

/**
 Sets the factor with which to reduce the resolution. For instance, 1 leads to a screenshot of 2048*1536 on iPad Retina displays, 2 means 1024*768, 3 means 512*384, 4 means 256*192 and so on.
 @param factor The value will be clipped between 1 and 8.
 */
+ (void)setResolutionFactor:(NSInteger)factor;

@end
