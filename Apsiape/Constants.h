//
//  Constants.h
//  Apsiape
//
//  Created by Dario Lass on 04.11.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+Colours.h"

#define CELL_IMAGE_PADDING 10
#define CELL_PADDING 0
#define CELL_SEPERATOR_INSET 10
#define ROW_PADDING 1
#define PULL_THRESHOLD 80

FOUNDATION_EXPORT NSString *const BYApsiapeCreateOnLaunchPreferenceKey;

FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDisplayExpenseCreationVCNotificationName;
FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDisplayPreferenceVCNotificationName;
FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDismissExpenseCreationVCNotificationName;
FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDismissPreferencesVCNotificationName;

FOUNDATION_EXPORT NSString *const BYApsiapeUserPreferredAppLocaleIdentifier;

FOUNDATION_EXPORT NSString *const BYApsiapeArrowImageName;
FOUNDATION_EXPORT NSString *const BYApsiapeLeftArrowImageName;
FOUNDATION_EXPORT NSString *const BYApsiapeCameraImageName;
FOUNDATION_EXPORT NSString *const BYApsiapeCrossImageName;
FOUNDATION_EXPORT NSString *const BYApsiapePlusImageName;
FOUNDATION_EXPORT NSString *const BYApsiapeCheckmarkImageName;

#define POPOVER_INSET_X 20
#define POPOVER_INSET_Y 40

typedef enum  {
    BYEdgeTypeNone = 0,
    BYEdgeTypeTop,
    BYEdgeTypeLeft,
    BYEdgeTypeBottom,
    BYEdgeTypeRight
} BYEdgeType;
