//
//  CLPageControl.h
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPageControl : UIView

@property (nonatomic, assign) NSUInteger currentPage;
@property(nonatomic) NSInteger numberOfPages;

- (void)setCurrentPage:(NSUInteger)currentPage;
- (void)setNumberOfPages:(NSInteger)numberOfPages;

@end
