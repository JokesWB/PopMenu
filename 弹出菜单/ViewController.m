//
//  ViewController.m
//  弹出菜单
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 LaiCunBa. All rights reserved.
//

#import "ViewController.h"
#import "ListView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"pop" style:UIBarButtonItemStyleDone target:self action:@selector(show)];
    
    
    
    
}

- (void)show
{
    CGRect rect = CGRectMake(self.view.frame.size.width - 130, 64 + 10, 120, 200);
    NSArray *titleArray = @[@"新闻", @"视频", @"娱乐", @"美食", @"笑话", @"电影"];
    [ListView showWithFrame:rect Images:nil Titles:titleArray MenuType:ListViewMenuType_ScaleBasedTopRight ClickItem:^(NSInteger index, NSString *title) {
        NSLog(@"点击了第 %ld 个", index);
        UIViewController *VC = [[UIViewController alloc] init];
        VC.view.backgroundColor = [UIColor yellowColor];
        VC.title = title;
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
    
    
}



@end
