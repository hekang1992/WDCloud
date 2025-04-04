//
//  MenuAction.m
//  LinkageMenu
//
//  Created by 魏小庄 on 2018/5/18.
//  Copyright © 2018年 魏小庄. All rights reserved.
//

#import "MenuAction.h"

@interface MenuAction ()
@property (nonatomic, assign, readwrite) MenuActionStyle actionStyle;
@property (nonatomic, copy, readwrite) NSString *title;


@end

@implementation MenuAction

+ (instancetype)actionWithTitle:(NSString *)title style:(MenuActionStyle)style {
    MenuAction *action = [[MenuAction alloc]init];
    action.actionStyle = style;
    action.title = title;
    action.adjustsImageWhenDisabled = NO;
    action.adjustsImageWhenHighlighted = NO;
    [action setTitle:title forState:UIControlStateNormal];
    action.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    action.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [action setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1] forState:UIControlStateNormal];
    [action setImage:[UIImage imageNamed:@"xialaiamge_nor"] forState:UIControlStateNormal];
    [action setImage:[UIImage imageNamed:@"xialaimage_sel"] forState:UIControlStateSelected];
    return action;
}

//+ (UIImage *)drawTriangleWithFront:(BOOL)front {
//    CGFloat w = 12;
//    CGFloat h = 8;
//    
//    UIView *triangleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
//    
//    CAShapeLayer *triangleLayer = [[CAShapeLayer alloc]init];
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    if (front) {
//        [path moveToPoint:CGPointMake(0, 0)];
//        [path addLineToPoint:CGPointMake(w, 0)];
//        [path addLineToPoint:CGPointMake(w * 0.5, h)];
//        triangleLayer.path = path.CGPath;
//        [triangleView.layer addSublayer:triangleLayer];
//        [triangleLayer setFillColor:[UIColor blackColor].CGColor];
//    }else {
//        [path moveToPoint:CGPointMake(w * 0.5, 0)];
//        [path addLineToPoint:CGPointMake(0, h)];
//        [path addLineToPoint:CGPointMake(w, h)];
//        triangleLayer.path = path.CGPath;
//        [triangleView.layer addSublayer:triangleLayer];
//        [triangleLayer setFillColor:[UIColor colorWithRed:242/255.0 green:136/255.0 blue:0/255.0 alpha:1/1.0].CGColor];
//    }
//    
//    triangleView.backgroundColor = [UIColor whiteColor];
//    UIGraphicsBeginImageContextWithOptions(triangleView.frame.size, YES, [UIScreen mainScreen].scale);  //图形上下文设置
//    [triangleView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//赋值
//    UIGraphicsEndImageContext();//结束
//    
//    return image;
//}

-(void)adjustFrame {
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.bounds.size.width + 2, 0, self.imageView.bounds.size.width + 5)];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width + 5, 0, -self.titleLabel.bounds.size.width + 2)];
}

- (void)adjustTitle:(NSString *)title textColor:(UIColor *)color {
     if (![title isKindOfClass:[NSString class]]) return;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self adjustFrame];
    // 移除筛选列表
    if(self.didDismissDropMenu){
        self.didDismissDropMenu();
    }
}

- (void) dismiss {
    
    if(self.didDismissDropMenu){
        self.didDismissDropMenu();
    }
}

@end
