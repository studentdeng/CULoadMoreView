//
//  ViewController.m
//  Example
//
//  Created by curer on 8/15/13.
//  Copyright (c) 2013 curer. All rights reserved.
//

#import "ViewController.h"

#define MAX_COUNT   25

@interface ViewController ()

@property (nonatomic, strong) CULoadMoreView *loadMoreView;

@property (nonatomic, assign) int sumCount;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.loadMoreView = [[CULoadMoreView alloc] initWithScrollView:self.tableView
                                                           delegate:self];
    
    self.sumCount = 13;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sumCount;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cellId";
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:identify];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"row:%d", indexPath.row];
    
    return cell;
}

- (void)loadMoreTableFooterDidTriggerRefresh:(CULoadMoreView *)loadMoreView {
    
    [self.loadMoreView startLoading];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        int iStep = 3;
        if (self.sumCount <= MAX_COUNT - iStep) {
            self.sumCount += 3;
        }
        
        [self.tableView reloadData];
        [self.loadMoreView finishLoading];
    });
    
    
}

@end
