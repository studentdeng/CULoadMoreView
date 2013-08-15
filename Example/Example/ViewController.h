//
//  ViewController.h
//  Example
//
//  Created by curer on 8/15/13.
//  Copyright (c) 2013 curer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CULoadMoreView.h"

@interface ViewController : UIViewController <CULoadMoreViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
