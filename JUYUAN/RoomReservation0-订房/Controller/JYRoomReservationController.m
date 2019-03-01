//
//  JYRoomReservationController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRoomReservationController.h"
#import "JYHomeTableViewCell.h"
#import "JYRoomListViewController.h"
#import "CZHotSearchView.h"

@interface JYRoomReservationController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
/** 搜索框 */
@property (nonatomic, strong) CZHotSearchView *search;
@end

@implementation JYRoomReservationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchView];
    [self.view addSubview:self.tableView];
}

- (void)setupSearchView
{
    self.search = [[CZHotSearchView alloc] initWithFrame:CGRectMake(14, IsiPhoneX ? 54 : 30, SCR_WIDTH - 28, 34) msgAction:^(NSString *title){
        NSLog(@"哈哈哈哈");
    }];
    self.search.textFieldActive = NO;
    [self.view addSubview:self.search];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushSearchController)];
    [self.search addGestureRecognizer:tap];
}

#pragma mark - 响应事件
- (void)pushSearchController
{
    NSLog(@"啦啦啦啦");
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight + 10, SCR_WIDTH, SCR_HEIGHT - kNavAndTabHeight - 10 - 10) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerNib:[UINib nibWithNibName:@"JYHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"JYHomeTableViewCell"];
        
    }
    return _tableView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 50)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *name = [[UILabel alloc] init];
        name.text = @"全部公寓";
        name.font = [UIFont boldSystemFontOfSize:22];
        name.frame = CGRectMake(20, 10, 100, 40);
        [_headerView addSubview:name];
    }
    return _headerView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    JYHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JYHomeTableViewCell"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCR_WIDTH - 30 ) / 1.7 + 75;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JYRoomListViewController *vc = [[JYRoomListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
