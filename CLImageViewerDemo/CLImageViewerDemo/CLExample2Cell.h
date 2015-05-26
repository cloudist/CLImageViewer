//
//  CLExample2Cell.h
//  CLImageViewerDemo
//
//  Created by ellochen on 15/5/26.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLExample2Cell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView0;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong, nonatomic) NSArray* imageViews;

@property (nonatomic, copy)void (^onClickImage)(NSUInteger index);
@end
