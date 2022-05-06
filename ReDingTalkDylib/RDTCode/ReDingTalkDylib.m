//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  ReDingTalkDylib.m
//  ReDingTalkDylib
//
//  Created by my on 2022/4/26.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

#import "ReDingTalkDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import <MDCycriptManager.h>
#import <CoreLocation/CoreLocation.h>

#import "RDTModels.h"
#import "RDTDefines.h"
#import "RDTMapViewController.h"

#define Class(name) NSClassFromString(@#name)
#define weakify(val) __weak __typeof(val) w##val = val
#define strongify(val) __weak __typeof(val) val = w##val

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Wunused-function"

CHDeclareClass(AMapGeoFenceManager);
CHOptimizedMethod0(self, BOOL, AMapGeoFenceManager, detectRiskOfFakeLocation) {
    return NO;
}

CHOptimizedMethod0(self, BOOL, AMapGeoFenceManager, pausesLocationUpdatesAutomatically) {
    return NO;
}

CHDeclareClass(AMapLocationManager);
CHOptimizedMethod0(self, BOOL, AMapLocationManager, detectRiskOfFakeLocation) {
    return NO;
}

CHOptimizedMethod0(self, BOOL, AMapLocationManager, pausesLocationUpdatesAutomatically) {
    return NO;
}


CHDeclareClass(DTALocationManager);
CHOptimizedMethod0(self, BOOL, DTALocationManager, detectRiskOfFakeLocation) {
    return NO;
}

CHOptimizedMethod0(self, BOOL, DTALocationManager, dt_pausesLocationUpdatesAutomatically) {
    return NO;
}

CHOptimizedMethod2(self, void, DTALocationManager, amapLocationManager, id, a1, didUpdateLocation, CLLocation *, location) {
    NSInteger currentOrganiztionID = [[NSUserDefaults standardUserDefaults] integerForKey:@"com.my.re.ReDingTalk.currentOrganiztionId"];
    NSDictionary * settingDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"com.my.re.dingtalk.settings"];
    RDTSettings * settings = [RDTSettings fromDictionary:settingDictionary];
    CLLocation * resLocation = location;
    if (settings.enable) {
        if (settings.globalSetting.enable && CLLocationCoordinate2DIsValid(settings.globalSetting.location.coordinate)) {
            RDTLocation * rLocation = settings.globalSetting.location;
            resLocation = [[CLLocation alloc] initWithLatitude:rLocation.coordinate.latitude longitude:rLocation.coordinate.longitude];
        } else {
            for (RDTWorkSetting * setting in settings.workSettings) {
                if (setting.workId == currentOrganiztionID && CLLocationCoordinate2DIsValid(setting.location.coordinate)) {
                    RDTLocation * rLocation = setting.location;
                    resLocation = [[CLLocation alloc] initWithLatitude:rLocation.coordinate.latitude longitude:rLocation.coordinate.longitude];
                }
            }
        }
    }
    CHSuper2(DTALocationManager, amapLocationManager, a1, didUpdateLocation, resLocation);
}

CHDeclareClass(DTOrganizationSwitcher)
CHOptimizedMethod1(self, void, DTOrganizationSwitcher, setOrgIDSelected, NSInteger, workId) {
    [[NSUserDefaults standardUserDefaults] setValue:@(workId) forKey:@"com.my.re.ReDingTalk.currentOrganiztionId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CHSuper1(DTOrganizationSwitcher, setOrgIDSelected, workId);
}

CHDeclareClass(NSBundle);
CHOptimizedMethod0(self, NSString *, NSBundle, bundleIdentifier) {
    NSString * res = CHSuper0(NSBundle, bundleIdentifier);
    if (![self isEqual:[NSBundle mainBundle]] || ![res isEqualToString:@"com.my.re.ReDingTalk"]) return res;
    return @"com.laiwang.DingTalk";
}

CHConstructor {
    CHLoadClass(NSBundle);
    CHHook0(NSBundle, bundleIdentifier);
    
    CHLoadLateClass(AMapLocationManager);
    CHHook0(AMapLocationManager, detectRiskOfFakeLocation);
    CHHook0(AMapLocationManager, pausesLocationUpdatesAutomatically);
    
    CHLoadLateClass(DTALocationManager);
    CHHook0(DTALocationManager, detectRiskOfFakeLocation);
    CHHook0(DTALocationManager, dt_pausesLocationUpdatesAutomatically);
    CHHook2(DTALocationManager, amapLocationManager, didUpdateLocation);

    CHLoadLateClass(AMapGeoFenceManager);
    CHHook0(AMapGeoFenceManager, detectRiskOfFakeLocation);
    CHHook0(AMapGeoFenceManager, pausesLocationUpdatesAutomatically);
    
    CHLoadLateClass(DTOrganizationSwitcher);
    CHHook1(DTOrganizationSwitcher, setOrgIDSelected);
}

CHDeclareClass(DTTableViewController);
CHDeclareClass(LMLocationViewController);
CHPropertyGetter(LMLocationViewController, workSettings, RDTSettings *) {
    NSDictionary * settingDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"com.my.re.dingtalk.settings"];
    return [RDTSettings fromDictionary:settingDictionary];
}
CHPropertySetter(LMLocationViewController, setWorkSettings, RDTSettings *, newValue) {
    NSDictionary * settingDictionary = [newValue toDictionary];
    [[NSUserDefaults standardUserDefaults] setValue:settingDictionary forKey:@"com.my.re.dingtalk.settings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
CHOptimizedMethod0(super, void, LMLocationViewController, viewDidLoad) {
    CHSuper0(LMLocationViewController, viewDidLoad);
    [self setTitle:@"其他"];
    [self tidyDatasource];
}

CHOptimizedMethod1(new, id, LMLocationViewController, sectionForEnable, RDTSettings *, settings) {
    id section = [Class(DTSectionItem) itemWithSectionHeader: nil sectionFooter: nil];
    weakify(self);
    id item = [Class(DTCellItem) cellItemForSwitcherStyleWithTitle: @"启用插件" isSwitcherOn: settings.enable switcherValueDidChangeBlock: ^(id val){
        strongify(self);
        settings.enable = !settings.enable;
        self.workSettings = settings;
        [self tidyDatasource];
    }];
    [item setCellHeight:56];
    [section setDataSource:@[item]];
    [section setHeaderHeight:8];
    [section setUseItemHeaderHeight:YES];
    return section;
}

CHOptimizedMethod1(new, id, LMLocationViewController, sectionForGlobal, RDTSettings *, settings) {
    id section = [Class(DTSectionItem) itemWithSectionHeader: nil sectionFooter: nil];
    weakify(self);
    id enableItem = [Class(DTCellItem) cellItemForSwitcherStyleWithTitle: @"启用全局" isSwitcherOn: settings.globalSetting.enable switcherValueDidChangeBlock: ^(id val){
        strongify(self);
        settings.globalSetting.enable = !settings.globalSetting.enable;
        self.workSettings = settings;
        [self tidyDatasource];
    }];
    [enableItem setCellHeight:56];
    NSMutableArray * items = [@[enableItem] mutableCopy];
    if ([settings.globalSetting enable]) {
        NSString * locationName = settings.globalSetting.location.name;
        if (!locationName.length) locationName = @"还没有指定全局位置哦";
        id locationItem = [Class(DTCellItem) cellItemForDefaultStyleWithIcon: nil title: locationName detail: settings.globalSetting.location.detail comment: nil showBadge: NO showIndicator: YES cellDidSelectedBlock: ^(id val) {
            strongify(self);
            RDTMapViewController * mapController = [[RDTMapViewController alloc] init];
            mapController.location = settings.globalSetting.location;
            [mapController setCompletion:^(NSDictionary *location) {
                RDTLocation * loc = [RDTLocation fromDictionary:location];
                settings.globalSetting.location = loc;
                self.workSettings = settings;
                [self tidyDatasource];
            }];
            [[self navigationController] pushViewController:mapController animated:YES];
        }];
        [locationItem setCellHeight:56];
        [items addObject:locationItem];
    }
    [section setDataSource:[items copy]];
    [section setHeaderHeight:8];
    [section setUseItemHeaderHeight:YES];
    return section;
}

CHOptimizedMethod1(new, id, LMLocationViewController, sectionForWorkList, RDTSettings *, settings) {
    NSMutableArray * workList = [[settings workSettings] mutableCopy];
    NSArray * workInfoList = [[Class(DTWorkInfoManager) sharedManager] workInfoList];
    if (workList.count < workInfoList.count) {
        for (DTBizWorkInfoModel * workInfo in workInfoList) {
            NSInteger indexInWorkList = NSNotFound;
            for (NSInteger i = 0; i < workList.count; i++) {
                if (workInfo.orgId == [[workList objectAtIndex:i] workId]) {
                    indexInWorkList = i; break;
                }
            }
            
            if (indexInWorkList == NSNotFound) {
                RDTWorkSetting * workSetting = [RDTWorkSetting new];
                workSetting.workId = workInfo.orgId;
                workSetting.workName = workInfo.orgName;
                workSetting.workIcon = workInfo.orgIcon;
                [workList addObject:workSetting];
            }
        }
        settings.workSettings = [workList copy];
        self.workSettings = settings;
    }
    
    NSMutableArray * items = [@[] mutableCopy];
    weakify(self);
    for (RDTWorkSetting * setting in workList) {
        id locationItem = [Class(DTCellItem) cellItemForDefaultStyleWithIcon: nil title: setting.workName detail: setting.location.name comment: nil showBadge: NO showIndicator: YES cellDidSelectedBlock: ^(id val) {
            strongify(self);
            RDTMapViewController * mapController = [[RDTMapViewController alloc] init];
            mapController.location = setting.location;
            [mapController setCompletion:^(NSDictionary *location) {
                RDTLocation * loc = [RDTLocation fromDictionary:location];
                setting.location = loc;
                self.workSettings = settings;
                [self tidyDatasource];
            }];
            [[self navigationController] pushViewController:mapController animated:YES];
        }];
        [locationItem setCellHeight:56];
        [items addObject:locationItem];
    }
    id sectionItem = [Class(DTSectionItem) itemWithSectionHeader: nil sectionFooter: nil];
    [sectionItem setDataSource:[items copy]];
    [sectionItem setHeaderHeight:8];
    [sectionItem setUseItemHeaderHeight:YES];
    return sectionItem;
}

CHOptimizedMethod1(new, id, LMLocationViewController, sectionForClear, RDTSettings *, settings) {
    weakify(self);
    id item = [Class(DTCellItem) cellItemForTitleOnlyStyleWithTitle: @"清理缓存"  cellDidSelectedBlock: ^(id item){
        strongify(self);
        [settings unset];
        self.workSettings = settings;
        [self tidyDatasource];
    }];
    [item setCellHeight:56];
    
    id sectionItem = [Class(DTSectionItem) itemWithSectionHeader: nil sectionFooter: nil];
    [sectionItem setDataSource:@[item]];
    [sectionItem setHeaderHeight:8];
    [sectionItem setUseItemHeaderHeight:YES];
    return sectionItem;
}

CHOptimizedMethod0(new, void, LMLocationViewController, tidyDatasource) {
    NSMutableArray * dataSource = [@[] mutableCopy];
    RDTSettings * settings = [self workSettings];

    [dataSource addObject: [self sectionForEnable:settings]];
    if (settings.enable) {
        [dataSource addObject:[self sectionForGlobal:settings]];
        if (!settings.globalSetting.enable) {
            [dataSource addObject:[self sectionForWorkList:settings]];
        }
    }
    
    [dataSource addObject:[self sectionForClear: settings]];
    
    id tableViewDataSource = [Class(DTTableViewDataSource) new];
    [tableViewDataSource setTableViewDataSource:dataSource];
    
    [self setDataSource:tableViewDataSource];
    [[self tableView] reloadData];
}

CHDeclareClass(DTSettingListViewController);
CHOptimizedMethod0(self, void, DTSettingListViewController, tidyDatasource) {
    CHSuper0(DTSettingListViewController, tidyDatasource);
    id dataSource = [self dataSource];

    NSMutableArray * sections = [[dataSource tableViewDataSource] mutableCopy];
    __weak typeof(self) wself = self;
    id cellItem = [Class(DTCellItem) itemWithStyle:0 cellDidSelectBlock:^{
        __strong typeof(wself) sself = wself;
        [[sself navigationController] pushViewController:[[Class(LMLocationViewController) alloc] init] animated:YES];
    }];
    [cellItem setTitle:@"其他"];
    [cellItem setShowIndicator:1];
    [cellItem setCellHeight:56];

    id sectionItem = [Class(DTSectionItem) itemWithSectionHeader:nil sectionFooter:nil];
    [sectionItem setDataSource:@[cellItem]];
    [sectionItem setHeaderHeight:8];
    [sectionItem setUseItemHeaderHeight:YES];
    
    [sections insertObject:sectionItem atIndex:sections.count - 1];
    [dataSource setTableViewDataSource:[sections copy]];
    
    [self setDataSource:dataSource];
}

CHConstructor {
    CHLoadLateClass(DTSettingListViewController);
    CHHook0(DTSettingListViewController, tidyDatasource);
    
    CHLoadLateClass(DTTableViewController);
    
    CHRegisterClass(LMLocationViewController, DTTableViewController);
    CHHook0(LMLocationViewController, viewDidLoad);
    CHHook0(LMLocationViewController, tidyDatasource);
    CHHook1(LMLocationViewController, sectionForEnable);
    CHHook1(LMLocationViewController, sectionForGlobal);
    CHHook1(LMLocationViewController, sectionForWorkList);
    CHHook1(LMLocationViewController, sectionForClear);
    CHHookProperty(LMLocationViewController, workSettings, setWorkSettings);
}

#pragma clang diagnostic pop
