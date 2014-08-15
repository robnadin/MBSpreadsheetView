//
//  MBSpreadsheetView.m
//  MMSpreadsheetView
//
//  Created by Rob Nadin on 09/11/2013.
//  Copyright (c) 2013 Rob Nadin. All rights reserved.
//

#import "MBSpreadsheetView.h"
#import "NSIndexPath+MMSpreadsheetView.h"

@interface MMSpreadsheetView (Private) <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) NSUInteger headerRowCount;

@property (nonatomic, strong) UICollectionView *upperLeftCollectionView;
@property (nonatomic, strong) UICollectionView *upperRightCollectionView;
@property (nonatomic, strong) UICollectionView *lowerLeftCollectionView;
@property (nonatomic, strong) UICollectionView *lowerRightCollectionView;

- (void)setupSubviews;
- (NSIndexPath *)dataSourceIndexPathFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end


@interface MBSpreadsheetView () <UICollectionViewDelegate>


@end


@implementation MBSpreadsheetView

#pragma mark - MBSpreadsheetView designated initializer

- (id)initWithNumberOfHeaderRows:(NSUInteger)headerRowCount numberOfHeaderColumns:(NSUInteger)headerColumnCount frame:(CGRect)frame
{
    if (self = [super initWithNumberOfHeaderRows:headerRowCount numberOfHeaderColumns:headerColumnCount frame:frame]) {
        _selectedRow = NSNotFound;
    }
    return self;
}

#pragma mark - View Setup functions

- (void)setupSubviews
{
    [super setupSubviews];
    
    self.lowerLeftCollectionView.allowsMultipleSelection = YES;
    self.lowerRightCollectionView.allowsMultipleSelection = YES;
}

#pragma mark - Custom functions that don't go anywhere else

- (NSIndexPath *)dataSourceIndexPathFromCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
{
    return [super dataSourceIndexPathFromCollectionView:collectionView indexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView selectRow:(NSInteger)row animated:(BOOL)animated
{
    NSInteger columnCount = [self collectionView:collectionView numberOfItemsInSection:0];
    for (NSInteger column = 0; column < columnCount; column++) {
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:column inSection:row];
        [collectionView selectItemAtIndexPath:cellPath
                                     animated:animated
                               scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (void)collectionView:(UICollectionView *)collectionView deselectRow:(NSInteger)row animated:(BOOL)animated
{
    NSInteger columnCount = [self collectionView:collectionView numberOfItemsInSection:0];
    for (NSInteger column = 0; column < columnCount; column++) {
        NSIndexPath *cellPath = [NSIndexPath indexPathForItem:column inSection:row];
        [collectionView deselectItemAtIndexPath:cellPath
                                       animated:animated];
    }
}

#pragma mark - UICollectionViewDataSource pass-through

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES; // TODO: temp

    if (collectionView != self.lowerLeftCollectionView)
        return YES;

    return indexPath.mmSpreadsheetRow != self.selectedRow;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *dataSourceIndexPath = [self dataSourceIndexPathFromCollectionView:collectionView indexPath:indexPath];
    if (dataSourceIndexPath.mmSpreadsheetRow < self.headerRowCount)
        [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];

    if (indexPath.mmSpreadsheetRow == self.selectedRow)
        return;

    if (dataSourceIndexPath.mmSpreadsheetRow - indexPath.mmSpreadsheetRow > 0) {
        [self collectionView:self.lowerLeftCollectionView deselectRow:self.selectedRow animated:NO];
        [self collectionView:self.lowerRightCollectionView deselectRow:self.selectedRow animated:NO];

        if (self.selectedRow != NSNotFound) {
            NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:self.selectedRow];
            NSIndexPath *dataSourceSelectedIndexPath = [self dataSourceIndexPathFromCollectionView:collectionView
                                                                                         indexPath:selectedIndexPath];
            if ([self.delegate respondsToSelector:@selector(spreadsheetView:didDeselectRowAtIndexPath:)]) {
                [self.delegate spreadsheetView:self didDeselectRowAtIndexPath:dataSourceSelectedIndexPath];
            }
        }

        self.selectedRow = indexPath.mmSpreadsheetRow;

        [self collectionView:self.lowerLeftCollectionView selectRow:indexPath.mmSpreadsheetRow animated:NO];
        [self collectionView:self.lowerRightCollectionView selectRow:indexPath.mmSpreadsheetRow animated:NO];

        if ([self.delegate respondsToSelector:@selector(spreadsheetView:didSelectRowAtIndexPath:)]) {
            [self.delegate spreadsheetView:self didSelectRowAtIndexPath:dataSourceIndexPath];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *dataSourceIndexPath = [self dataSourceIndexPathFromCollectionView:collectionView indexPath:indexPath];
    if (dataSourceIndexPath.mmSpreadsheetRow < self.headerRowCount)
        return;

    if ([self.delegate respondsToSelector:@selector(spreadsheetView:didDeselectRowAtIndexPath:)]) {
        [self.delegate spreadsheetView:self didDeselectRowAtIndexPath:dataSourceIndexPath];
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
