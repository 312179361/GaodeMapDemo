//
//  ViewController.m
//  MapDemo
//
//  Created by TongLi on 16/6/14.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
@interface ViewController ()<MAMapViewDelegate>
{
    //地图
    MAMapView *mapView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化地图
    mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
    //地图语言
//    mapView.language = MAMapLanguageEn;
    //代理
    mapView.delegate = self;
    [self.view addSubview:mapView];
    //修改了一点哦
    //又一次修改了哦
    
}
//地图区域将要改变
- (void)mapView:(MAMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    NSLog(@"地图区域将要改变");
}
//地图区域改变完毕
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"地图区域已经变化");
}
//地图将要移动
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    NSLog(@"地图将要移动");
}
//地图移动完毕
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    NSLog(@"地图已经移动完毕");
}
//地图将要缩放
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    NSLog(@"地图将要缩放");
}
//地图缩放完毕
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    NSLog(@"地图已经缩放完毕");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
