Shader "Noob/SurfaceShader/Shader02" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
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
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			// 应用纹理 
			o.Albedo = textureColor.rgb * _Color.rgb;
			o.Alpha = textureColor.a * _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
