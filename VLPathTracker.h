//
//  VLPathTracker.h
//  HackTest
//
//  Created by Viktor on 10/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface VLPathTracker : CCNode
{
    CCPointArray* _points;
    BOOL _dirtyResults;
    NSArray* _distances;
    
    CCPointArray* _resultPoints;
    NSMutableArray* _resultAngles;
}

@property (nonatomic, readwrite) int maxPoints;
@property (nonatomic, readwrite) float overflowAngle;
@property (nonatomic, retain) NSArray* distances;
@property (nonatomic, readonly) CCPointArray* resultPoints;
@property (nonatomic, readonly) NSArray* resultAngles;

- (void) addPoint:(CGPoint)pt;

@end
