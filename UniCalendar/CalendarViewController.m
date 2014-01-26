//
//  CalendarViewController.m
//  UniCalendar
//
//  Created by Liu Weilong on 26/1/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (NSDate *)dateAtBeginningOfDayForDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    dateComps.hour = 0;
    dateComps.minute = 0;
    dateComps.second = 0;
    
    return [calendar dateFromComponents:dateComps];
}
- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    
    return newDate;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableData = [@[] mutableCopy];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.dayNameLabelFontSize = 13.0f;
    self.dayPicker.dayLabelFontSize = 20.0f;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"EE"];
    
    /*
     *  You can set month, year using:
     *  self.dayPicker.month = 9;
     *  self.dayPicker.year = 2013;
     *  [self.dayPicker setActiveDaysFrom:1 toDay:30];
     *  [self.dayPicker setCurrentDay:15 animated:NO];
     *
     *  or set up date range:
     */
    
    [self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
    
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:3 month:10 year:2013] animated:NO];
    
    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.frame.size.height);
    self.title = @"Cal";
    
}

- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@",day.day);
    
    [self.tableData addObject:day];
    [self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"Will select day %@",day.day);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    MZDay *day = self.tableData[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",day.day];
    cell.detailTextLabel.text = day.name;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setDayPicker:nil];
    [super viewDidUnload];
}
@end

