
//----------------------------------------------------------------------------------------------------------
// X-PostProcessing Library
// https://github.com/QianMo/X-PostProcessing-Library
// Copyright (C) 2020 QianMo. All rights reserved.
// Licensed under the MIT License 
// You may not use this file except in compliance with the License.You may obtain a copy of the License at
// http://opensource.org/licenses/MIT
//----------------------------------------------------------------------------------------------------------

// reference : https://www.shadertoy.com/view/4d2Xzw

Shader "Pi/ImageEffect/GaussianBlur"
{
	Properties
	{
		// Base Params
		_MainTex("Texture", 2D) = "white" {}

		// Own Params
		_DeltaX("DeltaX", Float) = 0.0
		_DeltaY("DeltaY", Float) = 0.0

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

				#define KERNEL_OFFSET0 -15.36704337
				#define KERNEL_WEIGHT0 0.00226838
				#define KERNEL_OFFSET1 15.36704337
				#define KERNEL_WEIGHT1 0.00226838
				#define KERNEL_OFFSET2 -13.38352585
				#define KERNEL_WEIGHT2 0.00623279
				#define KERNEL_OFFSET3 13.38352585
				#define KERNEL_WEIGHT3 0.00623279
				#define KERNEL_OFFSET4 -11.40028041
				#define KERNEL_WEIGHT4 0.01489653
				#define KERNEL_OFFSET5 11.40028041
				#define KERNEL_WEIGHT5 0.01489653
				#define KERNEL_OFFSET6 -9.41727148
				#define KERNEL_WEIGHT6 0.03096924
				#define KERNEL_OFFSET7 9.41727148
				#define KERNEL_WEIGHT7 0.03096924
				#define KERNEL_OFFSET8 -7.4344613
				#define KERNEL_WEIGHT8 0.05600478
				#define KERNEL_OFFSET9 7.4344613
				#define KERNEL_WEIGHT9 0.05600478
				#define KERNEL_OFFSET10 -5.45181021
				#define KERNEL_WEIGHT10 0.08809971
				#define KERNEL_OFFSET11 5.45181021
				#define KERNEL_WEIGHT11 0.08809971
				#define KERNEL_OFFSET12 -3.46927703
				#define KERNEL_WEIGHT12 0.12055435
				#define KERNEL_OFFSET13 3.46927703
				#define KERNEL_WEIGHT13 0.12055435
				#define KERNEL_OFFSET14 -1.48681946
				#define KERNEL_WEIGHT14 0.14350044
				#define KERNEL_OFFSET15 1.48681946
				#define KERNEL_WEIGHT15 0.14350044
				#define KERNEL_OFFSET16 0.
				#define KERNEL_WEIGHT16 0.07494756

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

				float _DeltaX;
				float _DeltaY;

				int _IrisAreaActive;
				float _IrisAreaSize;
				float _IrisCenterOffsetX;
				float _IrisCenterOffsetY;
				float _IrisAreaTransition;

				// tex2D(_MainTex, i.uv);

				float IrisMask(float2 uv)
				{
					if (_IrisAreaActive == 1) {
						float2 center = uv * 2.0 - 1.0 - float2(_IrisCenterOffsetX, _IrisCenterOffsetY); // [0,1] -> [-1,1] 

						return saturate(saturate(abs(length(center)) - _IrisAreaSize) / _IrisAreaTransition);
					}
					else {
						return 1.0;
					}
					//return dot(center, center) * _AreaSize;
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
					float2 sampleCenter = i.uv.xy;
					float2 delta = float2(_DeltaX, _DeltaY);

					float2 sampleCoord0 = sampleCenter + delta * KERNEL_OFFSET0 * IrisMask(i.uv);
					float2 sampleCoord1 = sampleCenter + delta * KERNEL_OFFSET1 * IrisMask(i.uv);
					float2 sampleCoord2 = sampleCenter + delta * KERNEL_OFFSET2 * IrisMask(i.uv);
					float2 sampleCoord3 = sampleCenter + delta * KERNEL_OFFSET3 * IrisMask(i.uv);
					float2 sampleCoord4 = sampleCenter + delta * KERNEL_OFFSET4 * IrisMask(i.uv);
					float2 sampleCoord5 = sampleCenter + delta * KERNEL_OFFSET5 * IrisMask(i.uv);
					float2 sampleCoord6 = sampleCenter + delta * KERNEL_OFFSET6 * IrisMask(i.uv);
					float2 sampleCoord7 = sampleCenter + delta * KERNEL_OFFSET7 * IrisMask(i.uv);
					float2 sampleCoord8 = sampleCenter + delta * KERNEL_OFFSET8 * IrisMask(i.uv);
					float2 sampleCoord9 = sampleCenter + delta * KERNEL_OFFSET9 * IrisMask(i.uv);
					float2 sampleCoord10 = sampleCenter + delta * KERNEL_OFFSET10 * IrisMask(i.uv);
					float2 sampleCoord11 = sampleCenter + delta * KERNEL_OFFSET11 * IrisMask(i.uv);
					float2 sampleCoord12 = sampleCenter + delta * KERNEL_OFFSET12 * IrisMask(i.uv);
					float2 sampleCoord13 = sampleCenter + delta * KERNEL_OFFSET13 * IrisMask(i.uv);
					float2 sampleCoord14 = sampleCenter + delta * KERNEL_OFFSET14 * IrisMask(i.uv);
					float2 sampleCoord15 = sampleCenter + delta * KERNEL_OFFSET15 * IrisMask(i.uv);
					float2 sampleCoord16 = sampleCenter + delta * KERNEL_OFFSET16 * IrisMask(i.uv);

					float computedWeight = 0.0;
					half4 blend = half4(0., 0., 0., 0.);

					computedWeight = KERNEL_WEIGHT0;
					blend += tex2D(_MainTex, sampleCoord0) * computedWeight;
					computedWeight = KERNEL_WEIGHT1;
					blend += tex2D(_MainTex, sampleCoord1) * computedWeight;
					computedWeight = KERNEL_WEIGHT2;
					blend += tex2D(_MainTex, sampleCoord2) * computedWeight;
					computedWeight = KERNEL_WEIGHT3;
					blend += tex2D(_MainTex, sampleCoord3) * computedWeight;
					computedWeight = KERNEL_WEIGHT4;
					blend += tex2D(_MainTex, sampleCoord4) * computedWeight;
					computedWeight = KERNEL_WEIGHT5;
					blend += tex2D(_MainTex, sampleCoord5) * computedWeight;
					computedWeight = KERNEL_WEIGHT6;
					blend += tex2D(_MainTex, sampleCoord6) * computedWeight;
					computedWeight = KERNEL_WEIGHT7;
					blend += tex2D(_MainTex, sampleCoord7) * computedWeight;
					computedWeight = KERNEL_WEIGHT8;
					blend += tex2D(_MainTex, sampleCoord8) * computedWeight;
					computedWeight = KERNEL_WEIGHT9;
					blend += tex2D(_MainTex, sampleCoord9) * computedWeight;
					computedWeight = KERNEL_WEIGHT10;
					blend += tex2D(_MainTex, sampleCoord10) * computedWeight;
					computedWeight = KERNEL_WEIGHT11;
					blend += tex2D(_MainTex, sampleCoord11) * computedWeight;
					computedWeight = KERNEL_WEIGHT12;
					blend += tex2D(_MainTex, sampleCoord12) * computedWeight;
					computedWeight = KERNEL_WEIGHT13;
					blend += tex2D(_MainTex, sampleCoord13) * computedWeight;
					computedWeight = KERNEL_WEIGHT14;
					blend += tex2D(_MainTex, sampleCoord14) * computedWeight;
					computedWeight = KERNEL_WEIGHT15;
					blend += tex2D(_MainTex, sampleCoord15) * computedWeight;
					computedWeight = KERNEL_WEIGHT16;
					blend += tex2D(_MainTex, sampleCoord16) * computedWeight;

					return blend;
				}
				ENDCG
			}
		}
}


