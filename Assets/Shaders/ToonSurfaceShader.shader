Shader "Custom/ToonSurfaceShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Outline("Outline Width", Range(0.0, 0.1)) = .003
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		Cull Front
		CGPROGRAM
		#pragma surface surf Standard vertex:OutlineVert
		#pragma target 3.0

		float _Outline;

		void OutlineVert(inout appdata_full v)
		{
			v.vertex.xyz += v.normal * _Outline;
		}

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {}
		ENDCG

		Cull Back
		CGPROGRAM
		#pragma surface surf Toon fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input
		{
			float2 uv_MainTex;
			float3 viewDir;
		};

		half4 LightingToon(SurfaceOutput s, half3 lightDir, half atten) {
			half d = dot(s.Normal, lightDir) * 0.5 + 0.5;
			half4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * atten * step(0.5, d);
			c.a = s.Alpha;
			return c;
		}

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
