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
@property (nonatomic, strong) CLImageInfo* imageInfo;
@property (nonatomic, weak) UIViewController* fromController;

- (void)showImageViewFromOriginPosition;

@end
