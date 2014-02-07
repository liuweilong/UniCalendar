//
//  EventsViewController.m
//  UniCalendar
//
//  Created by Liu Weilong on 7/2/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "EventsViewController.h"
#import "ServerRequester.h"
#import "Event.h"
#import "EventDetailViewController.h"

#define dataRetrievalURL @"http://www.newcenturymanong.com/test/calendar.php"

@interface EventsViewController ()

@end

@implementation EventsViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.title = @"Events";
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
    self.eventStore = [[EKEventStore alloc] init];
    self.eventArray = [[NSMutableArray alloc] init];
    
    ServerRequester *req = [ServerRequester serverRequestWithURLString:dataRetrievalURL postVariables:nil timeOutInterval:10.f];
    [req setOnLoadedSelector:self selector:@selector(jsonLoaded:)];
    [req makeRequest];
}

-(void)jsonLoaded:(ServerRequester *)request {
    NSData *jsonData = request.receivedData;
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    for (NSDictionary *eventDic in dataArray) {
        NSString *title = [eventDic objectForKey:@"title"];
        NSString *description = [eventDic objectForKey:@"discription"];
        NSDate *startDate = [self.dateFormatter dateFromString:[eventDic objectForKey:@"startDate"]];
        NSDate *endDate = [self.dateFormatter dateFromString:[eventDic objectForKey:@"endDate"]];
        BOOL allday = [[eventDic objectForKey:@"allday"] boolValue];
        
        NSLog(@"%@%@%@%@%@", [eventDic objectForKey:@"title"], [eventDic objectForKey:@"discription"], [eventDic objectForKey:@"startDate"], [eventDic objectForKey:@"endDate"], [eventDic objectForKey:@"allday"]);
        
        Event *event = [[Event alloc] init];
        event.title = title;
        event.description = description;
        event.startDate = startDate;
        event.endDate = endDate;
        event.allDay = allday;
        
        [self.eventArray addObject:event];
        NSLog(@"%d", [self.eventArray count]);
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"%d", [self.eventArray count]);
    return [self.eventArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    EKEvent *event = [self.eventArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.description;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EventDetailViewController *dvc = [segue destinationViewController];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Event *event = [self.eventArray objectAtIndex:path.row];
    dvc.event = event;
    NSLog(@"Segue is bing called");
}

@end
