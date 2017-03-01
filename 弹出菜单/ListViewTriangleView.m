//
//  ListViewTriangleView.m
//  弹出菜单
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 LaiCunBa. All rights reserved.
//

#import "ListViewTriangleView.h"

@implementation ListViewTriangleView

- (void)setTriangleColor:(UIColor *)triangleColor
{
    _triangleColor = triangleColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //绘制三角形
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //-------------绘制三角形------------
    //
    //                 B
    //                /\
    //               /  \
    //              /    \
    //             /______\
    //            A        C
    //
    //
    
    //设置起点A
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    //连接到B
    [path addLineToPoint:CGPointMake(rect.size.width / 2, 0)];
    //连接到C
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    //封闭路径
    [path closePath];
    //填充颜色
    [self.triangleColor set];
    [path fill];
    
}

@end
