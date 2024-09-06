Shader "ZengDebug/PolybushTextures"
{
    Properties
    {
        _GridSizeX("Grid Size x", Integer) = 64
        _GridSizeZ("Grid Size z", Integer) = 32
        _MainTex ("Texture", 2D) = "white" {}
        _Texture0 ("Texture 0", 2D) = "white" {}
        _Texture1 ("Texture 1", 2D) = "white" {}
        _Texture2 ("Texture 2", 2D) = "white" {}
        _Texture3 ("Texture 3", 2D) = "white" {}
        _Texture4 ("Texture 4", 2D) = "white" {}
        _Texture5 ("Texture 5", 2D) = "white" {}
        _Texture6 ("Texture 6", 2D) = "white" {}
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
                int _GridSizeX;
                int _GridSizeZ;
            CBUFFER_END

            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_ST; float4  _MainTex_TexelSize;
            TEXTURE2D(_Texture1); float4 _Texture1_ST; float4  _Texture1_TexelSize;
            TEXTURE2D(_Texture2); float4 _Texture2_ST; float4  _Texture2_TexelSize;
            TEXTURE2D(_Texture3); float4 _Texture3_ST; float4  _Texture3_TexelSize;
            TEXTURE2D(_Texture4); float4 _Texture4_ST; float4  _Texture4_TexelSize;
            TEXTURE2D(_Texture5); float4 _Texture5_ST; float4  _Texture5_TexelSize;
            TEXTURE2D(_Texture6); float4 _Texture6_ST; float4  _Texture6_TexelSize;

            

            struct Attributes
            {
                float4 positionOS : POSITION;
                float4 color : COLOR;
                float2 uv : TEXCOORD0;
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD0;
                float2 uv3 : TEXCOORD0;
                float2 uv4 : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 color : COLOR;
                float2 positionOSXZ : TEXCOORD0;

                float2 uv : TEXCOORD1;

                float4 uv1 : TEXCOORD2;
                float4 uv2 : TEXCOORD3;
            };

            


            Varyings UnitPassVertex (Attributes input)
            {
                Varyings output = (Varyings)0;
                
                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);
                output.positionCS = vertexInput.positionCS;
                output.positionOSXZ = input.positionOS.xz;
                output.color = input.color;


                output.uv = input.uv;

                output.uv1 = float4(input.uv1, input.uv2);
                output.uv2 = float4(input.uv3, input.uv4);

                // TRANSFORM_TEX()

                
                return output;
            }



            #define SAMPLE_TITLE_TEXTURE(Index, sampler, uv) SAMPLE_TEXTURE2D(_Texture##Index, sampler, uv)
            #define BLEND_TITLE_TEXTURE(color, Index, sampler, uv) \
                half4 texel = SAMPLE_TITLE_TEXTURE(Index, sampler, uv); \
                color = lerp(color, texel, texel.a);\

            #define GET_TEXTURE_SIZE(name) name##_TexelSize

            

            half4 UnitPassFragment (Varyings input) : SV_Target
            {
                half4 col = half4(0,0,0,1);

                // BLEND_TITLE_TEXTURE(col, 1, sampler_MainTex, input.uv);
                // BLEND_TITLE_TEXTURE(col, 2, sampler_MainTex, input.uv);


                float2 gridSize = float2(_GridSizeX, _GridSizeZ);
                float2 uv = frac(input.positionOSXZ + gridSize * 0.5);

                gridSize = float2(1,1);
                
                half4 base = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, float2(0, 1) - uv * _MainTex_ST.xy * gridSize + _MainTex_ST.zw) ;
                half4 tex1= SAMPLE_TEXTURE2D(_Texture1, sampler_MainTex, float2(0, 1) - uv * _Texture1_ST.xy * gridSize + _Texture1_ST.zw) * input.uv1.y;
                half4 tex2= SAMPLE_TEXTURE2D(_Texture2, sampler_MainTex, float2(0, 1) - uv * _Texture2_ST.xy * gridSize + _Texture2_ST.zw) * input.uv1.z;
                half4 tex3= SAMPLE_TEXTURE2D(_Texture3, sampler_MainTex, float2(0, 1) - uv * _Texture3_ST.xy * gridSize + _Texture3_ST.zw) * input.uv1.w;
                half4 tex4= SAMPLE_TEXTURE2D(_Texture4, sampler_MainTex, float2(0, 1) - uv * _Texture4_ST.xy * gridSize + _Texture4_ST.zw) * input.uv2.x;
                half4 tex5= SAMPLE_TEXTURE2D(_Texture5, sampler_MainTex, float2(0, 1) - uv * _Texture5_ST.xy * gridSize  + _Texture5_ST.zw) * input.uv2.y;
                half4 tex6= SAMPLE_TEXTURE2D(_Texture6, sampler_MainTex, float2(0, 1) - uv * _Texture6_ST.xy * gridSize  + _Texture6_ST.zw)* input.uv2.z;

                col = base;
                col = lerp(col, tex1, input.uv1.y);
                col = lerp(col, tex2, input.uv1.z);
                col = lerp(col, tex3, input.uv1.w);
                col = lerp(col, tex4, input.uv2.x);
                col = lerp(col, tex5, input.uv2.y);
                col = lerp(col, tex6, input.uv2.z);
                col.a = 1;


                
                return col;
            }
            ENDHLSL
        }
    }
}
