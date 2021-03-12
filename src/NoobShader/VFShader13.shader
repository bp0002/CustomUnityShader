// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/// 环形多进度进度条 http://ser.yinengyun.com:8181/docs/front_library/front_library-1cn0v4ch98325
Shader "Noob/Vertex Fragment Shaders/Shader13(CircleProgress)" {
	Properties 
	{
		_MainTex("DiffuseTexture", 2D) = "white" {}

		[Header(Color)]
		_BackGroundColor("BackGround Color", Color) = (0.2, 0.2, 0.2, 1.0)
		_ProgressColor("Progress BackGround Color", Color) = (0.8, 0.8, 0.8, 1.0)
		_Progress1Color("Progress1 Color", Color) = (0.8, 0.1, 0.1, 1.0)
		_Progress2Color("Progress2 Color", Color) = (0.8, 0.8, 0.1, 1.0)

		[Header(Cirle Radius)]
		_C0("Radius 0", Range(0.0,0.5)) = 0.5
		_C1("Radius 1", Range(0.0,0.5)) = 0.46
		_C2("Radius 2", Range(0.0,0.5)) = 0.29
		_C3("Radius 3", Range(0.0,0.5)) = 0.2


		[Header(Progress)]
		_Progress1("Progress1", Range(0.0,1.0)) = 0.5
		_Progress2("Progress2", Range(0.0,1.0)) = 0.5

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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			float4 _BackGroundColor;
			float4 _ProgressColor;
			float4 _Progress1Color;
			float4 _Progress2Color;

			float _C0;
			float _C1;
			float _C2;
			float _C3;

			float _Progress1;
			float _Progress2;

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

				float PI_2 = 6.283185307179586;
				float F_1_4 = 0.25;
				float F_2_4 = 0.50;

				float2 vDiffuseUV = input.uv;
				fixed4 baseColor = float4(1.0, 1.0, 1.0, 1.0);

				float4 v_color_bg	= _BackGroundColor;
				float4 v_color0		= _ProgressColor;
				float4 v_color1		= _Progress1Color;
				float4 v_color2		= _Progress2Color;

				float2 progress = float2(_Progress1 * PI_2, _Progress2 * PI_2);

				progress.y		+= progress.x;
				float2 base_v	= float2(0.0, 1.0);
				float2 diff		= vDiffuseUV - float2(0.5, 0.5);
				float2 dist		= normalize(diff);
				float r			= distance(vDiffuseUV, float2(0.5, 0.5));
				float d			= dot(base_v, dist);
				float angle		= acos(d) * (dist.x > 0.0 ? 1.0 : -1.0);
				angle			= angle + (dist.x > 0.0 ? 0.0 : PI_2);

				float c0 = _C0;
				float c1 = _C1;
				float c2 = _C2;
				float c3 = _C3;

				float s_c0 = smoothstep(c0 - 0.01, c0, r);
				float s_c1 = smoothstep(c1 - 0.01, c1, r);
				float s_c2 = smoothstep(c2 - 0.01, c2, r);
				float s_c3 = smoothstep(c3 - 0.01, c3, r);

				float f_b0 = (1.0 - s_c0) * s_c1 + (1.0 - s_c2) * s_c3;

				float alpha_p = (1.0 - s_c1) * s_c2;

				float f_b1 = alpha_p * ((angle > progress.y) ? 1.0 : 0.0);

				float f_p1 = alpha_p * ((angle < progress.x) ? 1.0 : 0.0);

				float f_p2 = alpha_p * ((angle > progress.x && angle < progress.y) ? 1.0 : 0.0);

				baseColor.rgb = f_b0 * v_color_bg + f_b1 * v_color0 + f_p1 * v_color1 + f_p2 * v_color2;

				baseColor.a = (f_b0 * 0.8 + f_b1 + f_p1 + f_p2) * (1. - s_c0);

				float alpha = baseColor.a;

				return baseColor;
			}

			ENDCG
		}
	}
}
