Shader "ZengDebug/VertexColor"
{
    Properties
    {
        [Enum(Zeng.DebugShaders.ShowColorAxis)] _ShowAxis("显示分量", Int) = 15
    }
    
    
    SubShader
    {
        Tags
        {
            // 渲染管线标签， [UniversalPipeline, HighDefinitionRenderPipeline, 自定义管线]
            "RenderPipeline" = "UniversalPipeline"
            
             // 队列标签， [Background, Geometry, AlphaTest, Transparent, Overlay, 正数]
            "Queue" = "Transparent"
            
            // 渲染类型标签， [Opaque, Transparent, Cutout, Fade, Overlay,TreeOpaque, TreeTransparentCutout, TreeBillboard, Grass, GrassBillboard]
            "RenderType"="Transparent" 
        }
        LOD 100
        Blend SrcAlpha OneMinusSrcAlpha 

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
                int _ShowAxis;
            CBUFFER_END

            struct Attributes
            {
                float4 positionOS : POSITION;
                float4 color : COLOR;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 color : COLOR;
            };


            Varyings UnitPassVertex (Attributes input)
            {
                Varyings output = (Varyings)0;
                
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.color = input.color;
                
                return output;
            }

            half4 UnitPassFragment (Varyings input) : SV_Target
            {
                half4 col = half4(0,0,0,1);

                switch (_ShowAxis)
                {
                    // R
                case 1:
                    col.r = input.color.r;
                    break;
                    // G
                case 2:
                    col.g = input.color.g;
                    break;
                    // B
                case 4:
                    col.b = input.color.b;
                    break;
                    // alpha
                case 8:
                    col.rgb = input.color.a;
                    break;
                    // rgb
                case 7:
                    col.rgb = input.color.rgb;
                    break;
                    // rgba
                case 15:
                    col = input.color;
                    break;
                }
                
                return col;
            }
            ENDHLSL
        }
    }
}
