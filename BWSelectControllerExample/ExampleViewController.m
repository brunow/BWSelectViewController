//
//  ExampleViewController.m
//  BWSelectControllerExample
//
//  Created by Bruno Wernimont on 16/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExampleViewController.h"

#import "BWSelectViewController.h"

@interface ExampleViewController ()

@end

@implementation ExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)didPressSimpleSelect:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = NO;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPressMultiSelect:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresPreSelectedItems:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = YES;
    [vc setSlectedIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil]];
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresAllowEmpty:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    vc.items = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    vc.multiSelection = YES;
    vc.allowEmpty = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresMultipleSection:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    NSArray *items1 = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    NSArray *items2 = [NSArray arrayWithObjects:@"Item1", @"Item2", nil];
    NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", nil];
    [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", nil]];
    vc.multiSelection = YES;
    vc.allowEmpty = NO;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didPresDropDown:(id)sender
{
    BWSelectViewController *vc = [[BWSelectViewController alloc] init];
    NSArray *items1 = [NSArray arrayWithObjects:@"Item1", @"Item2", @"Item3", @"Item4", nil];
    NSArray *items2 = [NSArray arrayWithObjects:@"Item1", @"Item2", nil];
    NSDictionary *sections = [NSDictionary dictionaryWithObjectsAndKeys:items1, @"section1", items2, @"section2", nil];
    [vc setSections:sections orders:[NSArray arrayWithObjects:@"section1", @"section2", nil]];
    vc.multiSelection = NO;
    vc.allowEmpty = NO;
    vc.dropDownSection = YES;
    
    [vc setDidSelectBlock:^(NSArray *selectedIndexPaths, BWSelectViewController *controller) {
        NSLog(@"%@", selectedIndexPaths);
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
