//
//  MainMenuScene.h
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "cocos2d.h"
#import "SceneManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MainMenuScene : CCLayer {
    CCMenu* menu;
    CCMenuItem* playButton;
    CCMenuItem* howButton;
    CCMenuItem* aboutButton;
    CCMenuItem* highScoreButton;
    
    AVAudioPlayer* tap;
}

@end
