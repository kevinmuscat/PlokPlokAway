//
//  SceneManager.m
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "SceneManager.h"

@implementation SceneManager

+ (void)goLoadingScene
{
    CCLayer *layer = [LoadingScene node];
	[SceneManager go: layer];
}

+ (void)goMainMenuScene {
    CCLayer *layer = [MainMenuScene node];
	[SceneManager go: layer];
}

+ (void)goGameScene {
    CCLayer *layer = [GameScene node];
	[SceneManager go: layer];
}

+ (void)goHighScoreScene {
    CCLayer *layer = [HighScoreScene node];
	[SceneManager go: layer];
}

+ (void)goAboutScene {
    CCLayer *layer = [AboutScene node];
	[SceneManager go: layer];
}

+ (void)goHowScene {
    CCLayer *layer = [HowScene node];
	[SceneManager go: layer];
}

+ (void)goBonusScene {
    CCLayer *layer = [BonusScene node];
	[SceneManager go: layer];
}

+(void) go: (CCLayer *) layer{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	if ([director runningScene]) {
		[director replaceScene:newScene];
	}else {
		[director runWithScene:newScene];
	}
}

+(CCScene *) wrap: (CCLayer *) layer{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}

@end
