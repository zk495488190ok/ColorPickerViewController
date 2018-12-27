//
//  DivoomColorSquareView.m
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/25.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomColorSquareView.h"
#import "ColorIndicatorView.h"
#import "HSBSupport.h"

@interface DivoomColorSquareView()

@property (nonatomic, strong) ColorIndicatorView *indicator;
@end

@implementation DivoomColorSquareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    [self addSubview:self.indicator];
    [self setHvalue:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x = _svvalue.x * CGRectGetWidth(self.bounds);
    CGFloat y = CGRectGetHeight(self.bounds) - _svvalue.y * CGRectGetHeight(self.bounds);
    self.indicator.center = CGPointMake(x, y);
    
    self.curColor = [UIColor colorWithHue:_hvalue saturation:_svvalue.x brightness:_svvalue.y  alpha:1.0];
    
    if (_colorChangedBlock) {
        _colorChangedBlock(self.curColor);
    }
}

- (void)updateContent {
    CGImageRef image = createSaturationBrightnessSquareContentImageWithHue(self.hvalue * 360);
    self.layer.contents = (__bridge id)image;
    CGImageRelease(image);
}


#pragma mark - 手势

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects.firstObject;
    [self indcatorViewWithTouch:touch];
}

- (void)indcatorViewWithTouch:(UITouch *)touch {
    if (touch) {
        CGPoint p = [touch locationInView:self];
        CGFloat w = CGRectGetWidth(self.bounds);
        CGFloat h = CGRectGetHeight(self.bounds);
        if (p.x < 0) {
            p.x = 0;
        }
        if (p.x > w) {
            p.x = w;
        }
        if (p.y < 0) {
            p.y = 0;
        }
        if (p.y > h) {
            p.y = h;
        }
        _svvalue = CGPointMake(p.x / w, 1.0 - p.y / h);
        [self setNeedsLayout];
    }
}

#pragma mark - Getter / Setter

-(void)setHvalue:(CGFloat)hvalue{
    if (hvalue > 1) {
        hvalue = 1;
    }
    if (hvalue < 0) {
        hvalue = 0;
    }
    _hvalue = hvalue;
    [self updateContent];
    [self setNeedsLayout];
}

-(void)setSvvalue:(CGPoint)svvalue{
    if (!CGPointEqualToPoint(_svvalue, svvalue)) {
        _svvalue = svvalue;
        [self setNeedsLayout];
    }
}

- (ColorIndicatorView *)indicator{
    if (!_indicator) {
        _indicator = [[ColorIndicatorView alloc] init];
    }
    return _indicator;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
