//
//  CustomCalloutView.h
//  MapDemo
//
//  Created by TongLi on 16/6/16.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCalloutView : UIView
//图标
@property (nonatomic,strong)UIImage *image;
//标题
@property (nonatomic,copy)NSString *title;
//副标题
@property (nonatomic,copy)NSString *subtitle;
@end
