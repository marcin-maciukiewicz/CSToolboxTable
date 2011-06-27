//
//  ToolboxTable.m
//  ToolboxTable
//
//  Created by Marcin Maciukiewicz on 10/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSToolboxTableViewController.h"

#pragma mark -
@implementation CSToolboxTableViewDrawer

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){}
    
    return self;
}

@end

#pragma mark -
@interface CSToolboxTableViewCell : UITableViewCell {
    UITableViewCell *_content;
    UIView          *_drawer;
}

@property(nonatomic,retain) UITableViewCell *_content;
@property(nonatomic,retain) UIView          *_drawer;
@property(nonatomic,retain) UITableViewCell *content;
@property(nonatomic,retain) UIView          *drawer;

- (id)initWithReusableIdentifier:(NSString *)reuseIdentifier;

@end

@implementation CSToolboxTableViewCell 

@synthesize _content;
@synthesize _drawer;

- (id)initWithReusableIdentifier:(NSString *)reuseIdentifier {
    [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self){
        self.textLabel.text=@"";
        
        [self setClipsToBounds:TRUE];
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)dealloc {
    [_content release];
    [_drawer release];
    
    [super dealloc];
}

-(UITableViewCell*)content {
    return _content;
}

-(void)setContent:(UITableViewCell *)content {
    if(content!=_content){
        // new content, replace old view with new
        [_content removeFromSuperview];
        if(_drawer) {
            [self insertSubview:content aboveSubview:_drawer];
        } else {
            [self addSubview:content];
        }
        // user interaction enabled would break table gestures
        content.userInteractionEnabled=FALSE;
    }
    self._content=content;
}

-(UIView*)drawer {
    return _drawer;
}

-(void)setDrawer:(UIView *)drawer {
    if(drawer!=_drawer){
        // new drawer, replace old view with new
        [_drawer removeFromSuperview];
        [self insertSubview:drawer belowSubview:_content];
        // user interaction enabled would break table gestures
        drawer.userInteractionEnabled=FALSE;
    }
    self._drawer=drawer;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds=self.bounds;
    
    // content location is fixed to left-top corner
    CGFloat contentHeight=_content.frame.size.height;
    _content.frame=CGRectMake(0, 0, self.bounds.size.width, contentHeight);
    
    // drawer location is relative to bottom edge of the cell
    // this creates nice slide animation 
    // when toolbox is revealed
    CGFloat drawerHeight=_drawer.frame.size.height;
    CGFloat drawerOffsetY=bounds.size.height-drawerHeight;
    _drawer.frame=CGRectMake(0, drawerOffsetY, self.bounds.size.width, drawerHeight);

}

@end

#pragma mark -
@implementation CSToolboxTableViewController

@synthesize toolboxDelegate;
@synthesize _selectedRow;

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.toolboxDelegate=self;
    }
    return self;
}

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.toolboxDelegate=self;
    }
    return self;
}

- (void)dealloc {
    [toolboxDelegate release];
    [_selectedRow release];

    [super dealloc];
}

#pragma mark - CSToolboxTableViewControllerDelegate
-(CGFloat)toolboxTableViewController:(CSToolboxTableViewController*)controller 
  cellContentHeightForRowAtIndexPath:(NSIndexPath*)indexPath {
    // pass to original delegate
    return [self.tableView.delegate tableView:self.tableView heightForRowAtIndexPath:indexPath];
}

-(UITableViewCell*)toolboxTableViewController:(CSToolboxTableViewController*)controller
                 cellContentForRowAtIndexPath:(NSIndexPath*)indexPath {
    // pass to original data source
    return [self.tableView.dataSource tableView:self.tableView cellForRowAtIndexPath:indexPath];
}


-(CGFloat)toolboxTableViewController:(CSToolboxTableViewController*)controller cellDrawerHeightForRowAtIndexPath:(NSIndexPath*)indexPath {
    // no toolbox by default
    return 0;
}

-(CSToolboxTableViewDrawer*)toolboxTableViewController:(CSToolboxTableViewController*)controller cellDrawerForRowAtIndexPath:(NSIndexPath*)indexPath {
    // no toolbox by default
    return nil;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *result;
    
    // fetch cell content and drawer
    UITableViewCell *cellContent=[self.toolboxDelegate toolboxTableViewController:self 
                                                     cellContentForRowAtIndexPath:indexPath];
    UIView *drawerView=[self.toolboxDelegate toolboxTableViewController:self 
                                            cellDrawerForRowAtIndexPath:indexPath];
    if(drawerView) {
        // There is drawer view so we need to create a cell
        // that can present cell content and drawer
        static NSString *cellIdentifier = @"ToolboxTable-Cell";
        
        CSToolboxTableViewCell *cellWithToolbox = (CSToolboxTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cellWithToolbox == nil) {
            cellWithToolbox = [[[CSToolboxTableViewCell alloc] initWithReusableIdentifier:cellIdentifier] autorelease];
        }
        
        // assign default content frame
        CGFloat cellContentHeight=[self.toolboxDelegate toolboxTableViewController:self 
                                                cellContentHeightForRowAtIndexPath:indexPath];
        cellContent.frame=CGRectMake(0, 0, tableView.bounds.size.width, cellContentHeight);
        // assign default drawer frame        
        CGFloat drawerHeight=[self.toolboxDelegate toolboxTableViewController:self 
                                            cellDrawerHeightForRowAtIndexPath:indexPath];
        drawerView.frame=CGRectMake(0, cellContentHeight, tableView.bounds.size.width, drawerHeight);
        
        // add them to the cell view
        cellWithToolbox.content=cellContent;
        cellWithToolbox.drawer=drawerView;
        
        // assign default frame, height equals content height because drawer is hidden
        //cellWithToolbox.frame=CGRectMake(0, 0, tableView.bounds.size.width, cellContentHeight);
        
        result=cellWithToolbox;
    } else {
        // There is no drawer view
        // Cell content is the only view in table row
        result=cellContent;
    }
    
    return result;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    self._selectedRow=nil;
    
    // drawer have to have user interaction disabled when hidded
    // otherwise would steal table gestures
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if([cell isMemberOfClass:[CSToolboxTableViewCell class]]){
        CSToolboxTableViewCell *toolboxCell=(CSToolboxTableViewCell*)cell;
        toolboxCell.drawer.userInteractionEnabled=FALSE;
    }
    
    // this gives a nice animation: show/hide toolbox
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // deselect if selected again (toggle)
    self._selectedRow=([indexPath compare:_selectedRow]==NSOrderedSame)?nil:indexPath;
    
    // drawer have to have user interaction disabled when hidded
    // otherwise would steal table gestures
    BOOL isSelected=([indexPath compare:_selectedRow]==NSOrderedSame);
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if([cell isMemberOfClass:[CSToolboxTableViewCell class]]){
        CSToolboxTableViewCell *toolboxCell=(CSToolboxTableViewCell*)cell;
        toolboxCell.drawer.userInteractionEnabled=isSelected;
    }
    
    // this gives a nice animation: show/hide toolbox
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result;
    
    // fetch height for the cell content
    result=[self.toolboxDelegate toolboxTableViewController:self cellContentHeightForRowAtIndexPath:indexPath];
    
    BOOL isSelected=([indexPath compare:_selectedRow]==NSOrderedSame);
    
    if(isSelected){
        // current row is selected therefore
        // add drawer height to total cell height
        // other rows are not selected
        // their height is limited to content height
        CGFloat drawerHeight=[self.toolboxDelegate toolboxTableViewController:self cellDrawerHeightForRowAtIndexPath:indexPath];
        result+=drawerHeight;
    }
    
    return result;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL result=FALSE;
	return result;
}

@end
