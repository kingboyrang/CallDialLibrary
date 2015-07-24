//
//  WSSettingViewController.m
//  WldhWeishuo
//
//  Created by lonelysoul on 14-9-10.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "SettingViewController.h"
#import "DialModeViewController.h"
#import "ModifyPwdViewController.h"
#import "SecretaryMessageViewController.h"
#import "AboutUSViewController.h"
#import "SystemUser.h"


@interface SettingViewController ()<UITableViewDataSource, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *infoTable;
@property (nonatomic,strong) NSMutableArray *listData;
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        self.infoTable.backgroundView = [[UIView alloc]init];
    }
    self.infoTable.backgroundColor = [UIColor clearColor];
    
    self.listData=[[NSMutableArray alloc] initWithCapacity:0];
    
    [self.listData addObject:[NSArray arrayWithObjects:@"拨打方式",@"修改密码",@"秘书消息", nil]];
    [self.listData addObject:[NSArray arrayWithObjects:@"关于", nil]];
    [self.listData addObject:[NSArray arrayWithObjects:@"退出", nil]];
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.listData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 5)];
    
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (indexPath.section!=[self.listData count]-1) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment=NSTextAlignmentCenter;
        }
        
        
    }
     NSString *funName=[[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text=funName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *funName=[[self.listData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([funName isEqualToString:@"拨打方式"]) {
        // 拨打方式
        DialModeViewController *selectTypeViewCon = [[DialModeViewController alloc] initWithNibName:@"DialModeViewController" bundle:nil];
        [self.navigationController pushViewController:selectTypeViewCon animated:YES];
    }else if([funName isEqualToString:@"修改密码"]){
        // 修改密码
        ModifyPwdViewController *resetVC = [[ModifyPwdViewController alloc] initWithNibName:@"ModifyPwdViewController" bundle:nil];
        [self.navigationController pushViewController:resetVC animated:YES];
    }else if([funName isEqualToString:@"秘书消息"]){
        // 秘书消息
        SecretaryMessageViewController *changeBind = [[SecretaryMessageViewController alloc] initWithNibName:NSStringFromClass([SecretaryMessageViewController class]) bundle:nil ];
        [self.navigationController pushViewController:changeBind animated:YES];
    }
    else if([funName isEqualToString:@"关于"]){
        // 关于
        AboutUSViewController *changeBind = [[AboutUSViewController alloc] initWithNibName:NSStringFromClass([AboutUSViewController class]) bundle:nil ];
        [self.navigationController pushViewController:changeBind animated:YES];
    }
    else if([funName isEqualToString:@"退出"]){
        
        [AlertHelper showAlertWithTitle:@"退出登录" message:@"退出登录不会删除任何数据，下次登录依然可以使用本账号" cancelTitle:@"取消" cancelAction:nil confirmTitle:@"确定" confirmAction:^{
            
            SystemUser *mod=[SystemUser shareInstance];
            
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setValue:mod.userId forKey:@"uid"];
            [params setValue:mod.token forKey:@"token"];
            
            [[CZServiceManager shareInstance] requestServiceWithDictionary:params requestServiceType:CZServiceLoginOut completed:^(NSDictionary *userInfo) {
                
                NSInteger result=[[userInfo objectForKey:@"flag"] integerValue];
                if (result==0){
                    //删除用户信息
                    [[SystemUser shareInstance] removeUser];
                }
                else{
                    [AlertHelper showAlertWithMessage:[userInfo objectForKey:@"val"]];
                }
               
            }];
        }];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
