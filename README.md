[![Build Status](https://travis-ci.org/yixianxueqi/YHTDatePicker.svg?branch=master)](https://travis-ci.org/yixianxueqi/YHTDatePicker)

# YHTAddressPicker

## 这是一个简单的地址选择器，支持pickerView和tableView两种方式选择。

### 效果
<img src="./gif/1.gif" width="320" height="568" style="display: inline-block;float: left;"> <img src="./gif/2.gif" width="320" height="568" style="display: inline-block;float: right;">

### 使用

```
    YHTAddressPickerViewController *addressVC = [[YHTAddressPickerViewController alloc] init];
    [addressVC showType:YHTShowType_Picker parentController:self completion:^(NSDictionary *dic) {
        NSLog(@"address picker %@", dic);
    }];
```

控制展现方式：

```
typedef NS_ENUM(NSUInteger, YHTShowType) {

    YHTShowType_Picker = 0,
    YHTShowType_Table
};
```

数据源：

本控件自带有一份省市区的plist文件，所以默认的数据源为该plist文件，若用户需要更改数据源，
只需更改其代理对象dateSource即可。

代理对象需要满足YHTAddressDataSource协议

```
@required
/**
 获取省份列表根据国家

 @param mdoel 国家（可为nil, 默认中国）
 @param listBlock 获取列表回调
 */
- (void)getProvinceByCountry:(YHTAddressModel *)mdoel list:(YHTAddressListBlock)listBlock;

/**
 获取城市列表根据省份

 @param model 省份
 @param listBlock 获取列表回调
 */
- (void)getCityByProvince:(YHTAddressModel *)model list:(YHTAddressListBlock)listBlock;

/**
 获取区域列表根据城市

 @param model 城市
 @param listBlock 获取列表回调
 */
- (void)getRegionByCity:(YHTAddressModel *)model list:(YHTAddressListBlock)listBlock;
```

用户实现该协议，并在协议方法内通过block将数据回传给控件。
此处不需要担心异步导致的数据错乱问题，控件内部对异步已经做了序列化处理，保证展示的总是最新的数据。

关于模型问题，已经定义了YHTAddressModel这样一个模型，包含了编码和名字属性，若用户属性与此有差异，可能需要你做一个适配器以便将你的模型转化为控件所需要的模型。（注：差异过大，可以以源码形式导入，然后适当修改模型。）

注意：

关于UI：
该控件底部弹出picker选择器时，不论是否存在tabbar都可以正常展示，若视图底部存在显示不完整或留白，请检查父控制器的以下属性：

```
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;
```

关于数据正确性：
在使用picker进行数据选择时，有一种情况需要注意，可能会导致选择的数据错误结果。
例： 当用户在滑动省份时（惯性滑动，还没有明确选择时），点击确定按钮获取地址选择结果时，由于控件是在pickerView：didSelectRow：inComponent：代理方法被唤起时，才去刷新其余需要刷新的列，而在此种情况，该代理方法还没有被唤起执行，直到它减速将要停止时才明确是哪一行被选取，才能据此刷新。因此，其余列使用的还是滑动前的默认数据，这时获得的结果是个紊乱的结果。开发人员需要谨慎去处理此特殊情况（一般正常操作不会出现，但需要提防这种充满恶意的操作），可以在结果获取后校验是否合法。


### 安装

1. 将addressPicker文件夹拖入项目使用
2. cocopods安装

