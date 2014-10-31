//
//  VLPathTracker.m
//  HackTest
//
//  Created by Viktor on 10/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "VLPathTracker.h"

@implementation VLPathTracker

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    _points = [[CCPointArray alloc] init];
    _maxPoints = 1000;
    _dirtyResults = YES;
    
    return self;
}

- (void) addPoint:(CGPoint)pt
{
    [_points addControlPoint:pt];
    
    if (_points.count > _maxPoints)
    {
        [_points removeControlPointAtIndex:0];
    }
    
    _dirtyResults = YES;
}

- (void) setMaxPoints:(int)maxPoints
{
    _maxPoints = maxPoints;
    
    while (_points.count > _maxPoints) {
        [_points removeControlPointAtIndex:0];
    }
    
    _dirtyResults = YES;
}

- (void) setDistances:(NSArray*) distances
{
    _distances = distances;
}

- (CCPointArray*) resultPoints
{
    if (_dirtyResults)
    {
        [self calcResults];
    }
    
    return _resultPoints;
}

- (NSArray*) resultAngles
{
    if (_dirtyResults)
    {
        [self calcResults];
    }
    
    return _resultAngles;
}

- (void) calcResults
{
    [self calcPoints];
    [self calcAngles];
}

- (void) calcPoints
{
    _resultPoints = [[CCPointArray alloc] init];
    _resultAngles = [NSMutableArray array];
    
    if (!_distances) return;
    if (_distances.count == 0) return;
    
    if (_points.count == 0) return;
    
    int distIdx = 0;
    int pointsIdx = _points.count -1;
    
    CGPoint currentPoint = [_points getControlPointAtIndex:pointsIdx];
    [_resultPoints addControlPoint:currentPoint];
    
    if (_points.count == 1)
    {
        [_resultAngles addObject:[NSNumber numberWithFloat:_overflowAngle]];
        return;
    }
    
    CGPoint nextPoint = [_points getControlPointAtIndex:pointsIdx-1];
    float angle = atan2f(nextPoint.y-currentPoint.y, nextPoint.x-currentPoint.x);
    
    [_resultAngles addObject:[NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(angle)]];
    
    float currentDistance = [[_distances objectAtIndex:distIdx] floatValue];
    
    while (distIdx < _distances.count)
    {
        float ptDist = ccpDistance(currentPoint, nextPoint);
        angle = atan2f(nextPoint.y-currentPoint.y, nextPoint.x-currentPoint.x);
        
        if (currentDistance <= ptDist)
        {
            currentPoint = ccpAdd(currentPoint, ccpMult(ccp(cosf(angle), sinf(angle)), currentDistance));
            
            [_resultPoints addControlPoint:currentPoint];
            [_resultAngles addObject:[NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(angle)]];
            
            distIdx++;
            
            if (distIdx < _distances.count)
            {
                currentDistance = [[_distances objectAtIndex:distIdx] floatValue];
            }
            
        }
        else
        {
            currentPoint = nextPoint;
            pointsIdx--;
            /// XXX check bounds!
            if (pointsIdx <= 0) return;
            
            nextPoint = [_points getControlPointAtIndex:pointsIdx-1];
            
            currentDistance -= ptDist;
        }
    }
}

- (void) calcAngles
{
    int numPoints = _resultPoints.count;
    for (int i = 0; i < numPoints - 1; i++)
    {
        CGPoint current = [_resultPoints getControlPointAtIndex:i];
        CGPoint next = [_resultPoints getControlPointAtIndex:i+1];
        
        float angle = atan2f(next.y - current.y, next.x - current.x);
        [_resultAngles setObject:[NSNumber numberWithFloat:CC_RADIANS_TO_DEGREES(angle)] atIndexedSubscript:i];
    }
}

@end
