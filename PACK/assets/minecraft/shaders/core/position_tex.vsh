#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;

uniform sampler2D Sampler0;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;
uniform float GameTime;

out vec2 texCoord0;

vec2[] corners = vec2[](vec2(0, 0), vec2(0, 1), vec2(1, 1), vec2(1, 0));
vec2 screen = 2 / vec2(ProjMat[0][0], -ProjMat[1][1]);
float margin = 1;

bool posCheck(vec2 offset, vec2 size) {
    return ( abs( (round(screen.x/2)+offset.x+(size.x*corners[gl_VertexID % 4].x)) - Position.x )<= margin ) &&
           ( abs( (round(screen.y/2)+offset.y+(size.y*corners[gl_VertexID % 4].y)) - Position.y )<= margin );
}

int recipeType = 0;

void main() {
    texCoord0 = UV0;
    
    vec3 pos = Position;
    int vertID = gl_VertexID % 4;
    
    vec2 corner = corners[vertID];
    
    // 根据实际贴图尺寸推算出像素大小（支持任何贴图分辨率）
    vec2 pixelSize = 1.0 / vec2(textureSize(Sampler0, 0));
    
    // 更稳定的偏移：子像素向角落中心偏移半个像素量
    vec2 offsetBias = pixelSize * 0.5 * corner;
    
    vec4 color = round(texture(Sampler0, texCoord0 - offsetBias) * 255.0);
    if(color.a == 1){// GUI
        if(color.r == 255){// 256x256

            pos.xy += ((corner-0.5)*2*vec2(40,45));
            texCoord0 = corner*(256.0/1024.0);
            
            if(color.b == 255){// 生存物品栏动画

            float animation_speed = 3.5;
            float frames = 4;

            texCoord0 = corner * (256.0 / 1024.0);// 每帧大小仍为 256x256

            float unit = 256.0 / 1024.0;// 偏移单位（每帧宽度或高度（0.25））

            // 当前动画时间值（周期性）
            float time = mod(GameTime * 24000.0, animation_speed);

            if (time < animation_speed / frames)
                texCoord0.xy += vec2(0.0);
            else if (time < 2.0 * animation_speed / frames)
                texCoord0.x += unit;
            else if (time < 3.0 * animation_speed / frames)
                texCoord0.y += unit;
            else
                texCoord0.xy += vec2(unit, unit);
            
                }
            
            if(color.b == 254){// 熔炉动画

            float animation_speed = 3.5;
            float frames = 4;
            float unit = 256.0 / 1024.0;
            float time = mod(GameTime * 24000.0, animation_speed);
            texCoord0 = corner * (256.0 / 1024.0);
            if (time < animation_speed / frames) texCoord0.xy += vec2(0.0);
            else if (time < 2.0 * animation_speed / frames) texCoord0.x += unit;
            else if (time < 3.0 * animation_speed / frames) texCoord0.y += unit;
            else texCoord0.xy += vec2(unit, unit);
            
                }
                
            if(color.b == 253){// 工作台动画

            float animation_speed = 3.5;
            float frames = 4;
            float unit = 256.0 / 1024.0;
            float time = mod(GameTime * 24000.0, animation_speed);
            texCoord0 = corner * (256.0 / 1024.0);
            if (time < animation_speed / frames) texCoord0.xy += vec2(0.0);
            else if (time < 2.0 * animation_speed / frames) texCoord0.x += unit;
            else if (time < 3.0 * animation_speed / frames) texCoord0.y += unit;
            else texCoord0.xy += vec2(unit, unit);
            
                }
            
            }
            
        }
        /*
            else if (color.a == 1 && color.g == 1) { // 配方按钮
        // 根据颜色值确定配方类型
        if (color.r == 255) {
            recipeType = 1; // 生存物品栏
        } else if (color.r == 254) {
            recipeType = 2; // 熔炉
        } 
        
        // 从20x90贴图中选择20x18的子图
        vec2 iconSize = vec2(20.0, 18.0);
        vec2 textureSize = vec2(20.0, 90.0);
        vec2 baseUV = vec2(0.0, float(recipeType - 1) * iconSize.y / textureSize.y);
        vec2 localUV = corner * iconSize / textureSize;
        texCoord0 = baseUV + localUV;
    }*/
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);
}
