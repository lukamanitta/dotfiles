#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float fadeStart;
};

layout(binding = 1) uniform sampler2D source;

void main() {
    vec4 c = texture(source, qt_TexCoord0);
    float a = 1.0 - smoothstep(fadeStart, 1.0, qt_TexCoord0.x);
    fragColor = vec4(c.rgb * a, c.a * a) * qt_Opacity;
}
