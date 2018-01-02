Shader "Metropolia/Reflection"
{
	Properties
	{
		_ReflectionMap("Reflection Map", Cube) = "" {}
	}
	
	Subshader
	{
		Tags {"RenderType" = "Opaque"}

		Pass
		{
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			uniform samplerCUBE _ReflectionMap;

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

			float4 frag(vertexOutput i) : SV_Target
			{
				float d = dot(i.normal, -_WorldSpaceLightPos0);
				float3 r = reflect(i.viewDir, normalize(i.normal));
				float3 c = texCUBE(_ReflectionMap, r);
				return float4 (d * c, 1);
			}

			ENDCG
		}
	}
}