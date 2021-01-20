//
//  MineView.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/16.
//

#ifndef SEMineView_h
#define SEMineView_h

#import <UIKit/UIKit.h>
#import "SEMineViewModel.h"

@interface SEMineView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UIButton *editBtn;
    UITextField *userName;
    UIImageView *userImg;
    UITableView *tableView;
    SEMineViewModel *viewModel;
}

- (void)initView;

@end


#endif /* MineView_h */
