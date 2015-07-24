//
//  MKContactListTableViewCell.h
//  MKContact
//
//  Created by chenzhihao on 15-5-19.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactNode.h"

@interface MKContactListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *contactHeader;
@property (nonatomic, strong) UILabel *contactNameLable;
@property (nonatomic, strong) ContactNode *contactNode;
@property (nonatomic, assign) BOOL isLastCell;

/**
 *  设置用户关像
 *
 *  @param img
 */
- (void)setUserPhotoWithImg:(UIImage*)img;

@end
