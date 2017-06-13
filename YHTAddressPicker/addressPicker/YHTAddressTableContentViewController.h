//
//  YHTAddressTableContentViewController.h
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHTAddressModel.h"

typedef NS_ENUM(NSUInteger, YHTAddressIncident) {

    YHTAddressIncident_DidSelect = 1,
    YHTAddressIncident_Cacnel,
    YHTAddressIncident_finsh
};

typedef void(^YHTAddressTableBlock)(YHTAddressIncident index, YHTAddressModel *model);

@interface YHTAddressTableContentViewController : UIViewController

@property (nonatomic, strong) NSArray<YHTAddressModel *> *list;
@property (nonatomic, copy) YHTAddressTableBlock incidentBlock;

@end
