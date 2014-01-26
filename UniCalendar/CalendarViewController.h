//
//  CalendarViewController.h
//  UniCalendar
//
//  Created by Liu Weilong on 26/1/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDayPicker.h"

@interface CalendarViewController : UIViewController <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;

@end
