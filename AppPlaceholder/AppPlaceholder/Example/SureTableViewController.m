//
//  SureTableViewController.m
//  AppPlaceholder
//
//  Created by 刘硕 on 2016/12/1.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureTableViewController.h"
#import "UITableView+Sure_Placeholder.h"
@interface SureTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation SureTableViewController

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
    self.title = @"UITableViewPlaceholder";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TAB"];
    //模拟刷新操作
    __weak typeof(self) weakSelf = self;
    [_tableView setReloadBlock:^{
        [weakSelf refresh];
    }];
    [self.view addSubview:_tableView];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)refresh {
    //模拟刷新 偶数调用有数据 奇数无数据
    [_refreshControl beginRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static NSUInteger i = 0;
        if (i %2 == 0) {
            for (NSInteger i = 0; i < arc4random()%10; i++) {
                [_dataArr addObject:[NSString stringWithFormat:@"卖报的小画家随机测试数据%ld",i]];
            }
        } else {
            [_dataArr removeAllObjects];
        }
        i++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [_tableView reloadData];
           [_refreshControl endRefreshing];
       });
    });
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
