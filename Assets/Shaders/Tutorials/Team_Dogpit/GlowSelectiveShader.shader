Shader "Custom/Glow Selective"
{
	Properties
	{
		_MainTex ("Albedo (RGB)", 2D) = "black" {}
		_Color ("Color", Color) = (1,1,1,1)
		_EmissionMap ("Emission Map", 2D) = "white" {}
		_EmissionColor1 ("Emission Color 1", Color) = (1,0,0,1)
		_EmissionColor2 ("Emission Color 2", Color) = (0,1,0,1)
		_EmissionColor3 ("Emission Color 3", Color) = (0,0,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _EmissionMap;

		struct Input
		{
			float2 uv_MainTex;
		};
		fixed4 _Color;
		fixed4 _EmissionColor1;
		fixed4 _EmissionColor2;
		fixed4 _EmissionColor3;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			fixed4 emission1 = _EmissionColor1 * tex2D(_EmissionMap, IN.uv_MainTex).r;
			fixed4 emission2 = _EmissionColor2 * tex2D(_EmissionMap, IN.uv_MainTex).g;
			fixed4 emission3 = _EmissionColor3 * tex2D(_EmissionMap, IN.uv_MainTex).b;
			o.Emission = emission1 + emission2 + emission3;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
