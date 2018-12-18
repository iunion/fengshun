//
//  BMTestGPSMockVC.m
//  fengshun
//
//  Created by jiang deng on 2018/11/30.
//  Copyright © 2018 FS. All rights reserved.
//

#import "BMTestGPSMockVC.h"
#import "BMTestGPSMocker.h"
#import <MapKit/MapKit.h>

@interface BMTestGPSMockVC ()
<
    MKMapViewDelegate
>
{
    BOOL mockGPSSwitch;
}

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIView *operatorView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UISwitch *switchView;

@property (nonatomic, strong) UIButton *inputBtn;
@property (nonatomic, strong) UILabel *longitudeTipLabel;
@property (nonatomic, strong) UITextField *longitudeField;
@property (nonatomic, strong) UILabel *latitudeTipLabel;
@property (nonatomic, strong) UITextField *latitudeField;
@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) UILabel *gpsLabel;
@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UIButton *zoomin;
@property (nonatomic, strong) UIButton *zoomout;

@end

@implementation BMTestGPSMockVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IOS_VERSION >= 7.0f)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    // 隐藏系统的返回按钮
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    self.bm_NavigationBarStyle = UIBarStyleDefault;
    self.bm_NavigationBarBgTintColor = [UIColor whiteColor];
    self.bm_NavigationTitleTintColor = [UIColor blackColor];
    self.bm_NavigationItemTintColor = [UIColor blackColor];
    self.bm_NavigationShadowHidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Mock GPS";

    [self bm_setNavigationWithTitle:@"Mock GPS" barTintColor:nil leftItemTitle:nil leftItemImage:nil leftToucheEvent:nil rightItemTitle:nil rightItemImage:@"navigationbar_close_icon" rightToucheEvent:@selector(close)];
    
    [self requestUserLocationAuthor];
    
    [self makeUI];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)makeUI
{
    self.operatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 120.0f)];
    [self.view addSubview:self.operatorView];

    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.textColor = [UIColor blackColor];
    self.tipLabel.text = @"Mock GPS:";
    self.tipLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.tipLabel sizeToFit];
    self.tipLabel.bm_origin = CGPointMake(15.0f, 15.0f);
    [self.operatorView addSubview:self.tipLabel];
    
    UISwitch *switchView = [[UISwitch alloc] init];
    switchView.bm_origin = CGPointMake(self.tipLabel.bm_right+20.0f, 8.0f);
    [self.operatorView addSubview:switchView];
    [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.switchView = switchView;

    self.longitudeTipLabel = [[UILabel alloc] init];
    self.longitudeTipLabel.textColor = [UIColor blackColor];
    self.longitudeTipLabel.font = [UIFont systemFontOfSize:14];
    self.longitudeTipLabel.text = @"经度:";
    [self.operatorView addSubview:_longitudeTipLabel];
    self.longitudeTipLabel.frame = CGRectMake(20.0f, self.tipLabel.bm_bottom + 15.0f, 40.0f, 30.0f);
    
    self.longitudeField = [[UITextField alloc] initWithFrame:CGRectMake(self.longitudeTipLabel.bm_right, self.longitudeTipLabel.bm_top, 100.0f, 30.0f)];
    self.longitudeField.layer.borderWidth = 1;
    self.longitudeField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.operatorView addSubview:self.longitudeField];
    
    self.latitudeTipLabel = [[UILabel alloc] init];
    self.latitudeTipLabel.textColor = [UIColor blackColor];
    self.latitudeTipLabel.font = [UIFont systemFontOfSize:14];
    self.latitudeTipLabel.text = @"纬度:";
    [self.operatorView addSubview:self.latitudeTipLabel];
    self.latitudeTipLabel.frame = CGRectMake(self.longitudeField.bm_right+10.0f, self.longitudeTipLabel.bm_top, 40.0f, 30.0f);

    self.latitudeField = [[UITextField alloc] initWithFrame:CGRectMake(self.latitudeTipLabel.bm_right, self.latitudeTipLabel.bm_top, 100.0f, 30.0f)];
    self.latitudeField.layer.borderWidth = 1;
    self.latitudeField.layer.borderColor = [UIColor blackColor].CGColor;
    [self.operatorView addSubview:self.latitudeField];

    self.okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.latitudeField.bm_right+6.0f, self.longitudeTipLabel.bm_top, 50.0f, 30.0f)];
    self.okBtn.layer.cornerRadius = 2;
    [self.okBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.okBtn.backgroundColor = [UIColor orangeColor];
    [self.okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.operatorView addSubview:self.okBtn];

    // 获取定位服务授权
    [self requestUserLocationAuthor];

    // 初始化地图
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 100.0f, UI_SCREEN_WIDTH, UI_MAINSCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-100.0f)];
    mapView.mapType = MKMapTypeStandard;
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;

    if (@available(iOS 9.0, *)) {
        // 显示指南针
        self.mapView.showsCompass = YES;
        // 显示感兴趣的点，默认是显示的
        self.mapView.showsPointsOfInterest = YES;
        // 显示标尺(单位：mi 英尺)
        self.mapView.showsScale = YES;
        // 显示交通情况
        self.mapView.showsTraffic = NO;
        // 显示定位大头针，默认是显示的
        self.mapView.showsUserLocation = NO;
        // 显示建筑物的3D模型，设置3D/沙盘/航拍模式(高德地图不支持)
        self.mapView.showsBuildings = NO;
    }
    
    //MKCoordinateSpan span=MKCoordinateSpanMake(0.021251, 0.016093);
    //[self.mapView setRegion:MKCoordinateRegionMake(self.mapView.userLocation.coordinate, span) animated:YES];
    

    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    iconView.image = [UIImage imageNamed:@"testgpsmoker_icon"];
    [self.view addSubview:iconView];
    self.centerImageView = iconView;
    self.centerImageView.center = self.mapView.center;
 
    self.gpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 30.0f)];
    self.gpsLabel.textColor = [UIColor blueColor];
    self.gpsLabel.font = [UIFont systemFontOfSize:16.0f];
    self.gpsLabel.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.7f];
    self.gpsLabel.textAlignment = NSTextAlignmentCenter;
    [self.gpsLabel bm_roundedRect:15.0f];
    [self.view addSubview:self.gpsLabel];
    self.gpsLabel.hidden = YES;
    self.gpsLabel.bm_top = self.centerImageView.bm_top - 34.0f;
    
    [self addMapScale];
    
    self.switchView.on = [[BMTestGPSMocker sharedInstance] isMocking];
    mockGPSSwitch = self.switchView.on;
    if (mockGPSSwitch)
    {
        [self switchAction:self.switchView];
    }
}

- (void)addMapScale
{
    // 放大
    UIButton *zoomin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 60, self.mapView.bm_height, 50, 25)];
    zoomin.backgroundColor = [UIColor greenColor];
    [zoomin setTitle:@"+" forState:UIControlStateNormal];
    [zoomin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:zoomin];
    [zoomin addTarget:self action:@selector(clickZoom:) forControlEvents:UIControlEventTouchUpInside];
    self.zoomin = zoomin;
    
    // 缩小
    UIButton *zoomout = [[UIButton alloc] initWithFrame:CGRectMake(zoomin.bm_left, zoomin.bm_bottom + 5, 50, 25)];
    zoomout.backgroundColor = [UIColor greenColor];
    [zoomout setTitle:@"-" forState:UIControlStateNormal];
    [zoomout setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:zoomout];
    [zoomout addTarget:self action:@selector(clickZoom:) forControlEvents:UIControlEventTouchUpInside];
    self.zoomout = zoomout;
}

- (void)clickZoom:(UIButton *)sender
{
    CLLocationCoordinate2D coordinate = self.mapView.region.center;
    MKCoordinateSpan spn;
    if (sender == self.zoomin)
    {
        self.zoomout.hidden = NO;
        spn = MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta * 0.5, self.mapView.region.span.longitudeDelta * 0.5);
        
    }
    else
    {
        spn = MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta * 2, self.mapView.region.span.longitudeDelta * 2);
        if (spn.latitudeDelta >= 114 && spn.longitudeDelta >= 102)
        {
            self.zoomout.hidden = YES;
            return;
        }
    }
    
    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, spn) animated:YES];
}

- (void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    
    mockGPSSwitch = [switchButton isOn];
    if (mockGPSSwitch)
    {
        self.gpsLabel.hidden = NO;
        CLLocationCoordinate2D coordinate = [[BMTestGPSMocker sharedInstance] mockCoordinate];
        if (coordinate.longitude>0 && coordinate.latitude>0)
        {
            self.mapView.showsUserLocation = NO;
            [self redrawGpsLabelWithGPS:[NSString stringWithFormat:@"%f, %f", coordinate.longitude, coordinate.latitude]];
            [self.mapView setCenterCoordinate:coordinate animated:YES];
            CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            [[BMTestGPSMocker sharedInstance] mockPoint:loc];
        }
    }
    else
    {
        self.gpsLabel.hidden = YES;
        [[BMTestGPSMocker sharedInstance] stopMockPoint];
        //[[NSNotificationCenter defaultCenter] postNotificationName:DoraemonMockCoordinateNotification object:nil userInfo:@{@"mockSwitch":@NO}];
    }
}

- (void)okBtnClick
{
    if (!mockGPSSwitch)
    {
        NSLog(@"mock开关没有打开");
        return;
    }
    
    NSString *longitudeValue = self.longitudeField.text;
    NSString *latitudeValue = self.latitudeField.text;
    if (longitudeValue.length==0 || latitudeValue.length==0)
    {
        NSLog(@"经纬度不能为空");
        return;
    }
    
    CGFloat longitude = [longitudeValue floatValue];
    CGFloat latitude = [latitudeValue floatValue];
    if (longitude < -180 || longitude > 180)
    {
        NSLog(@"经度不合法");
        return;
    }
    if (latitude < -90 || latitude > 90)
    {
        NSLog(@"纬度不合法");
        return;
    }
    
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = longitude;
    coordinate.latitude = latitude;
    
    [self redrawGpsLabelWithGPS:[NSString stringWithFormat:@"%f, %f", coordinate.longitude, coordinate.latitude]];
    
    [self.mapView setCenterCoordinate:coordinate animated:NO];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [[BMTestGPSMocker sharedInstance] mockPoint:loc];
    
}

- (void)requestUserLocationAuthor
{
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled])
    {
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)redrawGpsLabelWithGPS:(NSString *)gps
{
    self.gpsLabel.text = gps;
    [self.gpsLabel sizeToFit];
    self.gpsLabel.bm_height = 30.0f;
    self.gpsLabel.bm_width += 20.0f;
    
    self.gpsLabel.bm_centerX = self.centerImageView.bm_centerX;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    
    if (![self.switchView isOn])
    {
        return;
    }
    
    [[BMTestGPSMocker sharedInstance] saveMockCoordinate:centerCoordinate];
    
    [self redrawGpsLabelWithGPS:[NSString stringWithFormat:@"%f, %f", centerCoordinate.longitude, centerCoordinate.latitude]];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:DoraemonMockCoordinateNotification object:nil userInfo:@{@"mockSwitch":@YES}];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    [[BMTestGPSMocker sharedInstance] mockPoint:loc];
}

@end
