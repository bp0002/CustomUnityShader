Shader "Noob/SurfaceShader/Shader11(FinalColor,Ambient)" {
	Properties 
	{
		_Color ("Final Color", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("BumpTexture(凹凸贴图)", 2D) = "bump" {}
	}
	SubShader 
	{
		Tags 
		{ 
			"RenderType"="Opaque" 
		}

		LOD 200
		
		CGPROGRAM
		// 表面着色器
		// 着色器函数 surf
		// 使用 Lambert(漫反射) 照明模型
		// 顶点处理
		#pragma surface surf Lambert finalcolor:myambient

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
		fixed4 _CustomAmbinet;
		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void myambient(Input IN, SurfaceOutput o, inout fixed4 color) {
			color *= _Color;
		}

		void surf (Input IN, inout SurfaceOutput o) {

			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 bumpValue	= tex2D(_BumpMap, IN.uv_BumpMap);

			o.Normal	= UnpackNormal(bumpValue);

			// 应用纹理 
			o.Albedo	= textureColor.rgb;
			o.Alpha		= textureColor.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
