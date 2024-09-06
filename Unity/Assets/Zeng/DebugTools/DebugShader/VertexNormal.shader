Shader "ZengDebug/VertexNormal"
{
    Properties
    {
        [Enum(Zeng.DebugShaders.SpaceType)] _SpaceType("Space Type", Int) = 0
        [Toggle] _HalfValue("Value * 0.5 + 0.5", Int) = 1
        [Enum(Zeng.DebugShaders.ShowAxis)] _ShowAxis("显示分量", Int) = 7
    }
    
    
    SubShader
    {
        Tags
        {
            // 渲染管线标签， [UniversalPipeline, HighDefinitionRenderPipeline, 自定义管线]
            "RenderPipeline" = "UniversalPipeline"
            
             // 队列标签， [Background, Geometry, AlphaTest, Transparent, Overlay, 正数]
            "Queue" = "Geometry"
            
            // 渲染类型标签， [Opaque, Transparent, Cutout, Fade, Overlay,TreeOpaque, TreeTransparentCutout, TreeBillboard, Grass, GrassBillboard]
            "RenderType"="Opaque" 
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
                int _SpaceType;
                int _HalfValue;
                int _ShowAxis;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalOS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
            };


            Varyings UnitPassVertex (Attributes input)
            {
                Varyings output = (Varyings)0;
                
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);
                output.normalOS = input.normalOS;
                output.normalWS = normalInput.normalWS;
                
                return output;
            }

            half4 UnitPassFragment (Varyings input) : SV_Target
            {
                half4 col = half4(0,0,0,1);

                switch (_SpaceType)
                {
                    // OS
                case 0:
                    col.rgb = normalize(input.normalOS);
                    break;
                    // WS
                case 2:
                    col.rgb = normalize(input.normalWS);
                    break;
                }

                if(_HalfValue == 1)
                {
                    col.rgb = col.rgb * 0.5 + 0.5;
                }

                
                switch (_ShowAxis)
                {
                    // R
                case 1:
                    col.g = 0;
                    col.b = 0;
                    col.a = 1;
                    break;
                    // G
                case 2:
                    col.r = 0;
                    col.b = 0;
                    col.a = 1;
                    break;
                    // B
                case 4:
                    col.r = 0;
                    col.g = 0;
                    col.a = 1;
                    break;
                    // alpha
                case 8:
                    col.rgb = col.a;
                    col.a = 1;
                    break;
                    // rgb
                case 7:
                    col.a = 1;
                    break;
                }
                
                return col;
            }
            ENDHLSL
        }
    }
}
