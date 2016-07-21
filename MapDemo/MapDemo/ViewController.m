//
//  ViewController.m
//  MapDemo
//
//  Created by TongLi on 16/6/14.
//  Copyright © 2016年 TongLi. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CustomAnnotationView.h"
@interface ViewController ()<MAMapViewDelegate>
{
    //地图
    MAMapView *tempMapView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化地图
   tempMapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
   
    //地图语言
//    tempMapView.language = MAMapLanguageEn;
    
    //地图类型
    tempMapView.mapType = MAMapTypeStandard;//普通地图
//    tempMapView.mapType = MAMapTypeSatellite;//卫星地图
    
    //打开实时路况
//    tempMapView.showTraffic = YES;
    
    //代理
    tempMapView.delegate = self;
    [self.view addSubview:tempMapView];
    
    //地图控件设置
    //    [self setMapControl];
    //地图手势
    //    [self setMapGesture];
    
    //添加热力图
//    [self addHeatMapAction];
    
    //显示用户位置，即开启定位功能
    tempMapView.showsUserLocation = YES;
    //定位图层的样式
    tempMapView.userTrackingMode = MAUserTrackingModeFollow;

    
}

//设置地图控件
- (void)setMapControl {
    //logo的位置
    tempMapView.logoCenter = CGPointMake(250, 550);
    
    //罗盘显示与否(默认是显示的)
    tempMapView.showsCompass = YES;
    //罗盘位置(默认是右上角)
    tempMapView.compassOrigin = CGPointMake(0, 0);
    
    //比例尺的显示与否(默认是显示的)
    tempMapView.showsScale = YES;
    //比例尺位置(默认是左上角)
    tempMapView.scaleOrigin = CGPointMake(150, 15);
}

//地图手势
- (void)setMapGesture {
    //缩放
    tempMapView.zoomEnabled = NO;//禁止缩放
    //缩放级别，即地图要显示多大，值越大显示的范围越小。范围是[3-19]
    tempMapView.zoomLevel = 10;
    
    //平移
    tempMapView.scrollEnabled = NO;//禁止移动
    //控制地图中心点，移动地图
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(34.7568711, 113.663221);
    [tempMapView setCenterCoordinate:centerCoordinate animated:YES];
    
}
#pragma mark - 截屏 -
//地图截屏
- (IBAction)screenShotAction:(UIBarButtonItem *)sender {
    //截屏
    [tempMapView takeSnapshotInRect:self.view.bounds withCompletionBlock:^(UIImage *resultImage, CGRect rect) {
        
        //resultImage就是截屏的图片。保存到本地
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        //文件路径
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"mapShot.png"]];
        NSLog(@"%@",filePath);
        BOOL result = [UIImagePNGRepresentation(resultImage) writeToFile:filePath atomically:YES];
        if (result == YES) {
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }

    }];

    
}


#pragma mark - mapView代理 -
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
#pragma mark - 热力图 -
- (void)addHeatMapAction {
    //创建热力图
    MAHeatMapTileOverlay *heatTile = [[MAHeatMapTileOverlay alloc]init];
    //初始化一下热力数据源
    NSMutableArray *data = [NSMutableArray array];
    //从本地获得热力数据源
    NSData *jsdata = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"heatMapData" ofType:@"json"]];
    if (jsdata) {
        NSArray *dicArray = [NSJSONSerialization JSONObjectWithData:jsdata options:NSJSONReadingAllowFragments error:nil];
        
        for (NSDictionary *dic in dicArray) {
            //通过数据源，封装成热力图节点模型MAHeatMapNode
            MAHeatMapNode *node = [[MAHeatMapNode alloc]init];
            //节点的坐标
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [dic[@"lat"] doubleValue];
            coordinate.longitude = [dic[@"lng"] doubleValue];
            node.coordinate = coordinate;
            //节点的权重
            node.intensity = 1;
            //添加到数据源数组中
            [data addObject:node];
        }
    }
    //给热力图的热力节点赋值
    heatTile.data = data;
    //构造渐变色对象
    MAHeatMapGradient *gradient = [[MAHeatMapGradient alloc] initWithColor:@[[UIColor blueColor],[UIColor greenColor], [UIColor redColor]] andWithStartPoints:@[@(0.2),@(0.5),@(0.9)]];
    heatTile.gradient = gradient;
    //将热力图添加到地图上
    [tempMapView addOverlay: heatTile];
    
}
#pragma mark - 热力图显示在地图上 -
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    
    if ([overlay isKindOfClass:[MATileOverlay class]])
    {
        //渲染类
        MATileOverlayView *tileOverlayView = [[MATileOverlayView alloc] initWithTileOverlay:overlay];
        
        return tileOverlayView;
    }
    return nil;
}


#pragma mark - 大头针 -
- (IBAction)addPointAnnotation:(UIBarButtonItem *)sender {
    //1、定义MAPointAnnotation对象，并指定属性
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    //指定大头针的经纬度
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.909604, 116.3972282);
    //指定大头针的标题和副标题
    pointAnnotation.title = @"天安门";
    pointAnnotation.subtitle = @"世界上最大的城市中心广场";
    //2、将大头针添加到地图上
    [tempMapView addAnnotation:pointAnnotation];
}

#pragma mark - 显示大头针的回调方法 -
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    /*
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //重用大头针机制
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        //创建大头针的展示效果视图 MAPinAnnotationView。
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
//        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
//        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
//        annotationView.pinColor = MAPinAnnotationColorPurple; //大头针颜色
        
        
        
        return annotationView;
    }
    return nil;
     */
    
    
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        //给标注附图片，注意不是气泡上的那个图片，是标注的样式图片
        annotationView.image = [UIImage imageNamed:@"money.png"];
        
        // 设置为NO，用以调用自定义的calloutView
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -20);
        return annotationView;
    }
    return nil;
}


#pragma mark - 定位--更新位置代理 -
//只要用户的位置更新，就会执行这个代理方法
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
    if (updatingLocation == YES) {
        NSLog(@"latitude:%f,,longitude:%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
//当mapView新添加annotation views时调用此接口
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MAAnnotationView *view = views[0];
    //如果是用户位置的标注，
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        //精度圈演示
        MAUserLocationRepresentation *repre = [[MAUserLocationRepresentation alloc]init];
        //精度圈填充颜色
        repre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
        //精度圈边框颜色
        repre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
        //定位图片，
        repre.image = [UIImage imageNamed:@"userPosition.png"];
        //精度圈的边线宽度
        repre.lineWidth = 3;
        //精度圈的虚线演示
        repre.lineDashPattern = @[@6, @3];
        //更新样式
        [tempMapView updateUserLocationRepresentation:repre];
        
        view.calloutOffset = CGPointMake(0, 0);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
