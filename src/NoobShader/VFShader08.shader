// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/// 阴影生成(映射)
Shader "Noob/Vertex Fragment Shaders/Shader08(Shadow Cast)" {
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	/// 着色器可以包含一个或多个 子着色器，主要用于为不同的GPU功能实现着色器
	SubShader 
	{
		//Tags 
		//{ 
		//	"RenderType"="Opaque" 
		//}

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
			/// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"
			/// for _LightColorn
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed4 diff : COLOR0;
			};

			sampler2D _MainTex;
			sampler2D _BumpTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f output;

				//将顶点位置从对象空间转换为所谓的“剪辑空间”
				output.pos = UnityObjectToClipPos(v.vertex);
				output.uv = v.texcoord;

				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));

				output.diff = nl * _LightColor0;

				/// UnityCG.cginc中的ShadeSH9函数include文件执行给定世界空间法线的所有评估工作
				/// 环境和光探头 数据以Spherical Harmonics形式传递到着色器
				output.diff.rgb += ShadeSH9(half4(worldNormal, 1));

				return output;
			}

			fixed4 frag(v2f input) : SV_Target
			{
				/// sample the texture
				fixed4 mainTexColor = tex2D(_MainTex, input.uv);

				mainTexColor *= input.diff;

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
