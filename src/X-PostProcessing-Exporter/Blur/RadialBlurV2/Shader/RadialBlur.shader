
//----------------------------------------------------------------------------------------------------------
// X-PostProcessing Library
// https://github.com/QianMo/X-PostProcessing-Library
// Copyright (C) 2020 QianMo. All rights reserved.
// Licensed under the MIT License 
// You may not use this file except in compliance with the License.You may obtain a copy of the License at
// http://opensource.org/licenses/MIT
//----------------------------------------------------------------------------------------------------------

// reference : https://www.shadertoy.com/view/4d2Xzw

Shader "Pi/ImageEffect/RadialBlur"
{
	Properties
	{
		// Base Params
		_MainTex("Texture", 2D) = "white" {}
		_BlurRadius("BlurRadius", Float) = 1.0
		_Iteration("Iteration", Range(8, 64)) = 16

		// Own Params
		_CenterX("CenterX", Range(0.0, 1.0)) = 0.5
		_CenterY("CenterY", Range(0.0, 1.0)) = 0.5

		// Iris Area Params
		_IrisAreaActive("ActiveIrisArea", Int) = 0
		_IrisAreaSize("IrisAreaSize", Range(0.0, 2.0)) = 0.2
		_IrisAreaTransition("IrisAreaTransition", Range(0.0, 2.0)) = 0.2
		_IrisCenterOffsetX("IrisCenterOffsetX", Range(-1.0, 1.0)) = 0.0
		_IrisCenterOffsetY("IrisCenterOffsetY", Range(-1.0, 1.0)) = 0.0
	}


		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				int _Iteration;
				float _BlurRadius;

				float _CenterX;
				float _CenterY;

				int _IrisAreaActive;
				float _IrisAreaSize;
				float _IrisCenterOffsetX;
				float _IrisCenterOffsetY;
				float _IrisAreaTransition;

				// tex2D(_MainTex, i.uv + (r - 1.0) * angle);

				float IrisMask(float2 uv)
				{
					if (_IrisAreaActive == 1) {
						float2 center = uv * 2.0 - 1.0 - float2(_IrisCenterOffsetX, _IrisCenterOffsetY); // [0,1] -> [-1,1] 

						return saturate(saturate(abs(length(center)) - _IrisAreaSize) / _IrisAreaTransition);
					}
					else
					{
						return 1.0;
					}
					//return dot(center, center) * _AreaSize;
				}

				half4 RadialBlur(v2f i)
				{
					float2 _RadialCenter = float2(_CenterX, _CenterY);

					float2 blurVector = (_RadialCenter - i.uv.xy) * _BlurRadius * IrisMask(i.uv);

					half4 acumulateColor = half4(0, 0, 0, 0);

					for (int j = 0; j < _Iteration; j++)
					{
						acumulateColor += tex2D(_MainTex, i.uv.xy);
						i.uv.xy += blurVector;
					}

					return acumulateColor / _Iteration;
				}


				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					return RadialBlur(i);
				}
				ENDCG
			}
		}
}


