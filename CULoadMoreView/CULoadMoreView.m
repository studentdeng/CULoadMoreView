//
//  AppDelegate.h
//  CULoadMoreViewExample
//
//  Created by yg curer on 13-1-26.
//  Copyright (c) 2013年 curer. All rights reserved.


#import "CULoadMoreView.h"


#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

#define SCROLL_HEIGHT   260

@interface CULoadMoreView ()

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets defaultContentInset;
@property (nonatomic, assign) BOOL loading;

- (void)setState:(LoadMoreState)aState;

@end

@implementation CULoadMoreView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:15.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
				
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(150.0f, 20.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		self.hidden = YES;
        
        self.loading = NO;
		
		[self setState:LoadMoreNormal];
    }
	
    return self;	
}

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<CULoadMoreViewDelegate>)delegate
{
    CGSize rcSize = scrollView.frame.size;
    if (self = [self initWithFrame:CGRectMake(0, scrollView.contentSize.height, rcSize.width, rcSize.height)]) {
        self.delegate = delegate;
        self.scrollView = scrollView;
        [self.scrollView addSubview:self];
    }
    
    return self;
}

#pragma mark -
#pragma mark Setters

- (void)setState:(LoadMoreState)aState{	
	switch (aState) {
		case LoadMorePulling:
			_statusLabel.text = NSLocalizedString(@"释放刷新", @"释放刷新");
			break;
		case LoadMoreNormal:
			_statusLabel.text = NSLocalizedString(@"上拉更多...", @"上拉更多");
			_statusLabel.hidden = NO;
			[_activityView stopAnimating];
			break;
		case LoadMoreLoading:
			_statusLabel.hidden = YES;
			[_activityView startAnimating];
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void)setScrollView:(UIScrollView *)scrollView {
	if ([_scrollView respondsToSelector:@selector(removeObserver:forKeyPath:context:)]) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset" context:self];
	} else if (_scrollView) {
		[_scrollView removeObserver:self forKeyPath:@"contentOffset"];
	}
	
	_scrollView = scrollView;
	_defaultContentInset = _scrollView.contentInset;
	[_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:self];
}

#pragma mark - public 

- (void)startLoading
{
    self.loading = YES;
}

- (void)finishLoading
{
    if (!self.loading) {
        return;
    }
    
    self.loading = NO;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(loadMoreScrollViewDataSourceDidFinishedLoading)
                                               object:nil];
    [self performSelector:@selector(loadMoreScrollViewDataSourceDidFinishedLoading)
               withObject:nil
               afterDelay:.1f];
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView {
	if (_state == LoadMoreLoading) {
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
	} else if (scrollView.isDragging) {
        
        int maxHeight = scrollView.frame.size.height;
        int maxRefreshHeight = maxHeight - 60;
		
		if (_state == LoadMoreNormal
                && scrollView.contentOffset.y < (scrollView.contentSize.height - maxRefreshHeight)
                && scrollView.contentOffset.y > (scrollView.contentSize.height - maxHeight)
                && !_loading)
        {
			self.frame = CGRectMake(0, scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
			self.hidden = NO;
		} else if (_state == LoadMoreNormal && scrollView.contentOffset.y > (scrollView.contentSize.height - maxRefreshHeight) && !_loading) {
			[self setState:LoadMorePulling];
		} else if (_state == LoadMorePulling && scrollView.contentOffset.y < (scrollView.contentSize.height - maxRefreshHeight) && scrollView.contentOffset.y > (scrollView.contentSize.height - maxHeight) && !_loading) {
			[self setState:LoadMoreNormal];
		}
		
		if (scrollView.contentInset.bottom != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
	}
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView {
    
    int maxHeight = scrollView.frame.size.height;
    int maxRefreshHeight = maxHeight - 60;
	
	if (scrollView.contentOffset.y > (scrollView.contentSize.height - maxRefreshHeight) && !_loading) {
		if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)]) {
			[_delegate loadMoreTableFooterDidTriggerRefresh:self];
		}
		
		[self setState:LoadMoreLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
		[UIView commitAnimations];
	}
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:LoadMoreNormal];
	self.hidden = YES;
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != self) {
        return;
    }
    
    if (object != self.scrollView || ![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    int maxHeight = self.scrollView.frame.size.height;
    int maxRefreshHeight = maxHeight - 60;
    
    // Get the offset out of the change notification
	//CGFloat y = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y + _defaultContentInset.top;
    if (_state == LoadMoreLoading)
    {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    }
    else if (self.scrollView.isDragging)
    {
		if (_state == LoadMoreNormal
            && self.scrollView.contentOffset.y < (self.scrollView.contentSize.height - maxRefreshHeight)
            && self.scrollView.contentOffset.y > (self.scrollView.contentSize.height - maxHeight)
            && !_loading)
        {
			self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.frame.size.width, self.frame.size.height);
			self.hidden = NO;
		} else if (_state == LoadMoreNormal && self.scrollView.contentOffset.y > (self.scrollView.contentSize.height - maxRefreshHeight) && !_loading) {
			[self setState:LoadMorePulling];
		} else if (_state == LoadMorePulling && self.scrollView.contentOffset.y < (self.scrollView.contentSize.height - maxRefreshHeight) && self.scrollView.contentOffset.y > (self.scrollView.contentSize.height - maxHeight) && !_loading) {
			[self setState:LoadMoreNormal];
		}
		
		if (self.scrollView.contentInset.bottom != 0) {
			self.scrollView.contentInset = UIEdgeInsetsZero;
		}
        
        return;
    }

    if (self.scrollView.contentOffset.y > (self.scrollView.contentSize.height - maxRefreshHeight) && !_loading
        && self.scrollView.contentSize.height > maxRefreshHeight)
    {
        
        if ([_delegate respondsToSelector:@selector(loadMoreTableFooterDidTriggerRefresh:)])
        {
            [_delegate loadMoreTableFooterDidTriggerRefresh:self];
        }
    
        [self setState:LoadMoreLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
    self.scrollView = nil;
    
    [super dealloc];
}


@end
