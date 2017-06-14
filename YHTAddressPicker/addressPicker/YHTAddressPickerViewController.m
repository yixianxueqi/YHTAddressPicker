//
//  YHTAddressPickerViewController.m
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTAddressPickerViewController.h"
#import "YHTAddressDefaultDataSource.h"
#import "YHTAddressTableContentViewController.h"

#ifndef kScreenSize
#define kScreenSize [UIScreen mainScreen].bounds.size
#endif

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/256.0 green:(g)/256.0 blue:(b)/256.0 alpha:(a)]

@interface YHTAddressPickerViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) void (^completionBlock)(NSDictionary *);
@property (nonatomic, assign) YHTShowType showType;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) YHTAddressDefaultDataSource *defaultDataSource;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) NSMutableArray *tableModelSelList;

@property (nonatomic, copy) YHTAddressListBlock provinceListBlock;
@property (nonatomic, copy) YHTAddressListBlock cityListBlock;
@property (nonatomic, copy) YHTAddressListBlock regionListBlock;
@property (nonatomic, strong) NSArray<YHTAddressModel *> *provinceList;
@property (nonatomic, strong) NSArray<YHTAddressModel *> *cityList;
@property (nonatomic, strong) NSArray<YHTAddressModel *> *regionList;
@property (nonatomic, strong) NSNumber *provinceSerialize;
@property (nonatomic, strong) NSNumber *citySerialize;
@property (nonatomic, strong) NSNumber *regionSerialize;

@end

@implementation YHTAddressPickerViewController

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateSource = self.defaultDataSource;
        self.provinceSerialize = @(0);
        self.citySerialize = @(0);
        self.regionSerialize = @(0);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    //点击事件在时间选择器外，则退出选择
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if (!CGRectContainsPoint(self.contentView.frame, touchPoint)) {
        [self clickCancel:nil];
    }
    [self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)dealloc {

    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark - public

- (void)showType:(YHTShowType)showType parentController:(UIViewController *)controller completion:(void (^)(NSDictionary *))completionBlock {

    [controller addChildViewController:self];
    [self didMoveToParentViewController:controller];
    [controller.view addSubview:self.view];
    self.view.frame = controller.view.bounds;

    self.showType = showType;
    self.completionBlock = completionBlock;
    if (showType == YHTShowType_Picker) {
        //以pickerView形式布局展示
        [self showPickerView];
    } else {
        //以tableview形式布局展示
        [self showTableView];
    }
}

#pragma mark - private

- (void)showTableView  {

    YHTAddressTableContentViewController *tableVC = [[YHTAddressTableContentViewController alloc] init];
    self.nav = [[UINavigationController alloc] initWithRootViewController:tableVC];
    [self presentViewController:self.nav animated:true completion:false];
    [self reloadProvinceAndCityAndRegion];
    self.tableModelSelList = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    YHTAddressTableBlock block = ^(YHTAddressIncident index, YHTAddressModel *model){
        if (index == YHTAddressIncident_DidSelect) {
            //选择一个
            [weakSelf.tableModelSelList addObject:model];
            NSInteger count = weakSelf.nav.viewControllers.count;
            if (count == 1) {
                [weakSelf reloadCityAndRegion];
            } else {
                [weakSelf reloadRegion];
            }
        } else if (index == YHTAddressIncident_Back) {
            //返回
            [weakSelf.tableModelSelList removeObject:model];
        } else if(index == YHTAddressIncident_Finsh) {
            //完成
            [weakSelf.tableModelSelList addObject:model];
            [weakSelf.nav dismissViewControllerAnimated:true completion:nil];
            [weakSelf clickChoose:nil];
        } else {
            //取消
            [weakSelf.nav dismissViewControllerAnimated:true completion:nil];
            [weakSelf clickCancel:nil];
        }
    };
    tableVC.incidentBlock = block;
    [self reloadProvinceAndCityAndRegion];
}

- (void)showPickerView {

    [self.contentView addSubview:self.pickerView];
    [self.view addSubview:self.contentView];
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    //视图容器
    CGFloat width = kScreenSize.width;
    CGFloat height = kScreenSize.height * 0.5;
    CGPoint center = CGPointMake(width * 0.5, kScreenSize.height + height * 0.5);
    self.contentView.bounds = CGRectMake(0, 0, width, height);
    self.contentView.center = center;
    //分割线
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, 0, width, 1);
    layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.contentView.layer addSublayer:layer];
    //按钮
    UIButton *cancelBtn = [self quickGetButtonWith:@"取消" color:[UIColor clearColor] selector:@selector(clickCancel:)];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIButton *chooseBtn = [self quickGetButtonWith:@"确认" color:[UIColor clearColor] selector:@selector(clickChoose:)];
    [chooseBtn setTitleColor:RGBA(28, 162, 248, 1) forState:UIControlStateNormal];
    CGFloat btnHeight = 35;
    [self.contentView addSubview:cancelBtn];
    [self.contentView addSubview:chooseBtn];
    cancelBtn.frame = CGRectMake(20, 8, 100, btnHeight);
    chooseBtn.frame = CGRectMake(width - 20 - 100, 8, 100, btnHeight);
    //pickView
    self.pickerView.frame = CGRectMake(0, btnHeight, width, height - btnHeight);
    //出现的动画效果
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
        CGFloat centerX = width * 0.5;
        CGFloat centerY = self.view.bounds.size.height - height * 0.5;
        self.contentView.center = CGPointMake(centerX, centerY);
    }];
    //刷新列表
    [self reloadProvinceAndCityAndRegion];
}
// 刷新省份列表、城市列表和区域列表
- (void)reloadProvinceAndCityAndRegion {

    [self generateProvinceSerialize];
    __weak typeof(self) weakSelf = self;
    NSInteger proviceFlag = [self.provinceSerialize integerValue];
    self.provinceListBlock = ^(NSArray<YHTAddressModel *> *list){
        //防止异步问题，对每一次的刷新都生成序列号标示，在回调内，比较发请求时的序列号和当前序列号是否
        //是同一值，若是则刷新，否则不做任何操作
        if (proviceFlag == [weakSelf.provinceSerialize integerValue]) {
            weakSelf.provinceList = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.showType == YHTShowType_Picker) {
                    //picker
                    [weakSelf.pickerView reloadComponent:0];
                    [weakSelf.pickerView selectRow:0 inComponent:0 animated:true];
                    [weakSelf reloadCityAndRegion];
                } else {
                    //table
                    YHTAddressTableContentViewController *tablVC = [weakSelf.nav.viewControllers firstObject];
                    tablVC.list = weakSelf.provinceList;
                }
            });
        }
    };
    [self.dateSource getProvinceByCountry:nil list:self.provinceListBlock];
}

// 刷新城市列表和区域列表
- (void)reloadCityAndRegion {

    [self generateCitySerialize];
    __weak typeof(self) weakSelf = self;
    NSInteger cityFlag = [self.citySerialize integerValue];
    self.cityListBlock = ^(NSArray<YHTAddressModel *> *list){
        //防止异步问题，对每一次的刷新都生成序列号标示，在回调内，比较发请求时的序列号和当前序列号是否
        //是同一值，若是则刷新，否则不做任何操作
        if (cityFlag == [weakSelf.citySerialize integerValue]) {
            weakSelf.cityList = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.showType == YHTShowType_Picker) {
                    //picker
                    [weakSelf.pickerView reloadComponent:1];
                    [weakSelf.pickerView selectRow:0 inComponent:1 animated:true];
                    [weakSelf reloadRegion];
                } else {
                    //table
                    YHTAddressTableContentViewController *tablVC = [weakSelf.nav.viewControllers firstObject];
                    YHTAddressTableContentViewController *subTableVC = [[YHTAddressTableContentViewController alloc] init];
                    subTableVC.list = weakSelf.cityList;
                    subTableVC.incidentBlock = tablVC.incidentBlock;
                    [weakSelf.nav pushViewController:subTableVC animated:true];
                }
            });
        }
    };
    YHTAddressModel *model;
    if (self.showType == YHTShowType_Picker) {
        NSInteger index = [self.pickerView selectedRowInComponent:0];
        model = self.provinceList[index];
    } else {
        model = [self.tableModelSelList firstObject];
    }
    [self.dateSource getCityByProvince:model list:self.cityListBlock];
}

// 刷新区域列表
- (void)reloadRegion {

    [self generateRegionSerialize];
    __weak typeof(self) weakSelf = self;
    NSInteger regionFlag = [self.regionSerialize integerValue];
    self.regionListBlock = ^(NSArray<YHTAddressModel *> *list){
        //防止异步问题，对每一次的刷新都生成序列号标示，在回调内，比较发请求时的序列号和当前序列号是否
        //是同一值，若是则刷新，否则不做任何操作
        if (regionFlag == [weakSelf.regionSerialize integerValue]) {
            weakSelf.regionList = list;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.showType == YHTShowType_Picker) {
                    //picker
                    [weakSelf.pickerView reloadComponent:2];
                    [weakSelf.pickerView selectRow:0 inComponent:2 animated:true];
                } else {
                    //table
                    YHTAddressTableContentViewController *tablVC = [weakSelf.nav.viewControllers firstObject];
                    YHTAddressTableContentViewController *subTableVC = [[YHTAddressTableContentViewController alloc] init];
                    subTableVC.list = weakSelf.regionList;
                    subTableVC.incidentBlock = tablVC.incidentBlock;
                    [weakSelf.nav pushViewController:subTableVC animated:true];
                }
            });
        }
    };
    YHTAddressModel *model;
    if (self.showType == YHTShowType_Picker) {
        NSInteger index = [self.pickerView selectedRowInComponent:1];
        model = self.cityList[index];
    } else {
        model = [self.tableModelSelList lastObject];
    }
    [self.dateSource getRegionByCity:model list:self.regionListBlock];
}

// 省份序列化
- (void)generateProvinceSerialize {

    self.provinceSerialize = @([self.provinceSerialize integerValue] + 1);
    [self generateCitySerialize];
}

// 城市序列化
- (void)generateCitySerialize {

    self.citySerialize = @([self.citySerialize integerValue] + 1);
    [self generateRegionSerialize];
}

// 区域序列化
- (void)generateRegionSerialize {

    self.regionSerialize = @([self.regionSerialize integerValue] + 1);
}

#pragma mark - button incident

- (void)clickCancel:(UIButton *)btn {

    if (self.showType == YHTShowType_Picker) {
        //从底部弹出则有动画效果
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat centerX = kScreenSize.width * 0.5;
            CGFloat centerY = kScreenSize.height + self.contentView.bounds.size.height * 0.5;
            self.contentView.center = CGPointMake(centerX, centerY);
            self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        } completion:^(BOOL finished) {
            [self willMoveToParentViewController:nil];
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
        }];
    } else {
        [self willMoveToParentViewController:nil];
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
}

- (void)clickChoose:(UIButton *)btn {

    if (self.completionBlock) {
        if (self.showType == YHTShowType_Picker) {
            YHTAddressModel *provinceModel = self.provinceList[[self.pickerView selectedRowInComponent:0]];
            YHTAddressModel *cityModel = self.cityList[[self.pickerView selectedRowInComponent:1]];
            YHTAddressModel *regionModel = self.regionList[[self.pickerView selectedRowInComponent:2]];
            self.completionBlock(@{@"province": provinceModel, @"city": cityModel, @"region": regionModel});
            [self clickCancel:nil];
        } else {
            self.completionBlock(@{@"province": self.tableModelSelList[0], @"city": self.tableModelSelList[1], @"region": self.tableModelSelList[2]});
            [self clickCancel:nil];
        }
    }
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {
        return self.provinceList.count;
    } else if (component == 1) {
        return self.cityList.count;
    } else {
        return self.regionList.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    NSString *name;
    if (component == 0) {
        name = self.provinceList[row].name;
    } else if (component == 1) {
        name = self.cityList[row].name;
    } else {
        name = self.regionList[row].name;
    }
    UILabel *label;
    if (view) {
        label = (UILabel *)view;
        label.text = name;
    } else {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:21.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = name;
        [label sizeToFit];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        [self reloadCityAndRegion];
    } else if (component == 1) {
        [self reloadRegion];
    }
}

#pragma mark - #pragma mark - tool
/**
 快速生成按钮

 @param title 标题
 @param color 背景色
 @param selector 响应方法
 @return UIButton
 */
- (UIButton *)quickGetButtonWith:(NSString *)title color:(UIColor *)color selector:(SEL)selector {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark - getter/setter

- (UIPickerView *)pickerView {

    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView sizeToFit];
    }
    return _pickerView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (YHTAddressDefaultDataSource *)defaultDataSource {

    if (!_defaultDataSource) {
        _defaultDataSource = [[YHTAddressDefaultDataSource alloc] init];
    }
    return _defaultDataSource;
}

@end




