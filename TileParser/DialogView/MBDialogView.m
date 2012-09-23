//
//  MBDialogView.m
//  TileParser
//
//  Created by Moshe Berman on 9/23/12.
//
//

#import "MBDialogView.h"

@interface MBDialogView ()

@property (nonatomic, strong) NSDictionary *dialogTree;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat horizontalMarginWidth;
@property (nonatomic, assign) CGFloat verticalMarginHeight;

@end

@implementation MBDialogView

- (id) init{
    self = [super init];
    
    if (self) {
        _maxWidth = 300;
        _horizontalMarginWidth = 20;
        _verticalMarginHeight = 10;
    }
    
    return self;
}

- (id) initWithText:(NSString *)text{
    
    self  = [self init];
    
    if (self) {
        
        _dialogTree = @{@"Dialog:":@[text]};
        
    }
    
    return self;
}

- (id) initWithDialogTree:(NSDictionary *)dialogTree{
    
    self = [self init];
    
    if (self) {
        _dialogTree = dialogTree;
    }
    
    return self;
}

- (void) showInView:(UIView *)view{
    
    //
    //  Prep the rectangle...
    //
    
    [[self layer] setCornerRadius:4.0];
    [[self layer] setBackgroundColor:[[UIColor colorWithWhite:1.0 alpha:0.65] CGColor]];
    [[self layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [[self layer] setBorderWidth:1];
    
    CGRect parentBounds = [view bounds];

    
    CGRect bounds = parentBounds;
    
    bounds.size.width = parentBounds.size.width - (_horizontalMarginWidth/2);
    bounds.size.height = parentBounds.size.height/3.5;
    
    [self setBounds:bounds];

    bounds.origin.x = parentBounds.size.width/2 - self.bounds.size.width/2;
    bounds.origin.y = _verticalMarginHeight;
    
    [self setFrame:bounds];
    
    [view addSubview:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    NSLog(@"%@", NSStringFromCGRect(rect));
}
*/
@end
