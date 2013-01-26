//
//  AppDelegate.h
//  CULoadMoreViewExample
//
//  Created by yg curer on 13-1-26.
//  Copyright (c) 2013年 curer. All rights reserved.

#import <UIKit/UIKit.h>

typedef enum{
	LoadMorePulling = 0,
	LoadMoreNormal,
	LoadMoreLoading,	
} LoadMoreState;

@protocol CULoadMoreViewDelegate;
@interface CULoadMoreView : UIView {
	id _delegate;
	LoadMoreState _state;
	
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic,assign) id <CULoadMoreViewDelegate> delegate;

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<CULoadMoreViewDelegate>)delegate;
- (void)startLoading;
- (void)finishLoading;

@end

@protocol CULoadMoreViewDelegate
- (void)loadMoreTableFooterDidTriggerRefresh:(CULoadMoreView *)view;
@end
