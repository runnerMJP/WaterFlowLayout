//
//  ViewController.m
//  瀑布流
//
//  Created by MJP on 16/10/13.
//  Copyright © 2016年 YSAN. All rights reserved.
//

#import "ViewController.h"
#import "WaterflowLayout.h"
#import "Shop.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ShopCell.h"
@interface ViewController () <UICollectionViewDataSource,WaterflowLayoutDelegate>

/**
 所有商品数据
 */
@property (strong,nonatomic) NSMutableArray *shopArrs;
@property (strong,nonatomic) UICollectionView *collectionView;
@end

@implementation ViewController

static NSString * const ShopId = @"shop";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupLayout];
    [self setupRefresh];

}

- (NSMutableArray *)shopArrs
{
    if (!_shopArrs) {
        _shopArrs = [NSMutableArray array];
    }
    return _shopArrs;
}
-(void)setupLayout{
    // 创建布局
    WaterflowLayout *layout = [[WaterflowLayout alloc] init];
    layout.delegate = self;
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
   
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCell class]) bundle:nil] forCellWithReuseIdentifier:ShopId];
     self.collectionView  = collectionView;
}

-(void)setupRefresh{
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];

    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
//    self.collectionView.footer.hidden = YES;
}


-(void)loadNewShops{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [Shop objectArrayWithFilename:@"1.plist"];
        [self.shopArrs removeAllObjects];
        [self.shopArrs addObjectsFromArray:shops];
        
        [self.collectionView reloadData];
        [self.collectionView.header endRefreshing];
    });
}

-(void)loadMoreShops{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 *NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [Shop objectArrayWithFilename:@"1.plist"];
        [self.shopArrs addObjectsFromArray:shops];
        [self.collectionView reloadData];
        [self.collectionView.footer endRefreshing];
    });

}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shopArrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShopId forIndexPath:indexPath];

    cell.shop = self.shopArrs[indexPath.row];
    return cell;
}

#pragma mark - WaterflowLayoutDelegate

/**
 算出cell的高度
 */
-(CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{

    Shop *shop = self.shopArrs[index];
    return itemWidth * shop.h/shop.w;
}


/**
 设置行间距
 */
- (CGFloat)rowMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout
{
    return 10;
}
/**
 设置列数
 */
- (CGFloat)columnCountInWaterflowLayout:(WaterflowLayout *)waterflowLayout
{
    if (self.shopArrs.count <= 50) return 2;
    return 3;
}
/**
 设置列间距
 */
-(CGFloat)columnMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout
{
    return 10;
}

/**
 设置边距
 */
//- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterflowLayout *)waterflowLayout
//{
//    return UIEdgeInsetsMake(10, 20, 30, 100);
//}

@end
