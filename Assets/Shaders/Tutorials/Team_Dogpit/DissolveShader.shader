Shader "Custom/DissolveShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DissolveTex("Dissolve Texture", 2D) = "white" {}
		_DissolveThreshold("Dissolve Threshold", Range(0, 1)) = 0
		_DissolveLine("Dissolve Line", Range(0,0.2)) = 0.1
		[HDR]_DissolveLineColor("Dissolve Line Color", Color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _DissolveTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		fixed4 _Color;
		half _DissolveThreshold;
	    half _DissolveLine;
    	half3 _DissolveLineColor;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			half4 noise = tex2D(_DissolveTex, IN.uv_MainTex);
			clip(noise.r - _DissolveThreshold);
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Emission += step(noise.r, _DissolveThreshold + _DissolveLine) * _DissolveLineColor;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
