//
//  UIImage+Helper.h
//  fanpianr
//
//  Created by ellochen on 15/5/25.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)

- (CGSize)fitSizeWithViewSize:(CGSize)size;
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end
