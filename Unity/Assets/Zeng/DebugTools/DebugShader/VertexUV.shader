Shader "ZengDebug/VertexUV"
{
    Properties
    {
        [Enum(Zeng.DebugShaders.UVChannel)] _UVChannel("UV 通道", Int) = 0
        [Enum(Zeng.DebugShaders.ShowUVAxis)] _ShowAxis("显示分量", Int) = 3
        _ValueMappingX("映射值 X", Vector) = (0, 1, 0, 0)
        _ValueMappingY("映射值 Y", Vector) = (0, 1, 0, 0)
    }
    
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "RenderPipeline" = "UniversalPipeline"
             // 队列标签， [Background, Geometry, AlphaTest, Transparent, Overlay, 正数]
            "Queue" = "Geometry"
        }
        LOD 100

        Pass
        {
            
            Name "ForwardLit"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            
            HLSLPROGRAM
            
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            #pragma vertex UnitPassVertex
            #pragma fragment UnitPassFragment

            CBUFFER_START(UnityPerMaterial)
                int _UVChannel;
                int _ShowAxis;
                float2 _ValueMappingX;
                float2 _ValueMappingY;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float2 uv3 : TEXCOORD3;
                float2 uv4 : TEXCOORD4;
                float2 uv5 : TEXCOORD5;
                float2 uv6 : TEXCOORD6;
                float2 uv7 : TEXCOORD7;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float2 uv3 : TEXCOORD3;
                float2 uv4 : TEXCOORD4;
                float2 uv5 : TEXCOORD5;
                float2 uv6 : TEXCOORD6;
                float2 uv7 : TEXCOORD7;
            };


            Varyings UnitPassVertex (Attributes input)
            {
                Varyings output = (Varyings)0;
                
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.uv0 = input.uv0;
                output.uv1 = input.uv1;
                output.uv2 = input.uv2;
                output.uv3 = input.uv3;
                output.uv4 = input.uv4;
                output.uv5 = input.uv5;
                output.uv6 = input.uv6;
                output.uv7 = input.uv7;
                
                return output;
            }

            half4 UnitPassFragment (Varyings input) : SV_Target
            {
                half2 inputUV = half2(0, 0);
                switch(_UVChannel)
                {
                    case 0:
                        inputUV = input.uv0;
                        break;
                    case 1:
                        inputUV = input.uv1;
                        break;
                    case 2:
                        inputUV = input.uv2;
                        break;
                    case 3:
                        inputUV = input.uv3;
                        break;
                    case 4:
                        inputUV = input.uv4;
                        break;
                    case 5:
                        inputUV = input.uv5;
                        break;
                    case 6:
                        inputUV = input.uv6;
                        break;
                    case 7:
                        inputUV = input.uv7;
                        break;
                }

                inputUV.x = (inputUV.x - _ValueMappingX.x) / (_ValueMappingX.y - _ValueMappingX.x);
                inputUV.y = (inputUV.y - _ValueMappingY.x) / (_ValueMappingY.y - _ValueMappingY.x);
                
                switch(_ShowAxis)
                {
                    // X
                    case 1:
                        inputUV.y = 0;
                        break;
                    // Y
                    case 2:
                        inputUV.x = 0;
                        break;
                }

                
                half4 col = half4(inputUV, 0, 1);
                return col;
            }
            ENDHLSL
        }
    }
}
