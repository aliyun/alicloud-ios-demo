//
//  KoaPullToRefresh.m
//  KoaPullToRefresh
//
//  Created by Sergi Gracia on 09/05/13.
//  Copyright (c) 2013 Sergi Gracia. All rights reserved.
//

#import "KoaPullToRefresh.h"
#import <QuartzCore/QuartzCore.h>

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

static CGFloat KoaPullToRefreshViewHeight = 82;
static CGFloat KoaPullToRefreshViewHeightShowed = 0;
static CGFloat KoaPullToRefreshViewTitleBottomMargin = 12;

@interface KoaPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *loaderLabel;
@property (nonatomic, readwrite) KoaPullToRefreshState state;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalBottomInset;
@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;

@end

#pragma mark - UIScrollView (KoaPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;

@implementation UIScrollView (KoaPullToRefresh)
@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler withBackgroundColor:[UIColor grayColor]];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
                  withBackgroundColor:(UIColor *)customBackgroundColor {
    [self addPullToRefreshWithActionHandler:actionHandler withBackgroundColor:customBackgroundColor withPullToRefreshHeightShowed:KoaPullToRefreshViewHeightShowed];
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
                      withBackgroundColor:(UIColor *)customBackgroundColor
            withPullToRefreshHeightShowed:(CGFloat)pullToRefreshHeightShowed {
    
    //KoaPullToRefreshViewHeight = pullToRefreshHeight;
    KoaPullToRefreshViewHeightShowed = pullToRefreshHeightShowed;
    KoaPullToRefreshViewTitleBottomMargin += pullToRefreshHeightShowed;
    
    [self setContentInset:UIEdgeInsetsMake(KoaPullToRefreshViewHeightShowed, self.contentInset.left, self.contentInset.bottom, self.contentInset.right)];
    
    if (!self.pullToRefreshView) {
        
        //Initial y position
        CGFloat yOrigin = -KoaPullToRefreshViewHeight;
        
        //Put background extra to fill top white space
        UIView *backgroundExtra = [[UIView alloc] initWithFrame:CGRectMake(0, -KoaPullToRefreshViewHeight*8, self.bounds.size.width, KoaPullToRefreshViewHeight*8)];
        [backgroundExtra setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [backgroundExtra setBackgroundColor:customBackgroundColor];
        [self addSubview:backgroundExtra];
        
        //Init pull to refresh view
        KoaPullToRefreshView *view = [[KoaPullToRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, KoaPullToRefreshViewHeight + KoaPullToRefreshViewHeightShowed)];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        view.backgroundColor = customBackgroundColor;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
    }
}

- (void)setPullToRefreshView:(KoaPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"KoaPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"KoaPullToRefreshView"];
}

- (KoaPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    }else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
            
            CGFloat yOrigin = -KoaPullToRefreshViewHeight;
            self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, KoaPullToRefreshViewHeight + KoaPullToRefreshViewHeightShowed);
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

@end


#pragma mark - KoaPullToRefresh
@implementation KoaPullToRefreshView

@synthesize pullToRefreshActionHandler, arrowColor, textColor, textFont;
@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize titleLabel = _titleLabel;
@synthesize loaderLabel = _loaderLabel;
@synthesize fontAwesomeIcon = _fontAwesomeIcon;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        
        // default styling values
        self.textColor = [UIColor darkGrayColor];
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = KoaPullToRefreshStateStopped;
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.loaderLabel setTextAlignment:NSTextAlignmentLeft];
        
        self.titles = [NSMutableArray arrayWithObjects: NSLocalizedString(@"Pull",),
                                                        NSLocalizedString(@"Release",),
                                                        NSLocalizedString(@"Loading",),
                                                        nil];
        
        self.wasTriggeredByUser = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "KoaPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews
{
    CGFloat leftViewWidth = 60;
    CGFloat margin = 10;
    CGFloat labelMaxWidth = self.bounds.size.width - margin - leftViewWidth;
    
    //Set title text
    self.titleLabel.text = [self.titles objectAtIndex:self.state];
    
    //Set title frame
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(labelMaxWidth,self.titleLabel.font.lineHeight) lineBreakMode:self.titleLabel.lineBreakMode];
    CGFloat titleY = KoaPullToRefreshViewHeight - KoaPullToRefreshViewHeightShowed - titleSize.height - KoaPullToRefreshViewTitleBottomMargin;
    
    [self.titleLabel setFrame:CGRectIntegral(CGRectMake(0, titleY, self.frame.size.width, titleSize.height))];
    
    //Set state of loader label
    switch (self.state) {
        case KoaPullToRefreshStateStopped:
            [self.loaderLabel setAlpha:0];
            [self.loaderLabel setFrame:CGRectMake(self.frame.size.width/2 - self.loaderLabel.frame.size.width/2,
                                                  titleY - 100,
                                                  self.loaderLabel.frame.size.width,
                                                  self.loaderLabel.frame.size.height)];
            break;
        case KoaPullToRefreshStateTriggered:
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.loaderLabel setAlpha:1];
                [self.loaderLabel setFrame:CGRectMake(self.frame.size.width/2 - self.loaderLabel.frame.size.width/2,
                                                      titleY - 24,
                                                      self.loaderLabel.frame.size.width,
                                                      self.loaderLabel.frame.size.height)];
            } completion:NULL];
            break;
    }
}

#pragma mark - Scroll View
- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.originalTopInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    //CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    //currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
    currentInsets.top = self.originalTopInset + self.bounds.size.height;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:NULL];
}

#pragma mark - Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        
        CGFloat yOrigin;
        yOrigin = -KoaPullToRefreshViewHeight;
        self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, KoaPullToRefreshViewHeight);
    }
    else if ([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    
    //Change title label alpha
    [self.titleLabel setAlpha: ((contentOffset.y * -1) / KoaPullToRefreshViewHeight) - 0.1];
    
    if(self.state != KoaPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold;
        scrollOffsetThreshold = self.frame.origin.y-self.originalTopInset;
        
        if(!self.scrollView.isDragging && self.state == KoaPullToRefreshStateTriggered)
            self.state = KoaPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == KoaPullToRefreshStateStopped)
            self.state = KoaPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != KoaPullToRefreshStateStopped)
            self.state = KoaPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
        offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
        contentInset = self.scrollView.contentInset;
        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
    }
    
    //Set content offset for special cases
    if(self.state != KoaPullToRefreshStateLoading) {
        if (self.scrollView.contentOffset.y > -KoaPullToRefreshViewHeightShowed && self.scrollView.contentOffset.y < 0) {
            [self.scrollView setContentInset:UIEdgeInsetsMake(abs(self.scrollView.contentOffset.y), self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)];
        }else if(self.scrollView.contentOffset.y > -KoaPullToRefreshViewHeightShowed) {
            [self.scrollView setContentInset:UIEdgeInsetsZero];
        }else{
            [self.scrollView setContentInset:UIEdgeInsetsMake(KoaPullToRefreshViewHeightShowed, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)];
        }
    }
}


#pragma mark - Getters
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210, 20)];
        _titleLabel.text = NSLocalizedString(@"Pull",);
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = textColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)loaderLabel {
    if(!_loaderLabel) {
        _loaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 17/2, 0, 17, 17)];
        _loaderLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:self.fontAwesomeIcon];
        _loaderLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        _loaderLabel.backgroundColor = [UIColor clearColor];
        _loaderLabel.textColor = textColor;
        [_loaderLabel sizeToFit];
        [self addSubview:_loaderLabel];
    }
    return _loaderLabel;
}

- (NSString *)fontAwesomeIcon {
    if (!_fontAwesomeIcon) {
        _fontAwesomeIcon = @"icon-refresh";
    }
    return _fontAwesomeIcon;
}

- (UIColor *)textColor {
    return self.titleLabel.textColor;
}

- (UIFont *)textFont {
    return self.titleLabel.font;
}

#pragma mark - Setters
- (void)setTitle:(NSString *)title forState:(KoaPullToRefreshState)state {
    if(!title)
        title = @"";
    
    if(state == KoaPullToRefreshStateAll)
        [self.titles replaceObjectsInRange:NSMakeRange(0, 3) withObjectsFromArray:@[title, title, title]];
    else
        [self.titles replaceObjectAtIndex:state withObject:title];
    
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    self.titleLabel.textColor = newTextColor;
    self.loaderLabel.textColor = newTextColor;
}

- (void)setTextFont:(UIFont *)font {
    [self.titleLabel setFont:font];
}

- (void)setFontAwesomeIcon:(NSString *)fontAwesomeIcon {
    _fontAwesomeIcon = fontAwesomeIcon;
    _loaderLabel.text = [NSString fontAwesomeIconStringForIconIdentifier:self.fontAwesomeIcon];
}

#pragma mark Animate
- (void)startAnimating{
    //Show loader
    self.state = KoaPullToRefreshStateTriggered;
    [self layoutSubviews];
    
    if(fequalzero(self.scrollView.contentOffset.y)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
        self.wasTriggeredByUser = NO;
    }
    else {
        self.wasTriggeredByUser = YES;
    }
    self.state = KoaPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = KoaPullToRefreshStateStopped;

    if(!self.wasTriggeredByUser && self.scrollView.contentOffset.y < -self.originalTopInset)
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
}

- (void)setState:(KoaPullToRefreshState)newState {
    
    if(_state == newState)
        return;
    
    KoaPullToRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    
    switch (newState) {
        case KoaPullToRefreshStateStopped:
            [self stopRotatingIcon];
            [self resetScrollViewContentInset];
            self.wasTriggeredByUser = YES;
            break;
            
        case KoaPullToRefreshStateTriggered:
            break;
            
        case KoaPullToRefreshStateLoading:
            [self startRotatingIcon];
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == KoaPullToRefreshStateTriggered && pullToRefreshActionHandler)
                pullToRefreshActionHandler();
            
            break;
    }
}

- (void)startRotatingIcon {
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
    rotation.duration = 1.2;
    rotation.repeatCount = HUGE_VALF;
    [self.loaderLabel.layer addAnimation:rotation forKey:@"Spin"];
}

- (void)stopRotatingIcon {
    [self.loaderLabel.layer removeAnimationForKey:@"Spin"];
}

@end
