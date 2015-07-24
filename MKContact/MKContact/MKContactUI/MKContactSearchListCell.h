//
//  MKContactSearchListCell.h
//  TDIMDemo
//
//  Created by chenzhihao on 15-1-13.
//  Copyright (c) 2015年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactNode.h"

@interface MKContactSearchListCell : UITableViewCell
@property (nonatomic,strong) UIImageView *headerImg;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) UILabel *pingYingLabel;

/**
 *  搜索结果Node(用于设置头像)
 */
@property (nonatomic,strong) ContactNode *contactNode;

/**
 *  设置用户关像
 *
 *  @param img
 */
- (void)setUserPhotoWithImg:(UIImage*)img;

@end
