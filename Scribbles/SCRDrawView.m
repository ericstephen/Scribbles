//
//  SCRDrawView.m
//  Scribbles
//
//  Created by Eric Williams on 8/4/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "SCRDrawView.h"

@implementation SCRDrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // if you do not alloc and init the array nothing can be added (must use code below)
        self.scribbles = [@[] mutableCopy];
        self.lineWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        self.lineColor = [UIColor darkGrayColor];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // this grabs our context layer to draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // this sets stroke or fill colors that follow
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    for (NSDictionary * scribble in self.scribbles)
    {
        CGContextSetLineWidth(context, [scribble[@"width"] intValue]);
        
        NSArray * points = scribble[@"points"];
        
        UIColor * lineColor = scribble[@"color"];
        
        [lineColor set];
        
        if (points.count > 0)
        {
            CGPoint startPoint = [points[0] CGPointValue];
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        };
        
        for (NSValue * pointVal in points)
        {
            CGPoint point = [pointVal CGPointValue];
            CGContextAddLineToPoint(context, point.x, point.y);
        }
        
        // this draws the text
        CGContextStrokePath(context);
    }
    
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.currentScribble = [@{
                              @"color": self.lineColor,
                              @"points": [@[] mutableCopy],
                              @"width": @(self.lineWidth)
                              } mutableCopy];
    
    [self.scribbles addObject:self.currentScribble];
    
    if (self.drawStyle)
    {
        [self scribbleWithTouches:touches];
        
    } else {
        
        UITouch * touch = [touches allObjects][0];
        CGPoint location = [touch locationInView:self];
        self.currentScribble[@"points"][0] = [NSValue valueWithCGPoint:location];
        
        [self setNeedsDisplay];
    }
    
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
{
    
    if (self.drawStyle)
    {
        [self scribbleWithTouches:touches];
        
    } else {
        
        UITouch * touch = [touches allObjects][0];
        CGPoint location = [touch locationInView:self];
        
        self.currentScribble[@"points"][1] = [NSValue valueWithCGPoint:location];
        
        [self setNeedsDisplay];
    }
    
}

- (void)scribbleWithTouches: (NSSet *)touches
{
    for (UITouch * touch in touches)
    {
        CGPoint location = [touch locationInView:self];
        
        [self.currentScribble[@"points"] addObject:[NSValue valueWithCGPoint:location]];
        
    }
    
    [self setNeedsDisplay];
}

@end
