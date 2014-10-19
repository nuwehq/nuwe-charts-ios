//
//  ViewController.m
//  TestNuweScoreFramework
//
//  Created by Dev Mac on 10/14/14.
//  Copyright (c) 2014 Dimitar Plamenov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize BigDialChart, TopDialChart1, TopDialChart2, BottomDialChart1, BottomDialChart2, BottomDialChart3;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void) viewDidAppear:(BOOL)animated
{
    // initialize part ******************************* */
    
    [BigDialChart setupWithCount:3 TotalValue:100];
    [BigDialChart setChartDataSource:self];
    [BigDialChart setChartDelegate:self];
    [BigDialChart reloadDialWithAnimation:YES];
    
    /* ************************************************* */
    
    // initialize part ******************************* */
    
    [TopDialChart1 setupWithCount:4 TotalValue:100];
    [TopDialChart1 setChartDataSource:self];
    [TopDialChart1 setChartDelegate:self];
    [TopDialChart1 reloadDialWithAnimation:YES];
    
    /* ************************************************* */

    // initialize part ******************************* */
    
    [TopDialChart2 setupWithCount:5 TotalValue:100];
    [TopDialChart2 setChartDataSource:self];
    [TopDialChart2 setChartDelegate:self];
    [TopDialChart2 reloadDialWithAnimation:YES];
    
    /* ************************************************* */
    
    // initialize part ******************************* */
    
    [BottomDialChart1 setupWithCount:1 TotalValue:100];
    [BottomDialChart1 setChartDataSource:self];
    [BottomDialChart1 setChartDelegate:self];
    [BottomDialChart1 reloadDialWithAnimation:YES];
    
    /* ************************************************* */
    
    // initialize part ******************************* */
    
    [BottomDialChart2 setupWithCount:2 TotalValue:100];
    [BottomDialChart2 setChartDataSource:self];
    [BottomDialChart2 setChartDelegate:self];
    [BottomDialChart2 reloadDialWithAnimation:YES];
    
    /* ************************************************* */
    // initialize part ******************************* */
    
    [BottomDialChart3 setupWithCount:1 TotalValue:100];
    [BottomDialChart3 setChartDataSource:self];
    [BottomDialChart3 setChartDelegate:self];
    [BottomDialChart3 reloadDialWithAnimation:YES];
    
    /* ************************************************* */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma NUDialChart Datasource
- (NSNumber*) dialChart:(NUDialChart*) dialChart valueOfCircleAtIndex:(int) _index
{
    NSInteger randomNumber = arc4random() % 100;
    return [NSNumber numberWithInteger:randomNumber];
}

/* Get a color of specific dial by index
 @param : Index of specific dial
 @return : Color of the dial
 */
- (UIColor* ) dialChart:(NUDialChart*) dialChart colorOfCircleAtIndex:(int) _index
{
    return [UIColor colorWithRed:(float)(arc4random() % 255) / 255.0f green:(float)(arc4random() % 255) / 255.0f blue:(float)(arc4random() % 255) / 255.0f alpha:1.0f];
}

/* Get a text of specific dial by index
 @param : Index of specific dial
 @return : Text of the dial
 */ // It's for just Nutribu
- (NSString* ) dialChart:(NUDialChart*) dialChart textOfCircleAtIndex:(int) _index
{
    return [NSString stringWithFormat:@"test message"];
}

- (UIColor* ) dialChart:(NUDialChart*) dialChart textColorOfCircleAtIndex:(int) _index
{
    
    return [UIColor whiteColor];
}


/* Show center label and text
 @param : No params
 @return : Is show center label?
 */
- (BOOL) isShowCenterLabelInDial:(NUDialChart*) dialChart
{
    if ( dialChart == BottomDialChart1 || dialChart == BottomDialChart3)
        return NO;
    return YES;
}

/* Show only border of dial
 @param : Index of specific dial
 @return : Is only frame of dial?
 */
- (BOOL) dialChart:(NUDialChart*) dialChart defaultCircleAtIndex:(int) _index
{
    if ( _index == 1 )
        return YES;
    
    return NO;
}

/* Get current nuscore
 @param : No params
 @return : NU score
 */
- (int) nuscoreInDialChart:(NUDialChart*) dialChart
{
    return (arc4random() % 100);
}

- (UIColor*) centerBackgroundColorInDialChart:(NUDialChart *)dialChart
{
    return [UIColor blueColor];
}

- (UIColor*) centerTextColorInDialChart:(NUDialChart *)dialChart
{
    return [UIColor whiteColor];
}


#pragma mark - NUDialChart Delegate

- (void) touchNuDialChart:(NUDialChart *)chart
{
    if ( chart == BigDialChart ){
        [BigDialChart reloadDialWithAnimation:YES];
        [TopDialChart1 reloadDialWithAnimation:YES];
        [TopDialChart2 reloadDialWithAnimation:YES];
        
        [BottomDialChart1 reloadDialWithAnimation:YES];
        [BottomDialChart2 reloadDialWithAnimation:YES];
        [BottomDialChart3 reloadDialWithAnimation:YES];
    }
}

@end