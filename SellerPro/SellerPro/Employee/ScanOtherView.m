//
//  ScanOtherView.m
//  SellerPro
//
//  Created by leiganzheng on 2017/6/13.
//  Copyright © 2017年 karashock. All rights reserved.
//

#import "ScanOtherView.h"

@implementation ScanOtherView

 - (void)drawRect:(CGRect)rect {
 CGFloat rectWidth = 30;
 CGFloat rectHeight = 200;
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGFloat black[4] = {0.0, 0.0, 0.0, 0.8};
 CGContextSetFillColor(context, black);
 //top
 CGRect rect1 = CGRectMake(0, 0, self.frame.size.width, rectHeight);
 CGContextFillRect(context, rect1);
 //left
 rect1 = CGRectMake(0, rectHeight, rectWidth, rectHeight);
 CGContextFillRect(context, rect1);
 //bottom
 rect1 = CGRectMake(0, rectHeight +100, self.frame.size.width, self.frame.size.height - rectHeight +100);
 CGContextFillRect(context, rect1);
 //right
 rect1 = CGRectMake(self.frame.size.width - rectWidth, rectHeight, rectWidth, rectHeight);
 CGContextFillRect(context, rect1);
 CGContextStrokePath(context);
 
 //中间画矩形(正方形)
 CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
 CGContextSetLineWidth(context, 1);
 CGContextAddRect(context, CGRectMake(rectWidth, rectHeight, self.frame.size.width - rectWidth * 2, 100));
 CGContextStrokePath(context);
 
 CGFloat lineWidth = 10;
 
 CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
 CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
 
 // Draw them with a 2.0 stroke width so they are a bit more visible.
 CGContextSetLineWidth(context, 2.0);
 //左上角水平线
 CGContextMoveToPoint(context, rectWidth, rectHeight);
 CGContextAddLineToPoint(context, rectWidth + lineWidth, rectHeight);
 
 //左上角垂直线
 CGContextMoveToPoint(context, rectWidth, rectHeight);
 CGContextAddLineToPoint(context, rectWidth, rectHeight + lineWidth);
 
 //左下角水平线
 CGContextMoveToPoint(context, rectWidth, rectHeight +100);
 CGContextAddLineToPoint(context, rectWidth + lineWidth, rectHeight +100);
 
 //左下角垂直线
 CGContextMoveToPoint(context, rectWidth, rectHeight +100 - lineWidth);
 CGContextAddLineToPoint(context, rectWidth, rectHeight +100);
 
 //右上角水平线
 CGContextMoveToPoint(context, self.frame.size.width - rectWidth - lineWidth, rectHeight);
 CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight);
 
 //右上角垂直线
 CGContextMoveToPoint(context, self.frame.size.width - rectWidth, rectHeight);
 CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight + lineWidth);
 
 //右下角水平线
 CGContextMoveToPoint(context, self.frame.size.width - rectWidth - lineWidth, rectHeight +100);
 CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight +100);
 //右下角垂直线
 CGContextMoveToPoint(context, self.frame.size.width - rectWidth, rectHeight +100 - lineWidth);
 CGContextAddLineToPoint(context, self.frame.size.width - rectWidth, rectHeight +100);
 CGContextStrokePath(context);
 
 }


@end
