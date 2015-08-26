//
//  RowItem.h
//  QL_Demo
//
//  Created by Xu Lian on 2015-08-25.
//  Copyright (c) 2015 QLD_Laoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface RowItem : NSObject <QLPreviewItem>
@property(retain) NSURL *remoteURL;
@property(retain) NSURL *localURL;
@property(retain) NSError *error;
@property(assign) BOOL gotImage;
@property(assign) BOOL downloading;

- (void)cancelDownload;
- (void)startDownload;

@end
