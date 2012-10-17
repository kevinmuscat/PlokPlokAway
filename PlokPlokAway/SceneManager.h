//
//  SceneManager.h
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import <Foundation/Foundation.h>

#import "LoadingScene.h"
#import "MainMenuScene.h"
#import "GameScene.h"
#import "HighScoreScene.h"
#import "AboutScene.h"
#import "HowScene.h"
#import "BonusScene.h"

extern int globalScore;
extern int globalWhatLevel;
extern int globalBonusScore;

@interface SceneManager : NSObject
{
    
}

+(void) goLoadingScene;
+(void) goMainMenuScene;
+(void) goGameScene;
+(void) goHighScoreScene;
+(void) goAboutScene;
+(void) goHowScene;
+(void) goBonusScene;

+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;

@end
