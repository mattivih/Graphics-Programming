Shader "Metropolia/Refraction"
{
	Properties
	{
		_RefractionMap("Refraction Map", Cube) = "" {}
		_IOR("Index of refraction", Float) = 1
	}

	SubShader
	{
		Tags{"RenderType" = "Opaque"}

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			uniform samplerCUBE _RefractionMap;
			uniform float _IOR;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD0;
			};

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = mul(unity_ObjectToWorld, v.vertex).xyz - _WorldSpaceCameraPos;
				return o;
			}

			float4 frag (vertexOutput i) : SV_TARGET
			{
				float3 rv = refract(i.viewDir, i.normal, _IOR);
				float3 c = texCUBE(_RefractionMap, rv);
				return float4(c, 1);
			}

			ENDCG
		}
	}

}
