#pragma once

#include "Asset.h"
#include "EngineTypes.h"
#include "Datum.h"

#include "Texture.h"
#include "AssetRef.h"

#include "Maths.h"
#include <string>
#include <vector>
#include <map>

#include "Enums.h"
#include "Asset.h"
#include "AssetRef.h"
#include "Constants.h"
#include "EngineTypes.h"
#include "Vertex.h"

class Material;
class MaterialInstance;
class Texture;

enum class ShaderParameterType
{
    Scalar,
    Vector,
    Texture,

    Count
};

struct ShaderParameter
{
    std::string mName;
    glm::vec4 mFloatValue = { }; // Holds scalar and vector values.
    TextureRef mTextureValue; // Only used when Texture param type.
    ShaderParameterType mType = ShaderParameterType::Count;
    uint32_t mOffset = 0; // Byte offset for uniforms, binding location for textures.
};

class Material : public Asset
{
public:

    DECLARE_ASSET(Material, Asset);

    void MarkDirty();
    void ClearDirty(uint32_t frameIndex);
    bool IsDirty(uint32_t frameIndex);
    MaterialResource* GetResource();

    virtual bool IsMaterialBase() const;
    virtual bool IsMaterialInstance() const;

    void SetScalarParameter(const std::string& name, float value);
    void SetVectorParameter(const std::string& name, glm::vec4 value);
    void SetTextureParameter(const std::string& name, Texture* value);

    float GetScalarParameter(const std::string& name);
    glm::vec4 GetVectorParameter(const std::string& name);
    Texture* GetTextureParameter(const std::string& name);

    std::vector<ShaderParameter>& GetParameters();

protected:

    std::vector<ShaderParameter> mParameters;
    bool mDirty[MAX_FRAMES] = {};

    // Graphics Resource
    MaterialResource mResource;
};

