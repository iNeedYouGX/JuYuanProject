//
//  JYRoomListViewController.m
//  JUYUAN
//
//  Created by 小香菜 on 2019/2/28.
//  Copyright © 2019 JasonBourne. All rights reserved.
//

#import "JYRoomListViewController.h"
#import "JYRoomListCollectionViewCell.h"
@interface JYRoomListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewTop;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation JYRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleViewTop.constant = kStatusBarHeight;
    [self.view addSubview:self.collectionView];
    
}
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, SCR_WIDTH, SCR_HEIGHT - kNavBarAndStatusBarHeight) collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _layout.itemSize = CGSizeMake((SCR_WIDTH - 60)/2.0, 150);
        _layout.minimumLineSpacing = 20;
        _layout.minimumInteritemSpacing = 10;
        _layout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [_collectionView registerNib:[UINib nibWithNibName:@"JYRoomListCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JYRoomListCollectionViewCell"];
    }
    return _collectionView;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JYRoomListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JYRoomListCollectionViewCell" forIndexPath:indexPath];
    return cell;
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
