//
//  UIImageView+Helper.h
//  fanpianr
//
//  Created by ellochen on 15/5/25.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Helper.h"
@interface UIImageView (Helper)

- (CGSize)contentSize;
- (CGSize)contentSizeWithParentViewSize:(CGSize)size;

@end


