// Copyright (c) 2013 Mutual Mobile (http://mutualmobile.com/)
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

#import "MMViewController.h"
#import "MBSpreadsheetView.h"
#import "MMGridCell.h"
#import "MMTopRowCell.h"
#import "MMLeftColumnCell.h"
#import "NSIndexPath+MMSpreadsheetView.h"

@interface MMViewController () <MMSpreadsheetViewDataSource, MBSpreadsheetViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSString *cellDataBuffer;

@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger rows = 11;
    NSUInteger cols = 9;
    
    // Create some fake grid data for the demo.
    self.tableData = [NSMutableArray array];
    
    for (NSUInteger rowNumber = 0; rowNumber < rows; rowNumber++) {
        NSMutableArray *row = [NSMutableArray array];
        for (NSUInteger columnNumber = 0; columnNumber < cols; columnNumber++) {
            [row addObject:[NSString stringWithFormat:@"R%i:C%i", rowNumber, columnNumber]];
        }
        [self.tableData addObject:row];
    }
    
    // Create the spreadsheet in code.
    MMSpreadsheetView *spreadSheetView = [[MBSpreadsheetView alloc] initWithNumberOfHeaderRows:1 numberOfHeaderColumns:1 frame:self.view.bounds];

    // Register your cell classes.
    [spreadSheetView registerCellClass:[MMGridCell class] forCellWithReuseIdentifier:@"GridCell"];
    [spreadSheetView registerCellClass:[MMTopRowCell class] forCellWithReuseIdentifier:@"TopRowCell"];
    [spreadSheetView registerCellClass:[MMLeftColumnCell class] forCellWithReuseIdentifier:@"LeftColumnCell"];

    // Set the delegate & datasource for the spreadsheet view.
    spreadSheetView.delegate = self;
    spreadSheetView.dataSource = self;
    
    // Disable bouncing
    spreadSheetView.bounces = NO;

    // Add the spreadsheet view as a subview.
    [self.view addSubview:spreadSheetView];

    spreadSheetView.translatesAutoresizingMaskIntoConstraints = NO;
    id topLayoutGuide = self.topLayoutGuide;
    id bottomLayoutGuide = self.bottomLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(topLayoutGuide, spreadSheetView, bottomLayoutGuide);
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[topLayoutGuide][spreadSheetView][bottomLayoutGuide]"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[spreadSheetView]|"
                                             options:0
                                             metrics:nil
                                               views:viewsDictionary]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MMSpreadsheetViewDataSource

- (CGSize)spreadsheetView:(MMSpreadsheetView *)spreadsheetView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat leftColumnWidth = 80.0f;
    CGFloat topRowHeight = 47.0f;
    CGFloat gridCellWidth = 80.0f;
    CGFloat gridCellHeight = 40.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        leftColumnWidth = 320.0f;
        topRowHeight = 150.0f;
        gridCellWidth = 124.0f;
        gridCellHeight = 103.0f;
    }

    // Upper left.
    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn == 0) {
        return CGSizeMake(leftColumnWidth, topRowHeight);
    }
    
    // Upper right.
    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn > 0) {
        return CGSizeMake(gridCellWidth, topRowHeight);
    }
    
    // Lower left.
    if (indexPath.mmSpreadsheetRow > 0 && indexPath.mmSpreadsheetColumn == 0) {
        return CGSizeMake(leftColumnWidth, gridCellHeight);
    }
    
    return CGSizeMake(gridCellWidth, gridCellHeight);
}

- (NSInteger)numberOfRowsInSpreadsheetView:(MMSpreadsheetView *)spreadsheetView {
    NSInteger rows = [self.tableData count];
    return rows;
}

- (NSInteger)numberOfColumnsInSpreadsheetView:(MMSpreadsheetView *)spreadsheetView {
    NSArray *rowData = [self.tableData lastObject];
    NSInteger cols = [rowData count];
    return cols;
}

- (UICollectionViewCell *)spreadsheetView:(MMSpreadsheetView *)spreadsheetView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
//    if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn == 0) {
//        // Upper left.
//        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
//        MMGridCell *gc = (MMGridCell *)cell;
//        gc.selectedBackgroundColor = nil;
//        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mm_logo"]];
//        [gc.contentView addSubview:logo];
//        logo.frame = gc.contentView.frame;
//        logo.center = gc.contentView.center;
//        logo.contentMode = UIViewContentModeScaleAspectFit;
//        gc.textLabel.numberOfLines = 0;
//        cell.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//    }
//    else if (indexPath.mmSpreadsheetRow == 0 && indexPath.mmSpreadsheetColumn > 0) {
    if (indexPath.mmSpreadsheetRow == 0) {
        // Upper right.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"TopRowCell" forIndexPath:indexPath];
        MMTopRowCell *tr = (MMTopRowCell *)cell;
        tr.textLabel.text = [NSString stringWithFormat:@"TR: %i", indexPath.mmSpreadsheetColumn];
        cell.backgroundColor = [UIColor whiteColor];
    }
//    else if (indexPath.mmSpreadsheetRow > 0 && indexPath.mmSpreadsheetColumn == 0) {
//        // Lower left.
//        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"LeftColumnCell" forIndexPath:indexPath];
//        MMLeftColumnCell *lc = (MMLeftColumnCell *)cell;
//        lc.textLabel.text = [NSString stringWithFormat:@"Left Column: %i", indexPath.mmSpreadsheetRow];
//        BOOL isDarker = indexPath.mmSpreadsheetRow % 2 == 0;
//        if (isDarker) {
//            cell.backgroundColor = [UIColor colorWithRed:222.0f / 255.0f green:243.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
//        } else {
//            cell.backgroundColor = [UIColor colorWithRed:233.0f / 255.0f green:247.0f / 255.0f blue:252.0f / 255.0f alpha:1.0f];
//        }
//    }
    else {
        // Lower right.
        cell = [spreadsheetView dequeueReusableCellWithReuseIdentifier:@"GridCell" forIndexPath:indexPath];
        MMGridCell *gc = (MMGridCell *)cell;
        gc.textLabel.text = self.tableData[indexPath.mmSpreadsheetRow][indexPath.mmSpreadsheetColumn];
        BOOL isDarker = indexPath.mmSpreadsheetRow % 2 == 0;
        if (isDarker) {
            cell.backgroundColor = [UIColor colorWithRed:242.0f / 255.0f green:242.0f / 255.0f blue:242.0f / 255.0f alpha:1.0f];
        } else {
            cell.backgroundColor = [UIColor colorWithRed:250.0f / 255.0f green:250.0f / 255.0f blue:250.0f / 255.0f alpha:1.0f];
        }
    }

    return cell;
}

#pragma mark - MMSpreadsheetViewDelegate

- (void)spreadsheetView:(MMSpreadsheetView *)spreadsheetView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected row %d", indexPath.mmSpreadsheetRow);
}

- (BOOL)spreadsheetView:(MMSpreadsheetView *)spreadsheetView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)spreadsheetView:(MMSpreadsheetView *)spreadsheetView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    /*
     These are the selectors the sender (a UIMenuController) sends by default.
     
     _insertImage:
     cut:
     copy:
     select:
     selectAll:
     paste:
     delete:
     _promptForReplace:
     _showTextStyleOptions:
     _define:
     _addShortcut:
     _accessibilitySpeak:
     _accessibilitySpeakLanguageSelection:
     _accessibilityPauseSpeaking:
     makeTextWritingDirectionRightToLeft:
     makeTextWritingDirectionLeftToRight:
     
     We're only interested in 3 of them at this point
     */
    if (action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(paste:)) {
        return YES;
    }
    return NO;
}

- (void)spreadsheetView:(MMSpreadsheetView *)spreadsheetView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    NSMutableArray *rowData = [self.tableData objectAtIndex:indexPath.mmSpreadsheetRow];
    if (action == @selector(cut:)) {
        self.cellDataBuffer = [rowData objectAtIndex:indexPath.row];
        [rowData replaceObjectAtIndex:indexPath.row withObject:@""];
        [spreadsheetView reloadData];
    } else if (action == @selector(copy:)) {
        self.cellDataBuffer = [rowData objectAtIndex:indexPath.row];
    } else if (action == @selector(paste:)) {
        if (self.cellDataBuffer) {
            [rowData replaceObjectAtIndex:indexPath.row withObject:self.cellDataBuffer];
            [spreadsheetView reloadData];
        }
    }
}

@end
