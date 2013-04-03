//
//  HelloWorldLayer.m
//  OutlineTool
//
//  Created by Anand Baumunk on 28.03.13.
//  Copyright Anand Baumunk 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super init]) ) {
		
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        [self setAnchorPoint:ccp(0.5, 0.5)];
        
        
        int lineSize = 1;
        ccColor3B color = ccc3(0, 0, 0);
        
        
        
        CCSprite* old = [CCSprite spriteWithFile:@"warrior_animation_montage.png"];
        
        
        CCRenderTexture* tex = [self outlineSprite:old lineSize:lineSize];
        [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
        
        
        
        CGPoint offset = ccp(old.contentSize.width /2, old.contentSize.height/2);
        offset.x += 0;//lineSize/2;
        offset.y += lineSize*2;
        
        old.position = offset;
        //old.rotationY = 180;
        
        CCSprite* f = [CCSprite spriteWithTexture:tex.sprite.texture];
        f.position = offset;
        f.rotationX = 180;
        //f.rotationY = 180;


        
        const GLchar * fragmentSource = (GLchar*) [[NSString stringWithContentsOfFile:[CCFileUtils fullPathFromRelativePath:@"pureColor.fsh"] encoding:NSUTF8StringEncoding error:nil] UTF8String];
        f.shaderProgram = [[CCGLProgram alloc] initWithVertexShaderByteArray:ccPositionTextureA8Color_vert
                                                          fragmentShaderByteArray:fragmentSource];
        [f.shaderProgram addAttribute:kCCAttributeNamePosition index:kCCVertexAttrib_Position];
        [f.shaderProgram addAttribute:kCCAttributeNameTexCoord index:kCCVertexAttrib_TexCoords];
        [f.shaderProgram link];
        [f.shaderProgram updateUniforms];

        [f.shaderProgram use];
        glActiveTexture(GL_TEXTURE0);


        int timeUniformLocation;

		timeUniformLocation = glGetUniformLocation(f.shaderProgram->_program, "u_color");
		glUniform3f(timeUniformLocation, color.r, color.g, color.b);
        
        [self addChild:f];
        [self addChild:old];
        

        
        CCRenderTexture *save = [CCRenderTexture renderTextureWithWidth:tex.sprite.contentSize.width height:tex.sprite.contentSize.height];
        [save begin];
        [self visit];
        [save end];
         
        
        [CCDirector sharedDirector].nextDeltaTimeZero = YES;
        [save saveToFile:@"OUTLINETEST.png" format:kCCImageFormatPNG];
        
	}
	return self;
}


-(CCRenderTexture*)outlineSprite:(CCSprite *)sprite lineSize:(float)size{
    
    
    CCRenderTexture* rt = [CCRenderTexture renderTextureWithWidth:sprite.texture.contentSize.width+size*2  height:sprite.texture.contentSize.height+size*2];
    
    CGPoint originalPos = [sprite position];
    [sprite setVisible:YES];
    ccBlendFunc originalBlend = [sprite blendFunc];
    [sprite setBlendFunc:(ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
    CGPoint bottomLeft = ccp(sprite.texture.contentSize.width * sprite.anchorPoint.x + size, sprite.texture.contentSize.height * sprite.anchorPoint.y + size);
    CGPoint positionOffset = ccp(sprite.texture.contentSize.width * sprite.anchorPoint.x - sprite.texture.contentSize.width/2,sprite.texture.contentSize.height * sprite.anchorPoint.y - sprite.texture.contentSize.height/2);
    CGPoint position = ccpSub(originalPos, positionOffset);
    
    [rt begin];
    for (int i=0; i<360; i+=30){
        [sprite setPosition:ccp(bottomLeft.x + sin(CC_DEGREES_TO_RADIANS(i))*size, bottomLeft.y + cos(CC_DEGREES_TO_RADIANS(i))*size)];
        [sprite visit];
    }
    
    [rt end];
    [sprite setPosition:originalPos];
    [sprite setBlendFunc:originalBlend];
    [rt setPosition:position];
    return rt;
    
}







// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
