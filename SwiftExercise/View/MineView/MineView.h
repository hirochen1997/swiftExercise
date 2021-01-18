//
//  MineView.h
//  SwiftExercise
//
//  Created by hiro on 2021/1/16.
//

#ifndef MineView_h
#define MineView_h

#import <UIKit/UIKit.h>
#import "MineViewModel.h"

@interface MineView : UIView <UITableViewDelegate, UITableViewDataSource> {
    UIButton *editBtn;
    UITextField *userName;
    UIImageView *userImg;
    UITableView *tableView;
    MineViewModel *viewModel;
}

- (void)initView;

@end


#endif /* MineView_h */
