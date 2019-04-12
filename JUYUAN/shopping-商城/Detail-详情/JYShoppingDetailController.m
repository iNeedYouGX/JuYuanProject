//
//  JYShoppingDetailController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingDetailController.h"
#import "CZNavigationView.h"
#import "CZMutContentButton.h"
#import "JYShoppingCollectionCell.h"
#import "GXNetTool.h"
#import "JYUserInfoManager.h" // 用户信息
#import "JYHtmlDetailViewController.h"

@interface JYShoppingDetailController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** <#注释#> */
@property (nonatomic, strong) CZNavigationView *navigationView;
/** 表单 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *hotSaleDataArr;
/** <#注释#> */
@property (nonatomic, strong) CZMutContentButton *recordBtn;
/** 商品排序 */
@property (nonatomic, strong) NSString *sort; //商品排序 1 默认排序 2 销量排序 3 价格排序
/** 排序 */
@property (nonatomic, strong) NSString *desc; // 排序 desc从大到小  asc 从小到大 

@end

@implementation JYShoppingDetailController

- (NSMutableArray *)hotSaleDataArr
{
    if (_hotSaleDataArr == nil) {
        _hotSaleDataArr = [NSMutableArray array];   
    }
    return _hotSaleDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //导航条
    CZNavigationView *navigationView = [[CZNavigationView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0), SCR_WIDTH, 67) title:@"商品列表" rightBtnTitle:nil rightBtnAction:nil navigationViewType:nil];
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, (IsiPhoneX ? 24 : 0) + 67, SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;
    
    [self setupToptTitle];
    
    // 获取数据
    [self getCategoryDataSource:self.param];
}

- (void)setupToptTitle
{
    UIView *topTitleView = [[UIView alloc] init];
    topTitleView.y = CZGetY(self.navigationView);
    topTitleView.width = SCR_WIDTH;
    topTitleView.height = 40;
    [self.view addSubview:topTitleView];
    
    //导航条
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CZGetY(topTitleView), SCR_WIDTH, 0.7)];
    line.backgroundColor = CZGlobalLightGray;
    [self.view addSubview:line];
    
    
    NSArray *titles = @[@"默认", @"销量", @"价格"];
    
    for (int i = 0; i < 3; i++) {
        UIView *backView = [[UIView alloc] init];
        backView.width = SCR_WIDTH / 3.0;
        backView.height = topTitleView.height;
        backView.x = backView.width * i;
        [topTitleView addSubview:backView];
        
        CZMutContentButton *rightBtn = [CZMutContentButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = i;
        [rightBtn setTitle:titles[i] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(moreTrialReport:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 15];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            [rightBtn setTitleColor:UIColorFromRGB(0xF7AC1D) forState:UIControlStateNormal];
            //        商品排序 1 默认排序 2 销量排序 3 价格排序
            self.sort = @"1";
            self.recordBtn = rightBtn;
        } else {
            [rightBtn setImage:[UIImage imageNamed:@"WX20190411-0"] forState:UIControlStateNormal];
        }
        [backView addSubview:rightBtn];
        [rightBtn sizeToFit];
        rightBtn.center = CGPointMake(backView.width / 2.0, backView.height / 2.0);
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCR_WIDTH - 0.5) / 2, 240);
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0.5;
//    layout.sectionInset = UIEdgeInsetsMake(18, 14, 10, 14);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CZGetY(topTitleView) + 0.7, SCR_WIDTH, SCR_HEIGHT - CZGetY(topTitleView) - (IsiPhoneX?(34):(0))) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = CZGlobalLightGray;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    static NSString *itemId = @"JYShoppingItem";
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JYShoppingCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:itemId];
}

- (void)moreTrialReport:(CZMutContentButton *)sender
{
    sender.selected = YES;
    switch (sender.tag) {
        case 0:
            //        商品排序 1 默认排序 2 销量排序 3 价格排序
            self.sort = @"1";
            self.desc = @"desc";
            [self.recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.recordBtn.selected = NO;
            self.recordBtn.flag = 0;
            [sender setTitleColor:UIColorFromRGB(0xF7AC1D) forState:UIControlStateNormal];
            break;
        case 1:
        {
            //        商品排序 1 默认排序 2 销量排序 3 价格排序
            self.sort = @"2";
            // 点击数
            NSInteger falg = sender.flag % 2;
            switch (falg) {
                case 0:
                    /** 默认降序 */ 
                    self.desc = @"desc";
                    [sender setImage:[UIImage imageNamed:@"WX20190411-1"] forState:UIControlStateSelected];
                    break;
                case 1:
                    /** 升序 */ 
                    self.desc = @"asc";
                    [sender setImage:[UIImage imageNamed:@"WX20190411-2"] forState:UIControlStateSelected];
                    break;
                    
                default:
                    break;
            }
            sender.flag ++;
            [self.recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (self.recordBtn != sender) {
                self.recordBtn.selected = NO;
                self.recordBtn.flag = 0;
            }
            [sender setTitleColor:UIColorFromRGB(0xF7AC1D) forState:UIControlStateNormal];

            break;
        }
        case 2:
        {
            //        商品排序 1 默认排序 2 销量排序 3 价格排序
            self.sort = @"3";
            // 点击数
            NSInteger falg = sender.flag % 2;
            switch (falg) {
                case 0:
                    /** 默认降序 */ 
                    self.desc = @"desc";
                    [sender setImage:[UIImage imageNamed:@"WX20190411-1"] forState:UIControlStateSelected];
                    break;
                case 1:
                    /** 升序 */ 
                    self.desc = @"asc";
                    [sender setImage:[UIImage imageNamed:@"WX20190411-2"] forState:UIControlStateSelected];
                    break;
                    
                default:
                    break;
            }
            sender.flag ++;
            [self.recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (self.recordBtn != sender) {
                self.recordBtn.selected = NO;
                self.recordBtn.flag = 0;
            }
            [sender setTitleColor:UIColorFromRGB(0xF7AC1D) forState:UIControlStateNormal];
            
            break;
        }
        default:
            break;
    }
    
    
    // 获取数据
    [self getCategoryDataSource:self.param];
    
    self.recordBtn = sender;
    
    
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotSaleDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemId = @"JYShoppingItem";
    JYShoppingCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemId forIndexPath:indexPath];
    cell.dataDic = self.hotSaleDataArr[indexPath.row];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *paramDic = self.hotSaleDataArr[indexPath.row];
    JYHtmlDetailViewController *vc = [[JYHtmlDetailViewController alloc] init];
//    NSString *name = [self.apartmentName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *html = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/goodsDetail?token=%@&goodsId=%@", [JYUserInfoManager getUserToken], paramDic[@"goods_id"]];
    NSLog(@"%@", html);
    vc.urlString = html;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据
// 获取类目数据
- (void)getCategoryDataSource:(NSDictionary *)category
{
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/goods"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    param[@"store_id"] = self.userHouseNumber; // 房间号
    if (category[@"id"]) {    
        param[@"category_id"] = category[@"id"]; // 类目ID
    } else {
        param[@"is_hot"] = @(1);
    }
    param[@"sort"] = self.sort; // 商品排序 1 默认排序 2 销量排序 3 价格排序
    param[@"desc"] = self.desc; // 排序 desc从大到小  asc 从小到大 
    param[@"limit"] = @(100);
    param[@"page"] = @(1);
    
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            /////////////////////////////////////////////////////
            // 获取文件路径
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
//            // 将文件数据化
//            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//            // 对数据进行JSON格式化并返回字典形式
//            NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            /////////////////////////////////////////////////////
            
           
            self.hotSaleDataArr = result[@"bizobj"][@"list"];
        }
        [self.collectionView reloadData];
        
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
    }];
}
#pragma mark -- end

@end
