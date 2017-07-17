//
//  MKTableViewController.m
//  MKRefresh
//
//  Created by MikeWang on 16/8/16.
//  Copyright © 2016年 MikeWang. All rights reserved.
//

#import "MKTableViewController.h"
#import "MKHeadRefreshView.h"
#import "MKFooterRefreshView.h"

@interface MKTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MKTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"海南之美";
    
    //创建下拉控件
    MKHeadRefreshView *refreshHeadView = [[MKHeadRefreshView alloc]init];
    
    [self.tableView addSubview:refreshHeadView];
    
    __block MKHeadRefreshView *blockHeadView = refreshHeadView;
    refreshHeadView.refresh = ^(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
            [blockHeadView stopRefresh];
        });
    };
    
    MKFooterRefreshView *footerRefreshView = [[MKFooterRefreshView alloc]init];
    [self.tableView addSubview:footerRefreshView];
    __block MKFooterRefreshView *blockFooterView = footerRefreshView;
    footerRefreshView.refreshMoreData = ^() {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self loadMoreData];
                    [blockFooterView stopRefresh];
                });
    };
    
    self.tableView.tableFooterView = [[UIView alloc]init];//消除tableView的FooterView的影响
    
}

- (void)loadData {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"海口2"];
    [array addObject:@"琼海3"];
    [array addObject:@"三亚3"];
    [array addObject:@"文昌3"];
   
    
    [array addObjectsFromArray:self.dataArray];
    self.dataArray = array;
    [self.tableView reloadData];
    
}

- (void)loadMoreData {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"海口1"];
    [array addObject:@"琼海1"];
    [array addObject:@"三亚1"];
    [array addObject:@"文昌1"];
    
    
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self loadData];
}


- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"海口"];
        [_dataArray addObject:@"琼海"];
        [_dataArray addObject:@"三亚"];
        [_dataArray addObject:@"文昌"];
        [_dataArray addObject:@"海口"];
        [_dataArray addObject:@"琼海"];
        [_dataArray addObject:@"三亚"];
        [_dataArray addObject:@"文昌"];
        [_dataArray addObject:@"海口"];
        [_dataArray addObject:@"琼海"];
        [_dataArray addObject:@"三亚"];
        [_dataArray addObject:@"文昌"];
        [_dataArray addObject:@"琼海"];
        [_dataArray addObject:@"三亚"];
        [_dataArray addObject:@"文昌"];
    }
    return _dataArray;
}

@end
