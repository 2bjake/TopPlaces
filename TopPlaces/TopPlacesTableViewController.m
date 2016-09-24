//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Foster, Jake on 9/23/16.
//  Copyright © 2016 Amazon. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesTableViewController ()
@property (strong, nonatomic) IBOutlet UIRefreshControl *spinner;
@property (strong, nonatomic) NSArray *countries; // of NSString
@property (strong, nonatomic) NSDictionary *countryToPlaces; // NSDictionary NSString->NSArray of NSString
@end

@implementation TopPlacesTableViewController

- (NSDictionary *)countryToPlaces {
    if (!_countryToPlaces) _countryToPlaces = [[NSDictionary alloc] init];
    return _countryToPlaces;
}

- (NSArray *)countries {
    if (!_countries) _countries = [[NSArray alloc] init];
    return _countries;
}

- (IBAction)refreshData:(UIRefreshControl *)sender {
    [self fetchData];
}

- (void)fetchData {
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *task =
            [session downloadTaskWithRequest:request
                           completionHandler:^(NSURL * _Nullable localFile, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               if (!error) {
                   NSDictionary *countryToPlaces =
                         [TopPlacesTableViewController countryToPlaceDictFromFlickrData:[NSData dataWithContentsOfURL:localFile]];
                   NSArray *countries = [[countryToPlaces allKeys] sortedArrayUsingSelector:@selector(compare:)];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self setCountries:countries andPlaceDictionary:countryToPlaces];
                   });
               }
           }];
    [task resume];
}

- (void)setCountries:(NSArray *)countries andPlaceDictionary:(NSDictionary *)countryToPlaces {
    self.countries = countries;
    self.countryToPlaces = countryToPlaces;
    [self.spinner endRefreshing];
    [self.tableView reloadData];
}

+ (NSDictionary *) countryToPlaceDictFromFlickrData:(NSData *)data {
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error: NULL];
    NSArray *places = [dict valueForKeyPath:FLICKR_RESULTS_PLACES];
    
    NSMutableDictionary *countryToPlaces = [[NSMutableDictionary alloc] init];
    
    [places enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary * placeDictionary = (NSDictionary *)obj;
        NSString *fullPlace = [placeDictionary valueForKeyPath:FLICKR_PLACE_NAME];
        NSRange commaRange = [fullPlace rangeOfString:@", " options:NSBackwardsSearch];
        if (commaRange.location != NSNotFound) {
            NSString * country = [fullPlace substringFromIndex:commaRange.location + 2];
            NSString * place = [fullPlace substringToIndex:commaRange.location];
            if (!countryToPlaces[country]) {
                countryToPlaces[country] = [[NSMutableArray alloc] init];
            }
            [countryToPlaces[country] addObject:place];
        }
    }];
    
    for (NSString *key in [countryToPlaces allKeys]) {
        countryToPlaces[key] = [countryToPlaces[key] sortedArrayUsingSelector:@selector(compare:)];
    }
    
    return countryToPlaces;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.countries.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *country = self.countries[section];
    return ((NSArray *)self.countryToPlaces[country]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Place Cell" forIndexPath:indexPath];
    NSString *country = self.countries[indexPath.section];
    NSString *place = self.countryToPlaces[country][indexPath.row];
    
    cell.textLabel.text = place;
    cell.detailTextLabel.text = @"";

    NSRange commaRange = [place rangeOfString:@", "];
    if (commaRange.location != NSNotFound) {
        cell.textLabel.text = [place substringToIndex:commaRange.location];
        cell.detailTextLabel.text = [place substringFromIndex:commaRange.location + 2];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.countries[section];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
