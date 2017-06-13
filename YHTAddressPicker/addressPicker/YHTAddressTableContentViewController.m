//
//  YHTAddressTableContentViewController.m
//  YHTAddressPicker
//
//  Created by 君若见故 on 2017/6/13.
//  Copyright © 2017年 isoftstone. All rights reserved.
//

#import "YHTAddressTableContentViewController.h"

@interface YHTAddressTableContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation YHTAddressTableContentViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;

    //标题
    NSInteger conunt = self.navigationController.viewControllers.count;
    NSString *str;
    if (conunt == 1) {
        str = @"省份";
    } else if (conunt == 2) {
        str = @"城市";
    } else {
        str = @"区域";
    }
    self.navigationItem.title = str;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel)];
}

#pragma mark - barbtn click

//点击取消
- (void)clickCancel {

    if (self.incidentBlock) {
        self.incidentBlock(YHTAddressIncident_Cancel, nil);
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    YHTAddressModel *model = self.list[indexPath.row];
    cell.textLabel.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger count = self.navigationController.viewControllers.count;
    YHTAddressIncident incident;
    if (count == 3) {
        incident = YHTAddressIncident_Finsh;
    } else {
        incident = YHTAddressIncident_DidSelect;
    }
    YHTAddressModel *model = self.list[indexPath.row];
    if (self.incidentBlock) {
        self.incidentBlock(incident, model);
    }
}

#pragma mark - getter/setter
- (UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, -10);
    }
    return _tableView;
}

- (void)setList:(NSArray<YHTAddressModel *> *)list {

    _list = list;
    [self.tableView reloadData];
}

@end
