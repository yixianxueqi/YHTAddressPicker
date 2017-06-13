//
//  YHTAddressPickerViewController.h
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHTAddressDataSource.h"

typedef NS_ENUM(NSUInteger, YHTShowType) {

    YHTShowType_Picker = 0,
    YHTShowType_Table
};


@interface YHTAddressPickerViewController : UIViewController

@property (nonatomic, weak) id<YHTAddressDataSource> dateSource;

/**
 展示地址选择器

 @param showType 展示方式
 @param controller 所在父控制器1
 @param completionBlock 完成回调
 dic: @{@"province":model, @"city":model, @"region": model}
 */
- (void)showType:(YHTShowType)showType parentController:(UIViewController *)controller completion:(void(^)(NSDictionary *dic))completionBlock;

@end
