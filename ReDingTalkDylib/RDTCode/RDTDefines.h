//
//  RDTDefines.h
//  ReDingTalk
//
//  Created by my on 2022/5/5.
//

#ifndef RDTDefines_h
#define RDTDefines_h

@interface DTTableViewDataSource
- (NSArray *)tableViewDataSource;
- (void)setTableViewDataSource: (NSArray *)dataSource;
@end

@interface DTCellItem
+ (id)itemWithStyle: (NSInteger)style cellDidSelectBlock: (id)block;
+ (id)cellItemForSwitcherStyleWithTitle: (NSString *)title isSwitcherOn: (BOOL)isOn switcherValueDidChangeBlock: (id)block;
+ (id)cellItemForDefaultStyleWithIcon:(id)arg1 title:(id)arg2 detail:(id)arg3 comment:(id)arg4 showBadge:(BOOL)arg5 showIndicator:(BOOL)arg6 cellDidSelectedBlock:(id)arg7;
+ (id)cellItemForTitleOnlyStyleWithTitle:(id)title cellDidSelectedBlock:(id)block;
- (void)setTitle: (NSString *)title;
- (void)setShowIndicator: (BOOL)isShow;
- (BOOL)isSwitcherOn;
@end

@interface DTSectionItem
+ (id)itemWithSectionHeader:(id)arg1 sectionFooter:(id)arg2;
- (void)setDataSource:(NSArray *)dataSource;
- (void)setUseItemHeaderHeight: (BOOL)a1;
- (void)setCellHeight: (CGFloat)height;
- (void)setHeaderHeight: (CGFloat)headerHeight;
@end

@interface DTSettingListViewController
- (id)dataSource;
- (void)setDataSource: (id)dataSource;

- (UINavigationController *)navigationController;
@end

@interface LMLocationViewController
@property(nonatomic, strong) RDTSettings * workSettings;
- (id)dataSource;
- (void)setDataSource: (id)dataSource
;
- (id)sectionForEnable: (RDTSettings *)settings;
- (id)sectionForGlobal: (RDTSettings *)settings;
- (id)sectionForWorkList: (RDTSettings *)settings;
- (id)sectionForClear: (RDTSettings *)settings;

- (UINavigationController *)navigationController;
- (void)setTitle: (NSString *)title;
- (void)tidyDatasource;
- (UITableView *)tableView;
@end

@interface DTBizWorkInfoModel
@property(copy, nonatomic) NSString *orgIcon;
@property(copy, nonatomic) NSString *orgName;
@property(nonatomic) NSInteger orgId;
@end

@interface DTWorkInfoManager
+ (id)sharedManager;
@property(retain, nonatomic) NSMutableArray *workInfoList;
@end

@interface DTMediaIdManager
+ (NSString *)transferToHttpUrl: (NSString *)uri;
@end

@interface RVKJsBridge
@property (nonatomic, weak) WKWebView * contentView;
@end

@interface UIImageView()
- (void)setImageWithURL: (NSString *)url cornerRadius: (CGFloat)radius placeholderImage: (id)placeholder progressBlock:(id)progressBlock succeedBlock: (id)successBlock failedBlock: (id)failedBlock;
@end

@interface WKWebView()
@property (nonatomic, weak) id rvaAssginNavigationDelegate;
@end

#endif /* RDTDefines_h */
