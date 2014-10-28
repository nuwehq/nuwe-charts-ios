//
//  NUBarChart.m
//  NuweScoreFramework
//
//  Created by Dev Mac on 10/19/14.
//  Copyright (c) 2014 Dimitar Plamenov. All rights reserved.
//

#import "NUBarChart.h"

@implementation NUBarChart
@synthesize barDataSource, barDelegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self ){
        
    }
    
    return self;
}

- (void) setupWithFrame:(CGRect)frame
{
    barChart = [[PNBarChart alloc] initWithFrame:frame];
    barChart.backgroundColor = [UIColor clearColor];
    barChart.pDelegate = self;
    barChart.showLabel = NO;
    
    [self addSubview:barChart];
}


- (void) reloadDialWithAnimation:(BOOL) animation
{
    
    
    if ( [barDataSource respondsToSelector:@selector(valuesOfYWithBarChart:)] )
    {
        NSArray* yValues = [barDataSource valuesOfYWithBarChart:self];
        [barChart setYValues:yValues];
    }
    
    if ( [barDataSource respondsToSelector:@selector(barColorsWithBarChart:)] )
    {
        NSArray* strokeColors = [barDataSource barColorsWithBarChart:self];
        [barChart setStrokeColors:strokeColors];
    }
    
    if ( [barDataSource respondsToSelector:@selector(maxYValueWithBarChart:)] )
    {
        int maxYValue = [barDataSource maxYValueWithBarChart:self];
        [barChart setYValueMax:maxYValue];
    }
    
    [barChart strokeChart];

}

#pragma mark - PNBarChart Delegates

- (void) onClickBarWithIndex:(int)_index
{
    if ( barDelegate )
        [barDelegate touchNUBar:self index:_index];
}



@end
