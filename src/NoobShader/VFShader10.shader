// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/// 阴影生成和接受阴影
/// 要实现对接收阴影的支持，需要将基础照明通道编译为多种变体，以正确处理“无阴影的定向光”和“有阴影的定向光”的情况
Shader "Noob/Vertex Fragment Shaders/Shader10(Babylon Standard)" {
	Properties 
	{
		[Header(Material Alpha)]
		_Alpha("Alpha", Range(0.0, 1.0)) = 0.5
		_AlphaCullOff("AlphaCullOff", Range(0.0, 1.0)) = 0.0

		[Header(Diffuse)]
		_TintColor("Diffuse Color (RGB)", Color) = (1, 1, 1, 1)
		_MainTex ("DiffuseTexture", 2D) = "white" {}
		[Enum(Off, 0, On, 1)]_DiffuseTexHasAlpha("DiffuseTextureHasAlpha", Int) = 1
		[Enum(Off, 0, On, 1)]_UseAlphaFromDiffuseTex("UseAlphaFromDiffuseTexture", Int) = 1

		[Header(Ambient)]
		_AmbientColor("Ambient Color (RGB)", Color) = (1, 1, 1, 1)
		_AmbientTex("AmbientTexture", 2D) = "white" {}

		[Header(Specular)]
		_SpecularColor("Specular Color (RGB)", Color) = (1, 1, 1, 1)
		_SpecularTex("SpecularTexture", 2D) = "white" {}
		_SpecularPower("SpecularPower", Range(0.0, 10.0)) = 1.0

		[Header(Emissive)]
		_EmissiveColor("Emissive Color (RGB)", Color) = (1, 1, 1, 1)
		_EmissiveTex("EmissiveTexture", 2D) = "white" {}

		[Header(Opacity)]
		_OpacityTex("OpacityTexture", 2D) = "white" {}

		[Header(Bump)]
		_BumpTex("BumpTexture", 2D) = "bump" {}

		[Header(LightMap)]
		_LightMapTex("LightMapTexture", 2D) = "white" {}

		[Header(Reflection)]
		_ReflectionTex("ReflectionTexture", 2D) = "white" {}

		[Header(Refraction)]
		_RefractionTex("RefractionTexture", 2D) = "white" {}

		[Header(Mask)]
		_MaskTex("MaskTexture", 2D) = "white" {}


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

		_Level("Brightness", Float) = 1.0
	}

	/// 着色器可以包含一个或多个 子着色器，主要用于为不同的GPU功能实现着色器
	SubShader 
	{
		//Tags 
		//{ 
		//	"RenderType"="Opaque" 
		//}

		Pass {
			Tags {
				"Queue"="Transparent"
				"IgnoreProjector"="True"
				"LightMode" = "ForwardBase"
			}

			ZWrite [_ZWrite]

			Blend[_SrcBlend][_DstBlend]
			ColorMask RGB
			Cull [_Cull]

			CGPROGRAM
			#pragma vertex vert alpha
			#pragma fragment frag alpha
			#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			/// multi_compile_fwdbase 处理“无阴影的定向光”和“有阴影的定向光”的情况
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			/// shadow helper functions and macros
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal: NORMAL;
				float3 color: COLOR0;

				float2 uv : TEXCOORD0;
				float2 ambient_uv : TEXCOORD1;
				float2 specular_uv : TEXCOORD2;
				float2 emissive_uv : TEXCOORD3;
				float2 opacity_uv : TEXCOORD4;
				float2 bump_uv : TEXCOORD5;
				float2 lightmap_uv : TEXCOORD6;
				float2 reflection_uv : TEXCOORD7;
				float2 refraction_uv : TEXCOORD8;
				float2 mask_uv : TEXCOORD9;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR0;
				fixed3 diff : COLOR1;
				fixed3 ambient : COLOR2;

				float3 normal: NORMAL;

				float2 uv : TEXCOORD0;
				float2 ambient_uv : TEXCOORD1;
				float2 specular_uv : TEXCOORD2;
				float2 emissive_uv : TEXCOORD3;
				float2 opacity_uv : TEXCOORD4;
				float2 bump_uv : TEXCOORD5;
				float2 lightmap_uv : TEXCOORD6;
				float2 reflection_uv : TEXCOORD7;
				float2 refraction_uv : TEXCOORD8;
				float2 mask_uv : TEXCOORD9;

				SHADOW_COORDS(10)
			};

			sampler2D _MainTex;
			sampler2D _AmbientTex;
			sampler2D _SpecularTex;
			sampler2D _EmissiveTex;
			sampler2D _OpacityTex;
			sampler2D _BumpTex;
			sampler2D _LightMapTex;
			sampler2D _ReflectionTex;
			sampler2D _RefractionTex;
			sampler2D _MaskTex;

			float4 _MainTex_ST;
			float4 _TintColor;

			float4 _AmbientTex_ST;
			float4 _AmbientColor;

			float4 _SpecularTex_ST;
			float4 _SpecularColor;

			float4 _EmissiveTex_ST;
			float4 _EmissiveColor;

			float4 _OpacityTex_ST;

			float4 _BumpTex_ST;

			float4 _LightMapTex_ST;

			float4 _ReflectionTex_ST;

			float4 _RefractionTex_ST;

			float4 _MaskTex_ST;

			float _Alpha;
			float _AlphaCullOff;

			float _Level;

			v2f vert(appdata v)
			{
				v2f output;

				output.pos = UnityObjectToClipPos(v.vertex);
				output.color = v.color;

				output.uv				= TRANSFORM_TEX(v.uv,			_MainTex);
				output.ambient_uv		= TRANSFORM_TEX(v.ambient_uv,	_AmbientTex);
				output.specular_uv		= TRANSFORM_TEX(v.specular_uv,	_SpecularTex);
				output.emissive_uv		= TRANSFORM_TEX(v.emissive_uv,	_EmissiveTex);
				output.opacity_uv		= TRANSFORM_TEX(v.opacity_uv,	_OpacityTex);
				output.bump_uv			= TRANSFORM_TEX(v.bump_uv,		_BumpTex);
				output.lightmap_uv		= TRANSFORM_TEX(v.lightmap_uv,	_LightMapTex);
				output.reflection_uv	= TRANSFORM_TEX(v.reflection_uv,_ReflectionTex);
				output.refraction_uv	= TRANSFORM_TEX(v.refraction_uv,_RefractionTex);
				output.mask_uv			= v.uv.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;

				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

				output.diff = nl * _LightColor0;

				output.ambient = ShadeSH9(half4(worldNormal, 1));

				TRANSFER_SHADOW(output);

				return output;
			}

			fixed4 frag(v2f input) : SV_Target
			{
				fixed4 mainTexColor = tex2D(_MainTex, input.uv);

				mainTexColor.a = mainTexColor.a < _AlphaCullOff ? 0.0 : mainTexColor.a;
				
				//mainTexColor *= input.color;

				//if (color.a < _CutOff)
				//	discard;

				mainTexColor.rgb *= _AmbientColor.rgb;

				/// compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
				fixed shadow = SHADOW_ATTENUATION(input);

				//fixed3 lighting = normalize(input.diff * UnpackNormal(tex2D(_BumpTex, input.bump_uv))) * shadow + input.ambient;

				//mainTexColor.rgb *= UnpackNormal(tex2D(_BumpTex, input.bump_uv));

				mainTexColor.a *= _Alpha;
				mainTexColor.a *= tex2D(_OpacityTex, input.opacity_uv).r;

				mainTexColor.rgb *= _TintColor.rgb;
				mainTexColor *= _Level;
				mainTexColor *= tex2D(_MaskTex, input.mask_uv.xy);

				return mainTexColor;
			}

			ENDCG
		}
	}
}
