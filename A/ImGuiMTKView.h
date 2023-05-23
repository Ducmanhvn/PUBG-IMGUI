//
//  ImGuiMTKView.h
//  IOSPUBG
//
//  Created by yy on 2022/5/2.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#import <shisangeIMGUI/imgui_impl_metal.h>
#import <shisangeIMGUI/imgui.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ImGuiMTKViewDelegate<NSObject>

- (void)绘制;

@end


@interface ImGuiMTKView : NSObject <MTKViewDelegate>

@property (nonatomic, weak, nullable) id<ImGuiMTKViewDelegate> delegate;

-(nonnull instancetype)initWithView:(nonnull MTKView *)view;

-(void)initializePlatform;

- (void)handleEvent:(UIEvent *_Nullable)event view:(UIView *_Nullable)view;
-(id<MTLTexture>_Nullable)loadTextureWithURL:(NSURL *_Nonnull)url;
-(id<MTLTexture>_Nullable)loadTextureWithName:(NSString *_Nonnull)name;
@end

NS_ASSUME_NONNULL_END
