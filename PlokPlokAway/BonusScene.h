//
//  BonusScene.h
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/9/12.
// 

#import "cocos2d.h"
#import "SceneManager.h"
#import <AVFoundation/AVFoundation.h>

@interface BonusScene : CCLayer <UIAccelerometerDelegate>
{
    CGSize s;
    CCSprite* background;
    
    CCSprite* bird;
	CGPoint bird_pos;
	ccVertex2F bird_vel;
	ccVertex2F bird_acc;
    BOOL birdLookingRight;
    
    float currentPlatformY;
	int currentPlatformTag;
	float currentMaxPlatformStep;
	int currentBonusPlatformIndex;
	int currentBonusType;
	int platformCount;
    
    CCLabelTTF* lblBonusScore;
    CCLabelTTF* lblBonusTimer;
    int bonusTimer;
    int bonusScore;
    
    CCSprite* bonusBG;
    
    CCLabelTTF* lblEndBonusScore;
    CCLabelTTF* lblEndTotalScore;
    
    AVAudioPlayer* bounce;
}

@property (nonatomic, retain) CCSprite* platform1;
@property (nonatomic, retain) CCSprite* platform2;
@property (nonatomic, retain) CCSprite* platform3;
@property (nonatomic, retain) CCSprite* platform4;
@property (nonatomic, retain) CCSprite* platform5;
@property (nonatomic, retain) CCSprite* platform6;
@property (nonatomic, retain) CCSprite* platform7;
@property (nonatomic, retain) CCSprite* platform8;
@property (nonatomic, retain) CCSprite* platform9;
@property (nonatomic, retain) CCSprite* platform10;
@end
