#import "MainScene.h"
#import "VLPathTracker.h"

@implementation MainScene

- (void) didLoadFromCCB
{
    // Make sure we recieve touches
    self.userInteractionEnabled = YES;
    
    // Setup sprites that make up the worms body
    _sprites = [NSMutableArray array];
    
    // Use 2 different sprites for the head
    CCSprite* head0 = [CCSprite spriteWithImageNamed:@"Sprites/arrow-0.png"];
    [_sprites addObject:head0];
    
    CCSprite* head1 = [CCSprite spriteWithImageNamed:@"Sprites/arrow-1.png"];
    [_sprites addObject:head1];
    
    // Add a couple of sprites for the tail
    for (int i = 0; i < 10; i++)
    {
        CCSprite* tailPiece = [CCSprite spriteWithImageNamed:@"Sprites/arrow-2.png"];
        [_sprites addObject:tailPiece];
    }
    
    // Add all the sprites to the scene
    for (CCNode* piece in _sprites)
    {
        [self addChild:piece];
    }
    
    // Setup path tracker
    _pathTracker = [[VLPathTracker alloc] init];
    
    // Distances between the sprites (one distance less than the number of sprites)
    _pathTracker.distances = @[@25, @18, @14, @14, @14, @14, @14, @14, @14, @14, @14];
}


// Handle touches
- (void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self moveToPoint:[touch locationInNode:self]];
}

- (void) touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self moveToPoint:[touch locationInNode:self]];
}


// Move worm to a position
- (void) moveToPoint:(CGPoint)pt
{
    // Insert a new control point into the path tracker
    [_pathTracker addPoint:pt];
}

- (void) fixedUpdate:(CCTime)delta
{
    // Update the worm on every frame
    
    // Get positions from path tracker and appy them to the sprites
    CCPointArray* pts = _pathTracker.resultPoints;
    for (int i = 0; i < pts.count; i++)
    {
        CCSprite* piece = [_sprites objectAtIndex:i];
        piece.position = [pts getControlPointAtIndex:i];
    }
    
    // Get rotations from path tracker and apply them to the sprites
    NSArray* angles = _pathTracker.resultAngles;
    for (int i = 0; i < angles.count; i++)
    {
        CCSprite* piece = [_sprites objectAtIndex:i];
        float angle = [[angles objectAtIndex:i] floatValue];
        piece.rotation = -90 - angle;
    }
}

@end
