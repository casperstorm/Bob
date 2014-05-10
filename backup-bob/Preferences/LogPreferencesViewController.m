//
// Created by Casper Storm Larsen on 10/05/14.
// SHAPE A/S
//


#import "LogPreferencesViewController.h"
#import "LogPreferencesViewModel.h"
#import "PaddingTextView.h"

@interface LogPreferencesViewController ()
@property (nonatomic, readonly) LogPreferencesViewModel *viewModel;
@property (nonatomic, strong) PaddingTextView *textView;
@property (nonatomic, strong) NSScrollView *containerScrollView;
@end
@implementation LogPreferencesViewController
{
    LogPreferencesViewModel *_viewModel;
}

- (id)init {
    self = [super init];
    if (self) {
        NSView *view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 300, 300)];

        [self setView:view];
        [self setupSubviews];

        [self setupBindings];
    }

    return self;
}

- (void)setupSubviews
{
    [self.view addSubview:self.containerScrollView];
    [self.containerScrollView setDocumentView:self.textView];
}

- (void)setupBindings
{
    RAC(self.textView, string) = [RACObserve(self.viewModel, logString) ignore:nil];
}

#pragma mark -
#pragma mark MASPreferencesViewController

- (NSString *)identifier {
    return @"LogPreferences";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:NSImageNameStatusNone];
}

- (NSString *)toolbarItemLabel
{
    return @"Log";
}

- (BOOL)hasResizableWidth {
    return NO;
}

- (BOOL)hasResizableHeight {
    return NO;
}


#pragma mark - Properties

- (LogPreferencesViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [LogPreferencesViewModel new];
    }

    return _viewModel;
}

- (PaddingTextView *)textView
{
    if (!_textView) {
        _textView = [[PaddingTextView alloc] initWithFrame:self.containerScrollView.bounds];
        [_textView setEditable:NO];
    }

    return _textView;
}

- (NSScrollView *)containerScrollView {
    if(!_containerScrollView) {
        CGRect frame = CGRectInset(self.view.bounds, 0, 0);
        _containerScrollView = [[NSScrollView alloc] initWithFrame:frame];
        [_containerScrollView setHasVerticalScroller:YES];
    }

    return _containerScrollView;
}



@end