Shader "Custom/ViewBlendShader"
{
	Properties
	{
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_LeftColor ("Left Color", Color) = (1,1,1,1)
		_LeftTex ("Left Tex", 2D) = "black" {}
		_CenterColor ("Center Color", Color) = (1,1,1,1)
		_CenterTex ("Center Tex", 2D) = "black" {}
		_RightColor ("Right Color", Color) = (1,1,1,1)
		_RightTex ("Right Tex", 2D) = "black" {}
		_TexSmooth("Tex Blend Smooth", Range(0, 1)) = 0.5
		_ColorSmooth("Color Blend Smooth", Range(0, 1)) = 0.5
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex, _LeftTex, _CenterTex, _RightTex;
		half4 _Color, _LeftColor, _CenterColor, _RightColor;
		half _TexSmooth, _ColorSmooth;

		struct Input
		{
			float2 uv_MainTex;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutputStandard o)
		{
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb * _Color;

			half dotLeft = dot(IN.viewDir, float3(1, 0, 0));
			half dotRight = dot(IN.viewDir, float3(-1, 0, 0));

			half colDotLeft = smoothstep(0, _ColorSmooth, smoothstep(0.5, 1, dotLeft));
			half colDotRight = smoothstep(0, _ColorSmooth, smoothstep(0.5, 1, dotRight));
			half colDotCenter = min((1 - colDotLeft), (1 - colDotRight));
			colDotLeft = max(0, colDotLeft - colDotCenter);
			colDotRight = max(0, colDotRight - colDotCenter);
			half3 colorMix = lerp(
				lerp(
					lerp(half3(1, 1, 1), _CenterColor, colDotCenter), 
					_LeftColor,
					colDotLeft
				),
				_RightColor,
				colDotRight
			);
			o.Albedo *= colorMix;

			half4 texCenter = tex2D(_CenterTex, IN.uv_MainTex);
			half4 texLeft = tex2D(_LeftTex, IN.uv_MainTex);
			half4 texRight = tex2D(_RightTex, IN.uv_MainTex);
			half texDotLeft = smoothstep(0, _TexSmooth, smoothstep(0.5, 1, dotLeft));
			half texDotRight = smoothstep(0, _TexSmooth, smoothstep(0.5, 1, dotRight));
			half texDotCenter = min((1 - texDotLeft), (1 - texDotRight));
			texDotLeft = max(0, texDotLeft - texDotCenter);
			texDotRight = max(0, texDotRight - texDotCenter);
			half3 texMix = lerp(
				lerp(
					lerp(half3(0, 0, 0), texCenter.rgb, texDotCenter * texCenter.a),
					texLeft.rgb,
					texDotLeft * texLeft.a
				),
				texRight,
				texDotRight * texRight.a
			);
			o.Emission += texMix;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
