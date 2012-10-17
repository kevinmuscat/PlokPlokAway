//
//  GameScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "GameScene.h"

int globalScore;
int globalWhatLevel;
int globalBonusScore;

@implementation GameScene

//Level Determiner
const int level2 = 40;  //40
const int level3 = 100; //100
const int level4 = 180; //180
const int level5 = 280; //280
bool bg1Changed = false;
bool bg2Changed = false;
bool bg3Changed = false;
bool bg4Changed = false;

//Adding of Targets Determiner
int goldRange=3;
int goldBaseRange = 1;
int stoneRange = 5;
int stoneBaseRange = 3;
int greenRange = 5;
int greenBaseRange = 3;
int rainbowRange = 9;
int rainbowBaseRange = 4;
int foxRange = 4;
int foxBaseRange = 3;
int blueRange = 4;
int blueBaseRange = 2;

float x;
float baseEggWidth = 10;
int eggHitNestCountPerLevel;
int eggHitNestCount;
int startTime;
bool newGame;

NSString* showHighScore;

@synthesize columns;
int randColumnIndex;
int randColumnIndexComparer;

@synthesize ratMotionLeft;

-(id) init
{
	if( (self=[super init])) {
        //screen size
        s = [CCDirector sharedDirector].winSize;
        
        //background color
        CCLayerColor *layerColor = [[CCLayerColor alloc] initWithColor:ccc4(255, 255, 255, 255)];
        
        //bacground image
        background = [CCSprite spriteWithFile:@"bg1.png"];
        background.position = ccp(s.width / 2, s.height / 2);
        
        //level BG
        levelBG = [CCSprite spriteWithFile:@"levelBG1.png"];
        levelBG.position = ccp(s.width - levelBG.textureRect.size.width / 2, 0 + levelBG.textureRect.size.height / 2);
        
        eggTrayBase = [CCSprite spriteWithFile:@"eggMeter.png"];
        
        //player
        player = [CCSprite spriteWithFile:@"nest.png"];
        player.position = ccp(240 + player.textureRect.size.width / 2, player.textureRect.size.height / 2);
             
        //egg meter base
        eggMeterBase = [CCSprite spriteWithFile:@"eggMeterBasis.png"];
        eggMeterBase.position = ccp(eggMeterBase.contentSize.width/2, eggMeterBase.contentSize.height/2);
        
        //egg tray complete
        eggTrayComplete = [CCSprite spriteWithFile:@"eggTrayComplete.png"];
        eggTrayComplete.position = ccp(eggTrayComplete.contentSize.width/2, 50 + eggTrayComplete.contentSize.height/2);
        
        //egg tray
        eggTray = [CCProgressTimer progressWithSprite:eggTrayBase];
        eggTray.type = kCCProgressTimerTypeBar;
        eggTray.percentage = 10;
        eggTray.position = ccp(1 + eggTrayBase.contentSize.width/2 ,46 - eggTrayBase.contentSize.height / 2);
        eggTray.barChangeRate=ccp(1,0);
        // 1.0,0.0 left 0.0,0.0 right
        eggTray.midpoint=ccp(0.0,0.0f);
        // 0,0 right 1,1 left 0.5,0.5 middle
        [eggTray setAnchorPoint: ccp(0.5,0.5)];
        
        //label countdown
        lblCountDown = [CCLabelTTF labelWithString:@"" fontName:@"Andy" fontSize:80];
        lblCountDown.position = ccp(s.width / 2 + 40 ,s.height / 2 - 100);
        
        //label time
        lblTime = [CCLabelTTF labelWithString:@"00:00" fontName:@"Andy" fontSize:25];
        lblTime.position = ccp(38.88f, 305.5);
        [lblTime setColor:ccWHITE];
        
        //label score count
        lblScoreCount = [CCLabelTTF labelWithString:@"0" fontName:@"Andy" fontSize:25];
        lblScoreCount.position = ccp(43 - lblScoreCount.contentSize.width /2 ,258.5);
        [lblScoreCount setColor:ccWHITE];
        [lblScoreCount setAnchorPoint:CGPointMake(0.5, 0.5)];
        
        //label egg count
        lblEggCount = [CCLabelTTF labelWithString:@"0" fontName:@"Andy" fontSize:25];
        lblEggCount.position = ccp(38.73f ,92.5);
        [lblEggCount setColor:ccWHITE];
        
        //label green egg count
        lblGreenEggCount = [CCLabelTTF labelWithString:@"0" fontName:@"Andy" fontSize:30];
        lblGreenEggCount.position = ccp(20.21,170 - lblGreenEggCount.contentSize.height);
        [lblGreenEggCount setColor:ccBLACK];
        
        //label showHighScore

        lblShowHighScore = [CCLabelTTF labelWithString:@"0" fontName:@"Andy" fontSize:30];
        
        //[NSString stringWithFormat:@"%@", showHighScore]
        lblShowHighScore.position = ccp((440 - lblShowHighScore.contentSize.width/2),120);
        [lblShowHighScore setColor:ccWHITE];
        [lblShowHighScore setAnchorPoint:CGPointMake(0.5, 0.5)];
        
        //life images
        imageLife1 = [CCSprite spriteWithFile:@"nest.png"];
        imageLife1.position = ccp(imageLife1.contentSize.width / 4, imageLife1.contentSize.height / 2 + 190);
        imageLife1.scaleX = 0.4f;
        imageLife1.scaleY = 0.6f;
        
        imageLife2 = [CCSprite spriteWithFile:@"nest.png"];
        imageLife2.position = ccp(imageLife1.contentSize.width / 4 + 40, imageLife1.contentSize.height / 2 + 190);
        imageLife2.scaleX = 0.4f;
        imageLife2.scaleY = 0.6f;
        
        imageLife3 = [CCSprite spriteWithFile:@"nest.png"];
        imageLife3.position = ccp(imageLife1.contentSize.width / 4, imageLife1.contentSize.height / 2 + 170);
        imageLife3.scaleX = 0.4f;
        imageLife3.scaleY = 0.6f;
        
        imageLife4 = [CCSprite spriteWithFile:@"nest.png"];
        imageLife4.position = ccp(imageLife1.contentSize.width / 4 + 40, imageLife1.contentSize.height / 2 + 170);
        imageLife4.scaleX = 0.4f;
        imageLife4.scaleY = 0.6f;
        
        //buttons
        pauseButton = [CCMenuItemImage itemWithNormalImage:@"pauseButton.png"
                                             selectedImage:@"pauseButton.png"
                                                    target:self
                                                  selector:@selector(btnPauseTapped:)];
        pauseButton.position = ccp(40,10);
        
        CCMenu* menuScreen = [CCMenu menuWithItems:pauseButton, nil];
        menuScreen.position = ccp(0,0);
        
        homeButton = [CCMenuItemImage itemWithNormalImage:@"homeButton.png"
                                            selectedImage:@"homeButton.png"
                                                   target:self
                                                 selector:@selector(btnHomeTapped:)];
        
        homeButton.position = ccp(456 , 50 + homeButton.contentSize.height/2);
        
        playAgainButton = [CCMenuItemImage itemWithNormalImage:@"playagainButton.png"
                                                 selectedImage:@"playagainButton.png"
                                                        target:self
                                                      selector:@selector(btnPlayAgainTapped:)];
        playAgainButton.position = ccp(456 , 0 + playAgainButton.contentSize.height/2);
        
        menuOverlay = [CCMenu menuWithItems:homeButton, playAgainButton, nil];
        menuOverlay.position = ccp(0,0);
        
        //blue egg up
        blueEggUp = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"eggBase.png"]];
        blueEggUp.type = kCCProgressTimerTypeBar;
        blueEggUp.percentage = 0;
        blueEggUp.position = ccp(58.50,139);
        blueEggUp.barChangeRate=ccp(0,1);
        // 1.0,0.0 left 0.0,0.0 right
        blueEggUp.midpoint=ccp(1.0,0.0f);
        // 0,0 right 1,1 left 0.5,0.5 middle
        [blueEggUp setAnchorPoint: ccp(0.5,0.5)];
        
        //Pause
        pauseOverlay = [CCSprite spriteWithFile:@"pause.png"];
        pauseOverlay.position = ccp(s.width / 2, s.height / 2);
        
        //Win
        winOverlay = [CCSprite spriteWithFile:@"win.png"];
        winOverlay.position = ccp(s.width / 2, s.height / 2);
        
        //Lose
        loseOverlay = [CCSprite spriteWithFile:@"lose.png"];
        loseOverlay.position = ccp(s.width / 2, s.height / 2);
        
        //HEN
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hen.plist"];
        
        defaultPose = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"hen1.png"];
        
        hen1 = [CCSprite spriteWithSpriteFrame:defaultPose];
        hen1.position = ccp(120,295);
        
        hen2 = [CCSprite spriteWithSpriteFrame:defaultPose];
        hen2.position = ccp(200,295);
        
        hen3 = [CCSprite spriteWithSpriteFrame:defaultPose];
        hen3.position = ccp(280,295);
        
        hen4 = [CCSprite spriteWithSpriteFrame:defaultPose];
        hen4.position = ccp(360,295);
        
        hen5 = [CCSprite spriteWithSpriteFrame:defaultPose];
        hen5.position = ccp(440,295);
        
        //animate hen
        hen1Frames = [NSMutableArray arrayWithCapacity:23];
        hen2Frames = [NSMutableArray arrayWithCapacity:23];
        hen3Frames = [NSMutableArray arrayWithCapacity:23];
        hen4Frames = [NSMutableArray arrayWithCapacity:23];
        hen5Frames = [NSMutableArray arrayWithCapacity:23];
        
        [self setHenFrames:1];
        [self setHenFrames:2];
        [self setHenFrames:3];
        [self setHenFrames:4];
        [self setHenFrames:5];
        
        CCAnimation* henAnimation = [CCAnimation animationWithSpriteFrames:hen1Frames delay:0.5];
        CCAnimate* animateHen = [CCAnimate actionWithAnimation:henAnimation];
        self.henMotion = [CCSequence actions:animateHen, nil];
        repeatMotion = [CCRepeatForever actionWithAction:self.henMotion];
        [hen1 runAction:repeatMotion];
        
        henAnimation = [CCAnimation animationWithSpriteFrames:hen2Frames delay:0.5];
        animateHen = [CCAnimate actionWithAnimation:henAnimation];
        self.henMotion = [CCSequence actions:animateHen, nil];
        repeatMotion = [CCRepeatForever actionWithAction:self.henMotion];
        [hen2 runAction:[[repeatMotion copy] autorelease]];
        
        henAnimation = [CCAnimation animationWithSpriteFrames:hen3Frames delay:0.5];
        animateHen = [CCAnimate actionWithAnimation:henAnimation];
        self.henMotion = [CCSequence actions:animateHen, nil];
        repeatMotion = [CCRepeatForever actionWithAction:self.henMotion];
        [hen3 runAction:[[repeatMotion copy] autorelease]];
        
        henAnimation = [CCAnimation animationWithSpriteFrames:hen4Frames delay:0.5];
        animateHen = [CCAnimate actionWithAnimation:henAnimation];
        self.henMotion = [CCSequence actions:animateHen, nil];
        repeatMotion = [CCRepeatForever actionWithAction:self.henMotion];
        [hen4 runAction:[[repeatMotion copy] autorelease]];
        
        henAnimation = [CCAnimation animationWithSpriteFrames:hen5Frames delay:0.5];
        animateHen = [CCAnimate actionWithAnimation:henAnimation];
        self.henMotion = [CCSequence actions:animateHen, nil];
        repeatMotion = [CCRepeatForever actionWithAction:self.henMotion];
        [hen5 runAction:[[repeatMotion copy] autorelease]];
        
        //cow
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cow.plist"];
        CCSpriteFrame* defaultCow = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cow1.png"];
        cow = [CCSprite spriteWithSpriteFrame:defaultCow];
        cow1 = [CCSprite spriteWithSpriteFrame:defaultCow];
        cow.flipX = YES;
        
        NSMutableArray* cowFrames = [NSMutableArray arrayWithCapacity:2];
        for (int i = 1; i <= 2; i++) {
            NSString *file = [NSString stringWithFormat:@"cow%i.png", i];
            CCSpriteFrame* frameCow = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            
            [cowFrames addObject:frameCow];
        }
        CCAnimation* cowAnimation = [CCAnimation animationWithSpriteFrames:cowFrames delay:1];
        CCAnimate* cowAction = [CCAnimate actionWithAnimation:cowAnimation];
        self.cowMotion = [CCRepeatForever actionWithAction:cowAction];
        CCSpawn* cowMove = [CCSpawn actions:self.cowMotion, nil];
        CCSequence* cowGo = [CCSequence actions:cowMove, nil];
        CCSequence* cowGo1 = cowGo.copy;
        
        cow.scaleX = .2f;
        cow.scaleY = .2f;
        cow.position = ccp(160, 120);
        cow1.scaleX = .2f;
        cow1.scaleY = .2f;
        cow1.position = ccp(415, 95);
        [cow runAction:[CCSequence actions:cowGo, nil]];
        [cow1 runAction:[CCSequence actions:cowGo1, nil]];
        
        //cow sleeping
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cow_sleeping.plist"];
        CCSpriteFrame* defaultCowSleeping = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"cow_sleeping1.png"];
        cow_sleeping = [CCSprite spriteWithSpriteFrame:defaultCowSleeping];
        cow_sleeping1 = [CCSprite spriteWithSpriteFrame:defaultCowSleeping];
        cow_sleeping.flipX = YES;
        
        NSMutableArray* cowSleepingFrames = [NSMutableArray arrayWithCapacity:2];
        for (int i = 1; i <= 2; i++) {
            NSString *file = [NSString stringWithFormat:@"cow_sleeping%i.png", i];
            CCSpriteFrame* frameSleepingCow = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            
            [cowSleepingFrames addObject:frameSleepingCow];
        }
        CCAnimation* cowSleepingAnimation = [CCAnimation animationWithSpriteFrames:cowSleepingFrames delay:1];
        CCAnimate* cowSleepingAction = [CCAnimate actionWithAnimation:cowSleepingAnimation];
        self.cowSleepingMotion = [CCRepeatForever actionWithAction:cowSleepingAction];
        CCSpawn* cowSleepMove = [CCSpawn actions:self.cowSleepingMotion, nil];
        CCSequence* cowSleepGo = [CCSequence actions:cowSleepMove, nil];
        CCSequence* cowSleepGo1 = cowSleepGo.copy;
        
        cow_sleeping.scaleX = .2f;
        cow_sleeping.scaleY = .2f;
        cow_sleeping.position = ccp(160, 120);
        cow_sleeping1.scaleX = .2f;
        cow_sleeping1.scaleY = .2f;
        cow_sleeping1.position = ccp(415, 95);
        [cow_sleeping runAction:[CCSequence actions:cowSleepGo, nil]];
        [cow_sleeping1 runAction:[CCSequence actions:cowSleepGo1, nil]];
        
        //indicator
        indicator = [CCSprite spriteWithFile:@"increase.png"];
        indicator.position = ccp(240 + indicator.textureRect.size.width / 2, indicator.textureRect.size.height / 2);
        
        //add child
        [self addChild:layerColor z:0];
        [self addChild:background z:1];
        [self addChild:levelBG z:4];
        [self addChild:eggMeterBase z:4];
        [self addChild:eggTrayComplete z:4];
        [self addChild:eggTray z:4];
        [self addChild:lblCountDown z:5];
        [self addChild:lblScoreCount z:4];
        [self addChild:lblEggCount z:4];
        [self addChild:lblTime z:4];
        [self addChild:lblShowHighScore z:-1];
        [self addChild:lblGreenEggCount z:5];
        [self addChild:blueEggUp z:5];
        [self addChild:imageLife1 z:4];
        [self addChild:imageLife2 z:4];
        [self addChild:imageLife3 z:4];
        [self addChild:imageLife4 z:4];
        [self addChild:hen1 z:3];
        [self addChild:hen2 z:3];
        [self addChild:hen3 z:3];
        [self addChild:hen4 z:3];
        [self addChild:hen5 z:3];
        [self addChild:cow z:-1];
        [self addChild:cow1 z:-1];
        [self addChild:cow_sleeping z:-1];
        [self addChild:cow_sleeping1 z:-1];
        [self addChild:indicator z:-1];
        [self addChild:menuScreen z:4];
        [self addChild:menuOverlay z:-1];
        [self addChild:pauseOverlay z:-1];
        [self addChild:winOverlay z:-1];
        [self addChild:loseOverlay z:-1];
        [self addChild:player z:3];
        
        whiteEggs = [[NSMutableArray alloc] init];
        silverEggs = [[NSMutableArray alloc] init];
        goldEggs = [[NSMutableArray alloc] init];
        stones = [[NSMutableArray alloc] init];
        greenEggs = [[NSMutableArray alloc] init];
        rats = [[NSMutableArray alloc] init];
        rainbowEggs = [[NSMutableArray alloc] init];
        foxes = [[NSMutableArray alloc] init];
        blueEggs = [[NSMutableArray alloc] init];
        
        fallenEggsToNest = [[NSMutableArray alloc] init];
        fallenEggsToFloor = [[NSMutableArray alloc] init];
        fallenStonesToNest = [[NSMutableArray alloc] init];
        fallenStonesToFloor = [[NSMutableArray alloc] init];
        ratsHistNest = [[NSMutableArray alloc] init];
        
        [self initLoad:1];
        
        [self schedule:@selector(gameLogic:) interval:2.0];
        [self schedule:@selector(update:)];
        
        newGame = true;
        paused = YES;
        lives = 4;
        homeButton.isEnabled = false;
        playAgainButton.isEnabled = false;
        isOnGround = YES;
        
        self.columns = [NSMutableArray arrayWithObjects: @"95", @"120", @"145", @"175", @"200", @"225", @"255", @"280", @"305", @"335", @"360", @"385", @"415", @"440", @"465" , nil];
        

        
	}
	return self;
}

- (void)onEnter  {
    [children_ makeObjectsPerformSelector:@selector(onEnter)];
	[self resumeSchedulerAndActions];
	isRunning_ = YES;
    
    //accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/30.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];    
}

-(void)initLoad:(int)num
{
    eggHitNestCountPerLevel=0;
    
    [self removeObjectsFromScreen];
    baseEggWidth = 10;
    [eggTray setPercentage:baseEggWidth];
    
    player.position = ccp(240 + player.textureRect.size.width / 2, player.textureRect.size.height / 2);
    
    if(num == 1)
    {
        [background setTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg1.png"]];
    }
    if(num == 2)
    {
        [background setTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg2.png"]];
        [cow setZOrder:3];
        [cow1 setZOrder:3];
    }
    if(num == 3)
    {
        [background setTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg3.png"]];
        [cow setZOrder:-1];
        [cow1 setZOrder:-1];
        [cow_sleeping setZOrder:3];
        [cow_sleeping1 setZOrder:3];

    }
    if(num == 4)
    {
        [background setTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg4.png"]];
        [cow_sleeping setZOrder:-1];
        [cow_sleeping1 setZOrder:-1];

    }
    if(num == 5)
    {
        [background setTexture:[[CCTextureCache sharedTextureCache] addImage:@"bg5.png"]];
    }
    
    [self startlevelBGFadeIn];
    startTime = 5;
    [self schedule:@selector(startTimer) interval:1.0];
}


//EVENTS
-(void) btnPauseTapped :(id)sender
{
//    [self->buttonClickSound play];
    
    if (paused == YES)
    {
        //resumeOnDidBecomeActive = YES; //will resume after going to the background
        [(CCMenuItemImage *)pauseButton setNormalImage:[CCSprite spriteWithFile:@"pauseButton.png"]];
        [[CCDirector sharedDirector]resume];
        [pauseOverlay setZOrder:-1];
        [menuOverlay setZOrder:-1];
        homeButton.isEnabled = false;
        playAgainButton.isEnabled = false;
        self.isTouchEnabled = YES;
        paused = NO;
        
    }
    else if (paused == NO)
    {
        //self.resumeOnDidBecomeActive = NO;
        [(CCMenuItemImage *)pauseButton setNormalImage:[CCSprite spriteWithFile:@"resumeButton.png"]];
        [[CCDirector sharedDirector]pause];
        [pauseOverlay setZOrder:10];
        [menuOverlay setZOrder:11];
        homeButton.isEnabled = true;
        playAgainButton.isEnabled = true;
        self.isTouchEnabled = NO;
        paused = YES;
    }
}

-(void) btnHomeTapped :(id)sender
{
//    [self->buttonClickSound play];
    
    [[CCDirector sharedDirector]resume];
    [self reset];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[MainMenuScene alloc] init]] withColor:ccWHITE]];
}

-(void) btnPlayAgainTapped :(id)sender
{
//    [self->buttonClickSound play];
    
    [[CCDirector sharedDirector]resume];
    
    [self reset];
    [pauseOverlay setZOrder:-1];
    [winOverlay setZOrder:-1];
    [loseOverlay setZOrder:-1];
    [menuOverlay setZOrder:-1];
    homeButton.isEnabled = false;
    playAgainButton.isEnabled = false;
    paused = YES;
    [self initLoad:1];
}

//JUMP OVER RAT
-(void)jump
{
    isOnGround = NO;
    id action = [CCMoveBy actionWithDuration:0.1 position:ccp(0, player.position.y + 30)];
    id actionBetween = [CCMoveBy actionWithDuration:0.7 position:ccp(0, 0)];
    id actionDone =[CCCallFuncN actionWithTarget:self selector:@selector(afterJump)];
    [player runAction:[CCSequence actions:action,actionBetween, actionDone, nil]];

}

//BACK DOWN
-(void)afterJump
{
    id action = [CCMoveBy actionWithDuration:0.2 position:ccp(0, 0)];
    [player runAction:action];
    [self scheduleOnce:@selector(setIsOnGround) delay:0.3];
}

//SET ISONGROUND
-(void)setIsOnGround
{
    isOnGround = YES;
}

-(void)reset
{
    [(CCMenuItemImage *)pauseButton setNormalImage:[CCSprite spriteWithFile:@"pauseButton.png"]];
    
    score = 0;
    timer = 0;
    time = @"00:00";
    eggHitNestCountPerLevel = 0;
    eggHitNestCount = 0;;
    greenEggCount = 0;
    [self removeObjectsFromScreen];
    bg1Changed = false;
    bg2Changed = false;
    bg3Changed = false;
    bg4Changed = false;
    lives = 4;
    
    [imageLife1 runAction:[CCFadeIn actionWithDuration:0.2]];
    [imageLife2 runAction:[CCFadeIn actionWithDuration:0.2]];
    [imageLife3 runAction:[CCFadeIn actionWithDuration:0.2]];
    [imageLife4 runAction:[CCFadeIn actionWithDuration:0.2]];
    [imageLife1 setVisible:YES];
    [imageLife2 setVisible:YES];
    [imageLife3 setVisible:YES];
    [imageLife4 setVisible:YES];
    [cow setZOrder:-1];
    [cow1 setZOrder:-1];
    [cow_sleeping setZOrder:-1];
    [cow_sleeping1 setZOrder:-1];
    
    blueEggCount=0;
    blueEggWidth = 0;
    [blueEggUp setPercentage:blueEggWidth];
    [self resetPlayerSize];
    [levelBG setVisible:YES];
    
    globalScore = 0;
    globalBonusScore = 0;
    globalWhatLevel = 1;
}

-(void)resetPlayerSize
{
    player.scale = 1;
    indicator.scale = 1;
}


-(void) removeObjectsFromScreen
{
    for (CCSprite* whiteEgg in [[whiteEggs copy] autorelease]) {
        [whiteEggs removeObject:whiteEgg];
        [self removeChild:whiteEgg cleanup:YES];
    }
    
    for (CCSprite* silverEgg in [[silverEggs copy] autorelease]) {
        [silverEggs removeObject:silverEgg];
        [self removeChild:silverEgg cleanup:YES];
    }
    
    for (CCSprite* goldEgg in [[goldEggs copy] autorelease]) {
        [goldEggs removeObject:goldEgg];
        [self removeChild:goldEgg cleanup:YES];
    }
    
    for (CCSprite* stone in [[stones copy] autorelease]) {
        [stones removeObject:stone];
        [self removeChild:stone cleanup:YES];
    }
    
    for (CCSprite* greenEgg in [[greenEggs copy] autorelease]) {
        [greenEggs removeObject:greenEgg];
        [self removeChild:greenEgg cleanup:YES];
    }

    for (CCSprite* rainbowEgg in [[rainbowEggs copy] autorelease]) {
        [rainbowEggs removeObject:rainbowEgg];
        [self removeChild:rainbowEgg cleanup:YES];
    }
    
    for (CCSprite* fox in [[foxes copy] autorelease]) {
        [foxes removeObject:fox];
        [self removeChild:fox cleanup:YES];
    }
    
    for (CCSprite* blueEgg in [[blueEggs copy] autorelease]) {
        [blueEggs removeObject:blueEgg];
        [self removeChild:blueEgg cleanup:YES];
    }
}

-(void) startlevelBGFadeIn
{
  
    [levelBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"levelBG1.png"]];
    if(eggHitNestCount >= level2 && eggHitNestCount < level3)
        [levelBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"levelBG2.png"]];
    if(eggHitNestCount >= level3 && eggHitNestCount < level4)
        [levelBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"levelBG3.png"]];
    if(eggHitNestCount >= level4 && eggHitNestCount < level5)
        [levelBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"levelBG4.png"]];
    if(eggHitNestCount >= level5)
    {
        NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
        showHighScore = [prefs valueForKey:@"score"];
        if(showHighScore == nil)
            showHighScore = @"0";
        [lblShowHighScore setZOrder:8];
        [lblShowHighScore setString:[NSString stringWithFormat:@"%@", showHighScore]];
        [levelBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"levelBG5.png"]];
    }
    
    id fadeIn = [CCFadeIn actionWithDuration:1.5];
    [levelBG runAction:[CCSequence actions:fadeIn, nil]];

}


//TIMERS
-(void)startTimer
{
    if(startTime == 5)
        score += globalBonusScore;
    
    // PAUSE
    paused = YES;
    pauseButton.isEnabled = false;
    self.isTouchEnabled = NO;
    
    [lblCountDown setString:[NSString stringWithFormat:@"%d", startTime]];
    [lblCountDown setColor:ccWHITE];
    
    //ANIMATION for lblCountDown
    
    startTime--;
    
    if(startTime == -1)
    {
        if(newGame)
        {
            [self schedule:@selector(updateTime) interval:1.0];
            newGame = false;
            //[self setHens];
        }
        //RESUME
        paused  = NO;
        pauseButton.isEnabled = true;
        self.isTouchEnabled = YES;
        [self unschedule:@selector(startTimer)];
        [lblCountDown setString:@" "];
        id fadeOut = [CCFadeOut actionWithDuration:0.5];
        [levelBG runAction:[CCSequence actions:fadeOut, nil]];
        [self scheduleOnce:@selector(fade) delay:0.5];
    }
}

-(void) fade
{
    [lblShowHighScore setZOrder:-1]; //if level 5
    [levelBG setVisible:NO];
}


int timer = 0;
int minute = 0;
-(void) updateTime
{
    if (paused == NO)
        timer++;
    
    if (timer == 60)
    {
        minute++;
        timer = 0;
    }
    
    if(minute <= 9)
    {
        if (timer <= 9){
            time = [NSString stringWithFormat:@"0%d:0%d",minute ,timer];
        }
        else
        {
            time = [NSString stringWithFormat:@"0%d:%d",minute ,timer];
        }
    }
    else
    {
        if (timer <= 9){
            time = [NSString stringWithFormat:@"%d:0%d" ,minute ,timer];
        }
        else
        {
            time = [NSString stringWithFormat:@"%d:%d",minute ,timer];
        }
    }
    
    [lblTime setString:time];

}


//SETTERS
-(void) setHenFrames: (int) henNum
{
    CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen1.png"]];
    CCSpriteFrame* frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen2.png"]];
    CCSpriteFrame* frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen3.png"]];
    CCSpriteFrame* frame4 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen4.png"]];
    CCSpriteFrame* frame5 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen5.png"]];
    CCSpriteFrame* frame6 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen6.png"]];
    CCSpriteFrame* frame7 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen7.png"]];
    CCSpriteFrame* frame8 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen8.png"]];
    CCSpriteFrame* frame9 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen9.png"]];
    CCSpriteFrame* frame10 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen10.png"]];
    CCSpriteFrame* frame11 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"hen11.png"]];
    
    switch (henNum) {
        case 1:
            for (int i = 0; i < 7; i++)
                [hen1Frames addObject:frame1];
            [hen1Frames addObject:frame2];
            [hen1Frames addObject:frame3];
            [hen1Frames addObject:frame4];
            [hen1Frames addObject:frame5];
            [hen1Frames addObject:frame6];
            [hen1Frames addObject:frame6];
            [hen1Frames addObject:frame7];
            [hen1Frames addObject:frame7];
            [hen1Frames addObject:frame8];
            [hen1Frames addObject:frame8];
            [hen1Frames addObject:frame9];
            [hen1Frames addObject:frame9];
            [hen1Frames addObject:frame10];
            [hen1Frames addObject:frame10];
            [hen1Frames addObject:frame11];
            [hen1Frames addObject:frame11];
            break;
        case 2:
            [hen2Frames addObject:frame2];
            [hen2Frames addObject:frame3];
            [hen2Frames addObject:frame4];
            [hen2Frames addObject:frame5];
            [hen2Frames addObject:frame6];
            [hen2Frames addObject:frame6];
            [hen2Frames addObject:frame7];
            [hen2Frames addObject:frame7];
            [hen2Frames addObject:frame8];
            [hen2Frames addObject:frame8];
            [hen2Frames addObject:frame9];
            [hen2Frames addObject:frame9];
            [hen2Frames addObject:frame10];
            [hen2Frames addObject:frame10];
            [hen2Frames addObject:frame11];
            [hen2Frames addObject:frame11];
            for (int i = 0; i < 7; i++)
                [hen2Frames addObject:frame1];
            break;
        case 3:
            [hen3Frames addObject:frame7];
            [hen3Frames addObject:frame7];
            [hen3Frames addObject:frame8];
            [hen3Frames addObject:frame8];
            [hen3Frames addObject:frame9];
            [hen3Frames addObject:frame9];
            [hen3Frames addObject:frame10];
            [hen3Frames addObject:frame10];
            [hen3Frames addObject:frame11];
            [hen3Frames addObject:frame11];
            for (int i = 0; i < 7; i++)
                [hen3Frames addObject:frame1];
            [hen3Frames addObject:frame2];
            [hen3Frames addObject:frame3];
            [hen3Frames addObject:frame4];
            [hen3Frames addObject:frame5];
            [hen3Frames addObject:frame6];
            [hen3Frames addObject:frame6];
            break;
        case 4:
            [hen4Frames addObject:frame10];
            [hen4Frames addObject:frame10];
            [hen4Frames addObject:frame11];
            [hen4Frames addObject:frame11];
            for (int i = 0; i < 7; i++)
                [hen4Frames addObject:frame1];
            [hen4Frames addObject:frame2];
            [hen4Frames addObject:frame3];
            [hen4Frames addObject:frame4];
            [hen4Frames addObject:frame5];
            [hen4Frames addObject:frame6];
            [hen4Frames addObject:frame6];
            [hen4Frames addObject:frame7];
            [hen4Frames addObject:frame7];
            [hen4Frames addObject:frame8];
            [hen4Frames addObject:frame8];
            [hen4Frames addObject:frame9];
            [hen4Frames addObject:frame9];
            break;
        case 5:
            for (int i = 0; i < 7; i++)
                [hen5Frames addObject:frame1];
            [hen5Frames addObject:frame2];
            [hen5Frames addObject:frame3];
            [hen5Frames addObject:frame4];
            [hen5Frames addObject:frame5];
            [hen5Frames addObject:frame6];
            [hen5Frames addObject:frame6];
            [hen5Frames addObject:frame7];
            [hen5Frames addObject:frame7];
            [hen5Frames addObject:frame8];
            [hen5Frames addObject:frame8];
            [hen5Frames addObject:frame9];
            [hen5Frames addObject:frame9];
            [hen5Frames addObject:frame10];
            [hen5Frames addObject:frame10];
            [hen5Frames addObject:frame11];
            [hen5Frames addObject:frame11];
            break;
    }
}

- (void)setEggTrayWhenEggHitNest
{
    baseEggWidth = 10;
    [eggTray setPercentage:baseEggWidth];
    
    id up =[CCScaleBy actionWithDuration:0.3f scale:1.0f];
    id down = [CCScaleBy actionWithDuration:0.3f scale:0.5f];//1 / 1.5f];
    id normal = [CCScaleBy actionWithDuration:0.3f scale:2.0f];
    
    [eggTrayComplete runAction:[CCSequence actions:up,down,normal, nil]];
}

-(void)setIndicator
{
    [indicator setZOrder:3];
    
    id up2 =[CCScaleBy actionWithDuration:.3 scale:1.0f];
    id down2 = [CCScaleBy actionWithDuration:.3 scale:.5f];//1 / 1.5f];
    id normal2 = [CCScaleBy actionWithDuration:.3 scale:2.0f];
    
    forever = [CCRepeatForever actionWithAction:[CCSequence actions:up2, down2, normal2, nil]];
    [indicator runAction:forever];
}

//UPDATE
-(void)gameLogic:(ccTime)dt
{
    if(paused == NO)
        [self addTarget];
    
}

- (void)update: (ccTime) dt
{
    
    for (CCSprite* whiteEgg in [[whiteEggs copy] autorelease]) {
        if (CGRectIntersectsRect(player.boundingBox, whiteEgg.boundingBox)) {
            [whiteEggs removeObject:whiteEgg];
            [self removeChild:whiteEgg cleanup:YES];
            
            score+=10;
            [self showFallenEggToNest:whiteEgg.position.x andY:whiteEgg.position.y andColor:@"white"];
            [self eggHitNest];
        }
    }
    
    for (CCSprite* silverEgg in [[silverEggs copy] autorelease]) {
        if (CGRectIntersectsRect(player.boundingBox, silverEgg.boundingBox)) {
            [silverEggs removeObject:silverEgg];
            [self removeChild:silverEgg cleanup:YES];
            
            score+=20;
            [self showFallenEggToNest:silverEgg.position.x andY:silverEgg.position.y andColor:@"silver"];
            [self eggHitNest];
            [self eggHitNest];
        }
    }
    
    for (CCSprite* goldEgg in [[goldEggs copy] autorelease]) {
        if (CGRectIntersectsRect(player.boundingBox, goldEgg.boundingBox)) {
            [goldEggs removeObject:goldEgg];
            [self removeChild:goldEgg cleanup:YES];
            
            score+=30;
            [self showFallenEggToNest:goldEgg.position.x andY:goldEgg.position.y andColor:@"gold"];
            [self eggHitNest];
            [self eggHitNest];
            [self eggHitNest];
        }
    }
    
    for (CCSprite* stone in [[stones copy] autorelease]) {
        if (CGRectIntersectsRect(player.boundingBox, stone.boundingBox)) {
            [stones removeObject:stone];
            [self removeChild:stone cleanup:YES];
            score-=20;
            [self showFallenStoneToNest:stone.position.x andY:stone.position.y];
        }
    }
    
    for (CCSprite* greenEgg in [[greenEggs copy] autorelease]) {
        if (CGRectIntersectsRect(player.boundingBox, greenEgg.boundingBox)) {
            [greenEggs removeObject:greenEgg];
            [self removeChild:greenEgg cleanup:YES];
            score += 50;
            greenEggCount++;
            [self showFallenEggToNest:greenEgg.position.x andY:greenEgg.position.y andColor:@"green"];
        }
    }
    
    for (CCSprite* rat in [[rats copy]autorelease]){
        if (CGRectIntersectsRect(CGRectMake(player.position.x+20, player.position.y, player.contentSize.width/4, player.contentSize.height), rat.boundingBox))
        {
            if(isCreatedRat)
            {
                [self obstacleHitNest];
                isCreatedRat = false;
            }
            [self showRatHitNest:rat.position.x andY:rat.position.y];

        }
    }
    
    for (CCSprite* rainbowEgg in [[rainbowEggs copy]autorelease]){
        if (CGRectIntersectsRect(player.boundingBox, rainbowEgg.boundingBox))
        {
            [rainbowEggs removeObject:rainbowEgg];
            [self removeChild:rainbowEgg cleanup:YES];
            [self addLife];
            [self showFallenEggToNest:rainbowEgg.position.x andY:rainbowEgg.position.y andColor:@"rainbow"];
            
        }
    }
    
    for (CCSprite* blueEgg in [[blueEggs copy]autorelease]){
        if (CGRectIntersectsRect(player.boundingBox, blueEgg.boundingBox))
        {
            [blueEggs removeObject:blueEgg];
            [self removeChild:blueEgg cleanup:YES];
            
            if(blueEggCount < 6)
            {
                blueEggCount++;
                blueEggWidth += 20;
                [blueEggUp setPercentage:blueEggWidth];
                
            }
            if (blueEggCount == 5)
                [self setIndicator];
            
            [self showFallenEggToNest:blueEgg.position.x andY:blueEgg.position.y andColor:@"blue"];
            
        }
    }
    
    //Background
    if(eggHitNestCount >= level2 && !bg1Changed) //level 2
    {
        paused = YES;
        
        globalWhatLevel = 1;
        globalScore = score;
        
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[BonusScene alloc] init]] withColor:ccWHITE]];
        
        [levelBG setVisible:YES];
        
        [self initLoad:2];
        bg1Changed = true;
    }
    
    if(eggHitNestCount >= level3 && !bg2Changed) //level 3
    {
        paused = YES;
        
        globalWhatLevel = 2;
        globalScore = score;
        
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[BonusScene alloc] init]] withColor:ccWHITE]];
        
        [levelBG setVisible:YES];
        
        [self initLoad:3];
        bg2Changed = true;
        
        //to add difficulty by increasing the number of times the rock will fall
        stoneRange = 3;
        stoneBaseRange = 1;
    }
    
    if(eggHitNestCount >= level4 && !bg3Changed) //level 4
    {
        paused = YES;
        
        globalWhatLevel = 3;
        globalScore = score;
        
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[BonusScene alloc] init]] withColor:ccWHITE]];
        
        [levelBG setVisible:YES];
        
        [self initLoad:4];
        bg3Changed = true;
    }
    
    if(eggHitNestCount >= level5 && !bg4Changed) //level 5
    {
        paused = YES;
        
        globalWhatLevel = 4;
        globalScore = score;
        
        [[CCDirector sharedDirector] pushScene:[CCTransitionFade transitionWithDuration:0.5 scene:[SceneManager wrap:[[BonusScene alloc] init]] withColor:ccWHITE]];
        
        [levelBG setVisible:YES];
        
        [self initLoad:5];
        bg4Changed = true;
    }
    

    
    [lblScoreCount setString:[NSString stringWithFormat:@"%d", score]];
    
//    if(score >= 100)
//        lblScoreCount.position = ccp(53 - lblScoreCount.contentSize.width /2 ,258.5);
//    else if(score >= 1000)
//        lblScoreCount.position = ccp(73 - lblScoreCount.contentSize.width /2 ,258.5);
    
    [lblEggCount setString:[NSString stringWithFormat:@"%d", eggHitNestCountPerLevel]];
    
    [lblGreenEggCount setString:[NSString stringWithFormat:@"%d", greenEggCount]];
    [indicator setPosition:CGPointMake(player.position.x,player.position.y)];
}


//ADD Targets
int minValue;
int maxValue;
- (void)addTarget
{
    [self addWhite];
    [self addSilver];
    
    if(eggHitNestCount >= level2 &&
       ((arc4random() % goldRange) == goldBaseRange))
        [self addGold];
    
    if(eggHitNestCount >= level2 &&
       ((arc4random() % stoneRange) == stoneBaseRange))
        [self addStone];
    
    if(eggHitNestCount >= level3 &&
       ((arc4random() % greenRange) == greenBaseRange)
       && greenEggCount < 9)
        [self addGreen];
    
    if(eggHitNestCount >= level4 &&
       ((arc4random() % rainbowRange) == rainbowBaseRange)
       && lives < 4)
        [self addRainbow];
    
    if(eggHitNestCount >= level4 &&
       ((arc4random() % foxRange) == foxBaseRange)
       && eggHitNestCountPerLevel > 1)
        [self addFox];
    
    if(eggHitNestCount >= level5 &&
       ((arc4random() % blueRange) == blueBaseRange) && 
       blueEggCount < 6)
        [self addBlue];
    
}

-(void) addWhite
{
    randColumnIndex = arc4random() % 15;
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* whiteEgg = [CCSprite spriteWithFile:@"whiteEgg.png"
                                           rect:CGRectMake(0, 0, 20, 27)];

    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
 

    whiteEgg.position = ccp(actualX, (270-whiteEgg.contentSize.height/2));
    

    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    

    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                    position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [whiteEgg runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    whiteEgg.tag = 1;
    [self addChild:whiteEgg z:6];
    [whiteEggs addObject:whiteEgg];
}

-(void) addSilver
{
    do {
        randColumnIndex = arc4random() % 15;
    } while (randColumnIndex == randColumnIndexComparer);
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* silverEgg = [CCSprite spriteWithFile:@"silverEgg.png"
                                             rect:CGRectMake(0, 0, 20, 27)];
    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
    
    silverEgg.position = ccp(actualX, (270-silverEgg.contentSize.height/2));
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [silverEgg runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    silverEgg.tag = 2;
    [self addChild:silverEgg z:6];
    [silverEggs addObject:silverEgg];
}

-(void) addStone
{
    do {
        randColumnIndex = arc4random() % 15;
    } while (randColumnIndex == randColumnIndexComparer);
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* stone = [CCSprite spriteWithFile:@"stone.png"
                                              rect:CGRectMake(0, 0, 30, 26)];

    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
    
    stone.position = ccp(actualX, (270-stone.contentSize.height/2));
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [stone runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    stone.tag = 3;
    [self addChild:stone z:6];
    [stones addObject:stone];
}

-(void) addGold
{
    do {
        randColumnIndex = arc4random() % 15;
    } while (randColumnIndex == randColumnIndexComparer);
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* goldEgg = [CCSprite spriteWithFile:@"goldEgg.png"
                                          rect:CGRectMake(0, 0, 20, 27)];
    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
    
    goldEgg.position = ccp(actualX, (270-goldEgg.contentSize.height/2));
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [goldEgg runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    goldEgg.tag = 4;
    [self addChild:goldEgg z:6];
    [goldEggs addObject:goldEgg];
}

-(void) addGreen
{
    do {
        randColumnIndex = arc4random() % 15;
    } while (randColumnIndex == randColumnIndexComparer);
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* greenEgg = [CCSprite spriteWithFile:@"greenEgg.png"
                                            rect:CGRectMake(0, 0, 20, 27)];

    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
    
    greenEgg.position = ccp(actualX, (270-greenEgg.contentSize.height/2));
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [greenEgg runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    greenEgg.tag = 5;
    [self addChild:greenEgg z:6];
    [greenEggs addObject:greenEgg];
}

//ADD RAT
-(void)addRat
{
    if (!paused)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"rat.plist"];
        defaultRat = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rat1.png"];
        CCSprite* rat = [CCSprite spriteWithSpriteFrame:defaultRat];
        
        
        [self addChild:rat z:7];
        
        ratFrames = [NSMutableArray arrayWithCapacity:6];
        for (int i = 1; i <= 6; i++) {
            NSString *file = [NSString stringWithFormat:@"rat%i.png", i];
            CCSpriteFrame* frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            
            [ratFrames addObject:frame];
        }
        
        ratAnimation = [CCAnimation animationWithSpriteFrames:ratFrames delay:0.08];
        animateWalk = [CCAnimate actionWithAnimation:ratAnimation];
        ratMotionLeft = [CCRepeat actionWithAction:animateWalk times:4];
        moveRatLeft = [CCMoveTo actionWithDuration:2 position:ccp(480, 15)];
        spawnWalkLeft = [CCSpawn actions:ratMotionLeft, moveRatLeft, nil];
        self.walkRatLeft = [CCSequence actions:spawnWalkLeft, nil];
        
        id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
        [rats addObject:rat];
        
        isCreatedRat = true;
        rat.scaleX = .6f;
        rat.scaleY = .6f;
        rat.position = ccp(110, 15);
        rat.flipX = YES;
        rat.tag = 6;
        [rat runAction:[CCSequence actions:self.walkRatLeft, actionMoveDone, nil]];
    }
}

-(void)addRainbow
{
    do {
        randColumnIndex = arc4random() % 15;
    } while (randColumnIndex == randColumnIndexComparer);
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* rainbowEgg = [CCSprite spriteWithFile:@"rainbowEgg.png"
                                             rect:CGRectMake(0, 0, 20, 27)];
    // Determine where to spawn the target along the Y axis
    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    rainbowEgg.position = ccp(actualX, (270-rainbowEgg.contentSize.height/2));
    
    // Determine speed of the target
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [rainbowEgg runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    rainbowEgg.tag = 7;
    [self addChild:rainbowEgg z:6];
    [rainbowEggs addObject:rainbowEgg];
}

-(void)addFox
{
    if (foxCount < 1)
    {
        foxCount++;
        CCSprite* fox = [CCSprite spriteWithFile:@"fox.png" rect:CGRectMake(0, 0, 80, 73)];
        
        int xBounds = 100;
        int yBounds = 60;
        int x = arc4random() % 300;
        int y = arc4random() % 172;
        
        fox.position = ccp(x + xBounds, y + yBounds);
        [self addChild:fox z:5];
        [foxes addObject:fox];
        
        [self scheduleOnce:@selector(foxMinusEgg) delay:3.0];
    }
}

//MINUS EGG
-(void)foxMinusEgg
{
    if(foxes != nil && foxCount == 1)
    {
        [self removeFox];
        
        minus = [CCSprite spriteWithFile:@"plok.png"];
        minus.position = CGPointMake(minus.contentSize.width/2, 70);
        [self addChild:minus z:7];
    
        id up =[CCScaleBy actionWithDuration:0.3f scale:1.0f];
        id down = [CCScaleBy actionWithDuration:0.3f scale:0.5f];
        id normal = [CCScaleBy actionWithDuration:0.3f scale:2.0f];
    
        [minus runAction:[CCSequence actions:up,down,normal, nil]];
    
        [self schedule:@selector(minusEgg) interval:5 repeat:0 delay:2];
        
        eggHitNestCountPerLevel--;
    }

}

//REMOVE MINUS EGG
-(void)minusEgg
{
    if (minus != nil)
    {
        [self removeChild:minus cleanup:YES];
    }
}

//REMOVE FOX
-(void)removeFox
{

    for(CCSprite* fox in [[foxes copy] autorelease])
    {
        foxCount--;
        [self removeChild:fox cleanup:YES];
        [foxes removeObject:fox];
    }
}

-(void) addBlue
{
    randColumnIndex = arc4random() % 15;
    randColumnIndexComparer = randColumnIndex;
    
    CCSprite* blueEgg = [CCSprite spriteWithFile:@"blueEgg.png"
                                             rect:CGRectMake(0, 0, 20, 27)];
    
    int actualX = [[columns objectAtIndex:randColumnIndex] integerValue];
    
    
    blueEgg.position = ccp(actualX, (270-blueEgg.contentSize.height/2));
    
    
    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(actualX, 0)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [blueEgg runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    
    blueEgg.tag = 8;
    [self addChild:blueEgg z:6];
    [blueEggs addObject:blueEgg];
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace: touch];
    bool isIntersect = false;

    if(!CGRectIntersectsRect(player.boundingBox, CGRectMake(location.x, location.y, 0, 0)))
    {
           if (foxes != nil)
           {
               for(CCSprite* fox in [[foxes copy] autorelease])
               {
                   if (CGRectIntersectsRect(fox.boundingBox, CGRectMake(location.x, location.y, 0, 0)))
                   {
                       [self removeFox];
                       isIntersect = true;
                   }
               }
            }
    
           if(greenEggs != nil)
           {
               if(isOnGround && greenEggCount > 0 && !isIntersect)
               {
                   greenEggCount--;
                   [self jump];
               }
           }
    }
    else if (CGRectIntersectsRect(player.boundingBox, CGRectMake(location.x, location.y, 0, 0)) && blueEggCount >= 5)
    {
        blueEggCount=0;
        blueEggWidth = 0;
        [blueEggUp setPercentage:blueEggWidth];
        
        player.scaleX = 1.5f;
        [indicator stopAction:forever];
        [indicator setZOrder:-1];

        [self scheduleOnce:@selector(resetPlayerSize) delay:5];
    }
}


//when egg hits offscreen
// 1 - White
// 2 - Silver
// 3 - Stone
// 4 - Gold
// 5 - Green
// 6 - Rat
// 7 - Rainbow
// 8 - Blue
-(void)spriteMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    if (sprite.tag == 1) { // whiteEgg
        [whiteEggs removeObject:sprite];
        [self showFallenEggToFloor:sprite.position.x andY:sprite.position.y andColor:@"white"];
    }
    if (sprite.tag == 2) { // silverEgg
        [silverEggs removeObject:sprite];
        [self showFallenEggToFloor:sprite.position.x andY:sprite.position.y andColor:@"silver"];
    }
    if (sprite.tag == 3) { // stone
        [stones removeObject:sprite];
        [self showFallenStoneToFloor:sprite.position.x andY:sprite.position.y];
    }
    if (sprite.tag == 4) { // goldEgg
        [goldEggs removeObject:sprite];
        [self showFallenEggToFloor:sprite.position.x andY:sprite.position.y andColor:@"gold"];
    }
    if (sprite.tag == 5) { // greeEgg
        [greenEggs removeObject:sprite];
        [self showFallenEggToFloor:sprite.position.x andY:sprite.position.y andColor:@"green"];
    }
    if (sprite.tag == 6) { // rat
        [rats removeObject:sprite];
    }
    if (sprite.tag == 7) { // rainbow
        [rainbowEggs removeObject:sprite];
        [self showFallenEggToFloor:sprite.position.x andY:sprite.position.y andColor:@"rainbow"];
    }
    if (sprite.tag == 8) { // blue
        [blueEggs removeObject:sprite];
        [self showFallenEggToFloor:sprite.position.x andY:sprite.position.y andColor:@"blue"];
    }
}


//EGG Events
-(void)eggHitNest
{
    eggHitNestCount++;
    eggHitNestCountPerLevel++;
    baseEggWidth +=16;
    
    if(eggHitNestCountPerLevel <= 5)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 5)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 10)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 10)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 15)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 15)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 20)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 20)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 25)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 25)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 30)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 30)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 35)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 35)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 40)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 40)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 45)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 45)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 50)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 50)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 55)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 55)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 60)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 60)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 65)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 65)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 70)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 70)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 75)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 75)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 80)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 80)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 85)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 85)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 90)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 90)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 95)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 95)
            [self setEggTrayWhenEggHitNest];
    }
    else if(eggHitNestCountPerLevel <= 100)
    {
        [eggTray setPercentage:baseEggWidth];
        if(eggHitNestCountPerLevel == 100)
            [self setEggTrayWhenEggHitNest];
    }
    

}

-(void)obstacleHitNest
{
    id fadeOut = [CCFadeOut actionWithDuration:2];
    lives--;
    
    switch (lives)
    {
        case 0:
            [imageLife4 runAction:[CCSequence actions:fadeOut, nil]];
            break;
        case 1:
            [imageLife3 runAction:[CCSequence actions:fadeOut, nil]];
            break;
        case 2:
            [imageLife2 runAction:[CCSequence actions:fadeOut, nil]];
            break;
        case 3:
            [imageLife1 runAction:[CCSequence actions:fadeOut, nil]];
            break;
    }
    
    //End of game
    if(lives == 0)
    {
        [self saveGame];
        paused = YES;
    }
}

-(void)addLife
{
    id fadeIn = [CCFadeIn actionWithDuration:2];
    lives++;
    
    switch (lives)
    {
        case 4:
            [imageLife1 runAction:[CCSequence actions:fadeIn, nil]];
            break;
        case 3:
            [imageLife2 runAction:[CCSequence actions:fadeIn, nil]];
            break;
        case 2:
            [imageLife3 runAction:[CCSequence actions:fadeIn, nil]];
            break;
    }

}

-(void)showFallenEggToNest:(float)valueX andY: (float) valueY andColor:(NSString *) valueEggColor
{
//    [self->fallToNestSound play];
    
    [self playEggToNest];
    
    CCSprite* fallenEggToNest;
    
    if(valueEggColor == @"white")
        fallenEggToNest = [CCSprite spriteWithFile:@"fWhiteEggToNest.png"];
    else if(valueEggColor == @"silver")
        fallenEggToNest = [CCSprite spriteWithFile:@"fSilverEggToNest.png"];
    else if(valueEggColor == @"gold")
        fallenEggToNest = [CCSprite spriteWithFile:@"fGoldEggToNest.png"];
    else if (valueEggColor == @"green")
    {
        fallenEggToNest = [CCSprite spriteWithFile:@"fGreenEggToNest.png"];
        [self scheduleOnce:@selector(addRat) delay:3];
    }
    else if (valueEggColor == @"rainbow")
         fallenEggToNest = [CCSprite spriteWithFile:@"fRainbowEggToNest.png"];
    else if (valueEggColor == @"blue")
        fallenEggToNest = [CCSprite spriteWithFile:@"fBlueEggToNest.png"];
    
    fallenEggToNest.position = ccp(valueX, valueY-5);
    
    [self addChild:fallenEggToNest z:4];
    [fallenEggsToNest addObject:fallenEggToNest];
    
    [self scheduleOnce:@selector(removeFallenEggToNest) delay:0.5];
}

-(void)removeFallenEggToNest
{
    for (CCSprite* fallenEggToNest in [[fallenEggsToNest copy] autorelease]) {
        [fallenEggsToNest removeObject:fallenEggToNest];
        [self removeChild:fallenEggToNest cleanup:YES];
    }
}

-(void)showFallenEggToFloor:(float)valueX andY:(float) valueY andColor:(NSString *) valueEggColor
{
    
//    [self->plokSound play];
    
    [self playPlok];
    CCSprite *fallenEggToFloor;
    
    if(valueEggColor == @"white")
        fallenEggToFloor  = [CCSprite spriteWithFile:@"fWhiteEggToFloor.png"];
    else if (valueEggColor == @"silver")
        fallenEggToFloor  = [CCSprite spriteWithFile:@"fSilverEggToFloor.png"];
    else if (valueEggColor == @"gold")
        fallenEggToFloor  = [CCSprite spriteWithFile:@"fGoldEggToFloor.png"];
    else if (valueEggColor == @"green")
        fallenEggToFloor  = [CCSprite spriteWithFile:@"fGreenEggToFloor.png"];
    else if (valueEggColor == @"rainbow")
        fallenEggToFloor  = [CCSprite spriteWithFile:@"fRainbowEggToFloor.png"];
    else if (valueEggColor == @"blue")
        fallenEggToFloor  = [CCSprite spriteWithFile:@"fBlueEggToFloor.png"];
    
    fallenEggToFloor.position = ccp(valueX+20, valueY + fallenEggToFloor.contentSize.height/2);
    
    [self addChild:fallenEggToFloor z:4];
    [fallenEggsToFloor addObject:fallenEggToFloor];
    
    [self scheduleOnce:@selector(removeFallenEggToFloor) delay:0.5];
}

-(void)removeFallenEggToFloor
{
    for (CCSprite* fallenEggToFloor in [[fallenEggsToFloor copy] autorelease]) {
        [fallenEggsToFloor removeObject:fallenEggToFloor];
        [self removeChild:fallenEggToFloor cleanup:YES];
    }
    
}

-(void)showFallenStoneToNest:(float)valueX andY:(float) valueY
{
//    [self->plokSound play];
    [self playEggToNest];
    
    CCSprite *fallenStoneToNest = [CCSprite spriteWithFile:@"stoneToNest.png"];
    fallenStoneToNest.position = ccp(valueX, valueY+15);
    
    [self addChild:fallenStoneToNest z:4];
    [fallenStonesToNest addObject:fallenStoneToNest];
    
    [self obstacleHitNest];
    
    [self scheduleOnce:@selector(removeFallenStoneToNest) delay:0.5];
}

-(void)removeFallenStoneToNest
{
    for (CCSprite* fallenStoneToNest in [[fallenStonesToNest copy] autorelease]) {
        [fallenStonesToNest removeObject:fallenStoneToNest];
        [self removeChild:fallenStoneToNest cleanup:YES];
    }
}

-(void)showFallenStoneToFloor:(float)valueX andY: (float) valueY
{
//    [self->fallStoneToFloorSound play];
    
    [self playRockToFloor];
    CCSprite *fallenStoneToFloor = [CCSprite spriteWithFile:@"stoneToFloor.png"];
    fallenStoneToFloor.position = ccp(valueX, valueY+10);
    
    [self addChild:fallenStoneToFloor z:4];
    [fallenStonesToFloor addObject:fallenStoneToFloor];
    
    [self scheduleOnce:@selector(removeFallenStoneToFloor) delay:0.5];
}

-(void)removeFallenStoneToFloor
{
    for (CCSprite* fallenStoneToFloor in [[fallenStonesToFloor copy] autorelease]) {
        [fallenStonesToFloor removeObject:fallenStoneToFloor];
        [self removeChild:fallenStoneToFloor cleanup:YES];
    }
}

-(void)showRatHitNest:(float)valueX andY:(float)valueY
{
    CCSprite *ratHitNest = [CCSprite spriteWithFile:@"bitOfNest.png"];
    ratHitNest.position = ccp(valueX, valueY);
    
    [self addChild:ratHitNest z:4];
    [ratsHistNest addObject:ratHitNest];
    
    [self scheduleOnce:@selector(removeRatHistNest) delay:0.5];
}

-(void)removeRatHistNest
{
    for (CCSprite* ratHitNest in [[ratsHistNest copy] autorelease]) {
        [ratsHistNest removeObject:ratHitNest];
        [self removeChild:ratHitNest cleanup:YES];
    }
}

-(void)saveGame
{
//    self.paused = YES;

    [pauseButton setIsEnabled:NO];
    [homeButton setIsEnabled:YES];
    [playAgainButton setIsEnabled:YES];
    
    NSUserDefaults* prefs = [NSUserDefaults standardUserDefaults];
    NSString* savedScore = [prefs valueForKey:@"score"];
    
    if(score > [savedScore intValue]) //score should be higher than the saved one
    {
//        [self->winSound play];
        [self playWinSound];
//        [lblBeat setTextColor:[UIColor blackColor]];
//        [lblBeat setShadowColor:[UIColor grayColor]];
//        [lblBeat setFont:[UIFont fontWithName:@"Futura" size:25]];
//        [lblBeat setText:@"You beat the High Score ;)"];
        
        [winOverlay setZOrder:10];
        [menuOverlay setZOrder:11];
        
        [prefs setValue:[NSString stringWithFormat:@"%d" ,score] forKey:@"score"];
        [prefs synchronize];
    }
    else
    {
//        [self->loseSound play];
        [self playLoseSound];
        [loseOverlay setZOrder:10];
        [menuOverlay setZOrder:11];
    }
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    //320 x 480
    if(paused == NO)
    {
        x = acceleration.y*(-20.0);
        
        int newX = (int)(player.position.x + x);
        
        if (newX > 480-player.contentSize.width /2)
            newX = 480-player.contentSize.width /2;
        
        else if (newX < 80 + player.contentSize.width /2) //bounds
            newX = 80 + player.contentSize.width /2;
        
        player.position = ccp(newX, player.contentSize.height/2);
    
    }
}

-(void)playPlok
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"plok", CFSTR ("wav"), NULL);
    
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)playRockToFloor
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"fallStoneToFloor", CFSTR ("wav"), NULL);
    
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)playEggToNest
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"fallToNest", CFSTR ("wav"), NULL);
    
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)playWinSound
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"win", CFSTR ("wav"), NULL);
    
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

-(void)playLoseSound
{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef;
    
    soundFileURLRef = CFBundleCopyResourceURL(mainBundle,(CFStringRef) @"lose", CFSTR ("wav"), NULL);
    
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
}


- (void) dealloc
{
    [super dealloc];
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    
    [rats release];
    [foxes release];
    [stones release];
    [blueEggs release];
    [goldEggs release];
    [greenEggs release];
    [whiteEggs release];
    [silverEggs release];
    [rainbowEggs release];
    
    [ratsHistNest release];
    [fallenEggsToNest release];
    [fallenEggsToFloor release];
    [fallenStonesToNest release];
    [fallenStonesToFloor release];
    
    [ratFrames release];
    [hen1Frames release];
    [hen2Frames release];
    [hen3Frames release];
    [hen4Frames release];
    [hen5Frames release];
    
    rats = nil;
    foxes = nil;
    stones = nil;
    blueEggs = nil;
    goldEggs = nil;
    greenEggs = nil;
    whiteEggs = nil;
    silverEggs = nil;
    rainbowEggs = nil;
    
    ratsHistNest = nil;
    fallenEggsToNest = nil;
    fallenEggsToFloor = nil;
    fallenStonesToNest = nil;
    fallenStonesToFloor = nil;
    
    ratFrames = nil;
    hen1Frames = nil;
    hen2Frames = nil;
    hen3Frames = nil;
    hen4Frames = nil;
    hen5Frames = nil;
}
@end
