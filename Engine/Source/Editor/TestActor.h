#pragma once

#include "Nodes/Node.h"
#include "Nodes/3D/Node3d.h"

class StaticMesh3D;
class PointLight3D;
class Node3D;
class ScriptComponent;
class Texture;
class StaticMesh;

class TestActor : public Node3D
{
public:

    TestActor();
    virtual void Create() override;
    virtual void Destroy() override;
    virtual void Tick(float deltaTime) override;
    virtual void EditorTick(float deltaTime) override;

    DECLARE_NODE(TestActor, Node3D);

protected:

    StaticMesh3D* mRootMesh;
    StaticMesh3D* mLeftMesh1;
    StaticMesh3D* mRightMesh1;
    StaticMesh3D* mRightMesh2;
    PointLight3D* mLeftLight1;
    PointLight3D* mLeftLight2;
    PointLight3D* mRightLight1;
    Node3D* mLeftSpin1;
    ScriptComponent* mScript;
};
