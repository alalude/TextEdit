//
//  TextEditViewController.m
//  TextEdit
//
//  Created by Akinbiyi Lalude on 3/23/13.
//  Copyright (c) 2013 Akinbiyi Lalude. All rights reserved.
//

#import "TextEditViewController.h"

@interface TextEditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIStepper *selectedWordStepper;
@property (weak, nonatomic) IBOutlet UILabel *selectedWordLabel;

@end

@implementation TextEditViewController

/*
 - (IBAction)underline
 {
     // Determine the range of our selected word within our attributed text
     // 1. Get the string
     // 2. FInd the range of the area containing the selected word
     NSRange range = [[self.label.attributedText string] rangeOfString:[self selectedWord]];
     
     // Assuming the range has been found
     if (range.location != NSNotFound)
     {
     // Get a mutable version of the string to work with
     NSMutableAttributedString *mat = [self.label.attributedText mutableCopy];
     
     // Add attributes to the range of text
     [mat addAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}
     range:range];
     
     // Update the attributed text
     self.label.attributedText = mat;
 } 
 */

// Takes a dictionary of attributes and a range to apply them
- (void)addLabelAttributes:(NSDictionary *)attributes range:(NSRange) range
{
    // Assuming the range has been found
    if (range.location != NSNotFound)
    {
        // Get a mutable version of the string to work with
        NSMutableAttributedString *mat = [self.label.attributedText mutableCopy];
        
        // Add attributes to the range of text
        [mat addAttributes:attributes
                    range:range];
        
        // Update the attributed text
        self.label.attributedText = mat;        
    }
}

// Take the attributes and apply them to the selected word
- (void)addSelectedWordAttributes:(NSDictionary *)attributes
{
    // Determine the range of our selected word within our attributed text
    // 1. Get the string
    // 2. FInd the range of the area containg the selected word
    NSRange range = [[self.label.attributedText string] rangeOfString:[self selectedWord]];
    [self addLabelAttributes:attributes range:range];
}

- (IBAction)underline
{
    [self addSelectedWordAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}];
}

- (IBAction)ununderline
{
    [self addSelectedWordAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
}

- (IBAction)changeColor:(UIButton *)sender
{
    [self addSelectedWordAttributes:@{NSForegroundColorAttributeName : sender.backgroundColor}];
}

- (IBAction)changeFont:(UIButton *)sender
{
    // Initialize fontSize
    CGFloat fontSize = [UIFont systemFontSize];
    
    // Must ask for current font size because font and size are package together,
    // but we only want to grab font from the button
    NSDictionary *attributes = [self.label.attributedText attributesAtIndex:0 effectiveRange:NULL];
    
    // Looking up in the dictionary what the font is
    UIFont *existingFont = attributes[NSFontAttributeName];
    
    // If a font is found
    if (existingFont) fontSize = existingFont.pointSize;
    
    //Set font with font from button and size from label
    UIFont *font = [sender.titleLabel.font fontWithSize:fontSize];
    
    // Update label
    [self addSelectedWordAttributes:@{NSFontAttributeName : font}];
}


// Using advanced foundation to
// get a list of words out of label
- (NSArray *)wordList
{
    // 1. Get the string out of the attributed text
    // 2. Break the string down based on the charachter
    //    set of white spaces and carraige returns
    // 3. Put the list of words in an array
    NSArray *wordList = [[self.label.attributedText string] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Prevent method from returning an empty array
    if ([wordList count])
    {
        return wordList;
    }
    
    else
    {
        return @[@""];
    }
}

// A method to get the word the stepper is on
- (NSString *)selectedWord
{
    // 1. Get the word list indexed by the stepper value
    // Note it's typecast as an int because the stepper can move in float increments
    return [self wordList][(int)self.selectedWordStepper.value];
}

// A method to set the steppers max to match the number of words in the array
- (IBAction)updateSelectedWord
{
    // 1. Set the max
    // Range checks with each step in case string/array changes lenght
    self.selectedWordStepper.maximumValue = [[self wordList] count]-1;
    
    // 2. Update the selected word text
    self.selectedWordLabel.text = [self selectedWord];
}

// Update selected word each time UI loads
// viewDidLoad is sent each time your screen is drawn and your actions are ready
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateSelectedWord];
}

@end
