//
//  DemoTableViewController.m
//  CSToolboxTable
//
//  Created by Beata Maciukiewicz on 22/06/11.
//  Copyright 2011 Blue Pocket Limited. All rights reserved.
//

#import "DemoTableViewController.h"


@implementation DemoTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text=[NSString stringWithFormat:@"Row #%i",[indexPath row]];
    
    return cell;
}

#pragma mark - CSToolboxTableViewControllerDelegate
-(CGFloat)toolboxTableViewController:(CSToolboxTableViewController*)controller 
   cellDrawerHeightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 40;
}

-(CSToolboxTableViewDrawer*)toolboxTableViewController:(CSToolboxTableViewController*)controller 
                           cellDrawerForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *DrawerIdentifier = @"Drawer";
    CSToolboxTableViewDrawer *drawer = (CSToolboxTableViewDrawer*)[controller.tableView dequeueReusableCellWithIdentifier:DrawerIdentifier];
    if (drawer == nil) {
        drawer = [[[CSToolboxTableViewDrawer alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DrawerIdentifier] autorelease];
    }
    
    // Configure the cell...
    drawer.textLabel.text=[NSString stringWithFormat:@"Drawer #%i",[indexPath row]];
    drawer.backgroundColor=[UIColor blueColor];
    
    return drawer;
}


@end
