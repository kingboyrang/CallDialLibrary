//
//  MKContactListTableViewCell.m
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKContactListTableViewCell.h"
#import "MKContact.h"
#import "ContactManager.h"



@implementation MKContactListTableViewCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //设置背景色和选中时的颜色
        self.backgroundView=[[UIView alloc] init];
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:241/255.0 alpha:1.0];
        self.selectedBackgroundView.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView.alpha = 0.05;
        
        // 头像
        _contactHeader = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 44, 44)];
        _contactHeader.image=[MKContact shareInstance].defaultHeadPhotoImage;
        //[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
        [self.contentView addSubview:_contactHeader];
        
        //姓名
        _contactNameLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_contactHeader.frame)+8, 16, 180, 28)];
        _contactNameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        _contactNameLable.backgroundColor = [UIColor clearColor];
        _contactNameLable.clearsContextBeforeDrawing = NO;
        _contactNameLable.font = [UIFont boldSystemFontOfSize:17.f];
        [self.contentView addSubview:_contactNameLable];
        
        
        
        //头像加载完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contactHeadLoadFinished:) name:kNotifyContactHeadChanged object:nil];
    }
    return self;
}
/**
 *  属性值重写
 *
 *  @param node
 */
- (void)setContactNode:(ContactNode *)node{
    if (_contactNode!=node) {
        _contactNode=node;
        UIImage *img=[[ContactManager shareInstance] contactHeadWithContactID:self.contactNode.contactID];
        [self performSelectorOnMainThread:@selector(updateHeadPhoto:) withObject:img waitUntilDone:NO];
    }
}

/**
 *  设置用户关像
 *
 *  @param img
 */
- (void)setUserPhotoWithImg:(UIImage*)img{
     [self performSelectorOnMainThread:@selector(updateHeadPhoto:) withObject:img waitUntilDone:NO];
}

/**
 *  联系人加载完成通知
 *
 *  @param notification
 */
- (void)contactHeadLoadFinished:(NSNotification*)notification{
    NSDictionary *info=[notification userInfo];
    if([[info objectForKey:@"ContactID"] integerValue]==self.contactNode.contactID){
        UIImage *img=[info objectForKey:@"Image"];
        [self performSelectorOnMainThread:@selector(updateHeadPhoto:) withObject:img waitUntilDone:NO];
    }
    
}
/**
 *  更新头像
 *
 *  @param info 头像信息
 */
- (void)updateHeadPhoto:(UIImage*)img{
    if (img) {
        self.contactHeader.image=img;
    }else{
        img=[MKContact shareInstance].defaultHeadPhotoImage;
        //[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
        
    }
    self.contactHeader.image=img;
    self.contactHeader.layer.cornerRadius=self.contactHeader.frame.size.height/2;
    self.contactHeader.layer.masksToBounds=YES;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
