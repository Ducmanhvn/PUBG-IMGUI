#import "XQView.h"

#import "YMUIWindow.h"
#import <shisangeIMGUI/imgui_impl_metal.h>
#import <shisangeIMGUI/imgui.h>
#include "string"
#import "ImGuiMTKView.h"




@interface XQView() <ImGuiMTKViewDelegate>
@property (nonatomic, strong) MTKView *mtkView;
@property (nonatomic, strong) ImGuiMTKView *renderer;

@end

@implementation XQView

CGSize screenSize;
using namespace std;
static UITextField* textField;
bool gzb=YES;
#pragma mark - 视图
#pragma mark - 视图


+ (void)load
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"load");
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[[self alloc] init] show];
            
        });});
    
}

#pragma mark - 绘制函数
//画线函数
static void DrawLine(ImVec2 startPoint, ImVec2 endPoint, int color, float thicknes = 1)
{
    ImGui::GetForegroundDrawList()->AddLine(startPoint, endPoint, color, thicknes);
}

//文本函数
static void DrawText(string text, ImVec2 pos, bool isCentered, int color, bool outline, float fontSize)
{
    const char *str = text.c_str();
    ImVec2 vec2 = pos;
    
    if (isCentered) {
        ImFont* font = ImGui::GetFont();
        font->Scale = 20.f / font->FontSize;
        
        ImVec2 textSize = font->CalcTextSizeA(fontSize, MAXFLOAT, 0.0f, str);
        vec2.x -= textSize.x * 0.5f;
    }
    if (outline)
    {
        ImU32 outlineColor = 0xFF000000;
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x + 1, vec2.y + 1), outlineColor, str);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x - 1, vec2.y - 1), outlineColor, str);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x + 1, vec2.y - 1), outlineColor, str);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x - 1, vec2.y + 1), outlineColor, str);
    }
    ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, vec2, color, str);
}

static void DrawText2(string text, ImVec2 pos, bool isCentered, int color, bool outline, float fontSize)
{
    const char *str = text.c_str();
    ImVec2 vec2 = pos;
    
    if (isCentered) {
        ImFont* font = ImGui::GetFont();
        font->Scale = 20.f / font->FontSize;
        
        ImVec2 textSize = font->CalcTextSizeA(fontSize, MAXFLOAT, 0.0f, str);
        vec2.x -= textSize.x * 0.5f;
    }
    if (outline)
    {
        ImU32 outlineColor = 0xFF0000FF;
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x + 1, vec2.y + 1), outlineColor, str);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x - 1, vec2.y - 1), outlineColor, str);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x + 1, vec2.y - 1), outlineColor, str);
        ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, ImVec2(vec2.x - 1, vec2.y + 1), outlineColor, str);
    }
    ImGui::GetForegroundDrawList()->AddText(ImGui::GetFont(), fontSize, vec2, color, str);
}

#pragma mark - 绘制结束

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        screenSize = [UIScreen mainScreen].bounds.size;
        screenSize.width *= [UIScreen mainScreen].nativeScale;
        screenSize.height *= [UIScreen mainScreen].nativeScale;
        self.userInteractionEnabled = NO;
        self.layer.allowsEdgeAntialiasing = YES;
        self.backgroundColor=[UIColor clearColor];
       
        
        [[YMUIWindow sharedInstance] addSubview:self];
        [YMUIWindow sharedInstance].hidden=NO;
        self.frame=[YMUIWindow sharedInstance].bounds;
        self.autoresizingMask= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setupUI];
        
        
        
        
        
    }
    return self;
}
- (void)setupUI
{
    self.mtkView = [[MTKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.mtkView.backgroundColor = [UIColor clearColor];
    
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    if (!self.mtkView.device) return;
    [self addSubview:self.mtkView];
    
    self.renderer = [[ImGuiMTKView alloc] initWithView:self.mtkView];
    self.renderer.delegate = self;
    self.mtkView.delegate = self.renderer;
    
    if( ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) && ([UIApplication sharedApplication].applicationState != UIApplicationStateInactive)) {
        [self.renderer initializePlatform];
        
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

#pragma mark 定时器===================================


-(void)show
{
    if(textField==nil){
        textField = [[UITextField alloc] init];
        textField.secureTextEntry = gzb;
        textField.frame = [YMUIWindow sharedInstance].bounds;
        textField.subviews.firstObject.userInteractionEnabled = NO;
        [textField.subviews.firstObject addSubview:self];
        textField.userInteractionEnabled = NO;
        [[YMUIWindow sharedInstance] addSubview:textField];
        self.autoresizingMask= UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
}


#pragma mark - 事件


- (void)绘制
{
    NSLog(@"绘制");
    ImU32 outlineColor = 0xFFFFFFFF;
    DrawLine(ImVec2(kWidth/2, 47), ImVec2(arc4random() %1000,arc4random() %1000),outlineColor,2);
}




@end
