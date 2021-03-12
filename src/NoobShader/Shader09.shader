Shader "Noob/SurfaceShader/Shader09(Normal Extrusion with Vertex Modifier)" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("BumpTexture(凹凸贴图)", 2D) = "bump" {}

		_ExtrusionAmount ("Extrusion Amount", Range(-1, 1)) = 0.2
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
		#pragma surface surf Lambert vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _BumpMap;
		float _ExtrusionAmount;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};

		void vert(inout appdata_full v) {
			v.vertex.xyz += v.normal * _ExtrusionAmount;
		}

		void surf (Input IN, inout SurfaceOutput o) {

			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 bumpValue	= tex2D(_BumpMap, IN.uv_BumpMap);

			o.Normal	= UnpackNormal(bumpValue);

			// 应用纹理 
			o.Albedo	= textureColor.rgb * _Color.rgb;
			o.Alpha		= textureColor.a * _Color.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
