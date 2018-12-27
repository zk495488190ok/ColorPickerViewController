//
//  DivoomColorLumpView.h
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/26.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 色块选择时期试图
 */
@interface DivoomColorLumpView : UIView

@property (nonatomic, copy) void(^colorBlock) (UIColor *color);

@end

NS_ASSUME_NONNULL_END
