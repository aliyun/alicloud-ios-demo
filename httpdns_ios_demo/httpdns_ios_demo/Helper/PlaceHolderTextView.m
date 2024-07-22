//
//  PlaceHolderTextView.m
//  httpdns_ios_demo
//
//  Created by Miracle on 2024/7/22.
//

#import "PlaceHolderTextView.h"

@interface PlaceHolderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end

@implementation PlaceHolderTextView
CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) )  {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged {
    if([[self placeholder] length] == 0)  {
        return;
    }

    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0) {
            [[self viewWithTag:999] setAlpha:1];
        }  else {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged];
}

- (void)drawRect:(CGRect)rect {
    if( [[self placeholder] length] > 0 ) {
        if (_placeHolderLabel == nil ) {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width-5,10)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines =0;
            _placeHolderLabel.font = [UIFont systemFontOfSize:14];
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }

        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }

    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )  {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
