//
//  JYShoppingSearchController.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/10.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingSearchController.h"
#import "CZTextField.h"
#import "JYShoppingCollectionCell.h"
#import "JYUserInfoManager.h" // 用户信息
#import "JYHtmlDetailViewController.h"
#import "GXNetTool.h"

@interface JYShoppingSearchController () <UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 文本框 */
@property (nonatomic, strong) CZTextField *textField;
/** 表单 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *hotSaleDataArr;
@end

@implementation JYShoppingSearchController

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
    
    [self setupSearchView];
}

#pragma mark - 加载搜索框
- (void)setupSearchView
{
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    backView.x = 14;
    backView.y = (IsiPhoneX ? 44 + 12 : 20 + 12);
    backView.width = SCR_WIDTH - 28;
    backView.height = 34;
    
    CZTextField *textF = [[CZTextField alloc] init];
    textF.placeholderStr = @"";
    textF.width = backView.width - 50;
    textF.height = backView.height;
    self.textField = textF;
    self.textField.delegate = self;
    [backView addSubview:textF];
    
    UIButton *msgBtn = [[UIButton alloc] init];
//    [msgBtn setImage:[UIImage imageNamed:@"tz1"] forState:UIControlStateNormal];
    [msgBtn setTitle:@"取消" forState:UIControlStateNormal];
    msgBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [msgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    msgBtn.x = CGRectGetMaxX(textF.frame);
    msgBtn.size = CGSizeMake(40, textF.height);
    msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [msgBtn addTarget:self action:@selector(msgAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:msgBtn];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCR_WIDTH - 0.5) / 2, 240);
    layout.minimumLineSpacing = 0.5;
    layout.minimumInteritemSpacing = 0.5;
    //    layout.sectionInset = UIEdgeInsetsMake(18, 14, 10, 14);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CZGetY(backView) + 0.7, SCR_WIDTH, SCR_HEIGHT - CZGetY(backView) - (IsiPhoneX?(34):(0))) collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    self.collectionView = collectionView;
    static NSString *itemId = @"JYShoppingItem";
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JYShoppingCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:itemId];
}

- (void)msgAction
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"搜索");
    [self getCategoryDataSource:@{}];
    [self.view endEditing:YES];
    return YES;
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
    NSString *html = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/goodsDetail?token=%@&goodsId=%@&aptId=%@", [JYUserInfoManager getUserToken], paramDic[@"goods_id"], self.userHouseNumber];
    NSLog(@"%@", html);
    vc.urlString = html;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 数据
// 获取类目数据
- (void)getCategoryDataSource:(NSDictionary *)category
{
    if (self.textField.text.length == 0) {
        return;
    }
    
    NSString *url = [JPSERVER_URL stringByAppendingPathComponent:@"/api/v1/mall/goods"];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = [JYUserInfoManager getUserToken];
    param[@"store_id"] = self.userHouseNumber; // 房间号
    param[@"goods_name"] = self.textField.text;
//    if (category[@"id"]) {    
//        param[@"category_id"] = category[@"id"]; // 类目ID
//    } else {
//        param[@"is_hot"] = @(1);
//    }
    param[@"sort"] = @(1); // 商品排序 1 默认排序 2 销量排序 3 价格排序
    param[@"desc"] = @"desc"; // 排序 desc从大到小  asc 从小到大 
    param[@"limit"] = @(100);
    param[@"page"] = @(1);
    
    
    [CZProgressHUD showProgressHUDWithText:nil];
    [GXNetTool GetNetWithUrl:url body:param header:nil response:GXResponseStyleJSON success:^(id result) {
        if ([result[@"error_code"] isEqual:@(0)]) {
            
            /////////////////////////////////////////////////////
            // 获取文件路径
//                        NSString *path = [[NSBundle mainBundle] pathForResource:@"File" ofType:@"json"];
//                        // 将文件数据化
//                        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//                        // 对数据进行JSON格式化并返回字典形式
//                        NSArray *jsonArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            self.hotSaleDataArr = jsonArr;
            /////////////////////////////////////////////////////
            self.hotSaleDataArr = result[@"bizobj"][@"list"];
            if (self.hotSaleDataArr.count > 0) {
                self.collectionView.backgroundColor = CZGlobalLightGray;
            } else {
                self.collectionView.backgroundColor = [UIColor whiteColor];
            }
            
        }
        [self.collectionView reloadData];
        
        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSError *error) {
    }];
}
#pragma mark -- end

@end
