//
//  SureCustomViewController.m
//  AppPlaceholder
//
//  Created by 刘硕 on 2016/12/1.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureCustomViewController.h"
#import "UITableView+Sure_Placeholder.h"
#import "CustomPlaceholderView.h"
@interface SureCustomViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SureCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self craeteUI];
    // Do any additional setup after loading the view.
}

- (void)initData {
    _dataArr = [[NSMutableArray alloc]init];
}

- (void)craeteUI {
    self.title = @"自定制占位图";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TAB"];
    CustomPlaceholderView *customView = [[CustomPlaceholderView alloc]initWithFrame:_tableView.bounds];
    __weak typeof(self) weakSelf = self;
    [customView setReloadClickBlock:^{
        //模拟刷新
        for (NSInteger i = 0; i < 10; i++) {
            [weakSelf.dataArr addObject:[NSString stringWithFormat:@"卖报的小画家随机测试数据%ld",i]];
        }
        [weakSelf.tableView reloadData];
    }];
    _tableView.placeholderView = customView;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAB"];
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
