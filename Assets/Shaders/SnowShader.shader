Shader "Custom/SnowShader"
{
    Properties
    {
        _SnowTex ("Snow Texture", 2D) = "white" {}
        _SnowBump ("Snow Normal", 2D) = "bump" {}
        _MainTex ("Main Texture", 2D) = "white" {}
        _MainNormal ("Main Normal", 2D) = "bump" {}
        _SnowMult ("Snow Density", Range(0, 1)) = 1
        _SnowDirection("Snow Direction", Vector) = (0, 1, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _SnowTex;
        sampler2D _MainNormal;
        sampler2D _SnowNormal;
        float _SnowMult;
        float3 _SnowDirection;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SnowTex;
            float3 worldNormal; INTERNAL_DATA
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {

            half d = dot(WorldNormalVector(IN, o.Normal), normalize(_SnowDirection));
            d = max(d, 0);
            fixed3 mainColor = tex2D (_MainTex, IN.uv_MainTex).rgb;
            fixed3 snowColor = tex2D (_SnowTex, IN.uv_SnowTex).rgb;
            o.Albedo = lerp(mainColor, snowColor, d * _SnowMult);

            fixed3 mainNormal = UnpackNormal(tex2D (_MainNormal, IN.uv_MainTex));
            fixed3 snowNormal = UnpackNormal(tex2D (_SnowNormal, IN.uv_SnowTex));
            o.Normal = lerp(mainNormal, snowNormal, d * _SnowMult);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
