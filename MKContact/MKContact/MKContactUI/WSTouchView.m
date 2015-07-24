//
//  WSTouchView.m
//  WldhWeishuo
//
//  Created by lonelysoul on 14-9-25.
//  Copyright (c) 2014年 Guoling. All rights reserved.
//

#import "WSTouchView.h"

@implementation WSTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor blackColor]];
    self.alpha=0.05;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor blackColor]];
    self.alpha=0.05;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor colorWithRed:247/255.0 green:247/255.0 blue:241/255.0 alpha:1.0]];
    self.alpha=1.0;
    
    UITouch *touch = [touches anyObject];
    CGPoint points = [touch locationInView:self];
    if (points.x >= 0 && points.y >= 0 && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectedKCItemClick:)]) {
            [self.delegate selectedKCItemClick:self];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
