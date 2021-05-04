//
//  MeViewController.m
//  MKExample
//
//  Created by rang on 15/6/21.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "MeViewController.h"
#import "SettingViewController.h"
#import "RecommendViewController.h"
#import "WldhTabBarController.h"

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"我";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        self.meTable.backgroundView = [[UIView alloc] init];
        
    }
    self.meTable.backgroundColor = [UIColor clearColor];
    
    
    //二维码名片
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"QRCode.png"] forState:UIControlStateNormal];
    [btn addTarget: self action: @selector(goQRcode) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem* QRcode=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = QRcode;
    
    self.listData=[NSMutableArray arrayWithCapacity:0];
    //建置数据源
    NSMutableArray *source=[NSMutableArray arrayWithCapacity:0];
    MeCenter *mod=[[MeCenter alloc] init];
    mod.name=@"我的帐户";
    mod.imageName=@"icon_money.png";
    mod.sourceType=MeSourceAccountType;
    [source addObject:mod];
    
    mod=[[MeCenter alloc] init];
    mod.name=@"推荐有礼";
    mod.imageName=@"icon_share.png";
    mod.sourceType=MeSourceRecommendType;
    [source addObject:mod];
    [self.listData addObject:source];
    
    //section 2
    source=[NSMutableArray arrayWithCapacity:0];
    mod=[[MeCenter alloc] init];
    mod.name=@"扫一扫";
    mod.imageName=@"icon_sys.png";
    mod.sourceType=MeSourceSweepType;
    [source addObject:mod];
    
    mod=[[MeCenter alloc] init];
    mod.name=@"设置";
    mod.imageName=@"icon_set.png";
    mod.sourceType=MeSourceSettingType;
    [source addObject:mod];
    [self.listData addObject:source];
    
}


//二维码
- (void)goQRcode{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table Soource & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listData count];
}
-(NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.listData objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Tableldentifier=@"MeTableldentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:Tableldentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Tableldentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    MeCenter *mod=[[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text=mod.name;
    cell.imageView.image=[UIImage imageNamed:mod.imageName];
    
    return cell;
}
//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MeCenter *mod=[[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (mod.sourceType==MeSourceAccountType) {//我的帐户
        
    }else if (mod.sourceType==MeSourceRecommendType){//推荐有礼
        
        RecommendViewController *setting=[[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil];
        [self.navigationController pushViewController:setting animated:YES];
    
    }else if (mod.sourceType==MeSourceSweepType){//扫一扫
        
    }else{//设置
        SettingViewController *setting=[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [self.navigationController pushViewController:setting animated:YES];
    }
    
}

@end
