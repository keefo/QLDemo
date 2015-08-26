//
//  CustomTableView.m
//  QL_Demo
//
//  Created by yuedongkui on 15/8/25.
//  Copyright (c) 2015年 QLD_Laoyue. All rights reserved.
//

#import "CustomTableView.h"
#import "AppDelegate.h"

@implementation CustomTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSString *key = [theEvent charactersIgnoringModifiers];
    if ([key isEqual:@" "])
    {
        [(AppDelegate*)[NSApp delegate] togglePreviewPanel:self];
    }
    else
    {
        [super keyDown:theEvent];
    }
}

@end
