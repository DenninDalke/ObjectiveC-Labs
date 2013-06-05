// ArtistsListViewController.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <CoreData/CoreData.h>
#import "GistsTableViewController.h"

#import "Gist.h"
#import "User.h"

#import "GistTableCell.h"

#import "UIImageView+AFNetworking.h"

@interface GistsTableViewController () <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
}

- (void)refetchData;

@end

@implementation GistsTableViewController

- (void)refetchData {
    [_fetchedResultsController performSelectorOnMainThread:@selector(performFetch:) withObject:nil waitUntilDone:YES modes:@[ NSRunLoopCommonModes ]];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGists];
}

- (void)loadGists
{
    self.title = NSLocalizedString(@"Public Gists", nil);
    
    self.tableView.rowHeight = 70.0f;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Gist"];
    
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:
		[NSSortDescriptor
         	sortDescriptorWithKey:@"gistID"
         	ascending:NO]];
    
    fetchRequest.fetchLimit = 50;
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]
			initWithFetchRequest:fetchRequest
			managedObjectContext:[(id)[[UIApplication sharedApplication] delegate]
			managedObjectContext]
		sectionNameKeyPath:nil
		cacheName:@"GistStream"];
    
    _fetchedResultsController.delegate = self;
    [self refetchData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refetchData)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[_fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[_fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    GistTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[GistTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
    @try {
        [(GistTableCell *)cell setGist:(Gist *)[_fetchedResultsController objectAtIndexPath:indexPath]];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GistTableCell heightForCellWithGist:(Gist *)[_fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Gist: %@", [_fetchedResultsController objectAtIndexPath:indexPath]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

@end
