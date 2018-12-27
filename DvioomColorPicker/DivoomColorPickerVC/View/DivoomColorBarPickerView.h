//
//  DivoomColorBarPickerView.h
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 颜色条选择器实图
 */
@interface DivoomColorBarPickerView : UIView

@property (nonatomic, assign) CGFloat hvalue;

@property (nonatomic, copy) void(^ValueChangedBlock) (CGFloat hvalue);
@property (nonatomic, copy) void(^ColorChangedBlock) (UIColor *color);

@end

NS_ASSUME_NONNULL_END
