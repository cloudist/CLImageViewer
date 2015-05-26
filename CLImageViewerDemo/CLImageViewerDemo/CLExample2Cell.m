//
//  CLExample2Cell.m
//  CLImageViewerDemo
//
//  Created by ellochen on 15/5/26.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLExample2Cell.h"

@interface CLExample2Cell()

@end

@implementation CLExample2Cell

- (void)awakeFromNib {
    // Initialization code
    _imageViews = @[_imageView0, _imageView1, _imageView2, _imageView3, _imageView4, _imageView5];
    
    for (NSUInteger i = 0; i < _imageViews.count; ++i) {
        UIImageView* view = _imageViews[i];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tapGesture];
    }
}

- (void)handleGesture:(UIGestureRecognizer*) gesture {
    for (NSUInteger i = 0; i < _imageViews.count; ++i) {
        UIImageView* view = _imageViews[i];
        if (gesture.view == view) {
            if (self.onClickImage) {
                self.onClickImage(i);
            }
            return ;
        }
    }
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
