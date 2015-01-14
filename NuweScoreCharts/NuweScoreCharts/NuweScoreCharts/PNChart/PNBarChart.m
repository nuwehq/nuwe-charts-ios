//
//  PNBarChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNBarChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#import "NuweDefine.h"

@interface PNBarChart() {
    NSMutableArray* _bars;
    NSMutableArray* _labels;
}

- (UIColor *)barColorAtIndex:(NSUInteger)index;
@end	

@implementation PNBarChart
@synthesize pDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds   = YES;
        _showLabel           = NO;
        _barBackgroundColor  = PNLightGrey;
        _labels              = [NSMutableArray array];
        _bars                = [NSMutableArray array];
    }

    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];

    _xLabelWidth = (self.frame.size.width - chartMargin*2)/[_yValues count];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }

    }

    //Min value for Y label
    if (max < 5) {
        max = 5;
    }

    _yValueMax = (int)max;
}

-(void)setXLabels:(NSArray *)xLabels
{
    [self viewCleanupForCollection:_labels];
    _xLabels = xLabels;

    if (_showLabel) {
        _xLabelWidth = (self.frame.size.width - chartMargin*2)/[xLabels count];

        for(int index = 0; index < xLabels.count; index++)
        {
            NSString* labelText = xLabels[index];
            PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin), self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
            [label setTextAlignment:NSTextAlignmentCenter];
            label.text = labelText;
            [_labels addObject:label];
            [self addSubview:label];
        }
    }
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
}

-(void)strokeChart
{
    [self viewCleanupForCollection:_bars];
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 20.0;
    NSInteger index = 0;

    for (NSString * valueString in _yValues) {
        float value = [valueString floatValue];

        float grade = (float)value / (float)_yValueMax;
        PNBar * bar;
        if (_showLabel) {
            bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight - 30.0, _xLabelWidth * 0.5, chartCavanHeight)];
        }else{
            bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), self.frame.size.height - chartCavanHeight , _xLabelWidth * 0.8, chartCavanHeight)];
        }
        bar.backgroundColor = _barBackgroundColor;
        bar.barColor = [self barColorAtIndex:index];
        bar.grade = grade;
        bar.pDelegate = self;
        [_bars addObject:bar];
        [self addSubview:bar];

        index += 1;
    }
}

- (void)viewCleanupForCollection:(NSMutableArray*)array
{
    if (array.count) {
        [array makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [array removeAllObjects];
    }
}

#pragma mark - Class extension methods

- (UIColor *)barColorAtIndex:(NSUInteger)index
{
    if ([self.strokeColors count] == [self.yValues count]) {
        return [self lighterColorForColor:(UIColor*) [self.strokeColors objectAtIndex:index]];//self.strokeColors[index];
    } else {
        return self.strokeColor;
    }
}

#pragma mark - 
#pragma mark - PNBar delegate

- (void) clickedBar:(id)bar
{
    int nIndex = 0;
    
    for (int i = 0; i < _bars.count; i++ )
    {
        PNBar * _bar = (PNBar*) [_bars objectAtIndex:i];
        
        if ( self.strokeColors.count == self.yValues.count )  // existing the stroke colors
            _bar.barColor = [self lighterColorForColor:(UIColor*) [self.strokeColors objectAtIndex:i]];
        else
            _bar.barColor = APP_COLOR_LIGHT_BLUE;
        
        if ( _bar == bar )
        {
            _bar.barColor = (UIColor*) [self.strokeColors objectAtIndex:i];
            nIndex = i;
        }
        
    }
    
    if ( pDelegate )
    {
        [pDelegate onClickBarWithIndex:nIndex];
    }
}

#pragma mark - Utilities

- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
