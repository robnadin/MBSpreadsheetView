//
//  MBSpreadsheetView.h
//  MMSpreadsheetView
//
//  Created by Rob Nadin on 09/11/2013.
//  Copyright (c) 2013 Rob Nadin. All rights reserved.
//

#import "MMSpreadsheetView.h"

@class MBSpreadsheetView;

@protocol MBSpreadsheetViewDelegate <MMSpreadsheetViewDelegate>
@optional

- (void)spreadsheetViewDidScroll:(MBSpreadsheetView *)spreadsheetView;
- (void)spreadsheetView:(MBSpreadsheetView *)spreadsheetView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)spreadsheetView:(MBSpreadsheetView *)spreadsheetView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)spreadsheetView:(MBSpreadsheetView *)spreadsheetView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)spreadsheetView:(MBSpreadsheetView *)spreadsheetView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface MBSpreadsheetView : MMSpreadsheetView

@property (nonatomic, weak) id<MBSpreadsheetViewDelegate> delegate;

@property (nonatomic) NSInteger selectedRow;
@property (nonatomic) CGPoint contentOffset;
@property (nonatomic, readonly) CGSize contentSize;

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

@end
