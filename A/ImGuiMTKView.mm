//
//  ImGuiMTKView.m
//  IOSPUBG
//
//  Created by yy on 2022/5/2.
//

#import "ImGuiMTKView.h"
//#import "jijia.h"
#import "XQView.h"
#define iPhone8P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPAD129 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(2732,2048), [[UIScreen mainScreen] currentMode].size) : NO)

//2732x2048
@interface ImGuiMTKView ()
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) MTKTextureLoader *loader;
@end

@implementation ImGuiMTKView

- (nonnull instancetype)initWithView:(nonnull MTKView *)view;
{
    self = [super init];
    if(self)
    {
        view.preferredFramesPerSecond = 120;
        
        _device = view.device;
        _commandQueue = [_device newCommandQueue];
        _loader = [[MTKTextureLoader alloc] initWithDevice: _device];
        
        IMGUI_CHECKVERSION();
        ImGui::CreateContext();
        ImGui::StyleColorsLight();
        
        //#if 0
        ImGuiIO & io = ImGui::GetIO();
        ImFontConfig config;
        NSString *FontPath = @"/System/Library/Fonts/LanguageSupport/PingFang.ttc";
        io.Fonts->AddFontFromFileTTF(FontPath.UTF8String, 40.f,NULL,io.Fonts->GetGlyphRangesChineseFull());
        
        
        ImGui::StyleColorsLight();
        //#endif
    }
    
    return self;
}


- (void)drawInMTKView:(MTKView *)view {
    
    ImGuiIO &io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;
    
#if TARGET_OS_OSX
    CGFloat framebufferScale = view.window.screen.backingScaleFactor ?: NSScreen.mainScreen.backingScaleFactor;
#else
    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
#endif
    if (iPhone8P){
        io.DisplayFramebufferScale = ImVec2(2.60, 2.60);
    }else{
        io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    }
    
    
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    static float clear_color[4] = { 0.0f, 0.0f, 0.0f, 0.0f };
    
    view.clearColor = MTLClearColorMake(clear_color[0], clear_color[1], clear_color[2], clear_color[3]);
    
    
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        [commandBuffer commit];
        return ;
    }
    
    
    if ((renderPassDescriptor != nil)& ([UIApplication sharedApplication].applicationState == UIApplicationStateActive))
    {
        id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"SwiftGUI"];
        
        // Start the Dear ImGui frame
        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();
        
        [self.delegate 绘制];
        
        
        // Rendering
        ImGui::Render();
        ImDrawData *drawData = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(drawData, commandBuffer, renderEncoder);
        
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        
        
        [commandBuffer presentDrawable:view.currentDrawable];
        
        
        
    }
    
    [commandBuffer commit];
    
    
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
}

- (void)initializePlatform {
    ImGui_ImplMetal_Init(_device);
}

- (void)handleEvent:(UIEvent *_Nullable)event view:(UIView *_Nullable)view {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);
    
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

-(id<MTLTexture>)loadTextureWithURL:(NSURL *)url {
    
    id<MTLTexture> texture = [self.loader newTextureWithContentsOfURL:url options:nil error:nil];
    
    if(!texture)
    {
        NSLog(@"Failed to create the texture from %@", url.absoluteString);
        return nil;
    }
    return texture;
}

-(id<MTLTexture>)loadTextureWithName:(NSString *)name {
    
    id<MTLTexture> texture = [self.loader newTextureWithName:name scaleFactor:1.0 bundle:nil options:nil error:nil];
    
    if(!texture)
    {
        NSLog(@"Failed to create the texture from %@", name);
        return nil;
    }
    return texture;
}


@end
