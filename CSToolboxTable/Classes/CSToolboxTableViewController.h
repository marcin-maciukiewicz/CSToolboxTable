//
//  ToolboxTable.h
//  ToolboxTable
//
//  Created by Marcin Maciukiewicz on 10/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma -
@interface CSToolboxTableViewDrawer : UITableViewCell {
}

-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

@end

#pragma -
@class CSToolboxTableViewController;
@protocol CSToolboxTableViewControllerDelegate <NSObject>

@required
    -(CGFloat)toolboxTableViewController:(CSToolboxTableViewController*)controller 
      cellContentHeightForRowAtIndexPath:(NSIndexPath*)indexPath;

    -(UITableViewCell*)toolboxTableViewController:(CSToolboxTableViewController*)controller
                     cellContentForRowAtIndexPath:(NSIndexPath*)indexPath;

    -(CGFloat)toolboxTableViewController:(CSToolboxTableViewController*)controller 
       cellDrawerHeightForRowAtIndexPath:(NSIndexPath*)indexPath;

    -(CSToolboxTableViewDrawer*)toolboxTableViewController:(CSToolboxTableViewController*)controller 
                               cellDrawerForRowAtIndexPath:(NSIndexPath*)indexPath;

@end

#pragma -
@interface CSToolboxTableViewController : UITableViewController <CSToolboxTableViewControllerDelegate> {
    NSIndexPath     *_selectedRow;
    id<CSToolboxTableViewControllerDelegate>                     
                    toolboxDelegate;
}

@property(nonatomic,retain) NSIndexPath *_selectedRow;
@property(nonatomic,retain) id<CSToolboxTableViewControllerDelegate>    
                                        toolboxDelegate;

@end
