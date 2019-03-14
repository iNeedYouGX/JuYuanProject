//
//  JYServiceTableViewCell.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/27.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYServiceTableViewCell.h"
#import "JYServiceCollectionViewCell.h"
@interface JYServiceTableViewCell()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *titleEnArray;
@property (nonatomic, strong) NSArray *titleImageArray;
@end
@implementation JYServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleArray = @[@"账单查询",@"水电费查询",@"我要开门",@"报修",@"我要续租",@"退房申请",@"投诉建议"];
    self.titleEnArray = @[@"BILL",@"ELECTRICITY",@"OPEN DOOR",@"SERVICE",@"RENEWAL",@"CHECK OUT",@"COMPLAINT"];
    self.titleImageArray = @[@"zdcx",@"sdcx",@"ms",@"bx",@"xz",@"tfsq",@"tsjy"];
    [self setupCollection];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setupCollection {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.layer.masksToBounds = NO;
//    self.collectionView.backgroundColor = [UIColor greenColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@ "JYServiceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JYServiceCollectionViewCell"];
    self.layout.minimumLineSpacing = 10;
    self.layout.minimumInteritemSpacing = 10;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYServiceCollectionViewCell" forIndexPath:indexPath];
    cell.titleChLabel.text = self.titleArray[indexPath.row];
    cell.titleEnLabel.text = self.titleEnArray[indexPath.row];
    cell.iconImage.image = [UIImage imageNamed:self.titleImageArray[indexPath.row]];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.titleArray.count - 1) {
        return CGSizeMake(SCR_WIDTH - 40, 70);
    }
    CGFloat width = (SCR_WIDTH - 50) / 2;
    return CGSizeMake(width, 70);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.block(indexPath.row);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
