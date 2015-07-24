//
//  RecommendViewController.h
//  MKExample
//
//  Created by rang on 15/6/22.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeCenter.h"
@interface RecommendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *recommentTab;
@property (nonatomic,strong) NSMutableArray *listData;
@end
