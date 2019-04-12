//
//  JYShoppingCell.m
//  JUYUAN
//
//  Created by JasonBourne on 2019/4/9.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYShoppingCell.h"
#import "JYHtmlDetailViewController.h"
#import "JYShoppingDetailCell.h"
#import "JYUserInfoManager.h" // 用户信息

@interface JYShoppingCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation JYShoppingCell
- (void)setHotSaleDataArr:(NSArray *)hotSaleDataArr
{
    _hotSaleDataArr = hotSaleDataArr;
    [self.collectionView reloadData];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupProperty];
    }
    return self;
}

- (void)setupProperty
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(90, 150);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 15;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCR_WIDTH, 170) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    self.collectionView.showsHorizontalScrollIndicator = NO;

    static NSString *itemId = @"JYShoppingDetailCell";
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JYShoppingDetailCell class]) bundle:nil] forCellWithReuseIdentifier:itemId];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *itemId = @"JYShoppingDetailCell";
    JYShoppingDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemId forIndexPath:indexPath];
    cell.dataDic = self.hotSaleDataArr[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotSaleDataArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *paramDic = self.hotSaleDataArr[indexPath.row];
    JYHtmlDetailViewController *vc = [[JYHtmlDetailViewController alloc] init];
    //    NSString *name = [self.apartmentName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *html = [NSString stringWithFormat:@"https://apartment.pinecc.cn/public/frontend/index.html#/goodsDetail?token=%@&goodsId=%@", [JYUserInfoManager getUserToken], paramDic[@"goods_id"]];
    NSLog(@"%@", html);
    vc.urlString = html;
    UIViewController *navVc = [self viewController];
    [navVc.navigationController pushViewController:vc animated:YES];
}

// 找到父控制器
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
