//
//  ViewController.m
//  CULoadMoreViewExample
//
//  Created by yg curer on 13-1-26.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) CULoadMoreView *loadMoreView;

@end

@implementation ViewController
@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.loadMoreView = [[[CULoadMoreView alloc] initWithScrollView:self.tableView
                                                           delegate:self] autorelease];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    self.loadMoreView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [tableView release];
    self.loadMoreView = nil;
    
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:identify] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%d", indexPath.row];
    
    return cell;
}

#pragma mark -
#pragma mark CULoadMoreViewDelegate Methods

- (void)loadMoreTableFooterDidTriggerRefresh:(CULoadMoreView *)loadMoreView {
    
    [self.loadMoreView startLoading];
    
    [self.loadMoreView finishLoading];
}

@end
