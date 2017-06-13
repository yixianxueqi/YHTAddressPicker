//
//  YHTAddressModel.m
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTAddressModel.h"


static NSString *const Code_key = @"code";
static NSString *const Name_key = @"name";

@implementation YHTAddressModel

#pragma mark - override

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    [super setValue:value forUndefinedKey:key];
    NSLog(@"YHTAddressModel setValueforUndefinedKey !!");
}

- (NSString *)description {

    return [NSString stringWithFormat:@"%@, %@", self.code, self.name];
}

#pragma mark - public
+ (YHTAddressModel *)modelWithDic:(NSDictionary *)dic {

    YHTAddressModel *model = [[YHTAddressModel alloc] init];
    [model setValue:dic[Code_key] forKey:Code_key];
    [model setValue:dic[Name_key] forKey:Name_key];
    return model;
}

+ (YHTAddressModel *)modelWithJson:(NSString *)json {

    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"Json to model Failure! %@", error);
        return nil;
    } else {
        return [self modelWithDic:dic];
    }
}

@end
