Shader "Noob/SurfaceShader/Shader04(Detail-ScreenSpace)" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("BumpTexture(凹凸贴图)", 2D) = "bump" {}
		_DetailTex ("DetailTexture", 2D) = "gray" {}
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
		sampler2D _DetailTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float4 screenPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 bumpValue = tex2D(_BumpMap, IN.uv_BumpMap);
			
			float2 screenUV = IN.screenPos.xy / IN.screenPos.w;
			screenUV *= float2(8, 6);

			float4 detailValue = tex2D(_DetailTex, screenUV);

			// 应用纹理 
			o.Albedo = textureColor.rgb * _Color.rgb;
			o.Albedo *= detailValue.rgb * 2;
			o.Alpha = textureColor.a * _Color.a;

			o.Normal = UnpackNormal(bumpValue);

		}
		ENDCG
	}
	FallBack "Diffuse"
}
