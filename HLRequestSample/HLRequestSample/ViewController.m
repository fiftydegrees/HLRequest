//
//  ViewController.m
//  HLRequestSample
//
//  Created by Hervé Droit on 15/04/2014.
//  Copyright (c) 2014 Hervé HEURTAULT DE LAMMERVILLE. All rights reserved.
//

#import "ViewController.h"

#import "HLRequest.h"

@interface ViewController ()
{
    NSArray *colorsArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

#pragma mark -
#pragma mark - ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/* THIS IS A SAMPLE USE OF HLREQUEST WITH COMPLETION HANDLER
 * YOU CAN ALSO USE DELEGATE AND IMPLEMENT HlRequestDelegate */
- (void)viewDidAppear:(BOOL)animated
{
    HLRequest *colorsRequest = [HLRequest new];
    
    colorsRequest.requestType = HLRequestTypeSample;
    
    [colorsRequest executeRequestWithCompletion:^(NSData *data, NSError *error) {
        if (error)
            NSLog(@"Error: %@", error.localizedDescription);
        else if (data)
        {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            colorsArray = [dataDictionary objectForKey:@"colorsArray"];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return colorsArray ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return colorsArray ? colorsArray.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell" forIndexPath:indexPath];
    
    NSDictionary *colorDictionary = [colorsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [colorDictionary objectForKey:@"colorName"];
    cell.detailTextLabel.text = [colorDictionary objectForKey:@"hexValue"];
    
    return cell;
}

#pragma mark -
#pragma mark - System

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
