//
//  RDTModels.m
//  ReDingTalkDylib
//
//  Created by my on 2022/5/5.
//

#import "RDTModels.h"

@implementation RDTLocation

+ (RDTLocation *)fromDictionary:(NSDictionary *)dictionary {
    
    double latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    double longitude = [[dictionary valueForKey:@"longitude"] doubleValue];
    
    RDTLocation * retVal = [[RDTLocation alloc] init];
    retVal.name = [dictionary valueForKey:@"name"];
    retVal.detail = [dictionary valueForKey:@"detail"];
    retVal.coordinate = (CLLocationCoordinate2D){latitude, longitude};
    return retVal;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary * retVal = [@{} mutableCopy];
    [retVal setValue:[_name copy] forKey:@"name"];
    [retVal setValue:@(_coordinate.latitude) forKey:@"latitude"];
    [retVal setValue:@(_coordinate.longitude) forKey:@"longitude"];
    [retVal setValue:[_detail copy] forKey:@"detail"];
    return [retVal copy];
}
@end

@implementation RDTWorkSetting
+ (RDTWorkSetting *)fromDictionary:(NSDictionary *)dictionary {
    RDTWorkSetting * retVal = [RDTWorkSetting new];
    retVal.workName = [dictionary valueForKey:@"workName"];
    retVal.workId = [[dictionary valueForKey:@"workId"] integerValue];
    retVal.workIcon = [dictionary valueForKey:@"workIcon"];
    retVal.location = [RDTLocation fromDictionary:[dictionary valueForKey:@"location"]];
    return retVal;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary * retVal = [@{} mutableCopy];
    [retVal setValue:[_workIcon copy] forKey:@"workIcon"];
    [retVal setValue:[_workName copy] forKey:@"workName"];
    [retVal setValue:@(_workId) forKey:@"workId"];
    [retVal setValue:[_location toDictionary] forKey:@"location"];
    return [retVal copy];
}
@end

@implementation RDTGlobalSetting
+ (RDTGlobalSetting *)fromDictionary:(NSDictionary *)dictionary {
    RDTGlobalSetting * retVal = [RDTGlobalSetting new];
    retVal.enable = [[dictionary valueForKey:@"enable"] boolValue];
    retVal.location = [RDTLocation fromDictionary:[dictionary valueForKey:@"location"]];
    return retVal;
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary * retVal = [@{} mutableCopy];
    [retVal setValue:@(_enable) forKey:@"enable"];
    [retVal setValue:[_location toDictionary] forKey:@"location"];
    return [retVal copy];
}
@end

@implementation RDTSettings
+ (RDTSettings *)fromDictionary:(NSDictionary *)dictionary {
    
    NSMutableArray * workList = [@[] mutableCopy];
    for (NSDictionary * workInfo  in [dictionary valueForKey:@"workSettings"])
        [workList addObject:[RDTWorkSetting fromDictionary:workInfo]];
    
    RDTSettings * retVal = [RDTSettings new];
    retVal.enable = [[dictionary valueForKey:@"enable"] boolValue];
    retVal.globalSetting = [RDTGlobalSetting fromDictionary:[dictionary valueForKey:@"globalSetting"]];
    retVal.workSettings = workList;
    return retVal;
}

- (NSDictionary *)toDictionary {
    NSMutableArray * workList = [@[] mutableCopy];
    for (RDTWorkSetting * workInfo in _workSettings)
        [workList addObject:[workInfo toDictionary]];
    
    NSMutableDictionary * retVal = [@{} mutableCopy];
    [retVal setValue:@(_enable) forKey:@"enable"];
    [retVal setValue:[_globalSetting toDictionary] forKey:@"globalSetting"];
    [retVal setValue:[workList copy] forKey:@"workSettings"];
    return [retVal copy];
}

- (void)unset {
    _enable = NO;
    _globalSetting = [RDTGlobalSetting new];
    _workSettings = @[];
}
@end
