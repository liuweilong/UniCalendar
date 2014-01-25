//
//  UserEventsTableViewController.m
//  UniCalendar
//
//  Created by Liu Weilong on 24/1/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "UserEventsTableViewController.h"

@interface UserEventsTableViewController ()

@end

@implementation UserEventsTableViewController

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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Events";
    
    NSDate *now = [NSDate date];
    
    //set the startDate and endDate of the table view
    NSDate *startDate = [self dateAtBeginningOfDayForDay:now];
    NSDate *endDate = [self dateByAddingYears:1 toDate:startDate];
    
    //get all events from current events store within startdate and enddate
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    //Request the access to the Calendar
    [eventStore requestAccessToEntityType:EKEntityTypeEvent
                               completion:^(BOOL granted,NSError* error){
                                   
                                   //Access not granted-------------
                                   if(!granted){
                                       NSLog(@"Permissions not granted");
                                   }
                               }];
    
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
    
    //Date formatter initialization
    _sectionDateFormatter = [[NSDateFormatter alloc] init];
    _sectionDateFormatter.dateStyle = NSDateFormatterLongStyle;
    _sectionDateFormatter.timeStyle = NSDateFormatterNoStyle;
    
    _cellDateFormatter = [[NSDateFormatter alloc] init];
    _cellDateFormatter.dateStyle = NSDateFormatterNoStyle;
    _cellDateFormatter.timeStyle = NSDateFormatterShortStyle;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
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

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
