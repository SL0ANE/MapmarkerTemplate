#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    vec2 atlasSize = textureSize(Sampler0, 0);
    vec2 onepixel = 1./atlasSize;
    float vertexId = mod(gl_VertexID, 4.0);
    vec2 onescr = 1./ScreenSize;

    int subShaderId = -1;
    vec4 texColor = textureLod(Sampler0, UV0, 0);

    if(ivec4(texColor * 255.0) == ivec4(255, 0, 0, 254)) {
        vec2 subCoord;
        vec2 pointOffset;
        vec2 targetUV;
        if(vertexId == 0.0) {
            subCoord = UV0 + vec2(16.0, 16.0) * onepixel;
            pointOffset = vec2(1, -1) * 0.2;
            targetUV = subCoord + vec2(16.0, 0.0) * onepixel;
        }
        else if(vertexId == 1.0) {
            subCoord = UV0 + vec2(16.0, -47.0) * onepixel;
            pointOffset = vec2(1, 1) * 0.2;
            targetUV = subCoord + vec2(16.0, 16.0) * onepixel;
        }
        else if(vertexId == 2.0) {
            subCoord = UV0 + vec2(-47.0, -47.0) * onepixel;
            pointOffset = vec2(-1, 1) * 0.2;
            targetUV = subCoord + vec2(32.0, 16.0) * onepixel;
        }
        else if(vertexId == 3.0) {
            subCoord = UV0 + vec2(-47.0, 16.0) * onepixel;
            pointOffset = vec2(-1, -1) * 0.2;
            targetUV = subCoord + vec2(32.0, 0.0) * onepixel;
        }

        vec4 subColor = textureLod(Sampler0, subCoord, 0);
        vertexColor = vec4(1.0);
        subShaderId = int(subColor.r * 255.0) << 16 + int(subColor.g * 255.0) << 8 + int(subColor.b * 255.0);

        if(subShaderId == 0) {
            
            vec4 tempPos = ModelViewMat * vec4(Position, 1.0);
            tempPos += vec4(pointOffset, 0.0, 0.0);
            tempPos = ProjMat * tempPos;

            float screenScale = floor(ScreenSize.y / 1080) + 1;
            float range = 256.0 * tempPos.z * screenScale;

            tempPos.xy -= range * pointOffset * onescr;
            tempPos.z = 0;

            gl_Position = tempPos;
            texCoord0 = targetUV;
        }
    }
}
