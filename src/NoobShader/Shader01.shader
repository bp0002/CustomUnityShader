Shader "Noob/SurfaceShader/Shader01" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
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

		struct Input {
			float4 color : COLOR;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			// 仅应用颜色
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
