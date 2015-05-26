//
//  UIImageView+Helper.m
//  fanpianr
//
//  Created by ellochen on 15/5/25.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "UIImageView+Helper.h"
@implementation UIImageView (Helper)

- (CGSize)contentSize
{
    return [self.image fitSizeWithViewSize:self.bounds.size];
}

- (CGSize)contentSizeWithParentViewSize:(CGSize)size
{
    return [self.image fitSizeWithViewSize:size];
}


@end