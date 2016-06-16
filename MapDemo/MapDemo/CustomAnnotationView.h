//
//  CustomAnnotationView.h
//  MapDemo
//
//  Created by TongLi on 16/6/16.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"
@interface CustomAnnotationView : MAAnnotationView

@property(nonatomic,strong)CustomCalloutView *calloutView;

@end
