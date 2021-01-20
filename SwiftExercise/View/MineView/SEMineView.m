//
//  MineView.m
//  SwiftExercise
//
//  Created by hiro on 2021/1/16.
//

#import <Foundation/Foundation.h>
#import "SEMineView.h"

@implementation SEMineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewModel = [[SEMineViewModel alloc] init];
        [self initView];
    }
    return self;
}


- (void)initView {
    userImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    userImg.backgroundColor = UIColor.greenColor;
    userImg.layer.masksToBounds = true;
    userImg.layer.cornerRadius = userImg.frame.size.width / 2;
    
    userName = [[UITextField alloc] initWithFrame:CGRectMake(userImg.frame.origin.x + userImg.frame.size.width+10, userImg.frame.origin.y, 60, userImg.frame.size.height)];
    userName.enabled = false;
    userName.textColor = UIColor.blackColor;
    userName.text = viewModel.datas[@"userName"];

    
    editBtn = [[UIButton alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-90, userImg.frame.origin.y, 80, userImg.frame.size.height)];
    editBtn.backgroundColor = UIColor.orangeColor;
    [editBtn setTitle:@"编辑" forState:normal];
    [editBtn setTitle:@"完成" forState:UIControlStateSelected];
    [editBtn addTarget:self action:@selector(pressEditBtn) forControlEvents:UIControlEventTouchUpInside];
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, userImg.frame.origin.y+userImg.frame.size.height+10, UIScreen.mainScreen.bounds.size.width, self.frame.size.height-userImg.frame.origin.y-userImg.frame.size.height-10-83)];
    tableView.scrollEnabled = false;
    tableView.rowHeight = tableView.frame.size.height/5;
    tableView.layer.borderWidth = 1;
    
    [self addSubview:userImg];
    [self addSubview:userName];
    [self addSubview:editBtn];
    [self addSubview:tableView];
}

- (void)pressEditBtn {
    if (!editBtn.isSelected) {
        // 进入编辑状态
        editBtn.selected = true;
        userName.enabled = true;
    } else {
        // 退出编辑状态，保存修改的数据到本地（json）
        editBtn.selected = false;
        userName.enabled = false;
        viewModel.datas[@"userName"] = userName.text;
        
        if ([NSJSONSerialization isValidJSONObject:viewModel.datas]) {
            // 首先初始化一下数据流， path 是本地沙盒的一个路径
            NSOutputStream *outStream = [[NSOutputStream alloc] initToFileAtPath:viewModel.infoSavePath append:NO];
            // 打开数据流
            [outStream open];
            // 执行写入方法
            [NSJSONSerialization writeJSONObject:viewModel.datas toStream:outStream options:NSJSONWritingPrettyPrinted error:nil];
            // 关闭数据流， 写入完成
            [outStream close];
            
        }
    }
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 5;
}


@end
