// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Metropolia/Diffuse"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags {"RenderType" = "Opaque"}

		Pass
		{
			CGPROGRAM
		
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv: TEXCOORD0;
			};

			struct vertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv: TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			float4 frag(vertexOutput i) : SV_Target
			{
				float4 c = tex2D(_MainTex, i.uv);
				float d = dot(i.normal, -_WorldSpaceLightPos0);
				return c * d;
			}
			ENDCG
		}
	}
}
