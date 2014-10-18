//
//  NUDialChart.m
//  NuweScoreFramework
//
//  Created by Dev Mac on 10/17/14.
//  Copyright (c) 2014 Dimitar Plamenov. All rights reserved.
//

#import "NUDialChart.h"
#import <QuartzCore/QuartzCore.h>

@implementation NUDialChart
{
    int centerLabelWidth;
    int overGap;
    int lineWidth;
}

@synthesize chartDataSource, chartDelegate;
@synthesize LabelCenterCurrent;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) init
{
    self = [self initWithFrame:CGRectMake(0, 0, 100, 100)];
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self )
    {
        arrayCircles = nil;
    }
    return self;
}

- (void) setupWithCount:(int) _count TotalValue:(int) _total
{
    [self setupWithCount:_count TotalValue:_total Frame:self.frame];
}

- (void) setupWithCount:(int) _count TotalValue:(int) _total Frame:(CGRect) _frame
{
    circleCount = _count;
    totalValue = _total;
    self.frame = _frame;
    CGPoint centerPoint = CGPointMake(self.center.x - _frame.origin.x, self.center.y - _frame.origin.y);
    
    if ( circleCount == 0 || totalValue == 0 )
    {
        NSLog(@"Bad params in setupwithcount for NUDialChart");
        return;
    }
    
    float _width = MIN(self.frame.size.width, self.frame.size.height);
    
    // determine of width for center label by dial count;
    int MAX_COUNT = 6;
    if ( _count > MAX_COUNT - 1 )
    {
        NSLog(@"Bad count value in setupwithcount for NUDialChart");
        return;
    }
    
    float _percent = (float)circleCount / (float)MAX_COUNT;
    centerLabelWidth = _width * (1.0f - _percent);
    float deltaWidth = (float)(_width - centerLabelWidth) / (float)_count;
    lineWidth = deltaWidth / 2 - 1;
    overGap = centerLabelWidth - lineWidth;
    
    if ( centerLabelWidth < 1 || overGap < 1 || lineWidth < 1 )
    {
        NSLog(@"Bad frame in setupwithcount for NUDialChart");
        return;
    }
    
    LabelCenterCurrent = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, centerLabelWidth, centerLabelWidth)];
    LabelCenterCurrent.font = [UIFont systemFontOfSize:(centerLabelWidth / 2)];
    LabelCenterCurrent.textAlignment = NSTextAlignmentCenter;
    LabelCenterCurrent.backgroundColor = [UIColor darkGrayColor];
    LabelCenterCurrent.textColor = [UIColor whiteColor];
    LabelCenterCurrent.layer.cornerRadius = centerLabelWidth / 2;
    LabelCenterCurrent.layer.masksToBounds = YES;
    
    labelTotalValue = [[UILabel alloc] initWithFrame:CGRectMake(0, (centerLabelWidth * 2) / 3, centerLabelWidth, centerLabelWidth / 3)];
    labelTotalValue.textAlignment = NSTextAlignmentCenter;
    labelTotalValue.font = [UIFont systemFontOfSize:(centerLabelWidth / 6)];
    labelTotalValue.text = [NSString stringWithFormat:@"/ %d", _total];
    labelTotalValue.textColor = [UIColor whiteColor];
    
    [LabelCenterCurrent addSubview:labelTotalValue];
    LabelCenterCurrent.center = centerPoint;
    [self addSubview:LabelCenterCurrent];
    
    arrayCircles = [[NSMutableArray alloc] initWithCapacity:_count];
    
    for ( int i = 0; i < _count; i++ )
    {
        PNCircleChart * _chart = [[PNCircleChart alloc] initWithFrame: CGRectMake(0, 0, overGap + deltaWidth * (i + 1), overGap + deltaWidth * (i + 1))
                                                             andTotal:[NSNumber numberWithInt: totalValue] andCurrent:0 andClockwise:YES hiddenLabel:(_count > 1 ? YES : NO)];
        _chart.lineWidth = [NSNumber numberWithFloat:lineWidth];
        _chart.labelFontSize = centerLabelWidth / 3;
        _chart.backgroundColor = [UIColor clearColor];
        
        _chart.center = centerPoint;
        [self addSubview:_chart];
        [arrayCircles addObject:_chart];
    }
    
    if ( _count == 1 )
        LabelCenterCurrent.hidden = YES;
}

- (void) reloadDialWithAnimation:(BOOL) animation
{
    if ( !chartDataSource || !arrayCircles )
    {
        NSLog(@"Chart data source is not assigned.");
        return;
    }
    
    for ( int i = 0; i < circleCount; i++ ){
        PNCircleChart * _chart = (PNCircleChart*)[arrayCircles objectAtIndex:i];
        
        if ( [chartDataSource respondsToSelector:@selector(dialChart:valueOfCircleAtIndex:)] )
        {
            NSNumber* _current = [chartDataSource dialChart:self valueOfCircleAtIndex:i];
            _chart.current = _current;
        }
    
        if ( [chartDataSource respondsToSelector:@selector(dialChart:colorOfCircleAtIndex:)] )
        {
            UIColor* _color = [chartDataSource dialChart:self colorOfCircleAtIndex:i];
            _chart.strokeColor = _color;
        }
        
        if ( [chartDataSource respondsToSelector:@selector(dialChart:textOfCircleAtIndex:)] )
        {
            NSString* _text = [chartDataSource dialChart:self textOfCircleAtIndex:i];
//            _chart.textTitle = _text;
        }
        
        if ( [chartDataSource respondsToSelector:@selector(dialChart:defaultCircleAtIndex:)] )
        {
            BOOL isDefault = [chartDataSource dialChart:self defaultCircleAtIndex:i];
            _chart.isFrame = isDefault;
        }
        
        [_chart strokeChart];
    }
    
    if ( [chartDataSource respondsToSelector:@selector(isShowCenterLabelInDial:)] )
    {
        BOOL isShowCenter = [chartDataSource isShowCenterLabelInDial:self];
        LabelCenterCurrent.hidden = !isShowCenter;
    }
    
    if ( [chartDataSource respondsToSelector:@selector(nuscoreInDialChart:)] )
    {
        int nuscore = [chartDataSource nuscoreInDialChart:self];
        
        LabelCenterCurrent.method = UILabelCountingMethodEaseInOut;
        LabelCenterCurrent.format = @"%d";
        [LabelCenterCurrent countFrom:0 to:nuscore withDuration:0.5];
        
    }
    
    if ( [chartDataSource respondsToSelector:@selector(centerTextColorInDialChart:)] )
    {
        UIColor* _color = [chartDataSource centerTextColorInDialChart:self];
        LabelCenterCurrent.textColor = _color;
        labelTotalValue.textColor = _color;
    }
    
    if ( [chartDataSource respondsToSelector:@selector(centerBackgroundColorInDialChart:)] )
    {
        UIColor* _color = [chartDataSource centerBackgroundColorInDialChart:self];
        LabelCenterCurrent.backgroundColor = _color;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    CGPoint viewPoint = [LabelCenterCurrent convertPoint:locationPoint fromView:self];
    if ([LabelCenterCurrent pointInside:viewPoint withEvent:event]) {
        if ( [chartDelegate respondsToSelector:@selector(touchNuDialChart:)])
        {
            [chartDelegate touchNuDialChart:self];
        }
    }
}

@end
