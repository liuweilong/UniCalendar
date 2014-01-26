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

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define redColor UIColorFromRGB(0x850000)

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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
    self.dayPicker.bottomBorderColor = redColor;
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
    
    //set the day picker to be today
    NSDate *today = [NSDate date];
    today = [self dateAtBeginningOfDayForDay:today];
    NSDate *startDate = [self dateByAddingYears:-1 toDate:today];
    NSDate *endDate = [self dateByAddingYears:1 toDate:today];
    
    //set the startDate and endDate of the table view
//    NSCalendar *cal = [[NSCalendar alloc] init];
//    NSDateComponents *todayComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
//    NSDateComponents *startDayComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:startDate];
//    NSDateComponents *endDayComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:endDate];
    
    [self.dayPicker setStartDate:startDate endDate:endDate];
    [self.dayPicker setCurrentDate:today animated:NO];
    
//    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.frame.size.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.frame.size.height);
    
    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.dayCellSize.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.dayCellSize.height);
    self.title = @"Calendar";
    
    //Date formatter initialization
    _sectionDateFormatter = [[NSDateFormatter alloc] init];
    _sectionDateFormatter.dateStyle = NSDateFormatterLongStyle;
    _sectionDateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    _cellDateFormatter = [[NSDateFormatter alloc] init];
    _cellDateFormatter.dateStyle = NSDateFormatterNoStyle;
    _cellDateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    NSDate *now = [NSDate date];
    
    //set the startDate and endDate of the table view
    NSDate *eventStartDate = [self dateAtBeginningOfDayForDay:now];
    NSDate *eventEndDate = [self dateByAddingYears:1 toDate:eventStartDate];
    
    //get all events from current events store within startdate and enddate
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    NSPredicate *searchPredicate = [eventStore predicateForEventsWithStartDate:eventStartDate endDate:eventEndDate calendars:nil];
    NSArray *events = [eventStore eventsMatchingPredicate:searchPredicate];
    
    self.sections = [NSMutableDictionary dictionary];
    for (EKEvent *event in events) {
        //reduce the event date to date components (year, month, day)
        NSDate *eventDate = [self dateAtBeginningOfDayForDay:event.startDate];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:eventDate];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            [self.sections setObject:eventsOnThisDay forKey:eventDate];
        }
        
        [eventsOnThisDay addObject:event];
    }
    
    //Created a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
}

- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@ month%@ year%@",day.day, day.month, day.year);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //[self.tableData addObject:day];
//  NSDate *now = [NSDate dateFromDay:[day.day integerValue] month:[day.month integerValue] year:[day.year integerValue]];
    NSDate *today = [NSDate date];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];
    
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = dateComps.year;
    nowComponents.month = dateComps.month;
    nowComponents.day = [day.day integerValue];
    
    NSDate *now = [calendar dateFromComponents:nowComponents];
    
    //set the startDate and endDate of the table view
    NSDate *startDate = [self dateAtBeginningOfDayForDay:now];
    NSDate *endDate = [self dateByAddingYears:1 toDate:startDate];
    
    //get all events from current events store within startdate and enddate
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    NSPredicate *searchPredicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:nil];
    NSArray *events = [eventStore eventsMatchingPredicate:searchPredicate];
    
    self.sections = [NSMutableDictionary dictionary];
    for (EKEvent *event in events) {
        //reduce the event date to date components (year, month, day)
        NSDate *eventDate = [self dateAtBeginningOfDayForDay:event.startDate];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *eventsOnThisDay = [self.sections objectForKey:eventDate];
        if (eventsOnThisDay == nil) {
            eventsOnThisDay = [NSMutableArray array];
            [self.sections setObject:eventsOnThisDay forKey:eventDate];
        }
        
        [eventsOnThisDay addObject:event];
    }
    
    //Created a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    
    [self.tableView reloadData];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"Will select day %@",day.day);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [_sortedDays objectAtIndex:section];
    return [[_sections objectForKey:dateRepresentingThisDay] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDate *date = [_sortedDays objectAtIndex:section];
    return [_sectionDateFormatter stringFromDate:date];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    EKEvent *event = [eventsOnThisDay objectAtIndex:indexPath.row];
    
    cell.textLabel.text = event.title;
    if (event.allDay) {
        cell.detailTextLabel.text = @"all day";
    } else {
        cell.detailTextLabel.text = [self.cellDateFormatter stringFromDate:event.startDate];
    }
    
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

