Shader "ZengDebug/VertexLambert"
{
    Properties
    {
        [Toggle] _HalfValue("Value * 0.5 + 0.5", Int) = 1
        [NoScaleOffset] _BumpMap("Normal Map", 2D) = "bump" {}
        [Toggle] _UseNormalMap("Use Normal Map", Int) = 0
        [Toggle] _UVUsePositionOSXZ("UV Use PositionOSXZ", Int) = 0
        _UVUsePositionOSXZSizeOffset("UV Use PositionOSXZ Size Offset", Vector) = (64,32,32,16)
        
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
                int _HalfValue;
                int _UseNormalMap;
                int _UVUsePositionOSXZ;
                float4 _UVUsePositionOSXZSizeOffset;
            CBUFFER_END
            TEXTURE2D(_BumpMap); SAMPLER(sampler_BumpMap);

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalOS : TEXCOORD0;
                float3 normalWS : TEXCOORD1;
                float3 positionOS : TEXCOORD2;
                float2 uv : TEXCOORD3;
            };


            Varyings UnitPassVertex (Attributes input)
            {
                Varyings output = (Varyings)0;
                
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.positionOS = input.positionOS.xyz;
                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS);
                output.normalOS = input.normalOS;
                output.normalWS = normalInput.normalWS;
                output.uv = input.uv;
                
                return output;
            }

            half4 UnitPassFragment (Varyings input) : SV_Target
            {
                half4 col = half4(0,0,0,1);

                float3 worldNormal = normalize(input.normalWS);
                half3 lightDirection = half3(_MainLightPosition.xyz);

                
                half4 n = SAMPLE_TEXTURE2D(_BumpMap, sampler_BumpMap, lerp(input.uv, (input.positionOS.xz + _UVUsePositionOSXZSizeOffset.zw) / _UVUsePositionOSXZSizeOffset.xy, _UVUsePositionOSXZ));
                float3 normalTS =  UnpackNormal(n);
                float3 normal = lerp(worldNormal, normalTS, _UseNormalMap);
                
                float lambert = dot(normal, lightDirection) ;
                col.rgb =  lambert;
                
                if(_HalfValue == 1)
                {
                    col.rgb = col.rgb * 0.5 + 0.5;
                }

                
                return col;
            }
            ENDHLSL
        }
    }
}
