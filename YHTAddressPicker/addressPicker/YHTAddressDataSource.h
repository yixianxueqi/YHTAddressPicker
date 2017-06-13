//
//  YHTAddressDataSource.h
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHTAddressModel.h"

typedef void(^YHTAddressListBlock)(NSArray<YHTAddressModel *> *);

@protocol YHTAddressDataSource <NSObject>


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

@end
