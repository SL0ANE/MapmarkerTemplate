#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform vec2 ScreenSize;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
out vec4 normal;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    #moj_import <sloane/texture_trigger.glsl>

    if(subShaderId == 0) {
        texCoord0 = UV0 + vec2(16.0 * onepixel.x, 0);
        vertexColor = vec4(1.0);
        uint colorInfo = uint(int(Color.r * 255.0) * 65536 + int(Color.g * 255.0) * 256 + int(Color.b * 255.0));
        float screenScale = floor(ScreenSize.y / 1080) + 1;
        float colorScale = float(colorInfo & 0x000000ffu);

        float range = 16.0 * gl_Position.w * screenScale * colorScale;

        gl_Position.z = 0.0;
        if(vertexId == 0.0) {
            gl_Position.xy += range * vec2(-1.0, 1.0) * onescr;
        }
        else if(vertexId == 1.0) {
            gl_Position.xy += range * vec2(-1.0, -1.0) * onescr;
        }
        else if(vertexId == 2.0) {
            gl_Position.xy += range * vec2(1.0, -1.0) * onescr;
        }
        else if(vertexId == 3.0) {
            gl_Position.xy += range * vec2(1.0, 1.0) * onescr;
        }
    };
}
