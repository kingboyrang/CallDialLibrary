//
//  MKContactViewController.m
//  MKFrameworkDemo
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKContactViewController.h"
#import "ShowContactSectionView.h"
#import "MKContactListTableViewCell.h"
#import "MKContactSearchListCell.h"
#import "MKContactDetailViewController.h"
#import "ContactManager.h"
#import "T9ContactRecord.h"
#import "ContactSearchNode.h"
#import "ContactWrapper.h"
#import "WSTouchView.h"
#import "MKContact.h"

#define kScreenWidth            [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height

#define kMKIsRetain4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)    //是否为4寸屏

// 颜色配置
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define kWSButtonNormalColor [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]
#define kWSButtonHighlightColor [UIColor colorWithRed:2/255.0 green:157/255.0 blue:0/255.0 alpha:1.0]

#define kWSSearchHightLightColor    [UIColor colorWithRed:6/255.0 green:191/255.0 blue:4/255.0 alpha:1.0]

@interface MKContactViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,KCItemClickDelegate,UISearchControllerDelegate,UISearchResultsUpdating>
//操作右侧索引显示的view
@property (nonatomic, strong) ShowContactSectionView *contactSectionView;

//tableview被点击的行所在的联系人节点
@property (nonatomic,strong) ContactNode *aContact;

//搜索控件
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic, copy)  NSString *filterString;

//联系人列表
@property (nonatomic,strong) UITableView *contactListTable;
//所有排序联系人数据
@property (nonatomic,strong) NSDictionary *allContactSortedDict;
//所有联系人的排序索引
@property (nonatomic,strong) NSMutableArray *allContactSortedKey;
//没有联系人显示提示view
@property (nonatomic,strong) UIView *notReadTipsView;

//是否出于搜索状态
@property (nonatomic,assign) BOOL isSearching;
//索索结果的列表
@property (nonatomic,strong) NSMutableArray *contactSearchList;
/** 搜索联系人列表，一个联系人多个号码，分开成两个項 **/
@property (nonatomic, strong) NSMutableArray *searchContactsByPhone;

//父试图控制器
@property (nonatomic,strong) UIViewController *parentVc;


@end

@implementation MKContactViewController

/**
 *  @brief  设置父视图控制器
 *
 *  @param parent   父视图控制器
 *
 */
- (void)setParentController:(UIViewController *)parent
{
    self.parentVc = parent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"联系人";
    
    //初始化数据源
    self.contactSearchList = [NSMutableArray arrayWithCapacity:0];
    self.allContactSortedKey = [NSMutableArray arrayWithCapacity:0];
    self.searchContactsByPhone = [NSMutableArray arrayWithCapacity:0];
    self.contactSearchList = [NSMutableArray arrayWithCapacity:0];
    
    //设置数据源
    NSDictionary *dict = nil;
    dict = [[ContactManager shareInstance] sortContactDict];
    [self.allContactSortedKey addObjectsFromArray:[ContactManager shareInstance].sortKeyList];
    if (dict != nil) {
        self.allContactSortedDict = [NSDictionary dictionaryWithDictionary:dict];
    }
    
   

    CGRect r=self.view.bounds;
    self.contactListTable = [[UITableView alloc] initWithFrame:r style:UITableViewStylePlain];
    self.contactListTable.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewContentModeBottom|UIViewAutoresizingFlexibleHeight;
    self.contactListTable.delegate = self;
    self.contactListTable.dataSource = self;
    self.contactListTable.backgroundView=[[UIView alloc] init];
    self.contactListTable.backgroundColor=[UIColor clearColor];
    self.contactListTable.sectionIndexBackgroundColor = [UIColor clearColor];
    self.contactListTable.sectionIndexColor=[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    self.contactListTable.separatorColor=[UIColor colorWithRed:226/255.0 green:226/255.0 blue:220/255.0 alpha:1.0];

    
    //酷秘团队
    WSTouchView *coolTeam=[[WSTouchView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    coolTeam.delegate=self;
    coolTeam.backgroundColor=self.view.backgroundColor;
    UIImageView *coolImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
    coolImageView.image=[MKContact getImageFromResourceBundleWithName:@"cool_secretary_team@2x" type:@"png"];
    [coolTeam addSubview:coolImageView];
    
    UILabel *coollab = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 200, 30)];
    coollab.backgroundColor=[UIColor clearColor];
    coollab.text=@"酷秘团队";
    coollab.font=[UIFont boldSystemFontOfSize:17.0];
    [coolTeam addSubview:coollab];
    //self.contactListTable.tableHeaderView=coolTeam;
    [self.view addSubview:self.contactListTable];
    
    
    // 创建搜索控制器
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    // 设置搜索控制器 更新的内容
    // 搜索框输入时  更新列表
    self.searchController.searchResultsUpdater = self;
    
    // 设置为NO的时候 列表的单元格可以点击 默认为YES无法点击无效
    self.searchController.dimsBackgroundDuringPresentation = NO;
    // 设置代理
    self.searchController.delegate = self;
    // 保证搜索导航栏中可见
    [self.searchController.searchBar sizeToFit];
    // 把搜索框 设置为表头
    self.contactListTable.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    //通讯录鉴权
    BOOL ret = [[ContactManager shareInstance] addressBookIsAuthentication:YES];
    if (ret) {
        [self.contactListTable setHidden:NO];
        //self.searchDisplay.searchBar.hidden = NO;
        //加载联系人
        BOOL loadContactSuccess = [[ContactManager shareInstance] loadAllContact];
        if (loadContactSuccess) {
            NSLog(@"加载联系人成功!");
        }
    } else {
        [self createNotReadAddressBookTips];
        [self.contactListTable setHidden:YES];
        //self.searchDisplay.searchBar.hidden = YES;
    }
    
    [self setTableViewFootView];
    
    
    //导航栏右侧按钮
    UIButton  *_rightcustomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _rightcustomButton.frame=CGRectMake(0, 10, 24, 24);
    [_rightcustomButton setBackgroundImage:[self getImageFromResourceBundleWithName:@"contact_add_nor" type:@"png"] forState:UIControlStateNormal];
    [_rightcustomButton setBackgroundImage:[self getImageFromResourceBundleWithName:@"contact_add_nor" type:@"png"] forState:UIControlStateHighlighted];
    [_rightcustomButton addTarget:self
                           action:@selector(createNewContact)
                 forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_rightcustomButton];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    //添加通知
    [self addObservers];
    
    _contactSectionView = [[ShowContactSectionView alloc] init];
    _contactSectionView.sectionList = self.allContactSortedKey;
    _contactSectionView.hidden = YES;
    [self.view addSubview:_contactSectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _contactSectionView.frame = CGRectMake((kScreenWidth-55)/2, self.contactListTable.frame.origin.y+20, 55, self.contactListTable.frame.size.height-40);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self removeObservers];
}

/**
 *
 *  酷秘团队 点击事件
 *  @param sender 
 */
- (void)selectedKCItemClick:(id)sender{
    [self coolTeamClick];
}
/**
 *  酷秘团队 点击事件
 */
- (void)coolTeamClick{

}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callRecordDataChanged)
                                                 name:kNotifyContactDataChanged
                                               object:nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyContactDataChanged object:nil];
}

- (void)callRecordDataChanged
{
    [self performSelectorOnMainThread:@selector(callRecordDataChangedInMain) withObject:nil waitUntilDone:YES];
}

- (void)callRecordDataChangedInMain{
    @synchronized(_contactListTable)
    {
        if (self.allContactSortedKey) {
            [self.allContactSortedKey removeAllObjects];
        }
        NSDictionary *dict = nil;
        dict = [[ContactManager shareInstance] sortContactDict];
        [self.allContactSortedKey addObjectsFromArray:[ContactManager shareInstance].sortKeyList];
        if (dict != nil) {
            self.allContactSortedDict = [NSDictionary dictionaryWithDictionary:dict];
        }
        
        if ([self.allContactSortedKey count] > 0){
            [_contactListTable setHidden:NO];
            //self.searchController.searchBar.hidden = NO;
            [_notReadTipsView setHidden:YES];
        }else{
            [_contactListTable setHidden:YES];
            //self.searchController.searchBar.hidden = YES;
            [_notReadTipsView setHidden:NO];
            
        }
        [self setTableViewFootView];
        [_contactListTable reloadData];
    }
}

/**
 *  @brief  创建新联系人
 */
- (void)createNewContact
{
    [[ContactWrapper shareWrapper] addNewContactWithPhone:nil rootViewController:self];
}

/**
 *  @brief 创建无通讯录界面
 */
- (void)createNotReadAddressBookTips
{
    if (!self.notReadTipsView)
    {
        self.notReadTipsView = [[UIView alloc]initWithFrame:self.view.frame];
        [self.notReadTipsView setBackgroundColor:[UIColor clearColor]];
        UIImageView *noContactImage = [[UIImageView alloc]initWithFrame:CGRectMake(87, kMKIsRetain4?((self.view.frame.size.height)/2 - 240):10, 146, 252)];
        noContactImage.backgroundColor = [UIColor clearColor];
        noContactImage.image = [self getImageFromResourceBundleWithName:@"noContactBg" type:@"png"];
        [_notReadTipsView addSubview:noContactImage];
        [self.view addSubview:_notReadTipsView];
        UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(50, noContactImage.frame.origin.y +noContactImage.frame.size.height +20, 220, 20)];
        lable1.backgroundColor = [UIColor clearColor];
        lable1.textColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
        lable1.text = @"在手机系统设置中";
        lable1.textAlignment = NSTextAlignmentCenter;
        
        UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(50, lable1.frame.origin.y +lable1.frame.size.height +5, 220, 20)];
        lable2.backgroundColor = [UIColor clearColor];
        lable2.textColor = [UIColor blackColor];
        lable2.text = @"设置 > 隐私 > 通讯录";
        lable2.textAlignment = NSTextAlignmentCenter;
        lable2.font = [UIFont systemFontOfSize:14.0];
        
        UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(50, lable2.frame.origin.y +lable2.frame.size.height +5, 220, 20)];
        lable3.backgroundColor = [UIColor clearColor];
        lable3.textColor = [UIColor blackColor];
        
        //获取app名称
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        CFShow((__bridge CFTypeRef)(infoDictionary));
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        lable3.text = [NSString stringWithFormat:@"开启%@开关",app_Name];
        lable3.textAlignment = NSTextAlignmentCenter;
        lable3.font = [UIFont systemFontOfSize: 14.0];
        [_notReadTipsView addSubview:lable1];
        [_notReadTipsView addSubview:lable2];
        [_notReadTipsView addSubview:lable3];
    }
}

/**
 *  @brief  设置tableview的footView，用于显示联系人数
 */
- (void)setTableViewFootView
{
    NSInteger count = 0;
    if (self.searchController.active) {
       count = [self.searchContactsByPhone count];
    }else{
        for (NSString *key in self.allContactSortedDict.allKeys) {
            NSArray *arr = self.allContactSortedDict[key];
            count += arr.count;
        }
    }
    if (_contactSectionView) {
        [_contactSectionView removeFromSuperview];
        _contactSectionView = nil;
        
        _contactSectionView = [[ShowContactSectionView alloc] init];
        _contactSectionView.sectionList = self.allContactSortedKey;//[[UILocalizedIndexedCollation currentCollation] sectionTitles];
        _contactSectionView.hidden = YES;
        [self.view addSubview:_contactSectionView];
        _contactSectionView.frame = CGRectMake((kScreenWidth-55)/2, self.contactListTable.frame.origin.y+20, 55, self.contactListTable.frame.size.height-40);
    }
    
    UILabel *wsFriendCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contactListTable.frame.size.width, 44)];
    wsFriendCountLabel.textAlignment = NSTextAlignmentCenter;
    wsFriendCountLabel.font = [UIFont systemFontOfSize:18];
    wsFriendCountLabel.textColor = [UIColor grayColor];
    wsFriendCountLabel.text = [NSString stringWithFormat:@"%ld 位联系人", (long)count];
    self.contactListTable.tableFooterView = wsFriendCountLabel;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contactListTable.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [wsFriendCountLabel addSubview:line];
}

- (void)hideContactSectionView{
    [UIView animateWithDuration:0.25 animations:^{
        _contactSectionView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _contactSectionView.hidden = YES;
        _contactSectionView.alpha = 1.0;
    }];
}

/**
 *  @brief  获得资源文件bundle的图片
 *
 *  @param imgName 图片名字
 *  @param type    图片类型
 *
 *  @return UIImage对象
 */
- (UIImage *)getImageFromResourceBundleWithName:(NSString *)imgName type:(NSString *)type;
{
    //定义一个NSBundle对象获取得到应用程序的main bundle
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

#pragma 代理fangfa
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchController.active) {
        ContactSearchNode *oneNode = [self.searchContactsByPhone objectAtIndex:indexPath.row];
        T9ContactRecord *oneRecord = oneNode.contactRecord;
        ContactNode *aContact = [[ContactManager shareInstance] getOneContactByID:oneRecord.abRecordID];
        self.aContact = aContact;
        [self selectedItemWithContactNode:self.aContact];
    }
    else
    {
        NSInteger section = indexPath.section;
        NSString *aKey = [self.allContactSortedKey objectAtIndex:section];
        NSArray *aList = [self.allContactSortedDict objectForKey:aKey];
        if ([aList count] > 0)
        {
            self.aContact = (ContactNode *)[aList objectAtIndex:indexPath.row];
            [self selectedItemWithContactNode:self.aContact];
        }
    }
}


/**
 *  @brief  tableview row点击事件，默认跳转到联系人详情(MKContactDetailViewController类)，子类可重写
 */
- (void)selectedItemWithContactNode:(ContactNode*)node{
    
    MKContactDetailViewController *contactDetail = [[MKContactDetailViewController alloc] init];
    contactDetail.aContact = node;
    if (self.navigationController) {
        [self.navigationController pushViewController:contactDetail animated:YES];
    }else{
        [self presentViewController:contactDetail animated:YES completion:nil];
    }
}


#pragma mark - UITableViewDataSource
/**
 *  tableView返回的section数
 *
 *  @param tableView 当前UITableView
 *
 *  @return section数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return 1;
    }
    return [self.allContactSortedKey count];
}
/**
 *  tableView的每个section返回的行数
 *
 *  @param tableView UITableView
 *  @param section   section
 *
 *  @return 每个section返回的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.searchContactsByPhone count];
    }
    else
    {
        NSInteger index = section;
        NSString *akey = self.allContactSortedKey[index];
        if (akey != nil)
        {
            NSArray *aList = [self.allContactSortedDict objectForKey:akey];
            return [aList count];
        }
    }
    return 0;
}
/**
 *  返回tableView的行高
 *
 *  @param tableView UITableView
 *  @param indexPath 当前行对应的indexPath
 *
 *  @return 行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}
/**
 *  返回tableView的每个section头部的高度
 *
 *  @param tableView UITableView
 *  @param section   section
 *
 *  @return 每个section头部的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return 0;
    } else {
        NSString *aKey = [self.allContactSortedKey objectAtIndex:section];
        NSArray *aList = [self.allContactSortedDict objectForKey:aKey];
        if ([aList count]>0) {
            return 23.0;
        }
    }
    return 0;
}
/**
 *  返回tableView的每个section头部的view
 *
 *  @param tableView UITableView
 *  @param section   section
 *
 *  @return 每个section头部的view
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return nil;
    }
    else
    {
        UIView *sectionBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 23)];
        sectionBackView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:236/255.0 alpha:1.0];
        UILabel *sectionLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 1.5, kScreenWidth-20, 20)];
        sectionLable.font = [UIFont systemFontOfSize:13.0];
        sectionLable.text = [self.allContactSortedKey objectAtIndex:section];
        sectionLable.backgroundColor=[UIColor clearColor];
        [sectionBackView addSubview:sectionLable];
        return sectionBackView;
    }
}
/**
 *  @brief  取得分组的索引，tableview右侧显示的索引
 *
 *  @param tableView tableview
 *
 *  @return 返回索引的数组
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return nil;
    } else {
        return self.allContactSortedKey;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.searchController.active) {
        return index;
    } else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideContactSectionView) object:nil];
        [_contactSectionView setHidden:NO];
        
        [_contactSectionView selectSection:index];
        [self performSelector:@selector(hideContactSectionView) withObject:nil afterDelay:0.5];
    }
    return index;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_contactSectionView setHidden:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active)
    {
        MKContactSearchListCell *cell = (MKContactSearchListCell *)[tableView dequeueReusableCellWithIdentifier:@"ContactListSearchCell"];
        ContactSearchNode *oneNode = self.searchContactsByPhone[indexPath.row];
        if (cell==nil)
        {
            cell = [[MKContactSearchListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:@"ContactListSearchCell"];
            //设置头像（暂时默认）
            //cell.contactNode=[[ContactManager shareInstance] getOneContactByID:oneNode.contactRecord.abRecordID];
        }
       
        
        //chenzhihao add 20150109 搜索结果匹配字高亮
        NSMutableAttributedString *contactFullName = [[NSMutableAttributedString alloc] initWithString:oneNode.name];
        NSMutableAttributedString *phone = [[NSMutableAttributedString alloc] initWithString:oneNode.number];
        NSMutableAttributedString *pinYing = [[NSMutableAttributedString alloc] initWithString:oneNode.pinYing];
        
        [contactFullName addAttribute:NSForegroundColorAttributeName value:kWSSearchHightLightColor range:oneNode.nameMatchRange];
        [phone addAttribute:NSForegroundColorAttributeName value:kWSSearchHightLightColor range:oneNode.numberMatchRange];
        [pinYing addAttribute:NSForegroundColorAttributeName value:kWSSearchHightLightColor range:oneNode.pinYingMatchRange];
        
        CGSize size = [oneNode.name sizeWithAttributes:@{NSFontAttributeName:cell.nameLabel.font}];
        CGRect frame = cell.nameLabel.frame;
        frame.size.width = size.width;
        cell.nameLabel.frame = frame;
        
        size = [oneNode.pinYing sizeWithAttributes:@{NSFontAttributeName:cell.pingYingLabel.font}];
        frame = cell.pingYingLabel.frame;
        frame.origin.x = CGRectGetMaxX(cell.nameLabel.frame)+5;
        frame.size.width = size.width;
        cell.pingYingLabel.frame = frame;
        
        cell.nameLabel.attributedText = contactFullName;
        cell.numberLabel.attributedText = phone;
        cell.pingYingLabel.attributedText = pinYing;
        
        if (oneNode.pinYingMatchRange.length>0) {
            cell.pingYingLabel.hidden = NO;
            cell.pingYingLabel.attributedText = pinYing;
        }
        else
        {
            cell.pingYingLabel.hidden = YES;
        }
        //设置头像
        cell.contactNode=[[ContactManager shareInstance] getOneContactByID:oneNode.contactRecord.abRecordID];
        //[cell setUserPhotoWithImg:[[ContactManager shareInstance] contactHeadWithContactID:oneNode.contactRecord.abRecordID]];
        return cell;
        
    }
    else
    {
        MKContactListTableViewCell *contactCell = (MKContactListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"contactListCell"];
        if (contactCell == nil)
        {
            contactCell = [[MKContactListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"contactListCell"];
        }
        NSInteger index = indexPath.section;
        NSString *aKey = [self.allContactSortedKey objectAtIndex:index];
        NSArray *aList = [self.allContactSortedDict objectForKey:aKey];
        
        if ([aList count] > 0)
        {
            ContactNode *aContact = (ContactNode *)[aList objectAtIndex:indexPath.row];
            
            if(nil != aContact)
            {
                contactCell.contactNameLable.text = [aContact getContactFullName];
                //设置头像
                contactCell.contactNode=aContact;
                //[contactCell setUserPhotoWithImg:[[ContactManager shareInstance] contactHeadWithContactID:aContact.contactID]];
            }
            else
            {
                contactCell.contactNameLable.text = @"";
            }
            
            if (indexPath.row == aList.count -1)
            {
                contactCell.isLastCell = YES;
            }
            else
            {
                contactCell.isLastCell = NO;
            }
        }
        
        return contactCell;
    }
}

#pragma mark - UISearchBarDelegate

#pragma mark - UISearchDisplayDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton=YES;
    for (UIView *cc in searchBar.subviews) {
        NSLog(@"cc class =%@",[cc class]);
        
        for (UIView *item in cc.subviews) {
             NSLog(@"item class =%@",[item class]);
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn=(UIButton *)cc;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        
    }
    return YES;
}


//判断是否为整形数字：
- (BOOL)isNumber:(NSString*)string{
    NSString *lastStr = [string substringFromIndex:(string.length-1)];
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:lastStr];
}

//判断是否为字母：
- (BOOL)isAlpha:(NSString *)string
{
    NSString *lastStr = [string substringFromIndex:(string.length-1)];
    NSString *regex = @"^[A-Za-z]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:lastStr];
}
//重新加载tableview
- (void)reloadListInMain{
    @synchronized(self.contactListTable)
    {
        //[self setTableViewFootView];
        [self.contactListTable reloadData];
    }
}

#pragma mark --- 重写 filterString的set方法
- (void)setFilterString:(NSString *)searchString
{
    
    if (_filterString!=searchString) {
        _filterString = searchString;
        
        [_searchContactsByPhone removeAllObjects];
        [_contactSearchList removeAllObjects];
        
        if ([searchString length] > 15) {
            searchString = [searchString substringWithRange:NSMakeRange(0, 14)];
        }
        
        //搜索结果
        NSArray *searchResult = [[ContactManager shareInstance] searchResultWithText:searchString];
        
        [self.contactSearchList addObjectsFromArray:searchResult];
        
        //避免同一个联系人N个相似号码搜索时出现 N*N条搜索结果
        NSMutableArray *ids = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i=0; i<self.contactSearchList.count; i++) {
            T9ContactRecord *record = self.contactSearchList[i];
            if (![ids containsObject:[NSNumber numberWithInteger:record.abRecordID]]) {
                [ids addObject:[NSNumber numberWithInteger:record.abRecordID]];
            }
            else
            {
                [self.contactSearchList removeObjectAtIndex:i];
                i--;
            }
        }
        
        
        //过滤结果集，将有多个手机号码的联系人分多行显示
        NSMutableArray *bList = [[NSMutableArray alloc] initWithCapacity:0];
        
        
        for (NSInteger i=0; i<self.contactSearchList.count; i++)
        {
            T9ContactRecord *record = self.contactSearchList[i];
            ContactNode *aContact = [[ContactManager shareInstance] getOneContactByID:record.abRecordID];
            NSString *fullName = [aContact getContactFullName];
            NSString *pinYing = record.strPinyinOfAcronym;
            
            NSArray *phoneList = [aContact contactAllPhone];
            
            for (int j=0; j<phoneList.count; j++)
            {
                NSString *phone = phoneList[j];
                ContactSearchNode *node = [[ContactSearchNode alloc] init];
                node.name = fullName;
                node.number = phone;
                node.pinYing = pinYing;
                node.contactRecord = record;
                
                //记录匹配的范围，用于高亮显示
                if ([node.name rangeOfString:searchString].location!=NSNotFound) {
                    node.nameMatchRange = [node.name rangeOfString:searchString];
                    [bList addObject:node];
                }
                else if ([node.number rangeOfString:searchString].location!=NSNotFound) {
                    node.numberMatchRange = [node.number rangeOfString:searchString];
                    [bList addObject:node];
                }
                else if ([self isAlpha:searchString] && [[node.contactRecord.strPinyinOfAcronym lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound) {
                    node.pinYingMatchRange = [[node.contactRecord.strPinyinOfAcronym lowercaseString] rangeOfString:[searchString lowercaseString]];
                    [bList addObject:node];
                }
                else if ([self isAlpha:searchString] && [[node.contactRecord.strValue lowercaseString] rangeOfString:[searchString lowercaseString]].location!=NSNotFound) {
                    [bList addObject:node];
                }
            }
        }
        [self.searchContactsByPhone addObjectsFromArray:bList];
        
        [self performSelectorOnMainThread:@selector(reloadListInMain)
                               withObject:nil
                            waitUntilDone:YES];
    }
}
#pragma mark ---- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (!searchController.active) {
        return;
    }
    self.filterString = searchController.searchBar.text;
}



#pragma mark --- 设置searchController 代理方法
// 将要返回
- (void)willDismissSearchController:(UISearchController *)searchController
{
    // 点击cancel的时候 数组还原 刷新表
    //self.visibleResults = self.allResults;
    //[self.tableView reloadData];
}

-(void)didDismissSearchController:(UISearchController *)searchController
{
    
    [self performSelectorOnMainThread:@selector(reloadListInMain)
          withObject:nil
       waitUntilDone:YES];
}

@end
