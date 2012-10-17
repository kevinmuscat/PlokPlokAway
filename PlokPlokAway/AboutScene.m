//
//  AboutScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "AboutScene.h"

@implementation AboutScene

-(id) init
{
	if( (self=[super init])) {
		
	}
	return self;
}

- (void)onEnter  {
    [children_ makeObjectsPerformSelector:@selector(onEnter)];
	[self resumeSchedulerAndActions];
	isRunning_ = YES;
    
    // screen size
    CGSize s = [CCDirector sharedDirector].winSize;
    
    // background color
    CCLayerColor *layerColor = [[CCLayerColor alloc] initWithColor:ccc4(255, 255, 255, 255)];
    
    //background image
    CCSprite *aboutBG = [CCSprite spriteWithFile:@"aboutBG.png"];
    aboutBG.position = ccp(s.width / 2, s.height / 2);
    
    CCMenuItem* backButton = [CCMenuItemImage itemWithNormalImage:@"backButton.png" selectedImage:@"backButton.png" target:self selector:@selector(backButtonTapped:)];
    backButton.position = ccp(s.width - backButton.rect.size.width / 2, s.height - backButton.rect.size.height / 2);
    
    CCMenu* menu = [CCMenu menuWithItems:backButton, nil];
    menu.position = ccp(0,0);
    
    //addchild
    [self addChild:layerColor z:0];
    [self addChild:aboutBG z:1];
    [self addChild:menu z:3];
}

- (void)backButtonTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[MainMenuScene alloc] init]] withColor:ccWHITE]];
}
@end
