//
//  MBSpreadsheetView.h
//  MMSpreadsheetView
//
//  Created by Robert Nadin on 09/11/2013.
//  Copyright (c) 2013 TMTI Limited. All rights reserved.
//

#import "MMSpreadsheetView.h"

@protocol MBSpreadsheetViewDelegate <MMSpreadsheetViewDelegate>
@optional

- (void)spreadsheetView:(MMSpreadsheetView *)spreadsheetView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface MBSpreadsheetView : MMSpreadsheetView

@property (nonatomic, weak) id<MBSpreadsheetViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedRow;

@end
