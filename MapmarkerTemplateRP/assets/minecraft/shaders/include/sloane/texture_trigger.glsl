vec2 atlasSize = textureSize(Sampler0, 0);
vec2 onepixel = 1./atlasSize;
float vertexId = mod(gl_VertexID, 4.0);
vec2 onescr = 1./ScreenSize;

int subShaderId = -1;
vec4 texColor = textureLod(Sampler0, UV0, 0);

if(ivec4(texColor * 255.0) == ivec4(255, 0, 0, 254)) {
    vec4 subColor = textureLod(Sampler0, UV0 + vec2(0, 16 * onepixel.y), 0);
    subShaderId = int(subColor.r * 255.0) << 16 + int(subColor.g * 255.0) << 8 + int(subColor.b * 255.0);
}