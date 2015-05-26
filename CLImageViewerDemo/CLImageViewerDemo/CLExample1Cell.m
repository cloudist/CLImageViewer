//
//  CLExample1Cell.m
//  CLImageViewerDemo
//
//  Created by ellochen on 15/5/26.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLExample1Cell.h"

@interface CLExample1Cell()

@end

@implementation CLExample1Cell

- (void)awakeFromNib {
    // Initialization code
    _imageView0.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.contentView addGestureRecognizer:tapGesture];
}

- (void)handleGesture:(UIGestureRecognizer*) gesture {
    if (self.onClickImage) {
        self.onClickImage();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
