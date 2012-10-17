//
//  LoadingScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "LoadingScene.h"
#import "SceneManager.h"

int globalScore;

@implementation LoadingScene

-(id) init
{
	if( (self=[super init])) {
		
	}
	return self;
}

- (void)onEnter
{
    [children_ makeObjectsPerformSelector:@selector(onEnter)];
	[self resumeSchedulerAndActions];
	isRunning_ = YES;
    
    // screen size
    s = [CCDirector sharedDirector].winSize;
    
    // background color
    CCLayerColor *layerColor = [[CCLayerColor alloc] initWithColor:ccc4(255, 255, 255, 255)];
    
    //[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
    
    background = [CCSprite spriteWithFile:@"loading_screen_edited.png"];
    
    background.position = ccp(s.width / 2, 960);
    
    [self addChild:layerColor z:0];
    [self addChild:background z:1];
    
    [self scheduleOnce:@selector(startAnim) delay:1.0];
    
    [self scheduleOnce:@selector(updateOnce) delay:10];
}

-(void)startAnim
{
    moveBG = [CCMoveTo actionWithDuration:5 position:CGPointMake(s.width / 2, -600)];
    [background runAction:moveBG];
}

- (void)updateOnce
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[MainMenuScene alloc] init]] withColor:ccWHITE]];
}

@end
