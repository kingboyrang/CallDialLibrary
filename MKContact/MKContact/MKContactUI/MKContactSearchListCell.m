//
//  MKContactSearchListCell.m
//  TDIMDemo
//
//  Created by chenzhihao on 15-1-13.
//  Copyright (c) 2015年 Guoling. All rights reserved.
//

#import "MKContactSearchListCell.h"
#import "MKContact.h"
#import "ContactManager.h"

@implementation MKContactSearchListCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView=[[UIView alloc] init];
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:241/255.0 alpha:1.0];
        self.selectedBackgroundView.backgroundColor = [UIColor blackColor];
        self.selectedBackgroundView.alpha = 0.05;
        
        // Initialization code
        self.headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.headerImg.image=[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
        [self.contentView addSubview:self.headerImg];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImg.frame)+3, 10, 150, 24)];
        [self.contentView addSubview:self.nameLabel];
        
        self.pingYingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+3, 14, 80, 20)];
        self.pingYingLabel.hidden = YES;
        self.pingYingLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.pingYingLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImg.frame)+3, CGRectGetMaxY(self.nameLabel.frame), 180, 20)];
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        self.numberLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.numberLabel];
        
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

    if(img){
        self.headerImg.image=img;
        self.headerImg.layer.cornerRadius=self.headerImg.frame.size.height/2;
        self.headerImg.layer.masksToBounds=YES;
    }
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
        self.headerImg.image=img;
    }else{
        self.headerImg.image=[MKContact getImageFromResourceBundleWithName:@"contact_default_photo" type:@"png"];
    }
    self.headerImg.layer.cornerRadius=self.headerImg.frame.size.height/2;
    self.headerImg.layer.masksToBounds=YES;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
