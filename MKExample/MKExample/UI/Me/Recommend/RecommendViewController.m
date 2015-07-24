//
//  RecommendViewController.m
//  MKExample
//
//  Created by rang on 15/6/22.
//  Copyright (c) 2015年 wulanzhou. All rights reserved.
//

#import "RecommendViewController.h"

@interface RecommendViewController ()

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐有礼";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        self.recommentTab.backgroundView = [[UIView alloc] init];
        
    }
    self.recommentTab.backgroundColor = [UIColor clearColor];
    
    self.listData=[NSMutableArray arrayWithCapacity:0];
    //建置数据源
    NSMutableArray *source=[NSMutableArray arrayWithCapacity:0];
    MeCenter *mod=[[MeCenter alloc] init];
    mod.name=@"手机通讯录";
    mod.imageName=@"addressBook.png";
    [source addObject:mod];
    [self.listData addObject:source];
    
   
    //section 2
    source=[NSMutableArray arrayWithCapacity:0];
    mod=[[MeCenter alloc] init];
    mod.name=@"微信好友";
    mod.imageName=@"weixin.png";
    [source addObject:mod];
    
    mod=[[MeCenter alloc] init];
    mod.name=@"朋友圈";
    mod.imageName=@"wx_friends.png";
    [source addObject:mod];
    
    mod=[[MeCenter alloc] init];
    mod.name=@"QQ好友";
    mod.imageName=@"qq.png";
    [source addObject:mod];
    
    mod=[[MeCenter alloc] init];
    mod.name=@"QQ空间";
    mod.imageName=@"qq_kj.png";
    [source addObject:mod];
    [self.listData addObject:source];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table Source & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //兼容 问题
    if (section == 0) {
        return 1;
    } else {
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.listData count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[self.listData objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Tableldentifier=@"recommendTableldentifier";
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
}

@end
