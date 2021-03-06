//
//  WaterflowLayout.m
//  瀑布流
//
//  Created by MJP on 16/10/13.
//  Copyright © 2016年 YSAN. All rights reserved.
//

#import "WaterflowLayout.h"

/** 默认的列数 */
static const NSInteger defaultColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat defaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat defaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets defaultEdgeInsets = {10, 10, 10, 10};

@interface WaterflowLayout()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度,collectView的高度为最高那一列的高度加上边缘 */
@property (nonatomic, assign) CGFloat contentHeight;

- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end

@implementation WaterflowLayout


#pragma mark - 常见数据处理
-(CGFloat)rowMargin{

    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return defaultRowMargin;
    }
}
- (CGFloat)columnMargin
{
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return defaultColumnMargin;
    }
}

- (NSInteger)columnCount
{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return defaultColumnCount;
    }
}

- (UIEdgeInsets)edgeInsets
{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return defaultEdgeInsets;
    }
}

#pragma mark - 懒加载
- ( NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _attrsArray;
}

- ( NSMutableArray *)columnHeights
{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray arrayWithCapacity:0];
    }
    return _columnHeights;
}

/**
 初始化
 */
-(void)prepareLayout{
    [super prepareLayout];
    
    self.contentHeight = 0;
    
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    // 添加初始数据，不然会发生数组越界
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    // 清楚之前所有的属性
    [self.attrsArray removeAllObjects];
    
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i< count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
    

}



/**
 * 决定cell的排布
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attrsArray;
}


/**
 返回indexPath位置cell的布局属性
 */
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    // 设置布局的frame
    CGFloat w = (collectionViewWidth - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1)*self.columnMargin)/self.columnCount;
    
    CGFloat h =  [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 找出高度最短的那一列
//    __block NSInteger destColumn = 0;
//    __block CGFloat minColumnHeight = MAXFLOAT;
//    [self.columnHeights enumerateObjectsUsingBlock:^(NSNumber *columnHeightNumber, NSUInteger idx, BOOL *stop) {
//     
//        CGFloat columnHeight = columnHeightNumber.doubleValue;
//        if (minColumnHeight > columnHeight) {
//            minColumnHeight = columnHeight;
//            destColumn = idx;
//        }
//    }];
    
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }

    
    CGFloat x = self.edgeInsets.left + destColumn *(w + self.columnMargin);
    CGFloat y = minColumnHeight;
    
    if (y != self.edgeInsets.top) {// 如果是最顶部的话则不加
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeights[destColumn]  =@(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight<columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}


/**
 collectionView的容量大小
 */
-(CGSize)collectionViewContentSize{

    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}


@end
