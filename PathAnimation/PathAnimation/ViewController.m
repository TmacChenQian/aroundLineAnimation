//
//  ViewController.m
//  PathAnimation
//
//  Created by 陈乾 on 2017/2/24.
//  Copyright © 2017年 Cha1ien. All rights reserved.
//

#import "ViewController.h"


#define KarcViewWidth 200
#define KarcViewHeight 50
@interface ViewController ()<CAAnimationDelegate>
{
    CGRect _orignalRect;
}
@property (nonatomic, assign)BOOL  annimating;
@property (weak, nonatomic) IBOutlet UIView *arcView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _orignalRect = self.arcView.bounds;
    
    if(self.annimating){
        return;
    }
    for (CALayer *sublayer in self.arcView.layer.sublayers) {
        [sublayer removeFromSuperlayer];
    }
    
    self.annimating = YES;
    
    self.arcView.layer.cornerRadius = KarcViewHeight/2;
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    baseAnimation.duration = 0.2;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    baseAnimation.delegate = self;
    
    [baseAnimation setValue:@"cornerRadiusAnimation" forKey:@"cornerRadiusAnimation"];
    [self.arcView.layer addAnimation:baseAnimation forKey:nil];
    
    

}


-(void)animationDidStart:(CAAnimation *)anim{
    
    
     if ([[anim valueForKey:@"cornerRadiusAnimation"] isEqualToString:@"cornerRadiusAnimation"]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.arcView.bounds = CGRectMake(0, 0, KarcViewWidth, KarcViewHeight);
        } completion:^(BOOL finished) {
            [self.arcView.layer removeAllAnimations];
            [self progressBarAnimation];
        }];

    }else if([[anim valueForKey:@"returnAroundAnimation"] isEqualToString:@"returnAroundAnimation"]){
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.arcView.bounds = CGRectMake(0, 0, KarcViewWidth, KarcViewWidth);
                self.arcView.backgroundColor = [UIColor colorWithRed:0.1803921568627451 green:0.8 blue:0.44313725490196076 alpha:1.0];
            } completion:^(BOOL finished) {
                [self.arcView.layer removeAllAnimations];
                [self checkAnimation];
                //-----
                self.annimating = NO;
            }];
    }else{
        
    }
}

-(void)checkAnimation{
    
    //创建shapLayer
    CAShapeLayer *shapLayer =[CAShapeLayer layer];
    //创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint startPoint = CGPointMake(self.arcView.frame.origin.x, self.arcView.frame.origin.y-100);
    CGPoint joinPoint = CGPointMake(self.arcView.frame.origin.x+20, self.arcView.frame.origin.y-50);
    CGPoint endPoint = CGPointMake(self.arcView.frame.origin.x+100, self.arcView.frame.origin.y-130);
    
    [path moveToPoint:startPoint];
    [path addLineToPoint:joinPoint];
    [path addLineToPoint:endPoint];
    
    //赋值给图层
    shapLayer.path = path.CGPath;
    shapLayer.strokeColor = [UIColor redColor].CGColor;
    shapLayer.fillColor = [UIColor clearColor].CGColor;
    shapLayer.lineJoin = kCALineJoinRound;
    shapLayer.lineCap = kCALineCapSquare;
    shapLayer.lineWidth = 10.0;
    
    [self.arcView.layer addSublayer:shapLayer];
    
    //动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.duration = 0.6;
    basicAnimation.fromValue = @(0.0f);
    basicAnimation.toValue = @(1.0f);
    basicAnimation.delegate = self;
    [shapLayer addAnimation:basicAnimation forKey:nil];


}

-(void)progressBarAnimation{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGPoint startPoint = CGPointMake(KarcViewHeight/2, KarcViewHeight/2);
    CGPoint endPoint = CGPointMake(KarcViewWidth - (KarcViewHeight/2), KarcViewHeight/2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = KarcViewHeight - 10;
    shapeLayer.lineCap =  kCALineCapRound;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.arcView.layer addSublayer:shapeLayer];
    /*
      These values define the subregion of the path used to draw the
     * stroked outline. The values must be in the range [0,1] with zero
     * representing the start of the path and one the end. Values in
     * between zero and one are interpolated linearly along the path
     * length. strokeStart defaults to zero and strokeEnd to one. Both are
     * animatable.
        @property CGFloat strokeStart;
        @property CGFloat strokeEnd;
      */
    CABasicAnimation *annimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    annimation.duration = 0.2;
    annimation.fromValue = @(0.0f);
    annimation.toValue = @(1.0f);
    annimation.delegate = self;
    [annimation setValue:@"lineStrokeEnd" forKey:@"lineStrokeEnd"];
    [shapeLayer addAnimation:annimation forKey:nil];
    
    
    

}



-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([[anim valueForKey:@"lineStrokeEnd"] isEqualToString:@"lineStrokeEnd"]) {
        //重新变回圆形
//        self.arcView.bounds = CGRectMake(0, 0, KarcViewWidth, KarcViewWidth);
        [UIView animateWithDuration:0.2 animations:^{
            for (CALayer *layer in self.arcView.layer.sublayers) {
                layer.opacity = 0;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                //先移除layer
                for (CALayer *layer in self.arcView.layer.sublayers) {
                    [layer removeFromSuperlayer];
                }
                //再绘制成圆形
                self.arcView.layer.cornerRadius = KarcViewWidth/2;
                CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                basicAnimation.duration = 0.2;
                basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                basicAnimation.fromValue = @(KarcViewHeight/2);

                basicAnimation.delegate = self;
                [basicAnimation setValue:@"returnAroundAnimation" forKey:@"returnAroundAnimation"];
                [self.arcView.layer addAnimation:basicAnimation forKey:nil];
            }
        }];
 
    }
    
}

@end
