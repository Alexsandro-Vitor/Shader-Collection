// Shader which makes an object appear only when covered by another one

Shader "Custom/Own/X Ray" {
	Properties {
		_XRayColor("X Ray Color", Color) = (1,1,1,1)
	}

	SubShader {
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			Stencil {
				Ref 4
				Pass replace
			}
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			struct vertexInput {
				float4 vertex : POSITION;
			};

			struct vertexOutput {
				float4 vertex : SV_POSITION;
			};
			
			vertexOutput vert (vertexInput v) {
				vertexOutput output;
				output.vertex = UnityObjectToClipPos(v.vertex);
				return output;
			}
			
			fixed4 frag (vertexOutput i) : SV_Target {
				return fixed4(0, 0, 0, 0);
			}
			ENDCG
		}

		Pass {
			Cull Back // draw front faces
			ZTest Always
			// Won't draw where it sees ref value 4
			Stencil {
				Ref 4
				Comp NotEqual
			}
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _XRayColor;

			struct vertexInput {
				float4 vertex : POSITION;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
			};

			vertexOutput vert(vertexInput input) {
				vertexOutput output;
				output.pos = UnityObjectToClipPos(input.vertex);
				return output;
			}

			fixed4 frag(vertexOutput input) : COLOR {
				return _XRayColor;
			}
			ENDCG
		}
	}
}