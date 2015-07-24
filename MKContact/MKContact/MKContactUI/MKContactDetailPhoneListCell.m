//
//  MKContactDetailPhoneListCell.m
//  MKContact
//
//  Created by chenzhihao on 15-5-20.
//  Copyright (c) 2015年 Chuzhong. All rights reserved.
//

#import "MKContactDetailPhoneListCell.h"
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width

@interface MKContactDetailPhoneListCell ()
@property (nonatomic,strong) UILabel *labLine; //线条
@end

@implementation MKContactDetailPhoneListCell

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
    //    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"MKContactResource" withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    //用对象mainBundle获取图片路径
    NSString *imagePath = [bundle pathForResource:imgName ofType:type];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
    return image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundView=[[UIView alloc] init];
        self.backgroundColor=[UIColor clearColor];
        
        // Initialization code
        
        //拨打按钮
        self.callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.callBtn.frame = CGRectMake(kScreenWidth-94, (self.bounds.size.height-32)/2, 32, 32);
        self.callBtn.backgroundColor = [UIColor clearColor];
        [self.callBtn setBackgroundImage:[self getImageFromResourceBundleWithName:@"dial_nor" type:@"png"] forState:UIControlStateNormal];
        [self.callBtn setBackgroundImage:[self getImageFromResourceBundleWithName:@"dial_sel" type:@"png"] forState:UIControlStateHighlighted];
        
        //信息按钮
        self.messageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.messageBtn.frame=CGRectMake(kScreenWidth-45, (self.bounds.size.height-32)/2, 32, 32);
        self.messageBtn.backgroundColor = [UIColor clearColor];
        [self.messageBtn setBackgroundImage:[self getImageFromResourceBundleWithName:@"contact_detail_im_nor" type:@"png"] forState:UIControlStateNormal];
        [self.messageBtn setBackgroundImage:[self getImageFromResourceBundleWithName:@"contact_detail_im_sel" type:@"png"] forState:UIControlStateHighlighted];
        
        //电话号码
        self.phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12,self.callBtn.frame.origin.x-20, 21)];
        self.phoneNumLab.textAlignment = NSTextAlignmentLeft;
        self.phoneNumLab.textColor = [UIColor blackColor];
        self.phoneNumLab.font = [UIFont systemFontOfSize:18.0];
        self.phoneNumLab.backgroundColor = [UIColor clearColor];
        
        //归属地
        self.phoneOnwerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 35,self.callBtn.frame.origin.x-20, 21)];
        self.phoneOnwerLab.textAlignment = NSTextAlignmentLeft;
        self.phoneOnwerLab.textColor = [UIColor lightGrayColor];
        self.phoneOnwerLab.font = [UIFont systemFontOfSize:13.0];
        self.phoneOnwerLab.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:self.phoneNumLab];
        [self addSubview:self.phoneOnwerLab];
        [self addSubview:self.callBtn];
        [self addSubview:self.messageBtn];
        
        //线条
        self.labLine= [[UILabel alloc] initWithFrame:CGRectMake(15, self.bounds.size.height-0.5, kScreenWidth-20, 0.5)];
        self.labLine.backgroundColor =[UIColor colorWithRed:226/255.0 green:226/255.0 blue:220/255.0 alpha:1.0];
        [self addSubview:self.labLine];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect r=self.callBtn.frame;
    r.origin.y=(self.bounds.size.height-r.size.height)/2;
    self.callBtn.frame=r;
    
    r=self.messageBtn.frame;
    r.origin.y=(self.bounds.size.height-r.size.height)/2;
    self.messageBtn.frame=r;
    
    r=self.labLine.frame;
    r.origin.y=self.bounds.size.height-r.size.height;
    self.labLine.frame=r;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
