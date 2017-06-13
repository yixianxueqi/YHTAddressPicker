//
//  YHTAddressModel.h
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHTAddressModel : NSObject

// 编号
@property (nonatomic, copy) NSString *code;
// 名字
@property (nonatomic, copy) NSString *name;

// 快捷生成模型方法
+ (YHTAddressModel *)modelWithJson:(NSString *)json;
+ (YHTAddressModel *)modelWithDic:(NSDictionary *)dic;

@end
