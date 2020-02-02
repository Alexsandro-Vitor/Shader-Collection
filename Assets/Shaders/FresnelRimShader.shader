Shader "Custom/FresnelRimShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "black" {}
        _RimColor ("Rim Color", Color) = (1,1,1,1)
        _RimPower ("Rim Fill", Range(0, 2)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
        };

        half4 _Color;
        half4 _RimColor;
        half _RimPower;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
            half d = 1 - pow(dot(o.Normal, IN.viewDir), _RimPower);
            o.Emission += _RimColor * d;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
