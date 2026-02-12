struct dataAnim
{
    vec3 position;
    vec2 uv0;
};
// 自定义类型 方便传输数据


dataAnim anim(float GameTime, vec3 pos, vec2 texCoord0, vec4 color, vec2 corner) {
    
    if(color.r == 255) {
            
        if(color.b == 254 || color.b == 255 || color.b == 253) {

            float frames = 4; // 4帧动画
            float frame_duration = 0.05; // 每帧0.05秒
            float animation_duration = frames * frame_duration; // 总时长 = 0.2秒
            float unit = 256.0 / 1024.0; // 每帧大小比例 = 0.25
            texCoord0 = corner * unit; // 基础位置
            float time = mod(GameTime * 1500.0, animation_duration);
            float frameIndex = floor(time / frame_duration); // 计算当前帧索引
            
            if (frameIndex < 1.0) // 第1帧
                texCoord0.xy += vec2(0.0);
            else if (frameIndex < 2.0) // 第2帧
                texCoord0.x += unit;
            else if (frameIndex < 3.0) // 第3帧
                texCoord0.y += unit;
            else // 第4帧
                texCoord0.xy += vec2(unit, unit);
            
            return dataAnim(pos, texCoord0);
            
        }
            
        return dataAnim(pos, texCoord0);
            
    }

    return dataAnim(pos, texCoord0);
}
