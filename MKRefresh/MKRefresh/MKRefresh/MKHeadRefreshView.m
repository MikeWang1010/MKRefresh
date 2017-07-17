//
//  MKHeadRefreshView.m
//  MKRefresh
//
//  Created by MikeWang on 16/8/16.
//  Copyright © 2016年 MikeWang. All rights reserved.
//

#import "MKHeadRefreshView.h"

typedef  enum {
    MKRefreshViewStatusNomarl,//正常状态
    MKRefreshViewStatusPulling,//下拉
    MKRefreshViewStatusRefreshing//刷新
    
}MKRefreshViewStatus;

@interface MKHeadRefreshView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) MKRefreshViewStatus currentStatus;
@property (nonatomic, strong) UIScrollView *superScrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activiView;

@end

@implementation MKHeadRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
     CGRect newRect = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    if (self = [super initWithFrame:newRect]) {
        
        [self setupSubView];
        
    }
    return self;
}

- (void)setupSubView {
    self.backgroundColor = [UIColor brownColor];
    self.iconImageView.frame = CGRectMake(self.center.x  - 25, (self.frame.size.height - 22 ) * 0.5, 22, 22);
    self.activiView.center = CGPointMake(self.center.x - 25, self.frame.size.height * 0.5);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, (self.frame.size.height - 16) * 0.5, 100, 16);
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.activiView];

}

- (void)dealloc {
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];//移除KVO
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView *)newSuperview;
        
        //KVO监听父控件的滚动
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
    }
}

- (void)stopRefresh {
    if (self.currentStatus == MKRefreshViewStatusRefreshing) {
        self.currentStatus = MKRefreshViewStatusNomarl;
        [UIView animateWithDuration:0.25 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top - 60, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
        }];    }

}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
//        NSLog(@"%f",self.superScrollView.contentOffset.y);
        if (self.superScrollView.isDragging) {
            CGFloat normalPullingOffset = -124;
            if (self.currentStatus == MKRefreshViewStatusPulling && self.superScrollView.contentOffset.y > normalPullingOffset) {
                NSLog(@"切换到normal");
                self.currentStatus = MKRefreshViewStatusNomarl;
            }else if (self.currentStatus == MKRefreshViewStatusNomarl && self.superScrollView.contentOffset.y < normalPullingOffset) {
                NSLog(@"切换到Pulling");
                self.currentStatus = MKRefreshViewStatusPulling;
            }
        }else {//手松开
            if (self.currentStatus == MKRefreshViewStatusPulling) {
                 NSLog(@"切换到refreshing");
                self.currentStatus = MKRefreshViewStatusRefreshing;
            }
        }
    }
}

- (void)setCurrentStatus:(MKRefreshViewStatus)currentStatus {
    _currentStatus = currentStatus;
    switch (_currentStatus) {
        case MKRefreshViewStatusNomarl:
        {
            [self.activiView stopAnimating];
            self.activiView.hidden = YES;
            self.titleLabel.text = @"下拉刷新";
            self.iconImageView.hidden = NO;
            self.iconImageView.transform = CGAffineTransformIdentity;
        }
            break;
            case MKRefreshViewStatusPulling:
        {
             self.titleLabel.text = @"释放刷新";
            self.iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
            break;
            case MKRefreshViewStatusRefreshing:
        {
            self.titleLabel.text = @"正在刷新...";
            self.iconImageView.hidden = YES;
            self.activiView.hidden = NO;
            [self.activiView startAnimating];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top + 60, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
            }];
            if (self.refresh) {
                self.refresh();
            }
        }
            break;
        default:
            break;
    }
}


- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"down@3x"]];
    }
    return _iconImageView;
}

- (UIActivityIndicatorView *)activiView {
    if (!_activiView) {
        _activiView = [[UIActivityIndicatorView alloc]init];
        _activiView.hidden = YES;
    }
    return _activiView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.text = @"下拉刷新";
    }
    return _titleLabel;
}
@end
