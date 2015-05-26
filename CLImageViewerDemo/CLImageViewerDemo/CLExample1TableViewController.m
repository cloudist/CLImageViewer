//
//  CLExample1TableViewController.m
//  CLImageViewerDemo
//
//  Created by ellochen on 15/5/26.
//  Copyright (c) 2015年 Cloudist. All rights reserved.
//

#import "CLExample1TableViewController.h"
#import "CLExample1Cell.h"
#import "CLImageViewer.h"

@interface CLExample1TableViewController ()
@property (nonatomic, strong)NSMutableArray* imageDataSource;
@end

@implementation CLExample1TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _imageDataSource = [NSMutableArray new];
    for (NSUInteger i = 1; i < 12; ++i) {
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        [_imageDataSource addObject:image];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _imageDataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLExample1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"example1Cell" forIndexPath:indexPath];
    
    UIImage* image = _imageDataSource[[indexPath row]];
    [cell.imageView setImage:image];
    __weak typeof(self)weakSelf = self;
    __weak typeof(cell)weakCell = cell;
    cell.onClickImage = ^ {
        NSMutableArray* placeHoldeImages = [NSMutableArray new];
        NSMutableArray* referenceRects = [NSMutableArray new];
        
        for (NSUInteger i = 0; i < weakSelf.imageDataSource.count; ++i) {
            UIImage* image = weakSelf.imageDataSource[i];
            [placeHoldeImages addObject:image];
        }
        [referenceRects addObject:[NSValue valueWithCGRect:weakCell.imageView0.frame]];
        CLImageViewer* imagesViewer = [CLImageViewer new];
        CLImageInfo* imagesInfo = [CLImageInfo new];
        imagesInfo.placeholderImages = placeHoldeImages;
        imagesInfo.startImageIndex = [indexPath row];
        imagesInfo.needSrollToOrigin = YES;
        imagesInfo.referenceRects = referenceRects;
        imagesInfo.referenceView = weakCell;
        imagesViewer.imageInfo = imagesInfo;
        imagesViewer.fromController = weakSelf;
        [imagesViewer showImageViewFromOriginPosition];
    };
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
