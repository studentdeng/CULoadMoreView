CULoadMoreView
==============
#CULoadMoreView

Simple load more to  refresh view

Inspired By [LoadMoreTableFooterView](https://github.com/sishen/LoadMoreTableFooterView) 
and [SSPullToRefresh](https://github.com/soffes/sspulltorefresh)

Most of the codes are directly copied from their work.

## Example

	- (void)viewDidLoad
	{
	    [super viewDidLoad];

	    self.loadMoreView = [[[CULoadMoreView alloc] initWithScrollView:self.tableView
	                                                           delegate:self] autorelease];
	}

	- (void)viewDidUnload
	{
	    [self setTableView:nil];
	    self.loadMoreView = nil;
	    
	    [super viewDidUnload];
	}

	- (void)loadMoreTableFooterDidTriggerRefresh:(CULoadMoreView *)loadMoreView {
	    
	    [self.loadMoreView startLoading];
	    // load data...
	    [self.loadMoreView finishLoading];
	}
