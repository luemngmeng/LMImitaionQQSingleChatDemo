//
//  LMImitaionQQSingleChatViewController.m
//  LMImitaionQQSingleChatDemo
//
//  Created by mengmenglu on 3/8/16.
//  Copyright © 2016 Hangzhou TaiXuan Network Technology Co., Ltd. All rights reserved.
//

#import "LMImitaionQQSingleChatViewController.h"

#import "LMMessageTextView.h"
#import "UITextView+PlaceHolder.h"
#import "LMMessageToolBar.h"
#import "LMMoreView/LMMoreView.h"

#import "LMLocationViewController.h"

@interface LMImitaionQQSingleChatViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LMMessageToolBarDelegate,LMMoreViewDelegate,LMLocationViewControllerDelegate>


/**
 *  处理相册和照相机文字的视图控制器
 */
@property (nonatomic,strong) UIImagePickerController *imagePicker;

/**
 *  自定义的toolBar视图
 */
@property (nonatomic,strong) LMMessageToolBar *toolBar;


/**
 *  聊天内容显示的视图
 */
@property (nonatomic,strong) UITableView *tableView;


/**
 *  内容数据数组
 */
@property (nonatomic,strong)  NSMutableArray *contentArray;


@end

@implementation LMImitaionQQSingleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模仿QQ单聊的Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化数组
    [self initContentData];
    
    
    // 初始化TableView视图
    [self initTableView];
    
    
    // 测试聊天界面的ToolBar视图
    _toolBar = [[LMMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height- 50, self.view.frame.size.width, 50)];
    _toolBar.delegate = self;
    //将self注册为chatToolBar的moreView的代理（为了后期拍照，从相册选择的跳转）
    if ([_toolBar.moreView isKindOfClass:[LMMoreView class]]) {
        [(LMMoreView *)self.toolBar.moreView setDelegate:self];
    }
    [self.view addSubview:_toolBar];
    
    
    // 添加手势为了回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method
#pragma mark 初始化数据
-(void)initContentData {
    self.contentArray = [[NSMutableArray alloc] initWithObjects:@"测试QQ聊天显示界面", nil];
}


#pragma mark 初始化TableView视图
- (void)initTableView {
    
    // 添加TableView子视图
    [self.view addSubview:self.tableView];
}

#pragma mark TableView视图
- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.height - 50, self.view.frame.size.width) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    
    return _tableView;
}

#pragma mark 处理相册和相机问题
- (UIImagePickerController *)imagePicker {
    
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}


#pragma mark 测试QQ聊天的Toolbar功能
- (void)keyBoardHidden {
    [_toolBar endEditing:YES];
}

#pragma mark - 各类Delegate
#pragma mark - UITableView Delegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.row < self.contentArray.count){
        cell.textLabel.text = self.contentArray[indexPath.row];
    }

    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"被点击了 %d ", (int)indexPath.row);
}

#pragma mark - LMMessageToolBarDelegate 
#pragma mark 发送消息
- (void)didSendText:(NSString *)text {
    
    if (text && text.length > 0) {
        
        [self.contentArray addObject:text];
        
        [_tableView reloadData];
    }
    
}

#pragma mark - LMMoreView Delegate 
#pragma 发送照片
- (void)moreViewPhotoAction:(LMMoreView *)moreView {
    
    // 停止编辑，隐藏键盘
    //[self keyBoardHidden];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

#pragma mark 发送定位
- (void)moreViewLocationAction:(LMMoreView *)moreView {
    
    // 停止编辑，隐藏键盘
    //[self keyBoardHidden];
    LMLocationViewController *locationController = [[LMLocationViewController alloc] init];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];
    
}

#pragma mark 拍照
- (void)moreViewTakePicAction:(LMMoreView *)moreView {
    
    // 停止编辑，隐藏键盘
    //[self keyBoardHidden];
    
    // 使用照相机之前需要判断是否是模拟器，或者有没有权限使用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"模拟器无法访问相机");
    }
    
    
   
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    NSLog(@"orgImage = %@",[orgImage description]);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
     [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

@end
