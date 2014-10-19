//
//  XMCircleTypeView.m
//  XMCircleType
//
//  Created by Michael Teeuw on 07-01-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

#import "XMCircleTypeView.h"

@interface XMCircleTypeView ()

@property (nonatomic) CGPoint circleCenterPoint;
@property (strong,nonatomic) NSMutableDictionary *kerningCacheDictionary;

@end

@implementation XMCircleTypeView

#pragma mark - Subclassing

- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    self.circleCenterPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //Get the string size.
    CGSize stringSize = [self.text sizeWithAttributes:self.textAttributes];
    
    //If the radius not set, calculate the maximum radius.
    float radius = (self.radius <=0) ? [self maximumRadiusWithStringSize:stringSize andVerticalAlignment:self.verticalTextAlignment] : self.radius;
    
    //We store both radius and textRadius. Since we might need an
    //unadjusted radius for visual debugging.
    float textRadius = radius;
    
    //Handle vertical alignment bij adjusting the textRadius;
    if (self.verticalTextAlignment == XMCircleTypeVerticalAlignInside) {
        textRadius = textRadius - stringSize.height;
    } else if (self.verticalTextAlignment == XMCircleTypeVerticalAlignCenter) {
        textRadius = textRadius - stringSize.height/2;
    }
    
    //Calculate the angle per charater.
    self.characterSpacing = (self.characterSpacing > 0) ? self.characterSpacing : 1;
    float circumference = 2 * textRadius * M_PI;
    float anglePerPixel = M_PI * 2 / circumference * self.characterSpacing;
    
    //Set initial angle.
    float startAngle;
    if (self.textAlignment == NSTextAlignmentRight) {
        startAngle = self.baseAngle - (stringSize.width * anglePerPixel);
    } else if(self.textAlignment == NSTextAlignmentLeft) {
        startAngle = self.baseAngle;
    } else {
        startAngle = self.baseAngle - (stringSize.width * anglePerPixel/2);
    }
    
    //Set drawing context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set helper vars.
    float characterPosition = 0;
    NSString *lastCharacter;
    
    //Loop thru characters of string.
    for (NSInteger charIdx=0; charIdx<self.text.length; charIdx++) {
        
        //Set current character.
        NSString *currentCharacter = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:charIdx]];
        
        //Set currenct character size & kerning.
        CGSize stringSize = [currentCharacter sizeWithAttributes:self.textAttributes];
        float kerning = (lastCharacter) ? [self kerningForCharacter:currentCharacter afterCharacter:lastCharacter] : 0;
        
        //Add half of character width to characterPosition, substract kerning.
        characterPosition += (stringSize.width / 2) - kerning;
        
        //Calculate character Angle
        float angle = characterPosition * anglePerPixel + startAngle;
        
        //Calculate character drawing point.
        CGPoint characterPoint = CGPointMake(textRadius * cos(angle) + self.circleCenterPoint.x, textRadius * sin(angle) + self.circleCenterPoint.y);
        
        //Strings are always drawn from top left. Calculate the right pos to draw it on bottom center.
        CGPoint stringPoint = CGPointMake(characterPoint.x -stringSize.width/2 , characterPoint.y - stringSize.height);
        
        //Save the current context and do the character rotation magic.
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, characterPoint.x, characterPoint.y);
        CGAffineTransform textTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
        CGContextConcatCTM(context, textTransform);
        CGContextTranslateCTM(context, -characterPoint.x, -characterPoint.y);
        
        //Draw the character
        [currentCharacter drawAtPoint:stringPoint withAttributes:self.textAttributes];
        
        //If we need some visual debugging, draw the visuals.
        if (self.visualDebug) {
            //Show Character BoundingBox
            [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5] setStroke];
            [[UIBezierPath bezierPathWithRect:CGRectMake(stringPoint.x, stringPoint.y, stringSize.width, stringSize.height)] stroke];
            
            //Show character point
            [[UIColor blueColor] setStroke];
            [[UIBezierPath bezierPathWithArcCenter:characterPoint radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES] stroke];
        }
        
        //Restore context to make sure the rotation is only applied to this character.
        CGContextRestoreGState(context);
        
        //Add the other half of the character size to the character position.
        characterPosition += stringSize.width / 2;
        
        //Stop if we've reached one full circle.
        if (characterPosition * anglePerPixel >= M_PI*2) break;
        
        //store the currentCharacter to use in the next run for kerning calculation.
        lastCharacter = currentCharacter;
    }
    
    //If we need some visual debugging, draw the circle.
    if (self.visualDebug) {
        //Show Circle
        [[UIColor greenColor] setStroke];
        [[UIBezierPath bezierPathWithArcCenter:self.circleCenterPoint radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES] stroke];
        
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(self.circleCenterPoint.x, self.circleCenterPoint.y - radius)];
        [line addLineToPoint:CGPointMake(self.circleCenterPoint.x, self.circleCenterPoint.y + radius)];
        [line moveToPoint:CGPointMake(self.circleCenterPoint.x-radius, self.circleCenterPoint.y)];
        [line addLineToPoint:CGPointMake(self.circleCenterPoint.x+radius, self.circleCenterPoint.y)];
        [line stroke];
    }
}

#pragma mark - Private Functions

- (void)initialize
{
    self.verticalTextAlignment = XMCircleTypeVerticalAlignOutside;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning) name: UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)handleMemoryWarning
{
    [self clearKerningCache];
}

- (float)kerningForCharacter:(NSString *)currentCharacter afterCharacter:(NSString *)previousCharacter
{
    //Create a unique cache key
    NSString *kerningCacheKey = [NSString stringWithFormat:@"%@%@", previousCharacter, currentCharacter];
    
    //Look for kerning in the cache dictionary
    NSNumber *cachedKerning = [self.kerningCacheDictionary objectForKey:kerningCacheKey];
    
    //If kerning is found: return.
    if (cachedKerning) {
        return [cachedKerning floatValue];
    }

    //Otherwise, calculate.
    float totalSize = [[NSString stringWithFormat:@"%@%@", previousCharacter, currentCharacter] sizeWithAttributes:self.textAttributes].width;
    float currentCharacterSize = [currentCharacter sizeWithAttributes:self.textAttributes].width;
    float previousCharacterSize = [previousCharacter sizeWithAttributes:self.textAttributes].width;
    
    float kerning = (currentCharacterSize + previousCharacterSize) - totalSize;
    
    //Store kerning in cache.
    [self.kerningCacheDictionary setValue:@(kerning) forKey:kerningCacheKey];
    
    //Return kerning.
    return kerning;
}

- (float)maximumRadiusWithStringSize:(CGSize)stringSize andVerticalAlignment:(XMCircleTypeVerticalAlignment)verticalTextAlignment;
{
    float radius = (self.bounds.size.width <= self.bounds.size.height) ? self.bounds.size.width / 2: self.bounds.size.height / 2;
    
    if (verticalTextAlignment == XMCircleTypeVerticalAlignOutside) {
        radius = radius - stringSize.height;
    } else if (verticalTextAlignment == XMCircleTypeVerticalAlignCenter) {
        radius = radius - stringSize.height/2;
    }
    
    return radius;
}

#pragma mark - Public Functions

- (void)clearKerningCache
{
    self.kerningCacheDictionary = nil;
}

- (void)setColor:(UIColor *)color
{
    NSMutableDictionary *textAttributes = [self.textAttributes mutableCopy];
    [textAttributes setValue:color forKey:NSForegroundColorAttributeName];
    self.textAttributes = [textAttributes copy];
}

#pragma mark - Getters & Setters

-(NSMutableDictionary *)kerningCacheDictionary
{
    if (self.disableKerningCache) return nil;

    if (!_kerningCacheDictionary) _kerningCacheDictionary = [NSMutableDictionary new];
    return _kerningCacheDictionary;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self setNeedsDisplay];
}

- (void)setTextAttributes:(NSDictionary *)textAttributes
{
    _textAttributes = textAttributes;
    
    //since the characteristics of the font changed, we need to fluch the kerning cache.
    self.kerningCacheDictionary = nil;
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    [self setNeedsDisplay];
}

- (void) setVerticalTextAlignment:(XMCircleTypeVerticalAlignment)verticalTextAlignment
{
    _verticalTextAlignment = verticalTextAlignment;
    [self setNeedsDisplay];
}

-(void)setRadius:(float)radius
{
    _radius = radius;
    [self setNeedsDisplay];
}

- (void)setBaseAngle:(float)baseAngle
{
    _baseAngle = baseAngle;
    [self setNeedsDisplay];
}

- (void)setCharacterSpacing:(float)characterSpacing
{
    _characterSpacing = characterSpacing;
    [self setNeedsDisplay];
}

- (void)setVisualDebug:(BOOL)visualDebug
{
    _visualDebug = visualDebug;
    [self setNeedsDisplay];
}

@end
