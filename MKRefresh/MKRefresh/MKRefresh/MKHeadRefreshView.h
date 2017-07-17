//
//  MKHeadRefreshView.h
//  MKRefresh
//
//  Created by MikeWang on 16/8/16.
//  Copyright © 2016年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKHeadRefreshView : UIView

@property (nonatomic, copy) void(^refresh)();

- (void)stopRefresh;

@end
