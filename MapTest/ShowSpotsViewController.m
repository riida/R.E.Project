//
//  ShowSpotsViewController.m
//  MapTest
//
//  Created by 飯田 諒 on 2013/09/11.
//  Copyright (c) 2013年 飯田 諒. All rights reserved.
//

#import "ShowSpotsViewController.h"
#import "SpotDetailViewController.h"

#define URL_STRING @"http://172.30.255.128:8000/"
//#define URL_STRING @"http://192.168.11.2:8000/"

@interface ShowSpotsViewController () {
    NSArray *results;
}

@end

@implementation ShowSpotsViewController

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

    NSString* root = URL_STRING;
    NSString* address = [root stringByAppendingString:@"spots"];
    
    NSURL* url = [NSURL URLWithString:address];
    NSURLRequest* request = [NSURLRequest
                             requestWithURL:url];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection
                    sendSynchronousRequest:request
                    returningResponse:&response
                    error:&error];
    
    results = [self parseJson:data];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", results);
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.detailTextLabel.text = [[results objectAtIndex:indexPath.row] objectForKey:@"pic"];
    // Configure the cell...
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *spotInfo = results[indexPath.row];
        
        [[segue destinationViewController] setDetailItem:spotInfo];
        //[(SpotDetailViewController *)[segue destinationViewController] setDetailItem:urlString];
    }
}

- (NSArray *)parseJson:(NSData *)parseData {
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:parseData
                                                     options:NSJSONReadingAllowFragments
                                                       error:&error];
    /*
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *obj in array) {
        [resultsArray addObject:obj];
    }
    */
    // JSON のオブジェクトは NSDictionary に変換されている
    return array;
}


@end
