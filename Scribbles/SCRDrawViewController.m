//
//  SCRDrawViewController.m
//  Scribbles
//
//  Created by Eric Williams on 8/4/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import "SCRDrawViewController.h"

#import "SCRDrawView.h"

@interface SCRDrawViewController ()

@end

@implementation SCRDrawViewController

{
    UIButton * drawColorButton;
    UIButton * curlyDrawButton;
    UIButton * lineDrawbutton;
    UIButton * drawStyleButton;
    NSArray * colors;
    NSMutableArray * buttons;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.view = [[SCRDrawView alloc] initWithFrame:self.view.frame];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    
    NSArray * colors = @[
                         [UIColor colorWithRed:0.278f green:0.000f blue:0.565f alpha:1.0f], //purple
                         [UIColor colorWithRed:0.110f green:0.290f blue:0.796f alpha:1.0f], //blue
                         [UIColor colorWithRed:0.000f green:0.898f blue:0.788f alpha:1.0f], //cyan
                         [UIColor colorWithRed:0.000f green:0.984f blue:0.639f alpha:1.0f], //shamrock
                         [UIColor cyanColor],
                         [UIColor colorWithRed:0.996f green:0.922f blue:0.298f alpha:1.0f], //yellow
                         [UIColor colorWithRed:1.000f green:0.529f blue:0.184f alpha:1.0f], //orange
                         [UIColor colorWithRed:1.000f green:0.000f blue:0.384f alpha:1.0f], //red
                         ];
    
    for (UIColor * color in colors)
    {
    
        NSInteger index = [colors indexOfObject:color];
        CGFloat angleSize = (2 * M_PI)/colors.count;
        
        // figure out x and y
        
        UIButton * colorButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10 + (50 *index), 40, 40)];
        colorButton.backgroundColor = color;
        colorButton.layer.cornerRadius = 20;
        [colorButton addTarget:self action:@selector(changeLineColor:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:colorButton];
    }
}

-(void)changeLineColor:(UIButton *)button
{
    SCRDrawView * view = (SCRDrawView *)self.view;
    view.lineColor = button.backgroundColor;
    
    [view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)prefersStatusBarHidden {return YES;}

@end
