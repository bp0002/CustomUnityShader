// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Noob/Vertex Fragment Shaders/Shader01(Unlit)" {
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
	}

	/// 着色器可以包含一个或多个 子着色器，主要用于为不同的GPU功能实现着色器
	SubShader 
	{
		Tags 
		{ 
			"RenderType"="Opaque" 
		}

		LOD 200
		
		/// 每个SubShader由许多遍组成，并且每个Pass代表由着色器的材质渲染的同一对象的顶点和片段代码的执行。
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			/// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f output;

				//将顶点位置从对象空间转换为所谓的“剪辑空间”
				output.vertex = UnityObjectToClipPos(v.vertex);
				//output.vertex = UnityObjectToClipPos(v.vertex);

				output.uv = TRANSFORM_TEX(v.uv, _MainTex);

				UNITY_TRANSFER_FOG(output, output.vertex);

				return output;
			}

			fixed4 frag(v2f input) : SV_Target
			{
				/// sample the texture
				fixed4 mainTexColor = tex2D(_MainTex, input.uv);
				/// apply fog
				UNITY_APPLY_FOG(i.fogCoord, mainTexColor);

				return mainTexColor;
			}

			ENDCG
		}
	}
}
