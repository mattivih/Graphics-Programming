Shader "Metropolia/Dissolve"
{
	Properties
	{
		_NoiseMap("Noise map", 2D) = "white" {}
		_NoiseMask("Noise mask", 2D) = "white" {}
		_DissolveStrength("Dissolve Strength", Float) = 1
	}

	Subshader
	{
		Tags {"Queue" = "Transparent"}

		GrabPass
		{

		}

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment fragment
			#include "UnityCG.cginc"

			struct vertexData
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct fragmentData
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float2 screenuv : TEXCOORD1;
			};

			sampler2D _NoiseMap;
			sampler2D _NoiseMask;
			sampler2D _GrabTexture;
			float _DissolveStrength;

			fragmentData vert(vertexData v)
			{
				fragmentData o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				float4 grabPos = ComputeGrabScreenPos(o.vertex);
				o.screenuv = grabPos.xy / grabPos.w;
				return o;
			}

			fixed4 fragment (fragmentData i) : SV_Target
			{
				float n = tex2D(_NoiseMap, i.uv);
				float m = tex2D(_NoiseMask, i.uv);
				float2 suv = i.screenuv + (2 * n - 1) * _DissolveStrength * m;
				return tex2D(_GrabTexture, suv);
			}

			ENDCG
		}
	}
}	