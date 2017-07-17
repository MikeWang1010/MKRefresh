//
//  MKFooterRefreshView.m
//  MKRefresh
//
//  Created by MikeWang on 2016/11/23.
//  Copyright © 2016年 MikeWang. All rights reserved.
//


typedef  enum {
    MKRefreshViewStatusNomarl,//正常状态
    MKRefreshViewStatusPulling,//拉
    MKRefreshViewStatusRefreshing//刷新
    
}MKRefreshViewStatus;

#import "MKFooterRefreshView.h"

@interface MKFooterRefreshView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) MKRefreshViewStatus currentStatus;
@property (nonatomic, strong) UIScrollView *superScrollView;
@property (nonatomic, strong) UIActivityIndicatorView *activiView;
@end

@implementation MKFooterRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect newRect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
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

- (void)stopRefresh {
    if (self.currentStatus == MKRefreshViewStatusRefreshing) {
        self.currentStatus = MKRefreshViewStatusNomarl;
        [UIView animateWithDuration:0.25 animations:^{
           self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom - 60, self.superScrollView.contentInset.right);
        }];
    }
    
}

- (void)dealloc {
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];//移除KVO
    [self.superScrollView removeObserver:self forKeyPath:@"contentSize"];//移除KVO
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView *)newSuperview;
        
        //KVO监听父控件的滚动
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
        [self.superScrollView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        if ([self.superScrollView isDragging]) {
            if((self.superScrollView.contentOffset.y + self.superScrollView.frame.size.height < self.superScrollView.contentSize.height + 60) && self.currentStatus == MKRefreshViewStatusPulling) {
                NSLog(@"normal");
                self.currentStatus = MKRefreshViewStatusNomarl;
            }else if ((self.superScrollView.contentOffset.y + self.superScrollView.frame.size.height >= self.superScrollView.contentSize.height + 60)&& self.currentStatus == MKRefreshViewStatusNomarl) {
                NSLog(@"pulling");
                self.currentStatus = MKRefreshViewStatusPulling;
            }
        }else {
            if (self.currentStatus == MKRefreshViewStatusPulling) {
                self.currentStatus = MKRefreshViewStatusRefreshing;
            }
        }
        
    }else if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"%f",self.superScrollView.contentSize.height);
        CGRect frame = self.frame;
        frame.origin.y = self.superScrollView.contentSize.height;
        self.frame = frame;
    }
}

- (void)setCurrentStatus:(MKRefreshViewStatus)currentStatus {
    _currentStatus = currentStatus;
    switch (_currentStatus) {
        case MKRefreshViewStatusNomarl:
        {
            [self.activiView stopAnimating];
            self.activiView.hidden = YES;
            self.titleLabel.text = @"上拉加载更多";
            self.iconImageView.hidden = NO;
            self.iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case MKRefreshViewStatusPulling:
        {
            self.titleLabel.text = @"释放加载";
            self.iconImageView.transform = CGAffineTransformIdentity;
        }
            break;
        case MKRefreshViewStatusRefreshing:
        {
            self.titleLabel.text = @"正在加载...";
            self.iconImageView.hidden = YES;
            self.activiView.hidden = NO;
            [self.activiView startAnimating];
            
            [UIView animateWithDuration:0.25 animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(self.superScrollView.contentInset.top, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom + 60, self.superScrollView.contentInset.right);
            }];
            if(self.refreshMoreData) {
                self.refreshMoreData();
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
        _iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
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
        _titleLabel.text = @"上拉加载更多";
    }
    return _titleLabel;
}
@end
