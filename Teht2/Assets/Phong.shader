Shader "Metropolia/Phong"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_SpecTex("SpecTexture", 2D) = "white" {}
		_SpecColor("Specular Color", Color) = (1,1,1,1)
		_Shininess("Shininess", Float) = 10
	}

	SubShader
	{
		Tags {"LightMode" = "ForwardAdd"}

		Pass
		{
			CGPROGRAM
		
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

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
				float4 wsVertex : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _SpecTex;
			float4 _MainTex_ST;
			float _Shininess;
			float4 _SpecColor;

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.wsVertex = mul(unity_WorldToObject, v.vertex);
				return o;
			}

			float4 frag(vertexOutput i) : SV_Target
			{
				float4 c = tex2D(_MainTex, i.uv);
				float4 sc = tex2D(_SpecTex, i.uv);

				float3 l = normalize(_WorldSpaceLightPos0.xyz - i.wsVertex.xyz);
				float3 v = normalize(_WorldSpaceCameraPos - i.wsVertex.xyz);

				float NdotL = max(0.0, dot(i.normal, l));
				float3 d = NdotL * c;
				float3 r = reflect(-l, i.normal);
				float RdotV = max(0.0, dot(r, v));
				
				float s = 0.0;
				
				if(dot(i.normal, l) > 0.0)
						s = pow(RdotV, _Shininess);

				return float4(d + sc * s, 1.0);
			}

			ENDCG
		}
	}
}
