//
//  PNPersonalViewController.m
//  cfw
//
//  Created by 马军 on 16/9/23.
//  Copyright © 2016年 马军. All rights reserved.
//


#import "XLOtherViewController.h"
#import "XLWaveView.h"
#import "UIView+Extension.h"
#import "PNPersonalViewController.h"
#define XLScreenW [UIScreen mainScreen].bounds.size.width
#define XLColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
@interface PNPersonalViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;

/** 数据数组 */
@property (nonatomic, strong) NSArray *dataList;

/** 记录清空缓存的index */
@property (nonatomic, strong) NSIndexPath *path;

/** 头View */
@property (nonatomic, weak) XLWaveView *waveView;

/** 是否正在播放动画 */
@property (nonatomic, assign, getter=isShowWave) BOOL showWave;

@end

@implementation PNPersonalViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupHeaderView];
}


- (NSArray *)dataList{
    if (!_dataList) {
        NSMutableDictionary *miaoBi = [NSMutableDictionary dictionary];
        miaoBi[@"title"] = @"我的喵币";
        miaoBi[@"icon"] = @"ic_account_balance_wallet_black_24dp1";
        
        //自己写要跳转到的控制器
        miaoBi[@"controller"] = [XLOtherViewController class];
        
        NSMutableDictionary *zhiBoJian = [NSMutableDictionary dictionary];
        zhiBoJian[@"title"] = @"直播间管理";
        zhiBoJian[@"icon"] = @"MoreExpressionShops";
        //自己写要跳转到的控制器
        zhiBoJian[@"controller"] = [XLOtherViewController class];
        
        NSMutableDictionary *shouYi = [NSMutableDictionary dictionary];
        shouYi[@"title"] = @"我的收益";
        shouYi[@"icon"] = @"MoreMyBankCard";
        shouYi[@"controller"] = [XLOtherViewController class];
        
        NSMutableDictionary *liCai = [NSMutableDictionary dictionary];
        liCai[@"title"] = @"微钱进理财";
        liCai[@"icon"] = @"buyread";
        liCai[@"controller"] = [XLOtherViewController class];
        
        NSMutableDictionary *cleanCache = [NSMutableDictionary dictionary];
        cleanCache[@"title"] = @"清空缓存";
        cleanCache[@"icon"] = @"img_cache";
        
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        setting[@"title"] = @"设置";
        setting[@"icon"] = @"MoreSetting";
        setting[@"controller"] = [XLOtherViewController class];
        
        NSArray *section1 = @[miaoBi, zhiBoJian];
        NSArray *section2 = @[shouYi, liCai];
        NSArray *section3 = @[cleanCache];
        NSArray *section4 = @[setting];
        
        _dataList = [NSArray arrayWithObjects:section1, section2, section3,section4, nil];
    }
    return _dataList;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
        _tableView.y = -20;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


//刷新tableview
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar *nav = self.navigationController.navigationBar;
    nav.hidden = YES;
    
}


#pragma mark - life cycle...


- (void)setupHeaderView
{
    
    XLWaveView *wave = [[XLWaveView alloc] initWithFrame:CGRectMake(0, 0, XLScreenW, 270) Image:@"Cyuri03.jpg" centerIcon:@"icon.jpg"];
    self.waveView = wave;
    [self scrollViewDidScroll:self.tableView];
    
    
    [self.tableView addSubview:wave];
    //self.tableView.tableHeaderView = wave;
    
    // 与图像高度一样防止数据被遮挡
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XLScreenW , wave.height)];
    
}



#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dict = self.dataList[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"title"];
    cell.imageView.image = [UIImage imageNamed:dict[@"icon"]];
    
    if (!indexPath.section && !indexPath.row) {
        cell.detailTextLabel.text = @"270枚";
        cell.detailTextLabel.textColor = XLColor(0.935, 210, 0);
    }
    
    cell.selected = YES;
    
    if ([cell.textLabel.text isEqualToString:@"清空缓存"]){
        
        cell.accessoryView = [[UIView alloc] init];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.dataList[indexPath.section][indexPath.row][@"controller"]){
        UIViewController *vc = [[self.dataList[indexPath.section][indexPath.row][@"controller"] alloc] init];
        
        vc.title = self.dataList[indexPath.section][indexPath.row][@"title"];
        
        vc.view.backgroundColor = XLColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255));
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return !section ? 1 : CGFLOAT_MIN;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.isShowWave) {
        [self.waveView starWave];
    }
}

- (void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (fabs(offsetY) > 20) {
        self.showWave = YES;
    }
    else {
        self.showWave = NO;
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.waveView stopWave];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        
        self.waveView.frame = CGRectMake(offsetY/2 + 10, offsetY, XLScreenW - offsetY, 270 - offsetY);  // 修改头部的frame值就行了
    }
    
    NSLog(@"%f,%f",self.waveView.height,self.tableView.tableHeaderView.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
