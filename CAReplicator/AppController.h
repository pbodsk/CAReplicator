//
//  AppController.h
//  CAReplicator
//
//  Created by Peter Bødskov on 5/8/13.
//  Copyright (c) 2013 Peter Bødskov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AppController : NSObject {
    IBOutlet NSView *view;
    CALayer *rootLayer;
    CALayer *sublayerOne;
	CALayer *sublayerTwo;
	
	CAReplicatorLayer *replicatorNorth;
	CAReplicatorLayer *replicatorEast;
	CAReplicatorLayer *replicatorSouth;
	CAReplicatorLayer *replicatorWest;

}
@property (weak) IBOutlet NSTextFieldCell *textField;

@end
