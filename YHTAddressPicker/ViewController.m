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

@property (weak, nonatomic) IBOutlet UITextField *pickerTextField;
@property (weak, nonatomic) IBOutlet UITextField *tableTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = UIRectEdgeNone;

}


- (IBAction)clickPicker:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;
    YHTAddressPickerViewController *addressVC = [[YHTAddressPickerViewController alloc] init];
    [addressVC showType:YHTShowType_Picker parentController:self completion:^(NSDictionary *dic) {
        NSLog(@"address picker %@", dic);

        YHTAddressModel *provinceModel = dic[@"province"];
        YHTAddressModel *cityModel = dic[@"city"];
        YHTAddressModel *regionModel = dic[@"region"];
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@", provinceModel.name, cityModel.name, regionModel.name];
        weakSelf.pickerTextField.text = str;
    }];

}

- (IBAction)clickTable:(UIButton *)sender {

    __weak typeof(self) weakSelf = self;
    YHTAddressPickerViewController *addressVC = [[YHTAddressPickerViewController alloc] init];
    [addressVC showType:YHTShowType_Table parentController:self completion:^(NSDictionary *dic) {
        YHTAddressModel *provinceModel = dic[@"province"];
        YHTAddressModel *cityModel = dic[@"city"];
        YHTAddressModel *regionModel = dic[@"region"];
        NSString *str = [NSString stringWithFormat:@"%@-%@-%@", provinceModel.name, cityModel.name, regionModel.name];
        weakSelf.tableTextField.text = str;
    }];
}



@end
