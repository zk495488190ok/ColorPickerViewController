//
//  DivoomColorLumpView.m
//  DvioomColorPicker
//
//  Created by yanhuanpei on 2018/12/26.
//  Copyright © 2018 zhuk. All rights reserved.
//

#import "DivoomColorLumpView.h"
#import "Masonry.h"

@implementation DivoomColorLumpView{
    NSMutableArray  *_views;
}

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
    _views = [[NSMutableArray alloc] init];
    NSArray *colors = @[[UIColor colorWithRed:1 green:1 blue:1 alpha:1],
                        [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                        [UIColor redColor],
                        [UIColor yellowColor],
                        [UIColor blueColor],
                        [UIColor greenColor],
                        [UIColor orangeColor]];
    for (int i = 0; i < colors.count; i++) {
        UIView *itemV = [UIView new];
        itemV.userInteractionEnabled = YES;
        itemV.layer.cornerRadius = 4;
        itemV.layer.masksToBounds = YES;
        itemV.layer.borderColor = [UIColor whiteColor].CGColor;
        itemV.layer.borderWidth = 1;
        itemV.tag = 1000 + i;
        [itemV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemAcion:)]];
        itemV.backgroundColor = colors[i];
        [self addSubview:itemV];
        [_views addObject:itemV];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIView *lastV = nil;
    CGFloat s = (CGRectGetWidth(self.frame) - (CGRectGetHeight(self.frame) * _views.count)) / (_views.count - 1);
    for (int i = 0; i < _views.count; i++) {
        UIView *v = _views[i];
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(self.mas_height);
            make.centerY.mas_equalTo(self);
            if (lastV == nil) {
                make.left.mas_equalTo(self);
            }else{
                make.left.mas_equalTo(lastV.mas_right).offset(s);
            }
        }];
        lastV = v;
    }
}

- (void)itemAcion:(UITapGestureRecognizer *)sender {
    if (_colorBlock) {
        _colorBlock([sender.view.backgroundColor copy]);
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
