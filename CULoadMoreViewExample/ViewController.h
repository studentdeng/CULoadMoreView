//
//  ViewController.h
//  CULoadMoreViewExample
//
//  Created by yg curer on 13-1-26.
//  Copyright (c) 2013年 curer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CULoadMoreView.h"

@interface ViewController : UIViewController
<CULoadMoreViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;



@end
