//
//  CLImageViewer.h
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLImageInfo.h"
@interface CLImageViewer : UIViewController
@property (strong, nonatomic) CLImageInfo* imageInfo;
@property (weak, nonatomic) UIViewController* fromController;

- (void)showImageViewFromOriginPosition;

@end
