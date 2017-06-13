//
//  ViewController.m
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/12.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "ViewController.h"
#import "YHTAddressPickerViewController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;

}


- (IBAction)clickPicker:(UIButton *)sender {

    YHTAddressPickerViewController *addressVC = [[YHTAddressPickerViewController alloc] init];
    [addressVC showType:YHTShowType_Picker parentController:self completion:^(NSDictionary *dic) {
        NSLog(@"address picker %@", dic);
    }];

}

- (IBAction)clickTable:(UIButton *)sender {

    YHTAddressPickerViewController *addressVC = [[YHTAddressPickerViewController alloc] init];
    [addressVC showType:YHTShowType_Table parentController:self completion:^(NSDictionary *dic) {
        NSLog(@"address table %@", dic);
    }];
}



@end
