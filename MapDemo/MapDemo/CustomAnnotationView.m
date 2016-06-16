//
//  CustomAnnotationView.m
//  MapDemo
//
//  Created by TongLi on 16/6/16.
//  Copyright © 2016年 TongLi. All rights reserved.
//
#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView
//重写点击标注 方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            //创建气泡
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        //给气泡的三个属性赋值，
        self.calloutView.image = [UIImage imageNamed:@"tianAnMen"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        //将气泡加到标注上
        [self addSubview:self.calloutView];
    }
    else
    {
        //移除气泡
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
