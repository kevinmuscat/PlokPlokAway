//
//  HowScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "HowScene.h"

@implementation HowScene

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
    CCSprite *aboutBG = [CCSprite spriteWithFile:@"howToBG.png"];
    aboutBG.position = ccp(s.width / 2, s.height / 2);
    
    //page
    page = [CCSprite spriteWithFile:@"ht1.png"];
    page.position = ccp(s.width / 2, s.height / 2);
    
    //buttons
    CCMenuItem* backButton = [CCMenuItemImage itemWithNormalImage:@"backButton.png" selectedImage:@"backButton.png" target:self selector:@selector(backButtonTapped:)];
    backButton.position = ccp(s.width - backButton.contentSize.width / 2, s.height - backButton.contentSize.height / 2);
    
    leftButton = [CCMenuItemImage itemWithNormalImage:@"leftButton.png" selectedImage:@"leftButton.png" target:self selector:@selector(leftButtonTapped:)];
    leftButton.position = ccp(49, 169 - leftButton.contentSize.height/2);
    
    rightButton = [CCMenuItemImage itemWithNormalImage:@"rightButton.png" selectedImage:@"rightButton.png" target:self selector:@selector(rightButtonTapped:)];
    rightButton.position = ccp(434,169 - rightButton.contentSize.height/2);
    
    CCMenu* menu = [CCMenu menuWithItems:backButton, leftButton, rightButton, nil];
    menu.position = ccp(0,0);
    
    //addchild
    [self addChild:layerColor z:0];
    [self addChild:aboutBG z:1];
    [self addChild:page z:2];
    [self addChild:menu z:3];
    
    currentPageCount = 1;
    [self setPage];
}

-(void)setPage
{
    if(currentPageCount == 1)
        [leftButton setVisible:NO];
    else
        [leftButton setVisible:YES];
    
    if(currentPageCount == 8)
        [rightButton setVisible:NO];
    else
        [rightButton setVisible:YES];
      
    switch (currentPageCount) {
        case 1:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht1.png"]];
            break;
        case 2:
           [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht2.png"]];
            break;
        case 3:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht3.png"]];
            break;
        case 4:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht4.png"]];
            break;
        case 5:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht5.png"]];
            break;
        case 6:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht6.png"]];
            break;
        case 7:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht7.png"]];
            break;
        case 8:
            [page setTexture:[[CCTextureCache sharedTextureCache] addImage:@"ht8.png"]];
            break;
    }
}

- (void)backButtonTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[MainMenuScene alloc] init]] withColor:ccWHITE]];
}

- (void)leftButtonTapped:(id)sender  {
//    [self->buttonClickSound play];
    
    if (currentPageCount > 1)
        currentPageCount--;
    
    [self setPage];
}

- (void)rightButtonTapped:(id)sender  {
//    [self->buttonClickSound play];
    
    if (currentPageCount < 8)
        currentPageCount++;
    
    [self setPage];
}
@end
