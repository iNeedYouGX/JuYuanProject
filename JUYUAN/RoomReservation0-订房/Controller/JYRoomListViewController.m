//
//  JYRoomListViewController.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRoomListViewController.h"
#import "JYRoomListCollectionViewCell.h"
#import "JYRoomListModel.h"
#import "GXNetTool.h"
#import "JYRoomReservationSubModel.h"
#import "JYHtmlDetailViewController.h"
#import "JYUserInfoManager.h"
#import "JYLoginController.h"

@interface JYRoomListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *msgButton;

@property (weak, nonatomic) IBOutlet UILabel *apartmentLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewTop;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *topView;
/** 为了挡住动画 */
@property (nonatomic, weak) IBOutlet UIView *topTopView;
/** <#注释#> */
@property (nonatomic, weak) IBOutlet UIView *arrowView;
/**  */
@property (nonatomic, weak) IBOutlet UILabel *arrowLable;
/** <#注释#> */
@property (nonatomic, strong) UIView *titlesView;
/** <#注释#> */
@property (nonatomic, assign) CGFloat titlesH;
/** <#注释#> */
@property (nonatomic, strong) UIView *masksView;

/** <#注释#> */
@property (nonatomic, assign) BOOL isUnfold;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;

@property (nonatomic, strong) NSArray<JYRoomListModel *> *dataArray;
// 楼层model
@property (nonatomic, strong) NSArray<JYRoomReservationSubModel *> *storeyArray;
// 当前楼层
@end

@implementation JYRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [JYRoomListModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"room_id" : @"id"
                 };
    }];
    // 获取楼层列表
    [self getApartmentStoreysListNet];
    self.titleViewTop.constant = kStatusBarHeight;
    [self.view addSubview:self.collectionView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowAction)];
    [self.arrowView addGestureRecognizer:tap];
    self.arrowLable.text = self.name;
    self.apartmentLabel.text = self.apartmentName;

    [self getNetwork];
    
    //创建刷新控件
    [self setupRefresh];
}

- (void)setupRefresh
{
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadNewDiscover)];
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDiscover)];
}

// 加载数据
- (void)reloadNewDiscover
{
    [self.collectionView.mj_header endRefreshing];
}

// 加载更多数据
- (void)loadMoreDiscover
{
    [self.collectionView.mj_footer endRefreshing];
}


- (UIView *)titlesView
{
    if (_titlesView == nil) {
        
        CGFloat btnW = 60;
        CGFloat btnH = 25;
        NSInteger cols = 4;
        
        NSInteger row = (self.storeyArray.count + (cols - 1)) / cols;
        UIView *titlesView = [[UIView alloc] init];
        titlesView.backgroundColor = [UIColor whiteColor];
        titlesView.width = SCR_WIDTH;
        titlesView.height = 0;
        self.titlesH = (row + row + 1) * btnH;
        titlesView.y = - (kNavBarAndStatusBarHeight + self.titlesH);
        titlesView.x = 0;
        _titlesView = titlesView;
        
        self.masksView = [[UIView alloc] init];
        self.masksView.y = self.titlesH;
        self.masksView.width = SCR_WIDTH;
        self.masksView.height = SCR_HEIGHT - self.masksView.y;
        [self.view addSubview:self.masksView];
        self.masksView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.masksView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapAction)];
        [self.masksView addGestureRecognizer:tap];
        
        CGFloat space = (SCR_WIDTH - (38 * 2) - (cols * btnW)) /  (cols - 1);
        for (int i = 0; i < self.storeyArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.width = btnW;
            btn.height = btnH;
            btn.x = 38 + (i % cols) * (btnW + space);
            btn.y = btnH + (i / cols) * (btnH + btnH);
            [btn setTitle:self.storeyArray[i].name forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor: [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00]forState:UIControlStateNormal];
            btn.layer.cornerRadius = 2;
            [_titlesView addSubview:btn];
            [self changeBtnUI:btn index:i];
            btn.tag = self.storeyArray[i].storeyId;
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    return _titlesView;
}
-(void)maskViewTapAction{
    [self contorlTopView];
}
- (void)changeButtonUI {
    for (int i = 0; i < self.storeyArray.count; i++) {
        UIButton *btn = (UIButton *)self.titlesView.subviews[i];
        [self changeBtnUI:btn index:i] ;
    }
}
- (void)changeBtnUI:(UIButton *)btn index:(NSInteger)i{
    if (self.storey_id == self.storeyArray[i].storeyId) {
        btn.backgroundColor = [UIColor colorWithRed:0.99 green:0.82 blue:0.26 alpha:1.00];
        [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        btn.layer.borderWidth = 0;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
    } else {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor: [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00]forState:UIControlStateNormal];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00].CGColor;
    }
}
#pragma mark - 点击选择楼层
- (void)btnAction:(UIButton *)btn {
    self.storey_id = btn.tag;
    [self changeButtonUI];
    for (int i = 0; i < self.storeyArray.count; i++) {
        if (self.storeyArray[i].storeyId == btn.tag) {
            self.arrowLable.text = self.storeyArray[i].name;
        }
    }
    
    [self getNetwork];
    [self contorlTopView];
}
#pragma mark - 网络请求->房间列表
- (void)getNetwork {
    
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/houses"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apt_id"] = @(self.apt_id);
    param[@"storey_id"] = @(self.storey_id);
    
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            /**胖糊: 数组转化模型 */
            self.dataArray = [JYRoomListModel objectArrayWithKeyValuesArray:result[@"bizobj"][@"data"][@"apartment_list"]];
            [self.collectionView reloadData];
            
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 网络请求->获取公寓楼层列表
- (void)getApartmentStoreysListNet {

    [JYRoomReservationSubModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"storeyId" : @"id"
                 };
    }];
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/storeys"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"apt_id"] = @(self.apt_id);
//    param[@"apt_id"] = @(199);
    
    
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            self.storeyArray = [JYRoomReservationSubModel objectArrayWithKeyValuesArray:result[@"bizobj"][@"data"][@"store_list"]];
            [self.view addSubview:self.titlesView];
            [self.view bringSubviewToFront:self.topTopView];
            [self.view bringSubviewToFront:self.topView];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)didClickedArrowAction:(id)sender {
    [self contorlTopView];
}

- (void)arrowAction
{
    [self contorlTopView];
    
}
#pragma mark - 选择楼层箭头 展开/收起
- (void)contorlTopView {
    if (!self.isUnfold) {
        [UIView animateWithDuration:0.25 animations:^{
            self.titlesView.y = kNavBarAndStatusBarHeight;
            self.titlesView.height = self.titlesH;
        } completion:^(BOOL finished) {
            self.masksView.hidden = NO;;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.titlesView.y = - (kNavBarAndStatusBarHeight + self.titlesH);
            self.titlesView.height = 0;
        } completion:^(BOOL finished) {
            self.masksView.hidden = YES;
        }];
    }
    self.isUnfold = !self.isUnfold;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCR_WIDTH, SCR_HEIGHT - kNavBarAndStatusBarHeight) collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _layout.itemSize = CGSizeMake((SCR_WIDTH - 60)/2.0, 160);
        _layout.minimumLineSpacing = 20;
        _layout.minimumInteritemSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [_collectionView registerNib:[UINib nibWithNibName:@"JYRoomListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JYRoomListCollectionViewCell"];
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYRoomListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYRoomListCollectionViewCell" forIndexPath:indexPath];
    [cell updateData:self.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JYHtmlDetailViewController *vc = [[JYHtmlDetailViewController alloc] init];
    NSString *name = [self.apartmentName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *html = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/selectDetail?apt_id=%ld&apt_name=%@&houseId=%ld&token=%@",(long)self.apt_id,name,(long)self.dataArray[indexPath.row].room_id, [JYUserInfoManager getUserToken]];
    vc.urlString = html;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)msgAction:(id)sender {
    if ([JYUserInfoManager getUserToken].length > 0) {
        JYHtmlDetailViewController *htmlVc = [[JYHtmlDetailViewController alloc] init];
        htmlVc.urlString = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/information?token=%@",[JYUserInfoManager getUserToken]];
        [self.navigationController pushViewController:htmlVc animated:true];
    } else {
        JYLoginController *loginView = [[JYLoginController alloc] init];
        [self presentViewController:loginView animated:YES completion:nil];
    }
}

@end
