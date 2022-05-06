//
//  RDTModels.h
//  ReDingTalkDylib
//
//  Created by my on 2022/5/5.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RDTLocation : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * detail;

+ (RDTLocation *) fromDictionary: (NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;
@end

@interface RDTGlobalSetting : NSObject
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, strong) RDTLocation * location;

+ (RDTGlobalSetting *) fromDictionary: (NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;
@end

@interface RDTWorkSetting : NSObject
@property (nonatomic, copy) NSString * workName;
@property (nonatomic, copy) NSString * workIcon;
@property (nonatomic, assign) NSInteger workId;
@property (nonatomic, strong) RDTLocation * location;

+ (RDTWorkSetting *) fromDictionary: (NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;
@end

@interface RDTSettings : NSObject
@property(nonatomic, assign) BOOL enable;
@property(nonatomic, strong) RDTGlobalSetting * globalSetting;
@property(nonatomic, copy) NSArray * workSettings;

- (void)unset;

+ (RDTSettings *) fromDictionary: (NSDictionary *)dictionary;
- (NSDictionary *) toDictionary;
@end

NS_ASSUME_NONNULL_END
