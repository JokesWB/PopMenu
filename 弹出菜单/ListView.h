//
//  ListView.h
//  POP
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 LaiCunBa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ListViewMenuType_ScaleBasedTopRight = 0,  //以右上角为基点进行伸缩
    ListViewMenuType_RollerShutter,          //卷帘效果
} ListViewMenuType;

typedef void(^ClickItem)(NSInteger index, NSString *title);

@interface ListView : UIView


//显示
+ (void)showWithFrame:(CGRect)rect Images:(NSArray *)imageArray Titles:(NSArray *)titleArray MenuType:(ListViewMenuType)menuType ClickItem:(ClickItem)clickItem;


@end
