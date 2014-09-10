//
//  SCRLineWithSlider.h
//  Scribbles
//
//  Created by Eric Williams on 8/5/14.
//  Copyright (c) 2014 Eric Williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCRLineWithSliderDelegate;

@interface SCRLineWithSlider : UIView

@property (nonatomic) float maxWidth;
@property (nonatomic) float minWidth;
@property (nonatomic) float currentWidth;

//potentially will use to change slider color based on selected color
@property (nonatomic) UIColor * lineColor;

@property (nonatomic, assign)id <SCRLineWithSliderDelegate> delegate;


@end


@protocol SCRLineWithSliderDelegate <NSObject>

- (void)updateLineWidth: (float)lineWidth;

@end