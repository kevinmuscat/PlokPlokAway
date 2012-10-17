//
//  HowScene.h
//  PlokPlokAway
//
//  Created by Karen Cate Arabit on 10/3/12.
//
//

#import "cocos2d.h"
#import "SceneManager.h"

@interface HowScene : CCLayer
{
    CCMenuItem* leftButton;
    CCMenuItem* rightButton;
    
    CCSprite* page;
    int currentPageCount;
}
@end
