//
//  HighScoreScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "HighScoreScene.h"

@implementation HighScoreScene

-(id) init
{
	if( (self=[super init])) {
		
	}
	return self;
}

NSString *score;

- (void)onEnter
{
    [children_ makeObjectsPerformSelector:@selector(onEnter)];
	[self resumeSchedulerAndActions];
	isRunning_ = YES;
    
    // screen size
    CGSize s = [CCDirector sharedDirector].winSize;
    
    // background color
    CCLayerColor *layerColor = [[CCLayerColor alloc] initWithColor:ccc4(255, 255, 255, 255)];
    
    //background image
    CCSprite *highScoreBG = [CCSprite spriteWithFile:@"highscoreBG.png"];
    highScoreBG.position = ccp(s.width / 2, s.height / 2);
    
    CCMenuItem* backButton = [CCMenuItemImage itemWithNormalImage:@"backButton.png" selectedImage:@"backButton.png" target:self selector:@selector(backButtonTapped:)];
    backButton.position = ccp(s.width - backButton.contentSize.width / 2, s.height - backButton.contentSize.height / 2);
    
    CCMenu* menu = [CCMenu menuWithItems:backButton, nil];
    menu.position = ccp(0,0);
    
    [self loadGame];
    
    if (score == nil) {
        score = @"0";
    } 
    
    CCLabelTTF *font = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", score] fontName:@"Andy" fontSize:60];
    font.position = ccp(s.width / 2,s.height / 2);
    
    //addchild
    [self addChild:layerColor z:0];
    [self addChild:highScoreBG z:1];
    [self addChild:font z:2];
    [self addChild:menu z:3];
}

-(void)loadGame
{
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
//    NSString* savedScore = [prefs valueForKey:@"score"];
    score = [prefs valueForKey:@"score"];

//    [lblHighScore setText:savedScore];
//    [lblHighScore setTextColor:[UIColor whiteColor]];
//    [lblHighScore setShadowColor:[UIColor blackColor]];
//    [lblHighScore setFont:[UIFont fontWithName:@"Futura" size:60]];
}

- (void)backButtonTapped:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[MainMenuScene alloc] init]] withColor:ccWHITE]];
}

@end
