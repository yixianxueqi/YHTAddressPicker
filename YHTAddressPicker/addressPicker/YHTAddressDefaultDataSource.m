//
//  YHTAddressDefaultDataSource.m
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTAddressDefaultDataSource.h"

@interface YHTAddressDefaultDataSource ()

@property (nonatomic, strong) NSArray *list;

@end

@implementation YHTAddressDefaultDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"cityArea" ofType:@"plist"];
        self.list = [NSArray arrayWithContentsOfFile:path];
    }
    return self;
}

#pragma mark - YHTAddressDataSource
- (void)getProvinceByCountry:(YHTAddressModel *)mdoel list:(YHTAddressListBlock)listBlock {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in self.list) {
            YHTAddressModel *model = [YHTAddressModel modelWithDic:dic];
            [list addObject:model];
        }
        listBlock(list);
    });
}

- (void)getCityByProvince:(YHTAddressModel *)model list:(YHTAddressListBlock)listBlock {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"code == %@", model.code]];
        NSArray *arr = [self.list filteredArrayUsingPredicate:predicate];
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in [arr firstObject][@"list"]) {
            YHTAddressModel *model = [YHTAddressModel modelWithDic:dic];
            [list addObject:model];
        }
        listBlock(list);
    });
}

- (void)getRegionByCity:(YHTAddressModel *)model list:(YHTAddressListBlock)listBlock {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {

            NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"code == %@", model.code];
            NSArray *arr = evaluatedObject[@"list"];
            NSArray *list = [arr filteredArrayUsingPredicate:subPredicate];
            return list.count > 0? true: false;
        }];
        NSArray *arr = [self.list filteredArrayUsingPredicate:predicate];
        NSArray *cityList = [arr firstObject][@"list"];
        NSPredicate *subPredicate = [NSPredicate predicateWithFormat:@"code == %@", model.code];
        NSArray *regionList = [cityList filteredArrayUsingPredicate:subPredicate];
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dic in [regionList firstObject][@"cityItme"]) {
            YHTAddressModel *model = [YHTAddressModel modelWithDic:dic];
            [list addObject:model];
        }
        listBlock(list);
    });
}

@end









