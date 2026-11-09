#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float leftFade;
    float rightFade;
};

layout(binding = 1) uniform sampler2D source;

void main() {
    vec4 c = texture(source, qt_TexCoord0);
    float l = leftFade > 0.0 ? smoothstep(0.0, leftFade, qt_TexCoord0.x) : 1.0;
    float r = rightFade > 0.0 ? (1.0 - smoothstep(1.0 - rightFade, 1.0, qt_TexCoord0.x)) : 1.0;
    fragColor = c * l * r * qt_Opacity;
}
