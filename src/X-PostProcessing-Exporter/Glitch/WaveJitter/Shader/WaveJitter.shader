
//----------------------------------------------------------------------------------------------------------
// X-PostProcessing Library
// https://github.com/QianMo/X-PostProcessing-Library
// Copyright (C) 2020 QianMo. All rights reserved.
// Licensed under the MIT License 
// You may not use this file except in compliance with the License.You may obtain a copy of the License at
// http://opensource.org/licenses/MIT
//----------------------------------------------------------------------------------------------------------

// reference : https://www.shadertoy.com/view/4d2Xzw

Shader "Pi/ImageEffect/WaveJitter"
{
	Properties
	{
		// Base Params
		_MainTex("Texture", 2D) = "white" {}

		// Own Params
		_RGBSplit("RGBSplit", Float) = 0.0
		_Frequency("Frequency", Int) = 0
		_Speed("Speed", Float) = 0.0
		_Amount("Amount", Int) = 0
		_Progress("Progress", Float) = 0.0
		_TexWidth("TexWidth", Float) = 0.0
		_TexHeight("TexHeight", Float) = 0.0
		_CustomTime("CustomTime", Float) = 0.0

		// Iris Area Params
		_IrisAreaActive("ActiveIrisArea", Int) = 0
		_IrisAreaSize("IrisAreaSize", Range(0.0, 2.0)) = 0.2
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

				float _RGBSplit;
				int _Frequency;
				float _Speed;
				int _Amount;

				float _Progress;
				float _CustomTime;

				float _TexWidth;
				float _TexHeight;

				int _IrisAreaActive;
				float _IrisAreaSize;
				float _IrisCenterOffsetX;
				float _IrisCenterOffsetY;

				float NOISE_SIMPLEX_1_DIV_289 = 0.00346020761245674;

				float IrisMask(float2 uv)
				{
					if (_IrisAreaActive == 1) {
						float2 center = uv * 2.0 - 1.0 - float2(_IrisCenterOffsetX, _IrisCenterOffsetY); // [0,1] -> [-1,1] 

						return saturate(abs(length(center)) - _IrisAreaSize);
					}
					else {
						return 1.0;
					}
					//return dot(center, center) * _AreaSize;
				}


				float mod289(float x)
				{
					return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
				}

				float2 mod289(float2 x)
				{
					return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
				}

				float3 mod289(float3 x)
				{
					return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
				}

				float4 mod289(float4 x)
				{
					return x - floor(x * NOISE_SIMPLEX_1_DIV_289) * 289.0;
				}
				float3 taylorInvSqrt(float3 r)
				{
					return 1.79284291400159 - 0.85373472095314 * r;
				}

				float4 taylorInvSqrt(float4 r)
				{
					return 1.79284291400159 - r * 0.85373472095314;
				}
				// ( x*34.0 + 1.0 )*x =x*x*34.0 + x
				float permute(float x)
				{
					return mod289(x * x * 34.0 + x);
				}

				float3 permute(float3 x)
				{
					return mod289(x * x * 34.0 + x);
				}

				float4 permute(float4 x)
				{
					return mod289(x * x * 34.0 + x);
				}
				float snoise(float2 v)
				{
					const float4 C = float4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
						0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
						-0.577350269189626, // -1.0 + 2.0 * C.x
						0.024390243902439); // 1.0 / 41.0
						// First corner
					float2 i = floor(v + dot(v, C.yy));
					float2 x0 = v - i + dot(i, C.xx);

					// Other corners
					float2 i1;
					i1.x = step(x0.y, x0.x);
					i1.y = 1.0 - i1.x;

					// x1 = x0 - i1  + 1.0 * C.xx;
					// x2 = x0 - 1.0 + 2.0 * C.xx;
					float2 x1 = x0 + C.xx - i1;
					float2 x2 = x0 + C.zz;

					// Permutations
					i = mod289(i); // Avoid truncation effects in permutation
					float3 p = permute(permute(i.y + float3(0.0, i1.y, 1.0))
						+ i.x + float3(0.0, i1.x, 1.0));

					float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0);
					m = m * m;
					m = m * m;

					// Gradients: 41 points uniformly over a line, mapped onto a diamond.
					// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
					float3 x = 2.0 * frac(p * C.www) - 1.0;
					float3 h = abs(x) - 0.5;
					float3 ox = floor(x + 0.5);
					float3 a0 = x - ox;

					// Normalise gradients implicitly by scaling m
					m *= taylorInvSqrt(a0 * a0 + h * h);

					// Compute final noise value at P
					float3 g;
					g.x = a0.x * x0.x + h.x * x0.y;
					g.y = a0.y * x1.x + h.y * x1.y;
					g.z = a0.z * x2.x + h.z * x2.y;
					return 130.0 * dot(m, g);
				}

				half4 Frag_Horizontal(v2f i)
				{
					float strength = 0.0;

					strength = 0.5 + 0.5 * cos(_CustomTime * _Frequency);

					// Prepare UV
					float uv_y = i.uv.y * _TexHeight;
					float2 param1 = float2(uv_y * 0.01, _CustomTime * _Speed * 20.0);
					float2 param2 = float2(uv_y * 0.02, _CustomTime * _Speed * 10.0);
					float noise_wave_1 = snoise(param1) * (strength * _Amount * 32.0);
					float noise_wave_2 = snoise(param2) * (strength * _Amount * 4.0);
					float noise_wave_x = noise_wave_1 * noise_wave_2 / _TexWidth;
					float uv_x = i.uv.x + noise_wave_x;

					float rgbSplit_uv_x = (_RGBSplit * 50.0 + (20.0 * strength + 1.0)) * noise_wave_x / _TexWidth;

					// Sample RGB Color
					half4 colorG = tex2D(_MainTex, float2(uv_x, i.uv.y));
					half4 colorRB = tex2D(_MainTex, float2(uv_x + rgbSplit_uv_x, i.uv.y));

					return half4(colorRB.r, colorG.g, colorRB.b, colorRB.a + colorG.a);
				}

				// tex2D(_MainTex, i.uv);


				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					return Frag_Horizontal(i);
				}
				ENDCG
			}
		}
}


