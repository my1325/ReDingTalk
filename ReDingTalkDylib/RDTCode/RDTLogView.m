//
//  RDTLogView.m
//  ReDingTalkDylib
//
//  Created by my on 2022/8/26.
//

#import "RDTLogView.h"

@implementation RDTLogView {
    UIScrollView * _scrollView;
    UILabel * _contentLabel;
}

+ (RDTLogView *)shared {
    static dispatch_once_t token;
    static RDTLogView *_instance = nil;
    dispatch_once(&token, ^{
        _instance = [[RDTLogView alloc] init];
        _instance.frame = [UIScreen mainScreen].bounds;
        [[UIApplication sharedApplication].delegate.window addSubview:_instance];
    });
    return _instance;
}

- (void)layoutSubviews {
    _scrollView.frame = self.bounds;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _contentLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = UIColor.blackColor;
        [[self scrollView] addSubview:_contentLabel];
        NSLayoutConstraint * top = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:8];
        NSLayoutConstraint * left = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                attribute:NSLayoutAttributeLeft
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeLeft
                                                               multiplier:1.0
                                                                 constant:8];
        NSLayoutConstraint * bottom = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:-8];
        NSLayoutConstraint * right = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                attribute:NSLayoutAttributeRight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeRight
                                                               multiplier:1.0
                                                                 constant:-8];
        [_scrollView addConstraints:@[top, left, bottom, right]];
        
        UILongPressGestureRecognizer * longGR = [[UILongPressGestureRecognizer alloc] init];
        [longGR addTarget:self action:@selector(handleLongGR:)];
        _contentLabel.userInteractionEnabled = YES;
        [_contentLabel addGestureRecognizer:longGR];
    }
    return _contentLabel;
}

- (void)showContent:(NSString *)content {
    self.hidden = false;
    [self contentLabel].text = content;
}

- (void) handleLongGR: (UIGestureRecognizer *)gr {
    if (gr.state != UIGestureRecognizerStateBegan) return;
    
    UIAlertAction * copyAction = [UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard.generalPasteboard.string = [self contentLabel].text;
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * closeAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.hidden = true;
    }];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:copyAction];
    [alertController addAction:closeAction];
    [alertController addAction:cancelAction];
    
    [[[UIApplication sharedApplication].delegate window].rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
