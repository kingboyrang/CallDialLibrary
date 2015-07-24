//
//  MeViewController.h
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeCenter.h"



@interface MeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phonelab;
@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UITableView *meTable;

@property (nonatomic,strong) NSMutableArray *listData;//数据源

@end
