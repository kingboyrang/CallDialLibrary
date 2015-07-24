//
//  WSTouchView.h
//  WldhWeishuo
//
//  Created by lonelysoul on 14-9-25.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KCItemClickDelegate <NSObject>

- (void)selectedKCItemClick:(id)sender;

@end

@interface WSTouchView : UIView

@property (nonatomic, weak) id<KCItemClickDelegate>delegate;

@end
