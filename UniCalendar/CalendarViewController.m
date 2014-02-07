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

#define redColor UIColorFromRGB(0x850000)
#define today [NSDate date]
#define currentCalendar [NSCalendar currentCalendar]
#define retreatEventTimeInterval 1
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


- (NSDate *)dateAtBeginningOfDayForDay:(NSDate *)date {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [currentCalendar setTimeZone:timeZone];
    
    NSDateComponents *dateComps = [currentCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    dateComps.hour = 0;
    dateComps.minute = 0;
    dateComps.second = 0;
    
    return [currentCalendar dateFromComponents:dateComps];
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate {
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [currentCalendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    
    return newDate;
}

- (void)resetDayPicker {
    NSDate *now = [self dateAtBeginningOfDayForDay:today];
    NSDate *startDate = [self dateByAddingYears:-retreatEventTimeInterval toDate:now];
    NSDate *endDate = [self dateByAddingYears:retreatEventTimeInterval toDate:now];
    
    [self.dayPicker setStartDate:startDate endDate:endDate];
    [self.dayPicker setCurrentDate:today animated:NO];
}

- (void)retreatEventsFrom:(EKEventStore *)eventStore from:(NSDate *)day to:(NSInteger) interval {
    //set the startDate and endDate of the table view
    NSDate *eventStartDate = [self dateAtBeginningOfDayForDay:day];
    NSDate *eventEndDate = [self dateByAddingYears:interval toDate:eventStartDate];
    
    //get all events from current events store within startdate and enddate
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dayPicker.delegate = self;
    self.dayPicker.dataSource = self;
    
#pragma mark changed the color/-----------------------
    self.dayPicker.bottomBorderColor = redColor;
    self.dayPicker.dayNameLabelFontSize = 13.0f;
    self.dayPicker.dayLabelFontSize = 20.0f;
    
    //Date formatter initialization
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"EE"];
    
    _sectionDateFormatter = [[NSDateFormatter alloc] init];
    [_sectionDateFormatter setDateFormat:@"EEEE, dd MMMM yyyy"];
    
    _cellDateFormatter = [[NSDateFormatter alloc] init];
    _cellDateFormatter.dateStyle = NSDateFormatterNoStyle;
    _cellDateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    _titleDateFormatter = [[NSDateFormatter alloc] init];
    [_titleDateFormatter setDateFormat:@"MMMM yyyy"];
//-----------------------------------------------------
    
    self.title = [_titleDateFormatter stringFromDate:today];
    
    //set the day picker to be today
    [self resetDayPicker];
    
    self.tableView.frame = CGRectMake(0, self.dayPicker.frame.origin.y + self.dayPicker.dayCellSize.height, self.tableView.frame.size.width, self.view.bounds.size.height-self.dayPicker.dayCellSize.height);
    
    //get all events from current events store within startdate and enddate
    _eventStore = [[EKEventStore alloc] init];
    [self retreatEventsFrom:_eventStore from:today to:retreatEventTimeInterval];
    [self.tableView reloadData];
}

- (NSString *)dayPicker:(MZDayPicker *)dayPicker titleForCellDayNameLabelInDay:(MZDay *)day
{
    return [self.dateFormatter stringFromDate:day.date];
}


- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSDateComponents *dateComps = [currentCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:day.date];
    
    NSDateComponents *nowComponents = [[NSDateComponents alloc] init];
    nowComponents.year = dateComps.year;
    nowComponents.month = dateComps.month;
    nowComponents.day = dateComps.day;
    
    NSDate *now = [currentCalendar dateFromComponents:nowComponents];
    
    [self retreatEventsFrom:_eventStore from:now to:retreatEventTimeInterval];
    [self.tableView reloadData];
    
    self.title = [_titleDateFormatter stringFromDate:day.date];
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    
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

// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
	return self.defaultCalendar;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller
		  didCompleteWithAction:(EKEventEditViewAction)action
{
    CalendarViewController * __weak weakSelf = self;
    // Dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Update the UI with the above events
                 [weakSelf.tableView reloadData];
             });
         } else {
             [weakSelf.tableView reloadData];
         }
     }];
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

