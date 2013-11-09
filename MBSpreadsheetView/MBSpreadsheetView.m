//
//  MBSpreadsheetView.m
//  MMSpreadsheetView
//
//  Created by Robert Nadin on 09/11/2013.
//  Copyright (c) 2013 TMTI Limited. All rights reserved.
//

#import "MBSpreadsheetView.h"
#import "NSIndexPath+MMSpreadsheetView.h"

@interface MMSpreadsheetView (Private) <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *lowerLeftCollectionView;
@property (nonatomic, strong) UICollectionView *lowerRightCollectionView;

- (void)setupSubviews;
- (NSIndexPath *)dataSourceIndexPathFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end


@interface MBSpreadsheetView () <UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *selectedItemCollectionView;
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end


@implementation MBSpreadsheetView

#pragma mark - MBSpreadsheetView designated initializer

- (id)initWithNumberOfHeaderRows:(NSUInteger)headerRowCount numberOfHeaderColumns:(NSUInteger)headerColumnCount frame:(CGRect)frame
{
    if (self = [super initWithNumberOfHeaderRows:headerRowCount numberOfHeaderColumns:headerColumnCount frame:frame]) {
        _selectedRow = -1;
    }
    return self;
}

#pragma mark - View Setup functions

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.lowerRightCollectionView.allowsMultipleSelection = YES;
}

#pragma mark - Custom functions that don't go anywhere else

- (NSIndexPath *)dataSourceIndexPathFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
{
    return [super dataSourceIndexPathFromCollectionView:collectionView indexPath:indexPath];
}

#pragma mark - UICollectionViewDataSource pass-through

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath.mmSpreadsheetRow == self.selectedRow) {
        cell.selected = YES;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];

    if (collectionView == self.lowerLeftCollectionView ||
        collectionView == self.lowerRightCollectionView) {
        self.selectedRow = indexPath.mmSpreadsheetRow;
        
        for (NSIndexPath *cellPath in [self.lowerLeftCollectionView indexPathsForVisibleItems]) {
            if (cellPath.mmSpreadsheetRow == indexPath.mmSpreadsheetRow) {
                [self.lowerLeftCollectionView selectItemAtIndexPath:cellPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        
        for (NSIndexPath *cellPath in [self.lowerRightCollectionView indexPathsForVisibleItems]) {
            if (cellPath.mmSpreadsheetRow == indexPath.mmSpreadsheetRow) {
                [self.lowerRightCollectionView selectItemAtIndexPath:cellPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        
        [self reloadData];
        
        NSIndexPath *dataSourceIndexPath = [self dataSourceIndexPathFromCollectionView:collectionView indexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(spreadsheetView:didSelectRowAtIndexPath:)]) {
            [self.delegate spreadsheetView:self didSelectRowAtIndexPath:dataSourceIndexPath];
        }
    }
}
    
@end
