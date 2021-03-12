Shader "Noob/SurfaceShader/Shader07(Cube Reflection)" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("BumpTexture(凹凸贴图)", 2D) = "bump" {}

		_CubeMap ("Cube Map", CUBE) = "white" {}
		_CubeReflectAmount("Cube Reflect Amount", Range(0.01, 1)) = 0.1
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

		float _CubeReflectAmount;
		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		samplerCUBE _CubeMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 bumpValue	= tex2D(_BumpMap, IN.uv_BumpMap);
			//float4 cubeValue	= texCUBE(_CubeMap, IN.worldRefl);

			o.Normal = UnpackNormal(bumpValue);

			// 如果要进行受法线贴图影响的反射，它需要稍微复杂一些：INTERNAL_DATA需要添加到Input结构中，
			// 并且需要WorldReflectionVector在编写Normal输出后用于计算每像素反射向量的函数。
			float4 cubeValue = texCUBE(_CubeMap, WorldReflectionVector(IN, o.Normal));

			// 应用纹理 
			o.Albedo	= textureColor.rgb * _Color.rgb;
			o.Alpha		= textureColor.a * _Color.a;


			o.Emission	= cubeValue.rgb * _CubeReflectAmount;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
