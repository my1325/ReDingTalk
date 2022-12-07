//
//  RDTLogView.h
//  ReDingTalkDylib
//
//  Created by my on 2022/8/26.
//

#import <UIKit/UIKit.h>

@interface RDTLogView : UIView

+ (RDTLogView *)shared;

- (void)showContent: (NSString *)content;
@end
