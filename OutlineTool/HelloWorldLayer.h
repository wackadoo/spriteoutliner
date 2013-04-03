//
//  HelloWorldLayer.h
//  OutlineTool
//
//  Created by Anand Baumunk on 28.03.13.
//  Copyright Anand Baumunk 2013. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(CCRenderTexture*)outlineSprite:(CCSprite *)sprite lineSize:(float)size;

@end
