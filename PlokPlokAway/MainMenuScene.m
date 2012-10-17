//
//  MainMenuScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "MainMenuScene.h"

int globalScore;

@implementation MainMenuScene

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
    
    // Cyscorpions Logo
    CCSprite *mainMenuBG = [CCSprite spriteWithFile:@"mainMenuBG.png"];
    mainMenuBG.position = ccp(s.width / 2, s.height / 2);
    
    // menu
    playButton = [CCMenuItemImage
                  itemWithNormalImage:@"playButton.png"
                  selectedImage:@"playButton2.png"
                  target:self
                  selector:@selector(playButtonTapped:)];
    howButton = [CCMenuItemImage
                  itemWithNormalImage:@"howButton.png"
                  selectedImage:@"howButton2.png"
                  target:self
                  selector:@selector(howButtonTapped:)];
    aboutButton = [CCMenuItemImage
                  itemWithNormalImage:@"aboutButton.png"
                  selectedImage:@"aboutButton.png"
                  target:self
                  selector:@selector(aboutButtonTapped:)];
    highScoreButton = [CCMenuItemImage
                  itemWithNormalImage:@"highscoreButton.png"
                  selectedImage:@"highscoreButton.png"
                  target:self
                  selector:@selector(highscoreButtonTapped:)];
    
    menu = [CCMenu menuWithItems:playButton,howButton,aboutButton,highScoreButton, nil];
    
    menu.position = ccp(0,0);
    playButton.position = ccp(s.width - playButton.rect.size.width, s.height / 1.5 + playButton.rect.size.height / 2);
    howButton.position = ccp(s.width - howButton.rect.size.width / 1.5, s.height / 2);
    aboutButton.position = ccp(s.width - aboutButton.rect.size.width / 2,s.height - aboutButton.rect.size.height / 2);
    highScoreButton.position = ccp(s.width - highScoreButton.rect.size.width - highScoreButton.rect.size.width / 2, s.height - highScoreButton.rect.size.height / 2);
    
    //add child
    [self addChild:layerColor z:0];
    [self addChild:mainMenuBG z:1];
    [self addChild:menu z:2];
    
    [self playTapSound];
}

- (void)playButtonTapped:(id)sender {
    [tap play];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[GameScene alloc] init]] withColor:ccWHITE]];
}

- (void)howButtonTapped:(id)sender {
    [tap play];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[HowScene alloc] init]] withColor:ccWHITE]];
}

- (void)aboutButtonTapped:(id)sender {
    [tap play];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[AboutScene alloc] init]] withColor:ccWHITE]];
}

- (void)highscoreButtonTapped:(id)sender {
    [tap play];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[HighScoreScene alloc] init]] withColor:ccWHITE]];
}

-(void)playTapSound
{
    NSString *plokFilePath=[[NSBundle mainBundle]pathForResource:@"buttonClick" ofType:@"wav"];
    self->tap=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:plokFilePath] error:nil];
    self->tap.numberOfLoops = 0;
    //self->tap.volume = 50;
    [self->tap prepareToPlay];
}

@end
