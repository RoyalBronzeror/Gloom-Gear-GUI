struct dataScale
{
    vec3 position;
    vec2 uv0;
};
// 自定义类型 方便传输数据


dataScale scale(vec3 pos, vec2 texCoord0, vec4 color, vec2 corner) {

    if(color.r == 255) { // 正常情况

            pos.xy += ((corner- 0.5) * 2 * vec2(40, 45));
            texCoord0 = corner * (256.0/ 1024.0);
            
            return dataScale(pos, texCoord0);
            
        }

    return dataScale(pos, texCoord0);
}
