//
//  PNCircleChart.m
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNCircleChart.h"
#import "UICountingLabel.h"

#import "Define.h"

#define TIP_GAP 20


CGFloat getAngleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2);

@interface PNCircleChart () {
    UICountingLabel *_gradeLabel;
    BOOL fControl;
    CGFloat rPrevAngle;
}

@end

@implementation PNCircleChart

- (UIColor *)labelColor
{
    if (!_labelColor) {
        _labelColor = PNDeepGrey;
    }
    return _labelColor;
}

- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current andClockwise:(BOOL)clockwise hiddenLabel:(BOOL) hidden {
    self = [super initWithFrame:frame];
    
    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        _clockwise = clockwise;
        
        CGFloat startAngle = clockwise ? -90.0f : 270.0f;
        CGFloat endAngle = clockwise ? -90.01f : 270.01f;
        
        //        _lineWidth = [NSNumber numberWithFloat:15.0];
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x - self.frame.origin.x,self.center.y - self.frame.origin.y) radius:self.frame.size.height*0.5 startAngle:DEGREES_TO_RADIANS(startAngle) endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:clockwise];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;  //kCALineCapSquare;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue] - 3;
        _circle.zPosition     = 1;
        
        _circleBorder               = [CAShapeLayer layer];
        _circleBorder.path          = circlePath.CGPath;
        _circleBorder.lineCap       = kCALineCapRound; //kCALineCapSquare;
        _circleBorder.fillColor     = [UIColor clearColor].CGColor;
        _circleBorder.lineWidth     = [_lineWidth floatValue];
        _circleBorder.zPosition     = 0;
        
        _circleBG             = [CAShapeLayer layer];
        _circleBG.path        = circlePath.CGPath;
        _circleBG.lineCap     = kCALineCapRound;
        _circleBG.fillColor   = [UIColor clearColor].CGColor;
        _circleBG.lineWidth   = [_lineWidth floatValue];
        _circleBG.strokeColor = PNLightYellow.CGColor;
        _circleBG.strokeEnd   = 1.0;
        _circleBG.zPosition   = -1;
        
        [self.layer addSublayer:_circleBG];
        [self.layer addSublayer:_circleBorder];
        [self.layer addSublayer:_circle];
        
        _gradeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
    }
    
    _gradeLabel.hidden = hidden;
    _editable = NO;
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame andStart:(CGFloat)rStart andEnd:(CGFloat)rEnd andCurrent:(CGFloat)rCurrent andClockwise:(BOOL)clockwise hiddenLabel:(BOOL) hidden
{
    CGFloat rTotal = rEnd - rStart;
    NSNumber* total = [NSNumber numberWithFloat:rTotal];
    NSNumber* current = [NSNumber numberWithFloat:rCurrent - rStart];
    
    self = [self initWithFrame:frame andTotal:total andCurrent:current andClockwise:clockwise
                   hiddenLabel:hidden];
    
    if (self)
    {
        self.rStart = rStart;
        self.rEnd = rEnd;
        _editable = YES;
    }
    
    return self;
}

-(void)strokeChart
{
    //Add count label
    [self setHidden:NO];
    
    [_gradeLabel setTextAlignment:NSTextAlignmentCenter];
    [_gradeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:_labelFontSize]];
    [_gradeLabel setTextColor:_strokeColor];
    [_gradeLabel setCenter:CGPointMake(self.center.x - self.frame.origin.x,self.center.y - self.frame.origin.y)];
    [_gradeLabel setBackgroundColor:[UIColor clearColor]];
    _gradeLabel.method = UILabelCountingMethodEaseInOut;
    _gradeLabel.format = @"%d";
    
    [self addSubview:_gradeLabel];
    
    //Add circle params
    
    _circle.lineWidth   = [_lineWidth floatValue] - 3;
    _circleBorder.lineWidth = [_lineWidth floatValue];
    _circleBG.lineWidth = [_lineWidth floatValue];
    _circleBG.strokeEnd = 1.0;
    
    _circle.strokeColor = _isFrame ? PNLightYellow.CGColor : _strokeColor.CGColor;
    _circleBorder.strokeColor = _strokeColor.CGColor;
    
    //Add Animation
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.5;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circle.strokeEnd   = [_current floatValue]/[_total floatValue];
    
    [_circleBorder addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _circleBorder.strokeEnd   = [_current floatValue]/[_total floatValue];
    
    if ( _editable )
        [_gradeLabel countFrom:0 to:[_current floatValue] + _rStart withDuration:0.5];
    else
        [_gradeLabel countFrom:0 to:[_current floatValue] withDuration:0.5];
    
}

-(void)toggleChart:(BOOL) isBig Hidden:(BOOL) hide
{
    //Add count label
    
    [_gradeLabel setTextAlignment:NSTextAlignmentCenter];
    [_gradeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:_labelFontSize]];
    [_gradeLabel setTextColor:_strokeColor];
    [_gradeLabel setCenter:CGPointMake(self.center.x - self.frame.origin.x,self.center.y - self.frame.origin.y)];
    [_gradeLabel setBackgroundColor:[UIColor clearColor]];
    _gradeLabel.method = UILabelCountingMethodEaseInOut;
    _gradeLabel.format = @"%d";
    
    [self addSubview:_gradeLabel];
    
    //Add circle params
    
    _circle.lineWidth   = [_lineWidth floatValue] - 3;
    _circleBorder.lineWidth = [_lineWidth floatValue];
    _circleBG.lineWidth = [_lineWidth floatValue];
    _circleBG.strokeEnd = 1.0;
    
    _circle.strokeColor = _isFrame ? PNLightYellow.CGColor : _strokeColor.CGColor;
    _circleBorder.strokeColor = _strokeColor.CGColor;
    
    if ( !hide )
        [self setHidden:NO];
    
    float _animationDuration = 0.2;
    
    if ( isBig )        // big scores animation
    {
        if ( !hide )     // show scores animation
        {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:[_lineWidth floatValue] - 3.0];
            [_circle addAnimation:pathAnimation forKey:@"lineWidthAnimation"];
            _circle.lineWidth   = [_lineWidth floatValue] - 3.0;
            
            pathAnimation.toValue = [NSNumber numberWithFloat:[_lineWidth floatValue]];
            [_circleBorder addAnimation:pathAnimation forKey:@"lineWidthAnimation"];
            _circleBorder.lineWidth   = [_lineWidth floatValue];
            
            
            //            [self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:NO]  afterDelay:_animationDuration];
        }
        else            // hide scores animation
        {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:[_lineWidth floatValue] - 3.0];
            pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
            [_circle addAnimation:pathAnimation forKey:@"lineWidthAnimation"];
            _circle.lineWidth   = 0;
            
            pathAnimation.fromValue = [NSNumber numberWithFloat:[_lineWidth floatValue]];
            [_circleBorder addAnimation:pathAnimation forKey:@"lineWidthAnimation"];
            _circleBorder.lineWidth   = 0;
            
            //            [self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES]  afterDelay:_animationDuration];
        }
    }
    else                // small scores animation
    {
        if ( !hide )     // show scores animation
        {
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnimation.toValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
            [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _circle.strokeEnd   = [_current floatValue]/[_total floatValue];
            
            [_circleBorder addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _circleBorder.strokeEnd   = [_current floatValue]/[_total floatValue];
            
            
            [_gradeLabel countFrom:0 to:[_current floatValue] withDuration:_animationDuration];
            
        }
        else            // hide scores animation
        {
            //Add Animation
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = _animationDuration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
            pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
            [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _circle.strokeEnd   = 0;
            
            [_circleBorder addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _circleBorder.strokeEnd   = 0;
            
            
            [_gradeLabel countFrom:[_current floatValue] to:0 withDuration:_animationDuration];
        }
    }
    //    //Add Animation
    //    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    //    pathAnimation.duration = _animationDuration;
    //    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    pathAnimation.fromValue = [NSNumber numberWithFloat:[_current floatValue]/[_total floatValue]];
    //    pathAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    //    [_circle addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    //    _circle.strokeEnd   = [_current floatValue]/[_total floatValue];
    //
    //    [_circleBorder addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    //    _circleBorder.strokeEnd   = [_current floatValue]/[_total floatValue];
    //
    //
    //    [_gradeLabel countFrom:[_current floatValue]/[_total floatValue]*100 to:0 withDuration:_animationDuration];
    
    if ( hide )
        [self performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:hide]  afterDelay:_animationDuration];
}

// for editting chart

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //    NSLog(@"touch moved");
    
    UITouch *touch = [touches anyObject];
    CGPoint tapLocation = [touch locationInView:self];
    
    if (!_editable)
        return;
    
    CGFloat rSize = self.bounds.size.width;
    CGFloat rHalfLineW = _lineWidth.floatValue / 2;
    CGFloat rRealRadius = rSize / 2.f - rHalfLineW;
    
    CGPoint ptCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGPoint ptStart = CGPointMake(ptCenter.x, ptCenter.y - rRealRadius);
    CGFloat angle = getAngleBetweenThreePoints(ptCenter, ptStart, tapLocation);
    
    if (fabsf(angle - rPrevAngle) < M_PI)
    {
        rPrevAngle = angle;
        
        CGFloat rCurrentPercent = angle / M_PI / 2;
        [self goTo:rCurrentPercent];
    }
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //        NSLog(@"touch ended");
    
    //    fControl = NO;
}


/*
 - (void)onHandlePan:(UIPanGestureRecognizer*)panRecognizer
 {
 CGPoint tapLocation = [panRecognizer locationInView:self];
 
 switch (panRecognizer.state)
 {
 case UIGestureRecognizerStateBegan:
 {
 if ([self IsPointInTip:tapLocation])
 {
 fControl = YES;
 tapLocation = tapLocation;
 
 }
 break;
 }
 
 case UIGestureRecognizerStateChanged:
 {
 if (!fControl)
 break;
 CGFloat rSize = self.bounds.size.width;
 CGFloat rHalfLineW = _lineWidth.floatValue / 2;
 CGFloat rRealRadius = rSize / 2.f - rHalfLineW;
 
 CGPoint ptCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
 CGPoint ptStart = CGPointMake(ptCenter.x, ptCenter.y - rRealRadius);
 CGFloat angle = getAngleBetweenThreePoints(ptCenter, ptStart, tapLocation);
 CGFloat rCurrent = angle / M_PI / 2 * _total.floatValue;
 [self goTo:rCurrent];
 
 NSLog(@"%f", angle / M_PI);
 break;
 }
 
 
 case UIGestureRecognizerStateEnded:
 {
 fControl = NO;
 }
 
 default:
 break;
 }
 
 }*/

- (BOOL)IsPointInTip:(CGPoint)pt
{
    CGFloat rSize = self.bounds.size.width;
    CGFloat rHalfLineW = _lineWidth.floatValue / 2;
    CGFloat rRealRadius = rSize / 2.f - rHalfLineW;
    
    CGFloat rCurrentRadian = (_current.floatValue / (_rEnd - _rStart)) * M_PI * 2 - M_PI_2;
    
    CGFloat rCurX, rCurY;
    
    rCurX = rSize / 2.f + cos(rCurrentRadian) * rRealRadius;
    rCurY = rSize / 2.f + sin(rCurrentRadian) * rRealRadius;
    
    CGFloat rRectRadius = rHalfLineW + TIP_GAP;
    if (CGRectContainsPoint(CGRectMake(rCurX - rRectRadius, rCurY - rRectRadius, rRectRadius * 2, rRectRadius * 2), pt))
    {
        rPrevAngle = rCurrentRadian + M_PI_2;
        return YES;
    }
    
    return NO;
}

- (void)goTo:(CGFloat)rCurrentPercent
{
    //    NSLog(@"%f", rCurrentPercent);
    
    if (rCurrentPercent < 0.005f)
        rCurrentPercent = 0.0f;
    
    if (rCurrentPercent > 0.996f)
        rCurrentPercent = 1.f;
    
    self.current = [NSNumber numberWithFloat:rCurrentPercent  * _total.floatValue];
    _circle.strokeEnd = rCurrentPercent;
    _circleBorder.strokeEnd = rCurrentPercent;
    
    _gradeLabel.text = [NSString stringWithFormat:@"%d", (int)(_current.floatValue + _rStart)];
}

CGFloat getAngleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2)
{
    //	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
    //	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
    
    //    CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
    
    CGFloat angle = atan2f(p2.y - centerPoint.y, p2.x - centerPoint.x);
    
    if (angle < 0)
        angle = M_PI * 2 + angle;
    
    angle += M_PI_2;
    if (angle >= M_PI * 2)
        angle -= M_PI * 2;
    
    return angle;
}


@end
