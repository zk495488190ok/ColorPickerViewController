//
//  ViewController.m
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "ViewController.h"
#import "DivoomColorBarPickerView.h"
#import "DivoomColorSquareView.h"
#import "DivoomColorPickerVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    DivoomColorBarPickerView *vbar = [[DivoomColorBarPickerView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    vbar.center = self.view.center;
    [vbar setColorChangedBlock:^(UIColor * _Nonnull color) {
        self.view.backgroundColor = color;
    }];
    [vbar setValueChangedBlock:^(CGFloat hvalue) {
        NSLog(@"hvalue:%.1f",hvalue);
    }];
    [self.view addSubview:vbar];*/
    
//    DivoomColorSquareView *cv = [[DivoomColorSquareView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds))];
//    cv.center = self.view.center;
//    cv.hvalue = 0;
//    cv.svvalue = CGPointMake(1, 1);
//    [cv setColorChangedBlock:^(UIColor * _Nonnull color) {
//        self.view.backgroundColor = color;
//    }];
//    [self.view addSubview:cv];
    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *t = [touches.allObjects firstObject];
    if (t.view == self.view) {
        DivoomColorPickerVC *vc = [[DivoomColorPickerVC alloc] initWithPreColor:self.view.backgroundColor];
        __weak typeof(self) weakSelf = self;
        [vc setColorPickerBLock:^(UIColor * _Nonnull color) {
            [weakSelf.view setBackgroundColor:color];
        }];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end
