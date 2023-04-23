#version 450
#extension GL_ARB_separate_shader_objects : enable

#include "Common.glsl"
#include "Skinning.glsl"

layout (set = 0, binding = 0) uniform GlobalUniformBuffer 
{
    GlobalUniforms global;
};

layout (set = 1, binding = 0) uniform GeometryUniformBuffer 
{
	SkinnedGeometryUniforms geometry;
};

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec2 inTexcoord0;
layout(location = 2) in vec2 inTexcoord1;
layout(location = 3) in vec3 inNormal;
layout(location = 4) in uvec4 inBoneIndices;
layout(location = 5) in vec4 inBoneWeights;

layout(location = 0) out vec3 outPosition;
layout(location = 1) out vec2 outTexcoord0;
layout(location = 2) out vec2 outTexcoord1;
layout(location = 3) out vec3 outNormal;
layout(location = 4) out vec4 outShadowCoordinate;
layout(location = 5) out vec4 outColor;

out gl_PerVertex 
{
    vec4 gl_Position;
};

void main()
{
    vec3 skinnedPosition = inPosition;
    vec3 skinnedNormal = inNormal;
    SkinVertex(skinnedPosition, skinnedNormal, inBoneIndices, inBoneWeights, geometry);

    gl_Position = geometry.mWVP * vec4(skinnedPosition, 1.0);
    
    outPosition = (geometry.mWorldMatrix * vec4(skinnedPosition, 1.0)).xyz;    
    outTexcoord0 = inTexcoord0;    
    outTexcoord1 = inTexcoord1;    
    outNormal = normalize((geometry.mNormalMatrix * vec4(skinnedNormal, 0.0)).xyz);
    outColor = vec4(1.0, 1.0, 1.0, 1.0);

    // Shadow map coordinate computation
    vec4 shadowCoord = (SHADOW_BIAS_MAT * global.mShadowViewProj) * vec4(outPosition, 1.0);
    shadowCoord = shadowCoord / shadowCoord.w;
    outShadowCoordinate = shadowCoord;
}