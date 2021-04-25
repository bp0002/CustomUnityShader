
//----------------------------------------------------------------------------------------------------------
// baipeng
//----------------------------------------------------------------------------------------------------------


Shader "Pi/ImageEffect/RadialWave"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		_WaveStartRadial("WaveStartRadial", Range(0.0, 8.0)) = 0.0
		_WaveEndRadial("WaveEndRadial", Range(0.0, 8.0)) = 0.0
		_WaveWidth("WaveWidth", Range(0.0, 2.0)) = 1.0
		_WaveCount("WaveCount", Range(0.0, 64.0)) = 1.0
		_WaveScreenWidth("WaveScreenWidth", Float) = 1.0
		_WaveScreenHeight("WaveScreenHeight", Float) = 1.0

		_BlurRadius("BlurRadius", Float) = 1.0
		_Iteration("Iteration", Range(8, 64)) = 16

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
				int _Iteration;
				float _BlurRadius;
				
				float _WaveStartRadial;
				float _WaveEndRadial;
				float _WaveWidth;
				float _WaveCount;

				float _WaveScreenWidth;
				float _WaveScreenHeight;

				int _IrisAreaActive;
				float _IrisAreaSize;
				float _IrisCenterOffsetX;
				float _IrisCenterOffsetY;

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

				// tex2D(_MainTex, i.uv + (r - 1.0) * angle);

				half4 IrisBlur(float2 uv, float mask)
				{
					half2x2 rot = half2x2(-0.7373688782616119, 0.675490294061441, -0.675490294061441, -0.7373688782616119);
					half4 accumulator = 0.0;
					half4 divisor = 0.0;

					half r = 1.0;
					half2 angle = half2(0.0, _BlurRadius * mask);

					for (int j = 0; j < _Iteration; j++)
					{
						r += 1.0 / r;
						angle = mul(rot, angle);

						half4 bokeh = tex2D(_MainTex, uv + (r - 1.0) * angle);

						accumulator += bokeh * bokeh;
						divisor += bokeh;
					}
					return accumulator / divisor;
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
					float2 uv = i.uv;
					float2 wave_uv = i.uv;
					float mask = IrisMask(uv);

					float2 center = wave_uv * 2.0 - 1.0 - float2(_IrisCenterOffsetX, _IrisCenterOffsetY); // [0,1] -> [-1,1] 

					center.y *= _WaveScreenHeight / _WaveScreenWidth;
					float diff = abs(length(center));

					float alpha = diff;

					diff = diff < _WaveStartRadial ? 0.0 : (diff > _WaveEndRadial ? 0.0 : diff - _WaveStartRadial);
					diff = diff / (_WaveEndRadial - _WaveStartRadial);
					diff = diff * _WaveCount;
					diff = sin(diff * 3.141592653589793) * _WaveWidth * (1.0 - alpha);

					uv += diff;

					return IrisBlur(uv, mask);
				}
				ENDCG
			}
		}
}


