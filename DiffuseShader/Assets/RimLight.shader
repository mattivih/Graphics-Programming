Shader "Metropolia/RimLight"
{
	Properties
	{
		_RimPower("Rim Power", Float) = 3.0
		_RimBoost("Rim Boost", Float) = 1.0
		_RimColor("Rim Color", Float) = (1, 0, 0, 1)
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}

		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			#include "UnityCG.cginc"

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 wPos : TEXCOORD0;
				float3 normal : NORMAL;
			};

			float _RimPower;
			float _RimBoost;
			float _RimColor;

			vertexOutput vert (vertexInput v)
			{
				vertexOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}
			
			float4 frag(vertexOutput i) : SV_Target
			{
				float3 viewDirection = normalize(_WorldSpaceCameraPos - i.wPos.xyz);
				float d = dot(i.normal, -_WorldSpaceLightPos0);
				float r = pow(1.0 - saturate(dot(i.normal, viewDirection)), _RimPower);
				return float4(0.3, 0.2, 0.1, 1.0) * d + r * _RimPower * _RimBoost;
			}
			
			ENDCG
		}
	}
}
