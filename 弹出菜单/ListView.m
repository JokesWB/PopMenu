//
//  ListView.m
//  POP
//
//  Created by admin on 16/9/30.
//  Copyright © 2016年 LaiCunBa. All rights reserved.
//

#import "ListView.h"
#import "ListViewTriangleView.h"

#define kAnimationDuration 0.3

@interface ListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , assign) CGRect rect;
@property (nonatomic , copy) NSArray *imageArray;
@property (nonatomic , copy) NSArray *titleArray;
@property (nonatomic , copy) ClickItem clickItem;
@property (nonatomic , assign) ListViewMenuType type;
@property (nonatomic , strong) ListViewTriangleView *triangleView;
@property (nonatomic , strong) UIColor *viewColor;

@end

@implementation ListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
        self.viewColor = [UIColor grayColor];
    }
    return self;
}


//显示
+ (void)showWithFrame:(CGRect)rect Images:(NSArray *)imageArray Titles:(NSArray *)titleArray MenuType:(ListViewMenuType)menuType ClickItem:(ClickItem)clickItem
{
    ListView *listView = [[self alloc] init];
    [[[UIApplication sharedApplication].windows lastObject] addSubview:listView];
    listView.rect = rect;
    listView.imageArray = imageArray;
    listView.titleArray = titleArray;
    listView.clickItem = clickItem;
    listView.type = menuType;
    
    [listView setup];
    
}

- (void)setup
{
    //设置三角形
    self.triangleView.triangleColor = self.viewColor;
    self.triangleView.alpha = 0;
    
    //设置tableView
    self.alpha = 0;
    __weak typeof(self) weakSelf = self;
    
    switch (self.type) {
        case ListViewMenuType_ScaleBasedTopRight: {
            //设置 tableView 的 frame
            self.tableView.frame = self.rect;
            //先将菜单tableView缩小
            self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            //执行动画：背景颜色 由浅到深,menu的tableView由小到大，回复到正常大小
            [UIView animateWithDuration:kAnimationDuration animations:^{
                weakSelf.tableView.transform = CGAffineTransformMakeScale(1, 1);
                weakSelf.alpha = 1.0;
                weakSelf.triangleView.alpha = 1.0;
            }];
        }
            break;
            
        case ListViewMenuType_RollerShutter: {
            CGRect frame = self.rect;
            frame.size.height = 0;
            self.tableView.frame = frame;
            [UIView animateWithDuration:kAnimationDuration animations:^{
                weakSelf.tableView.frame = self.rect;
                weakSelf.alpha = 1.0;
                weakSelf.triangleView.alpha = 1.0;
            }];
        }
            break;
            
        default:
            break;
    }
    
}


//点击屏幕消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissWithAnimation:YES];
}

//消失
- (void)dismissWithAnimation:(BOOL)animation
{
    if (!animation) {
        [self removeFromSuperview];
    } else {
        __weak typeof(self) weakSelf = self;
        switch (self.type) {
            case ListViewMenuType_ScaleBasedTopRight: {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    weakSelf.alpha = 0;
                    weakSelf.triangleView.alpha = 0;
                    weakSelf.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                } completion:^(BOOL finished) {
                    [weakSelf removeFromSuperview];
                }];
            }
                break;
            case ListViewMenuType_RollerShutter: {
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    weakSelf.alpha = 0;
                    weakSelf.triangleView.alpha = 0;
                    CGRect frame = self.rect;
                    frame.size.height = 0;
                    weakSelf.tableView.frame = frame;
                } completion:^(BOOL finished) {
                    [weakSelf removeFromSuperview];
                }];
            }
                break;
                
            default:
                break;
        }
    }
    
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (self.imageArray.count != 0) {
        cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.backgroundColor = self.viewColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.clickItem) {
        self.clickItem(indexPath.row, self.titleArray[indexPath.row]);
    }
    [self dismissWithAnimation:NO];
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
        [self addSubview:_tableView];
        
        //设置锚点（右上角）, 要先设置锚点，再设置frame，才有效
        switch (self.type) {
            case ListViewMenuType_ScaleBasedTopRight:
                _tableView.layer.anchorPoint = CGPointMake(1, 0);
                break;
            case ListViewMenuType_RollerShutter:
                _tableView.layer.anchorPoint = CGPointMake(0.5, 0);
                break;
                
            default:
                break;
        }
        
    }
    return _tableView;
}

- (ListViewTriangleView *)triangleView
{
    if (!_triangleView) {
        _triangleView = [[ListViewTriangleView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, self.rect.origin.y - 10, 20, 10)];
        _triangleView.backgroundColor = [UIColor clearColor];
        [self addSubview:_triangleView];
    }
    return _triangleView;
}


- (void)dealloc
{
    NSLog(@"移除 ListView ------ dealloc");
}


@end
