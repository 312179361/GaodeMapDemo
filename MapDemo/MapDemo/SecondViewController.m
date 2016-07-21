//
//  SecondViewController.m
//  MapDemo
//
//  Created by TongLi on 16/6/23.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "SecondViewController.h"
#import <MAMapKit/MAMapKit.h>
@interface SecondViewController ()<MAMapViewDelegate>
{
    //地图
    MAMapView *tempMapView1 ;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tempMapView1 = [[MAMapView alloc]initWithFrame:self.view.bounds];
    tempMapView1.mapType = MAMapTypeStandard;
    tempMapView1.delegate = self;
    [self.view addSubview:tempMapView1];
    
    
}


- (IBAction)addOverlayAction:(UIBarButtonItem *)sender {
    //折线
//    [self addPolylineAction];
    //多边形
//    [self addPolygonAction];
    //圆形
//    [self addCircleAction];
    //大地曲线
//    [self addGeodesicAction];
    //图片覆盖物
    [self addGroundAction];
}


//创建折线数据
- (void)addPolylineAction {
    //构造折线数据
    CLLocationCoordinate2D commonPolylineCoords[4];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    //折线数据类继承自MAOverlay
    MAPolyline *polyLine = [MAPolyline  polylineWithCoordinates:commonPolylineCoords count:4];
    //在地图上添加折线对象
    [tempMapView1 addOverlay: polyLine];

    
}
//创建多边形数据
- (void)addPolygonAction {
    //构造多边形各个折点的数据
    CLLocationCoordinate2D coordinates[4];
    coordinates[0].latitude = 39.810892;
    coordinates[0].longitude = 116.233413;
    
    coordinates[1].latitude = 39.816600;
    coordinates[1].longitude = 116.331842;
    
    coordinates[2].latitude = 39.762187;
    coordinates[2].longitude = 116.357932;
    
    coordinates[3].latitude = 39.733653;
    coordinates[3].longitude = 116.278255;
    //多边形数据类继承自MAOverlay
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    
    //在地图上添加多边形对象
    [tempMapView1 addOverlay: polygon];

}
//创建圆形数据
- (void)addCircleAction {
    //构造圆,有圆心和半径构成
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:5000];
    
    //在地图上添加圆
    [tempMapView1 addOverlay: circle];
}
//创建大地曲线
- (void)addGeodesicAction {
    //大地线的两个点
    CLLocationCoordinate2D geodesicCoords[2];
    geodesicCoords[0].latitude = 39.905151;
    geodesicCoords[0].longitude = 116.401726;
    
    geodesicCoords[1].latitude = 38.905151;
    geodesicCoords[1].longitude = 70.401726;
    
    //构造大地曲线对象
    MAGeodesicPolyline *geodesicPolyline = [MAGeodesicPolyline polylineWithCoordinates:geodesicCoords count:2];
    //添加到地图上
    [tempMapView1 addOverlay:geodesicPolyline];
    
}
//图片覆盖物
- (void)addGroundAction {

    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(39.919604, 116.3992282), CLLocationCoordinate2DMake(39.908504, 116.3871082));
    
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"tianAnMen"]];
    
    [tempMapView1 addOverlay:groundOverlay];
    //当前地图可见范围
    tempMapView1.visibleMapRect = groundOverlay.boundingMapRect;
    
    
}
#pragma mark - 代理方法 -
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    //如果是折线视图
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        //折线视图
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        //折线的宽度
        polylineView.lineWidth = 10.f;
        //颜色
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.lineJoin = kCGLineJoinRound;//连接类型
        polylineView.lineCap = kCGLineCapRound;//端点类型
        
        return polylineView;
    }
    //如果是多边形视图
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        //多边形视图
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        //线条宽度
        polygonView.lineWidth = 5.f;
        //线条颜色
        polygonView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        //填充颜色
        polygonView.fillColor = [UIColor colorWithRed:1 green:0.88 blue:0.94 alpha:0.8];
        polygonView.lineJoin = kCGLineJoinMiter;//连接类型
        
        return polygonView;
    }
    
    //如果是圆形视图
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 5.f;
        circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        //虚线样式，前面的是线的长度，后面的是空隙的长度。
        circleView.lineDashPattern = @[@"10", @"15"];
        return circleView;
    }
    
    //如果是大地曲线
    if ([overlay isKindOfClass:[MAGeodesicPolyline class]])
    {
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polylineRenderer.lineWidth    = 4.f;
        polylineRenderer.strokeColor  = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        
        return polylineRenderer;
    }
    
    //如果是图片覆盖物
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc]initWithGroundOverlay:overlay];
        
        return groundOverlayView;
    }
    
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
