#version 150

#moj_import "../misc/scale.glsl"
#moj_import "../misc/animation.glsl"


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


void main() {

    texCoord0 = UV0; // 使其他不修改的UI和原版效果相同
    vec3 pos = Position;
    int vertID = gl_VertexID % 4;
    vec2 corner = corners[vertID];
    
    // 稳定偏移 采样位置向角落像素的中心偏移半个像素量
    vec2 pixelSize = 1.0 / vec2(textureSize(Sampler0, 0)); // textureSize(..) 纹理大小   1.0 / vec2(..) 一个像素大小
    vec2 offsetBias = pixelSize * 0.5 * corner; // 半个像素大小
    vec4 color = round(texture(Sampler0, texCoord0 - offsetBias) * 255.0);
    
    dataScale data_scale = dataScale(pos, texCoord0);
    dataAnim data_anim = dataAnim(pos, texCoord0);
    
    if(color.a == 1) {
    
        // 缩放
        data_scale = scale(pos, texCoord0, color, corner);
        texCoord0 = data_scale.uv0;
        pos = data_scale.position;
        
        // 动画
        data_anim = anim(GameTime, pos, texCoord0, color, corner);
        texCoord0 = data_anim.uv0;
    
    }
    
    gl_Position = ProjMat * ModelViewMat * vec4(data_anim.position, 1.0);
}
