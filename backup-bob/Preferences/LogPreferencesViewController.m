//
// Created by Casper Storm Larsen on 10/05/14.
// SHAPE A/S
//


#import "LogPreferencesViewController.h"
#import "LogPreferencesViewModel.h"

@interface LogPreferencesViewController ()
@property (nonatomic, readonly) LogPreferencesViewModel *viewModel;
@property (nonatomic, strong) NSTextView *textView;
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
        [self setupLayout];

        [self setupBindings];
    }

    return self;
}

- (void)setupLayout
{

}

- (void)setupSubviews
{
    [self.view addSubview:self.textView];
}

- (void)setupBindings
{

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

- (NSTextView *)textView
{
    if (!_textView) {
        _textView = [[NSTextView alloc] initWithFrame:self.view.bounds];
        [_textView setEditable:NO];
        [_textView setString:@"haidaoiwdjoawjdoa awdjaoijwd aoijdwoaijwdoijoijo"];
    }

    return _textView;
}


@end