//
//  AboutCoolTalkViewController.m
//  CoolTalk2
//
//  Created by BreazeMago on 15/4/20.
//  Copyright (c) 2015年 BreazeMago. All rights reserved.
//

#import "AboutUSViewController.h"
#import "WebViewController.h"

@interface AboutUSViewController ()
@property (nonatomic,strong) NSMutableArray *listData;
@end

@implementation AboutUSViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"关于";
    
    self.listData=[NSMutableArray arrayWithObjects:@"用户帮助",@"版本更新", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Source & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"aboutCellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if (indexPath.row==0) {
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
    }
    cell.textLabel.text=[self.listData objectAtIndex:indexPath.row];
    cell.textLabel.textColor=UIColorMakeRGB(57, 57, 57);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"wap" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:url];
        //获取html路径
        NSString *path = [bundle pathForResource:@"help" ofType:@"html"];
        
        WebViewController *webController=[[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        webController.urlString=path;
        webController.title = @"用户帮助";
        [self.navigationController pushViewController:webController animated:YES];
    }
}
@end
