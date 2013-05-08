//
//  AppController.m
//  CAReplicator
//
//  Created by Peter Bødskov on 5/8/13.
//  Copyright (c) 2013 Peter Bødskov. All rights reserved.
//

#import "AppController.h"

@implementation AppController

-(void)awakeFromNib {
    self.textField.title = @"animation";
    rootLayer = [CALayer layer];
    
    CGColorRef color = CGColorCreateGenericRGB(0.0, 0.0, 0.0, 1.0);
    rootLayer.backgroundColor = color;
    CGColorRelease(color);
    
    //Replicator Layer
	replicatorEast	= [CAReplicatorLayer layer];
	replicatorNorth = [CAReplicatorLayer layer];
	replicatorSouth = [CAReplicatorLayer layer];
	replicatorWest	= [CAReplicatorLayer layer];
    
	replicatorEast.frame = CGRectMake(0, 0, 50, 50);
	replicatorWest.frame = CGRectMake(0, 0, 50, 50);
    
	replicatorEast.position = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
	replicatorWest.position = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    
	replicatorEast.anchorPoint = CGPointMake(0.5, 0.0);
	replicatorWest.anchorPoint = CGPointMake(0.5, 0.0);
	
	
	//Sublayers
	sublayerOne = [CALayer layer];
	sublayerTwo = [CALayer layer];
	
	sublayerOne.frame = replicatorEast.bounds;
	sublayerTwo.frame = replicatorWest.bounds;
	
    //	sublayerOne.position = position;
    //	sublayerTwo.position = position;
    //	sublayerOne.anchorPoint = CGPointMake(0.5, 0.0);
    //	sublayerTwo.anchorPoint = CGPointMake(0.5, 0.0);
	
	sublayerOne.cornerRadius = 8;
	sublayerTwo.cornerRadius = 8;
	
	color = CGColorCreateGenericRGB(0.5, 1, 1, 1);
//    color = CGColorCreateGenericRGB(1, 1, 1, 1);
    CGColorRef redColor = CGColorCreateGenericRGB(1, 0, 0, 1);
	sublayerOne.backgroundColor = color;
	sublayerTwo.backgroundColor = redColor;
//    sublayerTwo.backgroundColor = color;
	CGColorRelease(color);
    CGColorRelease(redColor);

    
	replicatorWest.transform = CATransform3DMakeScale(0.05, 0.05, 1.0);
	replicatorEast.transform = CATransform3DMakeScale(0.05, 0.05, 1.0);
    
	
	//Stack
	[replicatorNorth addSublayer:sublayerOne];
	[replicatorEast addSublayer:replicatorNorth];
	
	[replicatorSouth addSublayer:sublayerTwo];
	[replicatorWest addSublayer:replicatorSouth];
	
	[rootLayer addSublayer:replicatorEast];
	[rootLayer addSublayer:replicatorWest];

//    [rootLayer addSublayer:replicatorNorth];
//	[rootLayer addSublayer:replicatorSouth];

    

    
    

    view.layer = rootLayer;
    view.wantsLayer = YES;
    view.needsDisplay = YES;
    
    [self performSelector:@selector(zoomIn) withObject:nil afterDelay:1.0];
    
}

-(void)zoomIn {
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:.4];
    replicatorWest.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
	replicatorEast.transform = CATransform3DMakeScale(1.0, 1.0, 1.0);
    [CATransaction commit];

    [self performSelector:@selector(transform3D) withObject:nil afterDelay:.5];
}

-(void)transform3D {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    CATransform3D t = CATransform3DIdentity;
	t.m34 = 1.0/-550; //Newmans
	
	
	t = CATransform3DRotate(t, 0.09, 0, 0, 1); //Z
	t = CATransform3DRotate(t, .762, 0, 1, 0);	//Y
	t = CATransform3DRotate(t, 1.44, -1, 0, 0); //X
	
	replicatorEast.position = CGPointMake(135, 0);
	replicatorWest.position = CGPointMake(135, 0);
	
	rootLayer.sublayerTransform = t;
    [CATransaction commit];
     
    
    [self performSelector:@selector(createNorthQuad) withObject:nil afterDelay:1.0];
}

-(void)createNorthQuad {
    [CATransaction setDisableActions:YES];
    replicatorEast.instanceCount = 2;
    replicatorNorth.instanceCount = 2;
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:1.0];
    replicatorEast.instanceTransform = CATransform3DMakeTranslation(55, 0, 0);
    replicatorNorth.instanceTransform = CATransform3DMakeTranslation(0, 55, 0);
    
    [self performSelector:@selector(createSouthQuad) withObject:nil afterDelay:1.0];
}

-(void)createSouthQuad {
    [CATransaction setDisableActions:YES];
    replicatorWest.instanceCount = 2;
    replicatorSouth.instanceCount = 2;
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationDuration:1.0];
    replicatorWest.instanceTransform = CATransform3DMakeTranslation(-55, 0, 0);
    replicatorSouth.instanceTransform = CATransform3DMakeTranslation(0, -55, 0);
    
    //Zoom Out
	rootLayer.sublayerTransform = CATransform3DIdentity;
	
	replicatorEast.position = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
	replicatorWest.position = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
	
	[CATransaction commit];
    [self performSelector:@selector(spreadX) withObject:nil afterDelay:1.0];
}

-(void)centerX {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
//    replicatorNorth.instanceTransform = CATransform3DIdentity;
//    replicatorSouth.instanceTransform = CATransform3DIdentity;
    [CATransaction commit];
    [self performSelector:@selector(centerY) withObject:nil afterDelay:1.0];
}

-(void)centerY {
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];
//    replicatorEast.instanceTransform = CATransform3DIdentity;
//    replicatorWest.instanceTransform = CATransform3DIdentity;
    [CATransaction commit];
    [self performSelector:@selector(centerY) withObject:nil afterDelay:1.0];
}

-(void)spreadX {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:1.0];
    replicatorEast.instanceCount = 20;
    replicatorWest.instanceCount = 20;
    replicatorEast.instanceRedOffset = -0.05;
    replicatorEast.instanceBlueOffset = -0.05;
    replicatorWest.instanceGreenOffset = 0.05;
    replicatorWest.instanceBlueOffset = 0.05;
    [CATransaction setDisableActions:NO];
    replicatorEast.instanceTransform = CATransform3DMakeTranslation(55.0, 0.0, 0.0);
	replicatorWest.instanceTransform = CATransform3DMakeTranslation(-55.0, 0.0, 0.0);
	
	rootLayer.sublayerTransform = CATransform3DMakeScale(0.4, 0.4, 1.0);

    [CATransaction commit];
    [self performSelector:@selector(spreadY) withObject:nil afterDelay:1.0];
}

-(void)spreadY {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction setAnimationDuration:1.0];
    replicatorNorth.instanceCount = 20;
    replicatorSouth.instanceCount = 20;
    replicatorNorth.instanceRedOffset = -0.05;
    replicatorSouth.instanceGreenOffset = 0.05;
    replicatorNorth.instanceDelay = 1.3;
    replicatorSouth.instanceDelay = 1.1;
    [CATransaction setDisableActions:NO];
    replicatorNorth.instanceTransform = CATransform3DMakeTranslation(0.0, 55.0, 0.0);
	replicatorSouth.instanceTransform = CATransform3DMakeTranslation(0.0, -55.0, 0.0);
	
	rootLayer.sublayerTransform = CATransform3DMakeScale(0.4, 0.4, 1.0);
    
    [CATransaction commit];
    
}


@end
