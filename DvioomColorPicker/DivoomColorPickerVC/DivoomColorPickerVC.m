//
//  DvioomColorPickerVC.m
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomColorPickerVC.h"
#import "DivoomColorBarPickerView.h"
#import "DivoomColorSquareView.h"
#import "DivoomColorLumpView.h"
#import "HSBSupport.h"
#import "Masonry.h"

#define DEFAULT_COLOR [UIColor redColor]

@interface DivoomColorPickerVC ()

@property (nonatomic, strong) UIView *preColorView;     //之前的颜色视图
@property (nonatomic, strong) UIView *curColorView;     //当前的颜色视图

@property (nonatomic, strong) DivoomColorBarPickerView  *barPickerView;
@property (nonatomic, strong) DivoomColorSquareView     *squareView;
@property (nonatomic, strong) DivoomColorLumpView       *colorLumpView;

@property (nonatomic, strong) UIButton *btnOK;
@property (nonatomic, strong) UIButton *btnCancel;

@end

@implementation DivoomColorPickerVC{
    CGFloat _scaling;
}

- (instancetype)initWithPreColor:(UIColor *)color{
    if (self = [super init]) {
        _preColor = color;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scaling =  [[UIScreen mainScreen] bounds].size.width / 375.0;
    [self setupView];
    [self eventConfig];
}

- (void)setupView {
    self.view.backgroundColor = [UIColor colorWithRed:35/255.0 green:38/255.0 blue:41/255.0 alpha:1.0];
    [self.view addSubview:self.preColorView];
    [self.view addSubview:self.curColorView];
    [self.view addSubview:self.barPickerView];
    [self.view addSubview:self.squareView];
    [self.view addSubview:self.colorLumpView];
    [self.view addSubview:self.btnOK];
    [self.view addSubview:self.btnCancel];
}

- (void)eventConfig {
    
    [self.btnOK addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self.btnCancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.preColorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(preColorViewAction)]];
    
    __weak typeof(self) weakSelf = self;
    [self.barPickerView setValueChangedBlock:^(CGFloat hvalue) {
        [weakSelf.squareView setHvalue:hvalue];
    }];
    
    [self.squareView setColorChangedBlock:^(UIColor * _Nonnull color) {
        [weakSelf.curColorView setBackgroundColor:color];
    }];
    
    [self.colorLumpView setColorBlock:^(UIColor * _Nonnull color) {
        [weakSelf _fillColor:color];
    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat topS = [[UIApplication sharedApplication] statusBarFrame].size.height + 10;
    [self.preColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.top.mas_equalTo(self.view).offset(topS);
        make.size.mas_equalTo(CGSizeMake((CGRectGetWidth(self.view.frame) - 30) / 2, 60));
    }];
    
    [self.curColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-10);
        make.top.mas_equalTo(self.view).offset(topS);
        make.size.mas_equalTo(self.preColorView);
    }];
    
    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).multipliedBy(.333);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self.view).offset(-15);
        CGFloat s = CGRectGetWidth(self.view.frame) / 3 / 3 / 2;
        make.right.mas_equalTo(self.view.mas_centerX).offset(-s);
    }];
    
    [self.btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).multipliedBy(.333);
        make.height.mas_equalTo(45);
        make.bottom.mas_equalTo(self.view).offset(-15);
        CGFloat s = CGRectGetWidth(self.view.frame) / 3 / 3 / 2;
        make.left.mas_equalTo(self.view.mas_centerX).offset(s);
    }];
    
    [self.barPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.btnOK.mas_top).offset(-10);
    }];
    
    [self.colorLumpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(self.barPickerView.mas_top).offset(-10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
    }];
    
    [self.squareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.preColorView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.bottom.mas_equalTo(self.colorLumpView.mas_top).offset(-10);
    }];
    
    [self _fillColor:self.preColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Actions

// TODO:上一次颜色点击
- (void)preColorViewAction {
    [self _fillColor:self.preColor];
}

// TODO:确定
- (void)okAction {
    if (_colorPickerBLock) {
        _colorPickerBLock(self.curColor);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// TODO:取消
- (void)cancelAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)_fillColor:(UIColor *)color {
    float r,g,b,a,h,s,v;
    const CGFloat *comp = CGColorGetComponents([color CGColor]);
    r = comp[0];
    g = comp[1];
    b = comp[2];
    a = comp[3];
    RGBToHSV(r, g, b, &h, &s, &v, YES);
    [self.barPickerView setHvalue:h];
    [self.squareView setHvalue:h];
    [self.squareView setSvvalue:CGPointMake(s, v)];
}

#pragma mark - Getter / Setter

- (UIButton *)btnOK{
    if (!_btnOK) {
        _btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnOK.backgroundColor = [UIColor orangeColor];
        _btnOK.layer.cornerRadius = 4;
        _btnOK.layer.masksToBounds = YES;
        [_btnOK setTitle:@"OK" forState:UIControlStateNormal];
        [_btnOK.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _btnOK;
}

- (UIButton *)btnCancel{
    if (!_btnCancel) {
        _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCancel.backgroundColor = [UIColor grayColor];
        _btnCancel.layer.cornerRadius = 4;
        _btnCancel.layer.masksToBounds = YES;
        [_btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _btnCancel;
}

- (UIView *)preColorView{
    if (!_preColorView) {
        _preColorView = [UIView new];
        _preColorView.backgroundColor = self.preColor;
        _preColorView.layer.borderColor = [UIColor whiteColor].CGColor;
        _preColorView.layer.borderWidth = 2;
        _preColorView.layer.cornerRadius = 4;
        _preColorView.layer.masksToBounds = YES;
    }
    return _preColorView;
}

- (UIView *)curColorView{
    if (!_curColorView) {
        _curColorView = [UIView new];
        _curColorView.backgroundColor = self.curColor;
        _curColorView.layer.borderColor = [UIColor whiteColor].CGColor;
        _curColorView.layer.borderWidth = 2;
        _curColorView.layer.cornerRadius = 4;
        _curColorView.layer.masksToBounds = YES;
    }
    return _curColorView;
}

- (DivoomColorBarPickerView *)barPickerView{
    if (!_barPickerView) {
        _barPickerView = [[DivoomColorBarPickerView alloc] init];
        _barPickerView.layer.masksToBounds = YES;
        _barPickerView.layer.cornerRadius = 4;
    }
    return _barPickerView;
}

- (DivoomColorSquareView *)squareView{
    if (!_squareView) {
        _squareView = [[DivoomColorSquareView alloc] init];
        _squareView.layer.masksToBounds = YES;
        _squareView.layer.cornerRadius = 4;
    }
    return _squareView;
}

- (DivoomColorLumpView *)colorLumpView{
    if (!_colorLumpView) {
        _colorLumpView = [[DivoomColorLumpView alloc] init];
    }
    return _colorLumpView;
}

-(UIColor *)preColor{
    if (!_preColor) {
        _preColor = DEFAULT_COLOR; //默认红色
    }
    return _preColor;
}

-(UIColor *)curColor{
    if (!_curColor) {
        _curColor = DEFAULT_COLOR; //默认红色
    }
    return self.curColorView.backgroundColor;
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
