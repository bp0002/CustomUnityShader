Shader "Noob/SurfaceShader/Shader08(WorldSpace Clip)" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
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
		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			clip(frac((IN.worldPos.y + IN.worldPos.z * 0.1) * 5) - 0.5 );

			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 bumpValue	= tex2D(_BumpMap, IN.uv_BumpMap);

			o.Normal = UnpackNormal(bumpValue);

			// 应用纹理 
			o.Albedo	= textureColor.rgb * _Color.rgb;
			o.Alpha		= textureColor.a * _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
