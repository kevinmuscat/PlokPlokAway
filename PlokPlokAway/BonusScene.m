//
//  BonusScene.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/9/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BonusScene.h"

int globalScore;
int globalWhatLevel;
int globalBonusScore;

@implementation BonusScene
@synthesize platform1;
@synthesize platform2;
@synthesize platform3;
@synthesize platform4;
@synthesize platform5;
@synthesize platform6;
@synthesize platform7;
@synthesize platform8;
@synthesize platform9;
@synthesize platform10;

int bStartTime;
bool isEnter;
int bEndTime;
bool isPaused;

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
    
    //screen size
    s = [CCDirector sharedDirector].winSize;
    
    //background color
    CCLayerColor *layerColor = [[CCLayerColor alloc] initWithColor:ccc4(255, 255, 255, 255)];
    
   
    //bacground image
    if(globalWhatLevel == 1)
    {
        background = [CCSprite spriteWithFile:@"bbg1.png"];
        bonusTimer = 20;
    }
    if(globalWhatLevel == 2)
    {
        background = [CCSprite spriteWithFile:@"bbg2.png"];
        bonusTimer = 25;
    }
    if(globalWhatLevel == 3)
    {
        background = [CCSprite spriteWithFile:@"bbg3.png"];
        bonusTimer = 30;
    }
    if(globalWhatLevel == 4)
    {
        background = [CCSprite spriteWithFile:@"bbg4.png"];
        bonusTimer = 35;
    }
    
    background.position = ccp(s.width / 2, s.height / 2);

    //label score
    lblBonusScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"0"] fontName:@"Andy" fontSize:40];
    lblBonusScore.position = ccp(s.width / 2,s.height - (lblBonusScore.contentSize.height/2));
    [lblBonusScore setColor:ccBLACK];
    
    //label time
    lblBonusTimer = [CCLabelTTF labelWithString:@"00:00" fontName:@"Andy" fontSize:40];
    lblBonusTimer.position = ccp(s.width - (lblBonusTimer.contentSize.width/2) ,s.height - (lblBonusTimer.contentSize.height/2 - 2));
    [lblBonusTimer setColor:ccBLACK];
    
    //label end bonus score
    lblEndBonusScore = [CCLabelTTF labelWithString:@"0 pts" fontName:@"Andy" fontSize:40];
    lblEndBonusScore.position = ccp(s.width/2 - (lblEndBonusScore.contentSize.width/2) ,215);
    [lblEndBonusScore setColor:ccWHITE];
    
    //label end total score
    lblEndTotalScore = [CCLabelTTF labelWithString:@"0 pts" fontName:@"Andy" fontSize:40];
    lblEndTotalScore.position = ccp(s.width/2 - (lblEndBonusScore.contentSize.width/2) ,94);
    [lblEndTotalScore setColor:ccWHITE];
    
    //bonus overlay
    bonusBG = [CCSprite spriteWithFile:@"bonusBG.png"];
    bonusBG.position = ccp(s.width - bonusBG.textureRect.size.width / 2, 0 + bonusBG.textureRect.size.height / 2);
    
    //bird
    bird = [CCSprite spriteWithFile:@"bhen.png"];
    bird.position = ccp(s.width / 2 + 10, s.height / 2);
    
    //add child
    [self addChild:layerColor z:0];
    [self addChild:background z:1];
    [self addChild:bird z:4];
    [self addChild:lblBonusScore z:20];
    [self addChild:lblBonusTimer z:20];
    [self addChild:lblEndTotalScore z:-1];
    [self addChild:lblEndBonusScore z:-1];
    [self addChild:bonusBG z:21];
    
    [self initPlatforms];
    [self resetPlatforms];
    [self resetBird];

    [self playBounceSound];
    
    //accelerometer
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/30.0];
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    isEnter = false;
    isPaused = false;
    
    [self BGFade];
    bStartTime = 3;
    [self schedule:@selector(startTimer) interval:1.0 repeat:3 delay:0];
}

-(void)BGFade
{
    id fadeIn = [CCFadeIn actionWithDuration:0.5];
    [bonusBG runAction:[CCSequence actions:fadeIn, nil]];
}

-(void)setPoints
{
    [lblEndBonusScore setZOrder:22];
    [lblEndTotalScore setZOrder:22];
    
    [lblEndBonusScore setString:[NSString stringWithFormat:@"%d points",bonusScore]];
    lblEndBonusScore.position = ccp(s.width/2 ,216);
    
    [lblEndTotalScore setString:[NSString stringWithFormat:@"%d points",bonusScore+globalScore]];
    lblEndTotalScore.position = ccp(s.width/2 ,95);
}

-(void)startTimer
{    
    bStartTime--;
    
    if(bStartTime == 0)
    {
        id fadeOut = [CCFadeOut actionWithDuration:0.5];
        [bonusBG runAction:[CCSequence actions:fadeOut, nil]];
        [self scheduleOnce:@selector(fade) delay:0.5];
        
        [self schedule:@selector(step:)];
        [self schedule:@selector(bonusTimer) interval:1.0];
    }
}

-(void)endTimer
{
    bEndTime--;
    
    if(bEndTime == 0)
    {
        id fadeOut = [CCFadeOut actionWithDuration:0.5];
        [bonusBG runAction:[CCSequence actions:fadeOut, nil]];
        [self scheduleOnce:@selector(fade2) delay:0.5];
    }
}

-(void)fade2
{
    [bonusBG setVisible:NO];
    
    globalBonusScore = bonusScore;
    bonusScore = 0;
    bonusTimer = 0;
    
    [[CCDirector sharedDirector] popScene];
}

-(void)fade
{
    [bonusBG setVisible:NO];
}

NSString* timeString;
-(void)bonusTimer
{
    if(!isPaused)
        bonusTimer--;
    
    if (bonusTimer <= 9){
        timeString = [NSString stringWithFormat:@"00:0%d" ,bonusTimer];
    }
    else
    {
        timeString = [NSString stringWithFormat:@"00:%d",bonusTimer];
    }
    
    [lblBonusTimer setString:timeString];
    
    if(bonusTimer == 0 && !isEnter)
        [self endBonus];
}

-(void)initPlatforms
{
    currentPlatformTag = 200; //kPlatformsStartTag;
	while(currentPlatformTag < 200 + 10) //kPlatformsStartTag + kNumPlatforms
    {
		[self initPlatform];
		currentPlatformTag++;
	}
}

-(void)initPlatform
{  
    //platform
    if(currentPlatformTag == 200)
    {
        platform1 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform1 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 201)
    {
        platform2 = [CCSprite spriteWithFile:@"cloud2.png" rect:CGRectMake(0, 0, 80, 42)];
        [self addChild:platform2 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 202)
    {
        platform3 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform3 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 203)
    {
        platform4 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform4 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 204)
    {
        platform5 = [CCSprite spriteWithFile:@"cloud2.png" rect:CGRectMake(0, 0, 80, 42)];
        [self addChild:platform5 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 205)
    {
        platform6 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform6 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 206)
    {
        platform7 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform7 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 207)
    {
        platform8 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform8 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 208)
    {
        platform9 = [CCSprite spriteWithFile:@"cloud2.png" rect:CGRectMake(0, 0, 80, 42)];
        [self addChild:platform9 z:5 tag:currentPlatformTag];
    }
    if(currentPlatformTag == 209)
    {
        platform10 = [CCSprite spriteWithFile:@"cloud.png" rect:CGRectMake(0, 0, 80, 24)];
        [self addChild:platform10 z:5 tag:currentPlatformTag];
    }
}

-(void)resetPlatforms
{
    currentPlatformY = -1;
	currentPlatformTag = 200; //kPlatformsStartTag
	currentMaxPlatformStep = 60.0f;
	currentBonusPlatformIndex = 0;
	currentBonusType = 0;
	platformCount = 0;
    
    while(currentPlatformTag < 200 + 10)//kPlatformsStartTag + kNumPlatforms
    {
		[self resetPlatform];
		currentPlatformTag++;
	}
}

-(void) resetPlatform
{
    if(currentPlatformY < 0) {
    		currentPlatformY = 30.0f;
    	} else {
            currentPlatformY += random() % 100; //currentMaxPlatformStep
    if(currentMaxPlatformStep < 300) //kMaxPlatformStep
    {
        currentMaxPlatformStep += 0.5f;
	}
        }

    
    CCSprite* platform = [[CCSprite alloc] init];
    
    if(currentPlatformTag == 200)
        platform = platform1;
    if(currentPlatformTag == 201)
        platform = platform2;
    if(currentPlatformTag == 202)
        platform = platform3;
    if(currentPlatformTag == 203)
        platform = platform4;
    if(currentPlatformTag == 204)
        platform = platform5;
    if(currentPlatformTag == 205)
        platform = platform6;
    if(currentPlatformTag == 206)
        platform = platform7;
    if(currentPlatformTag == 207)
        platform = platform8;
    if(currentPlatformTag == 208)
        platform = platform9;
    if(currentPlatformTag == 209)
        platform = platform10;
    
    if(random()%2==1) platform.scaleX = -1.0f;
	
    float x;
    CGSize size = platform.contentSize;
    if(currentPlatformY == 30.0f) {
        x = 160.0f;
    } else {
        x = random() % (480-(int)size.width) + size.width;
    }
    
    platform.position = ccp(x,currentPlatformY);
	
	platformCount++;

}

- (void)resetBird {	
	
	bird_pos.x = 160;
	bird_pos.y = 160;
	bird.position = bird_pos;
	
	bird_vel.x = 0;
	bird_vel.y = 0;
	
	bird_acc.x = 0;
	bird_acc.y = -550.0f;
	
	birdLookingRight = YES;
	bird.scaleX = 1.0f;
}

- (void)step:(ccTime)dt {
    
    if(!isPaused)
    {
	bird_pos.x += bird_vel.x * dt;
	
	if(bird_vel.x < -30.0f && birdLookingRight) {
		birdLookingRight = NO;
		bird.scaleX = -1.0f;
	} else if (bird_vel.x > 30.0f && !birdLookingRight) {
		birdLookingRight = YES;
		bird.scaleX = 1.0f;
	}
    
	CGSize bird_size = bird.contentSize;
	float max_x = 480-bird_size.width/2;
	float min_x = 0+bird_size.width/2;
	
	if(bird_pos.x>max_x) bird_pos.x = max_x;
	if(bird_pos.x<min_x) bird_pos.x = min_x;
	
	bird_vel.y += bird_acc.y * dt;
	bird_pos.y += bird_vel.y * dt;

	if(bird_vel.y < 0) {

		for(int t = 200; t < 200 + 10; t++)
        {
			CCSprite *platform = [[CCSprite alloc] init];
            
            if(t == 200)
                platform = platform1;
            if(t == 201)
                platform = platform2;
            if(t == 202)
                platform = platform3;
            if(t == 203)
                platform = platform4;
            if(t == 204)
                platform = platform5;
            if(t == 205)
                platform = platform6;
            if(t == 206)
                platform = platform7;
            if(t == 207)
                platform = platform8;
            if(t == 208)
                platform = platform9;
            if(t == 209)
                platform = platform10;
            
			CGSize platform_size = platform.contentSize;
			CGPoint platform_pos = platform.position;
			
            //NSLog(@"t: %d position: x: %0.2f and y:%.2f", t, platform.position.x , platform.position.y);
            
			max_x = platform_pos.x - platform_size.width/2 - 10;
			min_x = platform_pos.x + platform_size.width/2 + 10;
			float min_y = platform_pos.y + (platform_size.height+bird_size.height)/2 - 10;//kPlatformTopPadding;
			
			if(bird_pos.x > max_x &&
			   bird_pos.x < min_x &&
			   bird_pos.y > platform_pos.y &&
			   bird_pos.y < min_y) {
				[self jump];
			}
		}
		
		if(bird_pos.y < -bird_size.height/2) {
            if(!isEnter)
                [self endBonus];
		}
        
	} else if(bird_pos.y > 160) {
		
		float delta = bird_pos.y - 160;
		bird_pos.y = 160;
        
		currentPlatformY -= delta;
		
		for(int t = 200; t < 200 + 10; t++)
        {
            CCSprite *platform = [[CCSprite alloc] init];
            
            if(t == 200)
                platform = platform1;
            if(t == 201)
                platform = platform2;
            if(t == 202)
                platform = platform3;
            if(t == 203)
                platform = platform4;
            if(t == 204)
                platform = platform5;
            if(t == 205)
                platform = platform6;
            if(t == 206)
                platform = platform7;
            if(t == 207)
                platform = platform8;
            if(t == 208)
                platform = platform9;
            if(t == 209)
                platform = platform10;
            
			CGPoint pos = platform.position;
			pos = ccp(pos.x,pos.y-delta);
			if(pos.y < -platform.contentSize.height/2)
            {
				currentPlatformTag = t;
				[self resetPlatform];
			} else {
				platform.position = pos;
			}
		}
		
        //		if(bonus.visible) {
        //			CGPoint pos = bonus.position;
        //			pos.y -= delta;
        //			if(pos.y < -bonus.contentSize.height/2) {
        //				[self resetBonus];
        //			} else {
        //				bonus.position = pos;
        //			}
        //		}
		
//		score += (int)delta;
//		NSString *scoreStr = [NSString stringWithFormat:@"%d",score];
//        
//		CCLabelBMFont *scoreLabel = (CCLabelBMFont*)[self getChildByTag:kScoreLabel];
//		[scoreLabel setString:scoreStr];
        
        bonusScore += (int)delta;
        [lblBonusScore setString:[NSString stringWithFormat:@"%d", bonusScore]];

	}
	
        if(!isEnter)
        bird.position = bird_pos;
    }
}

- (void)jump {
    [bounce play];
	bird_vel.y = 350.0f + fabsf(bird_vel.x);
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	float accel_filter = 0.1f;
	bird_vel.x = bird_vel.x * accel_filter - acceleration.y * (1.0f - accel_filter) * 500.0f;
}

-(void) endBonus
{
    [self removeChild:bird cleanup:YES];
    
    isEnter = true;
    isPaused = true;
    [bonusBG setVisible:YES];
    [bonusBG setTexture:[[CCTextureCache sharedTextureCache] addImage:@"bonusBGEnd.png"]];
    [self setPoints];
    [self BGFade];
    bEndTime = 3;
    [self schedule:@selector(endTimer) interval:1.0 repeat:3.0 delay:0.0];
}

-(void)playBounceSound
{
    NSString *plokFilePath=[[NSBundle mainBundle]pathForResource:@"bounce" ofType:@"wav"];
    self->bounce=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:plokFilePath] error:nil];
    self->bounce.numberOfLoops = 0;
    self->bounce.volume = 100;
    [self->bounce prepareToPlay];
}

- (void) dealloc
{
    [super dealloc];
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}
@end
