#define MAX_LIGHTS_PER_FRAME 32
#define MAX_LIGHTS_PER_DRAW 8
#define MAX_TEXTURES 4

#define SHADING_MODEL_UNLIT 0
#define SHADING_MODEL_LIT 1
#define SHADING_MODEL_TOON 2

#define BLEND_MODE_OPAQUE 0
#define BLEND_MODE_MASKED 1
#define BLEND_MODE_TRANSLUCENT 2
#define BLEND_MODE_ADDITIVE 3

#define VERTEX_COLOR_NONE 0
#define VERTEX_COLOR_MODULATE 1
#define VERTEX_COLOR_TEXTURE_BLEND 2

#define FOG_FUNC_LINEAR 0
#define FOG_FUNC_EXPONENTIAL 1

#define TEV_MODE_REPLACE 0
#define TEV_MODE_MODULATE 1
#define TEV_MODE_DECAL 2
#define TEV_MODE_ADD 3
#define TEV_MODE_SIGNED_ADD 4
#define TEV_MODE_SUBTRACT 5
#define TEV_MODE_INTERPOLATE 6
#define TEV_MODE_PASS 7

#define LIGHT_TYPE_POINT 0
#define LIGHT_TYPE_SPOT 1
#define LIGHT_TYPE_DIRECTIONAL 2

#define MAX_BONES 64
#define MAX_BONE_INFLUENCES 4

#define LIGHT_BAKE_SCALE 4.0

#define PI 3.14159265359

#define PATH_TRACE_MAX_TEXTURES 1024

struct LightData 
{
    vec4 mColor;

    vec3 mPosition;
    float mRadius;
    
    vec3 mDirection;
    uint mType;
};

struct GlobalUniforms
{
    mat4 mViewProj;
    mat4 mViewToWorld;
    mat4 mShadowViewProj;

    vec4 mAmbientLightColor;
    vec4 mViewPosition;
    vec4 mViewDirection;
    vec2 mScreenDimensions;
    vec2 mInterfaceResolution;
    vec4 mShadowColor;

    uint mFrameNumber;
    int mVisualizationMode;
    float mGameElapsedTime;
    float mRealElapsedTime;

    vec4 mFogColor;

    int mFogEnabled;
    int mFogDensityFunc;
    float mFogNear;
    float mFogFar;

    float mNearHalfWidth;
    float mNearHalfHeight;
    float mNearDist;
    uint mPathTracingEnabled;

    int mNumLights;
    uint mPad0;
    uint mPad1;
    uint mPad2;

    LightData mLights[MAX_LIGHTS_PER_FRAME];
};

struct GeometryUniforms 
{
    mat4 mWVP;
    mat4 mWorldMatrix;
    mat4 mNormalMatrix;
	vec4 mColor;

	uint mHitCheckId;
    uint mHasBakedLighting;
    uint mPad0;
    uint mPad1;

    uint mNumLights;
    uint mLights0;
    uint mLights1;
    uint mPad2;
};

struct SkinnedGeometryUniforms 
{
    mat4 mWVP;
    mat4 mWorldMatrix;
    mat4 mNormalMatrix;
	vec4 mColor;

	uint mHitCheckId;
    uint mHasBakedLighting;
    uint mPadding1;
    uint mPadding2;

    uint mNumLights;
    uint mLights0;
    uint mLights1;
    uint mPad2;

    mat4 mBoneMatrices[MAX_BONES];

    uint mNumBoneInfluences;
    uint mPadding3;
    uint mPadding4;
    uint mPadding5;
};

struct MaterialUniforms
{
    vec2 mUvOffset0;
    vec2 mUvScale0;

    vec2 mUvOffset1;
    vec2 mUvScale1;

    vec4 mColor;
    vec4 mFresnelColor;

    uint mShadingModel;
    uint mBlendMode;
    uint mToonSteps;
    float mFresnelPower;

    float mSpecular;
    float mOpacity;
    float mMaskCutoff;
    float mShininess;

    uint mFresnelEnabled;
    uint mVertexColorMode;
    uint mApplyFog;
    float mEmission;

    float mWrapLighting;
    float mPad0;
    float mPad1;
    float mPad2;

    uvec4 mUvMaps; // MAX_TEXTURES
    uvec4 mTevModes; // MAX_TEXTURES
};

const mat4 SHADOW_BIAS_MAT = mat4( 
	0.5, 0.0, 0.0, 0.0,
	0.0, 0.5, 0.0, 0.0,
	0.0, 0.0, 1.0, 0.0,
	0.5, 0.5, 0.0, 1.0 );

vec4 BlendTexture(MaterialUniforms material, vec4 prevColor, uint texIdx, sampler2D texSampler, vec2 uv0, vec2 uv1, float vertexIntensity)
{
    vec4 outColor = prevColor;
    vec2 uv = (material.mUvMaps[texIdx]) == 0 ? uv0 : uv1;
    uint tevMode = material.mTevModes[texIdx];
    uint vertexColorMode = material.mVertexColorMode;

    if (tevMode < TEV_MODE_PASS)
    {
        vec4 texColor = texture(texSampler, uv);

        if (vertexColorMode == VERTEX_COLOR_TEXTURE_BLEND && texIdx <= 2)
            outColor = mix(texIdx == 0 ? texColor : prevColor, texColor, vertexIntensity);
        else if (tevMode == TEV_MODE_REPLACE)
            outColor = texColor;
        else if (tevMode == TEV_MODE_MODULATE)
            outColor = prevColor * texColor;
        else if (tevMode == TEV_MODE_DECAL)
            outColor = prevColor * (1 - texColor.a) + (texColor * texColor.a);
        else if (tevMode == TEV_MODE_ADD)
            outColor = prevColor + texColor;
        else if (tevMode == TEV_MODE_SIGNED_ADD)
            outColor = prevColor + (texColor - 0.5);
        else if (tevMode == TEV_MODE_SUBTRACT)
            outColor = prevColor - texColor;
        else
            outColor = texColor;
    }

    return outColor;
}

float CalcLightIntensity(vec3 N, vec3 L, float wrap)
{
    float intensity = max(0.0, (dot(L, N) + wrap) / (1.0 + wrap));
    return intensity;
}