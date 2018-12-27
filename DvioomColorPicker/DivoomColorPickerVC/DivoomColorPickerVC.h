//
//  DvioomColorPickerVC.h
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DivoomColorPickerVC : UIViewController

@property (nonatomic, strong) UIColor *preColor;
@property (nonatomic, strong) UIColor *curColor;

@property (nonatomic, copy) void(^colorPickerBLock) (UIColor *color);

-(instancetype)initWithPreColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
