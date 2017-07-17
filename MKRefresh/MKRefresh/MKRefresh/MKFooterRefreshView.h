//
//  MKFooterRefreshView.h
//  MKRefresh
//
//  Created by MikeWang on 2016/11/23.
//  Copyright © 2016年 MikeWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKFooterRefreshView : UIView

@property (nonatomic, copy) void(^refreshMoreData)();

- (void)stopRefresh;
@end
