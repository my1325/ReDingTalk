//
// Created by my on 2022/4/21.
//

#import "PSViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "RDTModels.h"

typedef void(^LocationSelectCompletion)(NSDictionary * location);
@interface RDTMapViewController : UIViewController
@property (nonatomic, copy) LocationSelectCompletion completion;
@property (nonatomic, strong) RDTLocation * location;
@end
