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

@property (nonatomic, strong) UICollectionView *upperRightCollectionView;
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
    
#pragma mark - Content offset property getter

- (CGPoint)contentOffset
{
    return self.lowerRightCollectionView.contentOffset;
}

#pragma mark - Content offset property setter

- (void)setContentOffset:(CGPoint)contentOffset
{
    [self setContentOffset:contentOffset animated:NO];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    contentOffset.x = MIN(contentOffset.x, MAX(0, self.contentSize.width - CGRectGetWidth(self.bounds)));
    contentOffset.y = MIN(contentOffset.y, MAX(0, self.contentSize.height - CGRectGetHeight(self.bounds)));

    [self.lowerLeftCollectionView setContentOffset:CGPointMake(0, contentOffset.y) animated:animated];
    [self.upperRightCollectionView setContentOffset:CGPointMake(contentOffset.x, 0) animated:animated];
    [self.lowerRightCollectionView setContentOffset:contentOffset animated:animated];
    [self setNeedsLayout];
}

#pragma mark - Content size property getter

- (CGSize)contentSize
{
    if (self.lowerRightCollectionView.numberOfSections > 0) {
        return self.lowerRightCollectionView.contentSize;
    }

    CGFloat width = 0;
    CGFloat height = 0;

    if (self.upperRightCollectionView.numberOfSections > 0) {
        width = self.upperRightCollectionView.contentSize.width;
    }

    if (self.lowerLeftCollectionView.numberOfSections > 0) {
        height = self.lowerLeftCollectionView.contentSize.height;
    }

    return CGSizeMake(width, height);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];

    if ([self.delegate respondsToSelector:@selector(spreadsheetViewDidScroll:)]) {
        [self.delegate spreadsheetViewDidScroll:self];
    }
}

@end
