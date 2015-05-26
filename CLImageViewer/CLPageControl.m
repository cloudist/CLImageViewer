//
//  CLPageControl.m
//  fanpianr
//
//  Created by ellochen on 15/5/19.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLPageControl.h"

@implementation CLPageControl {
    UILabel* _label;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.text = @"0/0";
        _label.center = self.center;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)setCurrentPage:(NSUInteger)currentPage {
    _currentPage = currentPage;
    _label.text = [[[NSString stringWithFormat:@"%lu", (unsigned long)_currentPage + 1]
                        stringByAppendingString:@"/"]
                        stringByAppendingString:[NSString
                               stringWithFormat:@"%ld", (long)_numberOfPages]];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
}

@end
