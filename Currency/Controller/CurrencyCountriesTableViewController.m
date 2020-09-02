//
//  CurrencyCountriesTableViewController.m
//  Currency
//
//  Created by Bruno Meneghin on 27/08/20.
//  Copyright © 2020 Bruno Meneghin. All rights reserved.
//

#import "CurrencyCountriesTableViewController.h"
#import "CurrencyModel.h"
#import "CurrencyTableViewCell.h"

@interface CurrencyCountriesTableViewController ()

@property (strong, nonatomic) NSMutableArray<CurrencyModel *> *currencyModel;


@end

@implementation CurrencyCountriesTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self fetchingDataFromCurrency];
    [self.tableView reloadData];
}

# pragma mark - Functions

- (void) setupUI {
    self.cellId = @"cellCurrency";
    self.navigationItem.title = @"Currency";
}

- (void) fetchingDataFromCurrency {
    NSString *stringURLContent = @"https://economia.awesomeapi.com.br/json/all";
    NSURL *url = [NSURL URLWithString:stringURLContent];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data,
                                                                         NSURLResponse * _Nullable _,
                                                                         NSError * _Nullable error) {
        NSError *err;
        NSDictionary *currencyWithCountries = [NSJSONSerialization JSONObjectWithData:data
                                                                             options:kNilOptions
                                                                               error:&err];
        [self completionHandlerNSURLError:error];
        [self serializationError:err];
        
        NSDictionary *currencyUSD = [[NSDictionary alloc]
                                     initWithDictionary:[currencyWithCountries objectForKey:@"USD"]];
        
        NSMutableArray *currencyValues = [[NSMutableArray alloc]
                                          initWithArray:[currencyUSD allValues]];
        
        [self constructObjectWithDictionaryValues:currencyValues];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    }] resume];
}

- (void) completionHandlerNSURLError:(NSError *)err {
    if (err) {
        NSLog(@"Error to fetch values: %@", err.localizedDescription);
        return;
    }
}

- (void) serializationError:(NSError *)err {
    if (err) {
        NSLog(@"Error in NSJSONSerialization %@", err.localizedDescription);
        return;
    }
}

- (void) constructObjectWithDictionaryValues:(NSMutableArray *)arrayWithCurrencyValues {
    NSMutableArray <CurrencyModel *> *currency = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in arrayWithCurrencyValues) {
        NSString *currencyCountry = [NSString stringWithFormat:@"%@", dictionary];
        
        CurrencyModel *USD = [[CurrencyModel alloc] init];
        USD.currencyUSD = currencyCountry;
        
        [currency addObject:USD];
    }
    
    self.currencyModel = currency;
}


#pragma mark - Table View data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencyModel.count > 0 ? self.currencyModel.count : 0; 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellId];
    
    CurrencyModel *currency = self.currencyModel[indexPath.row];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"CurrencyTableViewCell" bundle:nil] forCellReuseIdentifier:_cellId];
        
        cell = [self.tableView dequeueReusableCellWithIdentifier:_cellId];
    }
    
    cell.currencyLabel.text = currency.currencyUSD;
    
    return cell;
}


@end
