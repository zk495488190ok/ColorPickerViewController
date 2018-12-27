//
//  DivoomColorBarPickerView.m
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomColorBarPickerView.h"
#import "ColorIndicatorView.h"
#import "HSBSupport.h"

@interface DivoomColorBarPickerView()

@property (nonatomic, strong) ColorIndicatorView *indicator;
@end

@implementation DivoomColorBarPickerView

-(void)drawRect:(CGRect)rect{
    float hsv[] = {0.0,1.0,1.0};
    CGImageRef image = createHSVBarContentImage(InfComponentIndexHue,hsv);
    if (image) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextDrawImage(ctx, rect, image);
        CGImageRelease(image);
        
        CGFloat x = _hvalue * CGRectGetWidth(self.frame);
        self.indicator.center = CGPointMake(x, CGRectGetMidY(self.bounds));
    }
}

-(void)setHvalue:(CGFloat)hvalue{
    if (hvalue > 1) {
        hvalue = 1;
    }
    if (hvalue < 0) {
        hvalue = 0;
    }
    _hvalue = hvalue;
    CGFloat x = _hvalue * CGRectGetWidth(self.frame);
    self.indicator.center = CGPointMake(x, CGRectGetMidY(self.bounds));
}

- (ColorIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[ColorIndicatorView alloc] init];
        [self addSubview:_indicator];
    }
    return _indicator;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

- (void)indcatorViewWithTouch:(UITouch *)touch{
    CGPoint p = [touch locationInView:self];
    if (p.x > 0 && p.x <= CGRectGetWidth(self.bounds)) {
        self.indicator.center = CGPointMake(p.x, self.indicator.center.y);
        self.hvalue = self.indicator.center.x / CGRectGetWidth(self.bounds);
        //颜色 回调
        if (_ColorChangedBlock) {
            _ColorChangedBlock([UIColor colorWithHue:_hvalue saturation:1.0 brightness:1.0 alpha:1.0]);
        }
        //hvalue 回调
        if (_ValueChangedBlock) {
            _ValueChangedBlock(_hvalue);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
