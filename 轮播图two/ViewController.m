//
//  ViewController.m
//  轮播图two
//
//  Created by FDC-iOS on 16/9/6.
//  Copyright © 2016年 meilun. All rights reserved.
//

#import "ViewController.h"
#import "YSCollectionView.h"
#import "HMObjcSugar.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@end

NSString * const tableCellId = @"tableCellId";
#define kHeaderHeight 200

@implementation ViewController {
    NSArray <NSURL *>           *_urls;
    YSCollectionView            *_collectionView;
    UIView                      *_header;
    UIStatusBarStyle            _statusBarYStyle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self addTableView];
    [self addHeardView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _statusBarYStyle = UIStatusBarStyleLightContent;
}

- (void)addTableView {
    UITableView * table = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellId];
    table.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
}

- (void)addHeardView {
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.hm_width, kHeaderHeight)];
    _header.backgroundColor = [UIColor hm_colorWithHex:0xF8F8F8];
    [self.view addSubview:_header];
    _collectionView = [[YSCollectionView alloc] initWithUrls:_urls];
    
    _collectionView.frame = CGRectMake(0, 0, self.view.hm_width, kHeaderHeight);
    [_header addSubview:_collectionView];
}



- (void)loadData {
    NSMutableArray * temp = [NSMutableArray array];
    for (int i = 0; i < 3; i ++) {
        NSString * fileName = [NSString stringWithFormat:@"%zd.jpg",i];
        NSURL * url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        [temp addObject:url];
    }
    _urls = temp.copy;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + kHeaderHeight;
//    NSLog(@"%f",offset);
    if (offset < 0) {
        NSDictionary *dic = @{
                              @"offset" : [NSString stringWithFormat:@"%f",offset]
                              };
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"zys" object:nil userInfo:dic];
        _header.hm_height = kHeaderHeight;
        _header.hm_y = 0;
        _header.hm_height = kHeaderHeight - offset;
        _collectionView.alpha = 1;
    } else {
        
        _header.hm_y = 0;
        CGFloat minOffset = kHeaderHeight - 64;
        _header.hm_y = minOffset > offset ? - offset : - minOffset;
        
        CGFloat progress = 1 - (offset / minOffset);
        _collectionView.alpha = progress;
        _statusBarYStyle = progress < 0.4 ? UIStatusBarStyleDefault:UIStatusBarStyleLightContent;
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }
    _collectionView.hm_height = _header.hm_height;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarYStyle;
}


// zhu yi  yi chu  tong  zhi ..  !移!除!
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tingzhi" object:nil userInfo:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jixu" object:nil userInfo:nil];
}

@end
