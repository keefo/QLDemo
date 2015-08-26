//
//  AppDelegate.m
//  QL_Demo
//
//  Created by yuedongkui on 15/8/24.
//  Copyright (c) 2015年 QLD_Laoyue. All rights reserved.
//

#import "AppDelegate.h"
#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>

@interface AppDelegate ()<NSTableViewDelegate, NSTableViewDataSource>
{
    NSMutableArray *array;
    NSURL *preview_image_url;
}
@property (weak) IBOutlet NSTableView *table;
@property (strong) QLPreviewPanel *previewPanel;

@property (weak) IBOutlet NSWindow *window;
@end



@implementation AppDelegate

- (void)addLink:(NSString*)link
{
    [array addObject:[NSURL URLWithString:link]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    array = [[NSMutableArray alloc] init];
    [self addLink:@"http://pic9.nipic.com/20100826/1201941_094030072844_2.jpg"];
    [self addLink:@"http://www.jydoc.com/uploads/jydoc/2009-08-01/2009080110280411253.jpg"];
    [self addLink:@"http://image.tianjimedia.com/uploadImages/2012/009/V3CB7C778D1A.jpg"];
    [self addLink:@"http://images.ccoo.cn/ablum/20120131/20120131154010913.jpg"];
    [self addLink:@"http://tong.visitkorea.or.kr/images/wallpaper/2012/chs/12_56_1024x768_02.jpg"];
    _table.usesAlternatingRowBackgroundColors = YES;
    [_table reloadData];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    
}

- (void)togglePreviewPanel:(id)previewPanel
{
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible])
    {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    }
    else
    {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}

#pragma mark - 
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return array.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return array[row];
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([_table selectedRow]!=NSNotFound) {
        preview_image_url =array[[_table selectedRow]];
        [self.previewPanel reloadData];
    }
}



#pragma mark - Quick Look panel support

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document is now responsible of the preview panel
    // It is allowed to set the delegate, data source and refresh panel.
    //
    _previewPanel = panel;
    panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    // This document loses its responsisibility on the preview panel
    // Until the next call to -beginPreviewPanelControl: it must not
    // change the panel's delegate, data source or refresh it.
    //
    _previewPanel = nil;
}


#pragma mark - QLPreviewPanelDataSource

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
{
    return preview_image_url;
}


#pragma mark - QLPreviewPanelDelegate

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event
{
    // redirect all key down events to the table view
    if ([event type] == NSKeyDown)
    {
        [self.table keyDown:event];
        return YES;
    }
    return NO;
}

// This delegate method provides the rect on screen from which the panel will zoom.
- (NSRect)previewPanel:(QLPreviewPanel *)panel sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item
{
    NSInteger index = [array indexOfObject:preview_image_url];
    NSLog(@"%@", item);
    NSLog(@"%lu", index);
    if (index == NSNotFound)
    {
        return NSZeroRect;
    }
    
    NSRect iconRect = [self.table frameOfCellAtColumn:0 row:index];
    
    // check that the icon rect is visible on screen
    NSRect visibleRect = [self.table visibleRect];
    
    if (!NSIntersectsRect(visibleRect, iconRect))
    {
        return NSZeroRect;
    }
    
    // convert icon rect to screen coordinates
    iconRect = [self.table convertRectToBase:iconRect];
    iconRect.origin = [[self.table window] convertBaseToScreen:iconRect.origin];
    
    return iconRect;
}

// this delegate method provides a transition image between the table view and the preview panel
//
- (id)previewPanel:(QLPreviewPanel *)panel transitionImageForPreviewItem:(id <QLPreviewItem>)item contentRect:(NSRect *)contentRect
{
//    DownloadItem *downloadItem = (DownloadItem *)item;
    
    return [NSImage imageNamed:@"aaa.png"];
}



@end
