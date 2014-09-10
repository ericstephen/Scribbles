//
//  SCRDrawViewController.m
//  Scribbles
//
//  Created by Eric Williams on 8/4/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "SCRDrawViewController.h"

#import "SCRDrawView.h"

#import "SCRLineWithSlider.h"

@interface SCRDrawViewController () <SCRLineWithSliderDelegate>

@end

   UIButton * resetButton;

@implementation SCRDrawViewController
{
    NSMutableArray * colors;
    NSMutableArray * buttons;
    UIButton * drawColorButton;
    UIButton * freeButton;
    UIButton * lineButton;
    UIButton * drawStyleButton;
    UIImage * freeDrawImage;
    UIImage * lineDrawImage;

    UIView *lineWidthSize;
    
    BOOL colorChoicesOpen;
    
    SCRLineWithSlider * lineSlider;
    
}

// add reset button
// should clear scren of scribbles
// hint: remove something from drawView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        buttons = [@[] mutableCopy];
        self.view = [[SCRDrawView alloc] initWithFrame:self.view.frame];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    colors = [@[
                [UIColor colorWithRed:0.000f green:0.898f blue:0.788f alpha:1.0f], //cyan
                [UIColor colorWithRed:0.000f green:0.984f blue:0.639f alpha:1.0f], //shamrock
                [UIColor colorWithRed:0.800f green:0.992f blue:0.204f alpha:1.0f], //lime green
                [UIColor colorWithRed:0.996f green:0.922f blue:0.298f alpha:1.0f], //yellow
                [UIColor colorWithRed:1.000f green:0.529f blue:0.184f alpha:1.0f], //orange
                [UIColor colorWithRed:1.000f green:0.000f blue:0.384f alpha:1.0f], //red
                [UIColor colorWithRed:0.278f green:0.000f blue:0.565f alpha:1.0f], //purple
                [UIColor colorWithRed:0.110f green:0.290f blue:0.796f alpha:1.0f], //blue
                ]mutableCopy];
    
    
    drawColorButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 57) / 2.0, SCREEN_HEIGHT - 101, 48, 48)];
    drawColorButton.layer.cornerRadius = 24;
    drawColorButton.backgroundColor = colors[0];
    [drawColorButton addTarget:self action:@selector(showColorChoices) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:drawColorButton];
    
    self.view.lineColor = colors [0];
    
    
    drawStyleButton = [[UIButton alloc] initWithFrame:CGRectMake(251, 465, 48, 48)];
    drawStyleButton.backgroundColor = [UIColor clearColor];
    drawStyleButton.layer.borderColor = [UIColor blackColor].CGColor;
    drawStyleButton.layer.borderWidth = 2;
    drawStyleButton.layer.cornerRadius = 24;
    
    [self.view addSubview:drawStyleButton];
    
    
    freeButton = [[UIButton alloc] initWithFrame:CGRectMake(259, 428, 30, 30)];
    freeButton.backgroundColor = [UIColor whiteColor];
    freeButton.layer.cornerRadius = 15;
    freeDrawImage = [UIImage imageNamed:@"scribble_button"];
    [freeButton setImage:freeDrawImage forState:UIControlStateNormal];
    [freeButton addTarget:self action:@selector(changeDrawToScribble) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:freeButton];
    
    
    lineButton = [[UIButton alloc] initWithFrame:CGRectMake(259, 391, 30, 30)];
    lineButton.backgroundColor = [UIColor whiteColor];
    lineButton.layer.cornerRadius = 15;
    lineDrawImage = [UIImage imageNamed:@"lines_button"];
    [lineButton setImage:lineDrawImage forState:UIControlStateNormal];
    [lineButton addTarget:self action:@selector(changeDrawToLine) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:lineButton];
    
    
    lineWidthSize = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
    lineWidthSize.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:lineWidthSize];
    
    
    UIButton * resetButton = [[UIButton alloc]initWithFrame:CGRectMake(251, SCREEN_HEIGHT - 550, 48, 48)];
    resetButton.backgroundColor = [UIColor lightGrayColor];
    resetButton.layer.cornerRadius = 24;
    [resetButton addTarget:self action:@selector(resetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:resetButton];

    
    UIButton * openLineWidthSlider = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 60, 40, 40)];
    openLineWidthSlider.layer.cornerRadius = 20;
    openLineWidthSlider.layer.borderColor = [UIColor blackColor].CGColor;
    openLineWidthSlider.layer.borderWidth = 1.0;
    [openLineWidthSlider addTarget:self action:@selector(openSlider) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:openLineWidthSlider];
    
    lineWidthSize.center = openLineWidthSlider.center;
    
    //defining the bounds of the color wheel to properly display a circle of colors to choose from
    
}

-(void)openSlider
{
    // this if statement will remove an instance of lineslider so that it does not duplicate on the screen
    if (lineSlider)
    {
        [lineSlider removeFromSuperview];
        lineSlider = nil;
        
        return;
    }
    
    lineSlider = [[SCRLineWithSlider alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 280, 40, 200)];
    lineSlider.currentWidth = self.view.lineWidth;
    lineSlider.delegate = self;
    
    [self.view addSubview:lineSlider];
}

-(void)changeLineColor:(UIButton*)button
{
    
    self.view.lineColor = drawColorButton.backgroundColor = button.backgroundColor;
    [self hideColorChoices];
}

-(void)updateLineWidth:(float)lineWidth
{
    self.view.lineWidth = lineWidth;
    
    CGPoint center = lineWidthSize.center;
    lineWidthSize.frame = CGRectMake(0, 0, lineWidth * 2, lineWidth *2);
    lineWidthSize.center = center;
    lineWidthSize.layer.cornerRadius = lineWidth;
}

-(void)showColorChoices
{
    if (colorChoicesOpen)
    {
        [self hideColorChoices];
        return;
    }
    
    for (UIColor * color in colors)
    {
        NSInteger index = [colors indexOfObject:color];
        UIButton * colorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        colorButton.backgroundColor = color;
        colorButton.center = drawColorButton.center;
        colorButton.layer.cornerRadius = 15;
        [colorButton addTarget:self action:@selector(changeLineColor:)forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:colorButton];
        
        
        int radius = 60;
        float mpi = M_PI/180;
        float angle = 360 / colors.count;
        float radians = angle * mpi;
        
        float moveX = drawColorButton.center.x + sinf(radians * index) * radius;
        float moveY = drawColorButton.center.y + cosf(radians * index) * radius;
        
        [UIView animateWithDuration:0.2 delay:0.05 * index options: UIViewAnimationOptionAllowUserInteraction animations:^{
            
            colorButton.center = CGPointMake(moveX, moveY);
        } completion:^(BOOL finished) {
            
        }];
        
        [self.view insertSubview:colorButton atIndex:0];
    }
    
    colorChoicesOpen = YES;
}
-(void)hideColorChoices
{
    for (UIButton * colorButton in buttons)
    {
        NSInteger index = [buttons indexOfObject:colorButton];
        
        [UIView animateWithDuration:0.2 delay:0.05 * index options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            colorButton.center = drawColorButton.center;
            
        } completion:^(BOOL finished) {
            
            [colorButton removeFromSuperview];
        }];
        
    }
    [buttons removeAllObjects];
    colorChoicesOpen = NO;
}



-(void)changeDrawToScribble
{
    [drawStyleButton setImage:freeDrawImage forState:UIControlStateNormal];
    self.view.drawStyle = YES;
    
}

-(void)changeDrawToLine
{
    [drawStyleButton setImage:lineDrawImage forState:UIControlStateNormal];
    self.view.drawStyle = NO;
}


-(BOOL)prefersStatusBarHidden {return YES;}


@end