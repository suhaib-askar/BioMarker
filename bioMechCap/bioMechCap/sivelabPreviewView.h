/*
 
 */

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreVideo/CVOpenGLESTextureCache.h>

@interface sivelabPreviewView : UIView 
{
	int renderBufferWidth;
	int renderBufferHeight;
    
	CVOpenGLESTextureCacheRef videoTextureCache;    

	EAGLContext* oglContext;
	GLuint frameBufferHandle;
	GLuint colorBufferHandle;
    GLuint passThroughProgram;
}

- (void)displayPixelBuffer:(CVImageBufferRef)pixelBuffer;

@end


