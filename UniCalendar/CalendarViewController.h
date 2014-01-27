//
//  CalendarViewController.h
//  UniCalendar
//
//  Created by Liu Weilong on 26/1/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "MZDayPicker.h"

@interface CalendarViewController : UIViewController <MZDayPickerDelegate, MZDayPickerDataSource, UITableViewDataSource, UITableViewDelegate, EKEventEditViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (nonatomic, strong) EKCalendar *defaultCalendar;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic,strong) NSMutableArray *tableData;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;
@property (strong, nonatomic) NSDateFormatter *titleDateFormatter;

- (NSDate *)dateAtBeginningOfDayForDay:(NSDate *)date;
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate;

@end
