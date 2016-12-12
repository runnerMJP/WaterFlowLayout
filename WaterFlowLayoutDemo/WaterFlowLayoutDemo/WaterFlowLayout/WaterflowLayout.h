//
//  WaterflowLayout.h
//  瀑布流
//
//  Created by MJP on 16/10/13.
//  Copyright © 2016年 YSAN. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterflowLayout;
@protocol WaterflowLayoutDelegate <NSObject>


/**
 必须要实现的代理，求每个cell的高度
 */
@required
- (CGFloat)waterflowLayout:(WaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;


@optional
// 列数代理
- (CGFloat)columnCountInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
// 列间距
- (CGFloat)columnMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
// 行间距
- (CGFloat)rowMarginInWaterflowLayout:(WaterflowLayout *)waterflowLayout;
// 边缘间距
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(WaterflowLayout *)waterflowLayout;

@end

@interface WaterflowLayout : UICollectionViewLayout
@property (nonatomic,weak) id <WaterflowLayoutDelegate> delegate;

@end
