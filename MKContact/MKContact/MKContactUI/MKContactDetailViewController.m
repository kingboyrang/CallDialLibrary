//
//  MKContactDetailViewController.m
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKContactDetailViewController.h"
#import "MKContactDetailPhoneListCell.h"
#import "ContactManager.h"
#import <AddressBookUI/AddressBookUI.h>
//#import "MKCallBackManager.h"
#import "ContactUtils.h"
#import "MKContact.h"
#import "ContactWrapper.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
// 颜色配置
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBAplha(r, g ,b , a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kWSButtonNormalColor [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]
#define kWSButtonHighlightColor [UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0]

@interface MKContactDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ABNewPersonViewControllerDelegate>

@property (nonatomic,strong) NSArray *phoneList;
@property (nonatomic,strong) ABPersonViewController *personViewController;
@property (nonatomic,strong) NSString *buttonClickedStr;    //按钮点击选中的电话号码

//显示联系人姓名的view
@property (nonatomic,strong) UIView *contactNameView;

//显示联系人电话列表的view
@property (nonatomic,strong) UITableView *contactPhoneList;
//头像
@property (nonatomic,strong) UIImageView *headImageView;
@end

@implementation MKContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"联系人详情";
    
    // Do any additional setup after loading the view.
    
    
    //初始化数据源
    self.phoneList = [NSMutableArray arrayWithArray:[self.aContact contactAllPhone]];;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.contactNameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
    
    //联系人头像
    self.headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 60, 60)];
    
    UIImage *headImg=[[ContactManager shareInstance] contactHeadWithContactID:self.aContact.contactID];
    if (headImg==nil) {
        headImg=[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
    }
    self.headImageView.image=headImg;
    self.headImageView.layer.cornerRadius=self.headImageView.frame.size.height/2.0;
    self.headImageView.layer.masksToBounds=YES;
    [self.contactNameView addSubview:self.headImageView];
    
    
    //联系人姓名的Label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 25, screenWidth-95, 30)];
    nameLabel.text = [self.aContact getContactFullName];
    nameLabel.font = [UIFont boldSystemFontOfSize:20.0];
    [self.contactNameView addSubview:nameLabel];
    
    //横线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 79.5, screenWidth, 0.5)];
    line.backgroundColor = RGB(226, 226, 220);
    [self.contactNameView addSubview:line];
    
    //[self.view addSubview:self.contactNameView];
    
    //设置显示联系人号码的view
    self.contactPhoneList = [[UITableView alloc] initWithFrame:CGRectMake(0,0,screenWidth, screenHeight-64) style:UITableViewStylePlain];
    self.contactPhoneList.delegate = self;
    self.contactPhoneList.dataSource = self;
    self.contactPhoneList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.contactPhoneList.bounces = NO;
    self.contactPhoneList.backgroundView=[[UIView alloc] init];
    self.contactPhoneList.backgroundColor=[UIColor clearColor];
    self.contactPhoneList.tableHeaderView=self.contactNameView;
    [self.view addSubview:self.contactPhoneList];
    
    //导航栏右侧按钮
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(0, 0, 20, 20);
    [aButton setBackgroundImage:[MKContact getImageFromResourceBundleWithName:@"contact_edit_nor" type:@"png"] forState:UIControlStateNormal];
    [aButton setBackgroundImage:[MKContact getImageFromResourceBundleWithName:@"contact_edit_sel" type:@"png"] forState:UIControlStateHighlighted];
    UIBarButtonItem *aBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    [aButton addTarget:self action:@selector(editContact) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:aBarButtonItem];
    
    //用户数据发送改变时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contactDataChange:)
                                                 name:kNotifyContactDataChanged
                                               object:nil];
    //头像加载完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactHeadLoadFinished:) name:kNotifyContactHeadChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

/**
 *  头像加载完成通知
 *
 *  @param notification
 */
- (void)contactHeadLoadFinished:(NSNotification *)notification{
    NSDictionary *info=[notification userInfo];
    [self performSelectorOnMainThread:@selector(updateHeadPhoto:) withObject:info waitUntilDone:NO];
    
   
}
/**
 *  更新头像
 *
 *  @param info 头像信息
 */
- (void)updateHeadPhoto:(NSDictionary*)info{
    if([[info objectForKey:@"ContactID"] integerValue]==self.aContact.contactID){
        UIImage *img=[info objectForKey:@"Image"];
        if (img) {
            self.headImageView.image=img;
        }else{
            self.headImageView.image=[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
        }
        self.headImageView.layer.cornerRadius=self.headImageView.frame.size.height/2.0;
        self.headImageView.layer.masksToBounds=YES;
    }
}

//表示当前用户信息发生改变
- (void)contactDataChange:(NSNotification *)notification
{
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
}

/**
 *  @brief  刷新UI
 */
- (void)updateUI{
    ContactNode *node=[[ContactManager shareInstance] getOneContactByID:self.aContact.contactID];
    if (node==nil) {
        return;
    }
    self.aContact = node;
    self.phoneList = [NSMutableArray arrayWithArray:[self.aContact contactAllPhone]];
    
    //重新加载数据
    [self.contactPhoneList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 编辑联系人
/** 编辑联系人 */
- (void)editContact
{
    if ((self.aContact != nil) && (kInValidContactID != self.aContact.contactID))
    {
        ABAddressBookRef addressBookhandle = [[ContactManager shareInstance] contactAddressBook];
        ABRecordRef onePerson = [[ContactManager shareInstance] getOneABRecordWithID:self.aContact.contactID
                                                                       inAddressBook:addressBookhandle];
        if (NULL != onePerson)
        {
            [self createEditVC:onePerson];
        }
    }
}

- (void)createEditVC:(ABRecordRef)person
{
    ABNewPersonViewController *npvc = [[ABNewPersonViewController alloc] init];
    [npvc setTitle:@"编辑"];
    [npvc setDisplayedPerson:person];
    [npvc setNewPersonViewDelegate:self];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        npvc.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelContactEdit)];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:npvc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cancelContactEdit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)editingCanceled:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    self.personViewController.personViewDelegate = nil;
}

- (void)editingFinished:(id)sender
{
    [ContactManager shareInstance].canLoadData = NO;
    [self.personViewController setEditing:NO];
    
    BOOL ret = ABAddressBookSave(self.personViewController.addressBook, nil);
    [ContactManager shareInstance].canLoadData = YES;
    
    if (ret) {
        NSLog(@"编辑联系人保存成功");
        [[ContactManager shareInstance] loadAllContact];
    } else {
        NSLog(@"编辑联系人保存失败");
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.personViewController.personViewDelegate = nil;
}

/**
 *  @brief  根据电话号码拨打电话
 *
 *  @param phone 电话号码
 */
- (void)makeCall:(NSString *)phone
{
    /**
    MKCallBackManager *callBackManager = [MKCallBackManager shareInstance];
    callBackManager.calleePhoneNumber = phone;
    callBackManager.calleeName = [ContactUtils getContactNameByPhone:phone];
    callBackManager.calleePhonePlace = [ContactUtils getPlaceByPhone:phone];
    [callBackManager startCallBackInsertRecordblock:^{
        [ContactUtils insertOneCallRecord:phone];
    }];
     **/
}

/**
 *  @brief  给该联系人打回拨
 */
- (void)callBackToContact:(NSString *)phoneNumber
{
    [self makeCall:phoneNumber];
}

/**
 *  @brief  按钮点击事件
 *
 *  @param sender button
 */
- (void)callButtonAction:(UIButton *)sender
{
    [self makeCall:self.buttonClickedStr];
}
/**
 *  发短信事件
 *
 *  @param sender
 */
- (void)sendMessageAction:(UIButton*)sender{
    
    id v=[sender superview];
    while (![v isKindOfClass:[MKContactDetailPhoneListCell class]]) {
        v=[v superview];
    }
    
    MKContactDetailPhoneListCell *cell=(MKContactDetailPhoneListCell*)v;
    
    NSArray *phones=[NSArray arrayWithObjects:cell.phoneNumLab.text, nil];
    
    [[ContactWrapper shareWrapper] sendMessageWithPhones:phones
                                              msgContent:[self GetSendSMS]
                                      rootViewController:self];
}

/**
 *  短信发送内容(子类化重写)
 *
 *  @return  返回要发送的默认短信内容
 */
- (NSString*)GetSendSMS{
   return @"";
}

#pragma 代理方法
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *phoneStr = [self.phoneList objectAtIndex:indexPath.row];
    [self callBackToContact:phoneStr];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.phoneList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKContactDetailPhoneListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailPhoneListCell"];
    if (cell==nil) {
        cell = [[MKContactDetailPhoneListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailPhoneListCell"];
    }
    
    cell.phoneNumLab.text = [self.phoneList objectAtIndex:indexPath.row];
    self.buttonClickedStr = [self.phoneList objectAtIndex:indexPath.row];
    cell.phoneOnwerLab.text = [ContactUtils getPlaceByPhone:[self.phoneList objectAtIndex:indexPath.row]];
    [cell.callBtn addTarget:self action:@selector(callButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.messageBtn addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    return cell;
}

@end
