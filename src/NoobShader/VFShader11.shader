// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/// 阴影生成(映射)
Shader "Noob/Vertex Fragment Shaders/Shader11(Warning)" {
	Properties 
	{
		//_MainTex("DiffuseTexture", 2D) = "white" {}

		_BaseColor ("Base Color", Color) = ( 1, 1, 0, 1 )
		_Speed("Speed", Range(0.0, 50.0)) = 1
		_Repeat("Repeat", Range(0.0,50.0)) = 3
		_Bold("Bold", Range(0.0,10.0)) = 4.0

		[Header(AlphaBlendMode)]
		[Enum(UnityEngine.Rendering.BlendOp)]  _BlendOp("BlendOp", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Int) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DstBlend", Int) = 1

		[Header(ZWrite)]
		[Enum(Off, 0, On, 1)]_ZWrite("ZWrite", Int) = 1

		[Header(Cull)]
		[Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Int) = 2

		[Header(ColorMask)]
		[Enum(UnityEngine.Rendering.ColorWriteMask)]_ColorMask("ColorMask", Int) = 15
	}

	/// 着色器可以包含一个或多个 子着色器，主要用于为不同的GPU功能实现着色器
	SubShader 
	{
		Pass {
			Tags {
				"Queue" = "Transparent"
				"IgnoreProjector" = "True"
				"LightMode" = "ForwardBase"
			}

			ZWrite[_ZWrite]

			Blend[_SrcBlend][_DstBlend]
			ColorMask RGB
			Cull[_Cull]

			CGPROGRAM
			#pragma vertex vert alpha
			#pragma fragment frag alpha

			/// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			//sampler2D _MainTex;
			//float4 _MainTex_ST;

			float4 _BaseColor;

			float _Speed;
			float _Repeat;
			float _Bold;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f output;

				//将顶点位置从对象空间转换为所谓的“剪辑空间”
				output.pos = UnityObjectToClipPos(v.vertex);
				output.uv  = v.uv.xy * float2(1.0, 1.0) + float2(0.0, 0.0);
				//output.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return output;
			}

			fixed4 frag(v2f input) : SV_Target
			{
				float rim = length(input.uv - float2(0.5, 0.5));
				float trim = frac((rim - _Time * _Speed) * _Repeat * 2.0);
				float mixAlpha = min(pow(trim, _Bold), 1.0 - (rim * 2.0));
				
				fixed4 mainTexColor = _BaseColor;
				mainTexColor.a = mixAlpha;

				return mainTexColor;
			}

			ENDCG
		}
	}
}
