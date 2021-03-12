// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/// 阴影生成和接受阴影
/// 要实现对接收阴影的支持，需要将基础照明通道编译为多种变体，以正确处理“无阴影的定向光”和“有阴影的定向光”的情况
Shader "Noob/Vertex Fragment Shaders/Shader09(Shadow Cast and receive)" {
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
		_AmbinetColor("Ambinet Color (RGB)", Color) = (1, 1, 1, 1)
		_Alpha ("Alpha", Float) = 1.0
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

			ZWrite Off
			
			Blend SrcAlpha OneMinusSrcAlpha

			Cull front

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
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 diff : COLOR0;
				fixed3 ambient : COLOR1;
				float2 uv : TEXCOORD0;
				SHADOW_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _AmbinetColor;
			float _Alpha;

			v2f vert(appdata_base v)
			{
				v2f output;

				output.pos = UnityObjectToClipPos(v.vertex);
				output.uv = v.texcoord;

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

				mainTexColor.rgb *= _AmbinetColor.rgb;

				/// compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
				fixed shadow = SHADOW_ATTENUATION(input);

				fixed3 lighting = input.diff * shadow + input.ambient;

				mainTexColor.rgb *= lighting;

				mainTexColor.a = _Alpha;

				return mainTexColor;
			}

			ENDCG
		}

		//LOD 200
		
		/// 每个SubShader由许多遍组成，并且每个Pass代表由着色器的材质渲染的同一对象的顶点和片段代码的执行。
		Pass
		{
			Tags
			{
				"LightMode"="ForwardBase"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			/// multi_compile_fwdbase 处理“无阴影的定向光”和“有阴影的定向光”的情况
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			/// shadow helper functions and macros
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 diff : COLOR0;
				fixed3 ambient : COLOR1;
				float2 uv : TEXCOORD0;
				SHADOW_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f output;

				output.pos = UnityObjectToClipPos(v.vertex);
				output.uv = v.texcoord;

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

				/// compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
				fixed shadow = SHADOW_ATTENUATION(input);

				fixed3 lighting = input.diff * shadow + input.ambient;

				mainTexColor.rgb *= lighting;

				return mainTexColor;
			}

			ENDCG
		}

		/// 为了投射阴影，着色器必须在其任何子着色器或任何fallback中都具有ShadowCaster pass类型。ShadowCaster传递用于将对象渲染到阴影图中，
		/// 通常非常简单-顶点着色器仅需要评估顶点位置，而片段着色器几乎不执行任何操作。
		Pass
		{
			Tags
			{
				"LightMode"="ShadowCaster"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster

			#include "UnityCG.cginc"

			struct v2f {
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata_base v) {
				v2f output;

				TRANSFER_SHADOW_CASTER_NORMALOFFSET(output);

				return output;
			}

			float4 frag(v2f input) : SV_Target {
				SHADOW_CASTER_FRAGMENT(inpput);
			}

			ENDCG
		}
	}
}
