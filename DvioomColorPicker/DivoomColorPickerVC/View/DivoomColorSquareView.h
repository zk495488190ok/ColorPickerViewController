//
//  DivoomColorSquareView.h
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 颜色空间选择视图
 */
@interface DivoomColorSquareView : UIView

@property (nonatomic, assign) CGFloat hvalue;
@property (nonatomic, assign) CGPoint svvalue;
@property (nonatomic, strong) UIColor *curColor;

@property (nonatomic, copy) void(^colorChangedBlock) (UIColor *color);

@end

NS_ASSUME_NONNULL_END
