//
//  GameScene.h
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "cocos2d.h"
#import "SceneManager.h"
#import <AVFoundation/AVFoundation.h>

@interface GameScene : CCLayer <UIAccelerometerDelegate>
{
    int score;
    int lives;
    int foxCount;
    int blueEggCount;
    int blueEggWidth;
    int greenEggCount;
    
    bool paused;
    bool isOnGround;
    bool isCreatedRat;
    
    CGSize s;
    NSString* time;
    
    CCSpawn* spawnWalkLeft;
    CCMoveTo* moveRatLeft;
    CCAction* repeatMotion;
    CCAnimate* animateWalk;
    CCSequence* walkRatLeft;
    CCAnimation* ratAnimation;
    CCRepeatForever* forever;
    
    CCMenu* menuOverlay;
    CCMenuItem* pauseButton;
    CCMenuItem* homeButton;
    CCMenuItem* playAgainButton;
    
    CCSprite* hen1;
    CCSprite* hen2;
    CCSprite* hen3;
    CCSprite* hen4;
    CCSprite* hen5;
    
    CCSprite* player;
    CCSprite* background;
    CCSprite* winOverlay;
    CCSprite* loseOverlay;
    CCSprite* pauseOverlay;
    
    CCSprite* levelBG;
    CCSprite* eggTrayBase;
    CCSprite* eggMeterBase;
    CCSprite* eggTrayComplete;
    
    CCSprite* imageLife1;
    CCSprite* imageLife2;
    CCSprite* imageLife3;
    CCSprite* imageLife4;
    
    CCSprite* cow;
    CCSprite* cow1;
    CCSprite* minus;
    CCSprite* indicator;
    CCSprite* cow_sleeping;
    CCSprite* cow_sleeping1;
    
    CCLabelTTF* lblTime;
    CCLabelTTF* lblLife;
    CCLabelTTF* lblScore;
    CCLabelTTF* lblEggCount;
    CCLabelTTF* lblCountDown;
    CCLabelTTF* lblScoreCount;
    CCLabelTTF* lblGreenEggCount;
    CCLabelTTF* lblShowHighScore;
    
    CCSpriteFrame* defaultRat;
    CCSpriteFrame* defaultPose;
    
    CCProgressTimer* eggTray;
    CCProgressTimer* blueEggUp;
    
    NSMutableArray* rats;
    NSMutableArray* foxes;
    NSMutableArray* stones;
    NSMutableArray* goldEggs;
    NSMutableArray* blueEggs;
    NSMutableArray* greenEggs;
    NSMutableArray* whiteEggs;
    NSMutableArray* silverEggs;
    NSMutableArray* rainbowEggs;
    
    NSMutableArray* ratFrames;
    NSMutableArray* hen1Frames;
    NSMutableArray* hen2Frames;
    NSMutableArray* hen3Frames;
    NSMutableArray* hen4Frames;
    NSMutableArray* hen5Frames;
    
    NSMutableArray* ratsHistNest;
    NSMutableArray* fallenEggsToNest;
    NSMutableArray* fallenEggsToFloor;
    NSMutableArray* fallenStonesToNest;
    NSMutableArray* fallenStonesToFloor;
    
    AVAudioPlayer* tap;

}
@property (nonatomic, retain) NSMutableArray* columns;
@property (nonatomic, retain) CCSequence* henMotion;
@property (nonatomic, retain) CCSequence* ratMotionLeft;
@property (nonatomic, retain) CCSequence* walkRatLeft;
@property (nonatomic, retain) CCSequence* cowMotion;
@property (nonatomic, retain) CCSequence* cowSleepingMotion;
@end
