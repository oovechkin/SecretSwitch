//
//  SerectSwitch.m
//  SecretSwitch
//
//  Created by croath on 1/22/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "SecretSwitch.h"
#import <Accelerate/Accelerate.h>

@implementation SecretSwitch

static UIImageView *imageView;

+ (void)protectSecret
{
  if (imageView == nil) {
    imageView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [imageView.layer setBorderWidth:1.f];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleToFill];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationWillResignActive)
                                               name:UIApplicationWillResignActiveNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(applicationDidBecomeActive)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

+ (void)applicationWillResignActive
{
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  UIView *view = [window.subviews lastObject];
  
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width/4, view.bounds.size.height/4), NO, 0);
  
  [view drawViewHierarchyInRect:CGRectMake(view.bounds.origin.x,
                                           view.bounds.origin.y,
                                           view.bounds.size.width/4,
                                           view.bounds.size.height/4)
             afterScreenUpdates:NO];
  
  UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  
  //boxsize must be an odd integer
  uint32_t boxSize = (uint32_t)(5.0f * copied.scale);
  if (boxSize % 2 == 0)
    boxSize ++;
  
  //create image buffers
  CGImageRef imageRef = copied.CGImage;
  vImage_Buffer buffer1, buffer2;
  buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
  buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
  buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
  size_t bytes = buffer1.rowBytes * buffer1.height;
  buffer1.data = malloc(bytes);
  buffer2.data = malloc(bytes);
  
  //create temp buffer
  void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                               NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
  
  //copy image data
  CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
  memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
  CFRelease(dataSource);
  
  for (NSUInteger i = 0; i < 1; i++) {
    //perform blur
    vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    //swap buffers
    void *temp = buffer1.data;
    buffer1.data = buffer2.data;
    buffer2.data = temp;
  }
  
  //free buffers
  free(buffer2.data);
  free(tempBuffer);
  
  //create image context from buffer
  CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                           8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                           CGImageGetBitmapInfo(imageRef));
  
  //apply tint
  //  if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
  //  {
  //    CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
  //    CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
  //    CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
  //  }
  
  //create image from context
  imageRef = CGBitmapContextCreateImage(ctx);
  UIImage *image = [UIImage imageWithCGImage:imageRef
                                       scale:copied.scale
                                 orientation:copied.imageOrientation];
  CGImageRelease(imageRef);
  CGContextRelease(ctx);
  free(buffer1.data);
  
  [imageView setAlpha:1.f];
  [imageView setImage:image];
  [window addSubview:imageView];
}

+ (void)applicationDidBecomeActive
{
  [UIView animateWithDuration:0.3f
                   animations:^{
                     [imageView setAlpha:0.f];
                   } completion:^(BOOL finished) {
                     if (finished) {
                       [imageView removeFromSuperview];
                     }
                   }];
}
@end
