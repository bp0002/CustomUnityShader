Shader "Noob/SurfaceShader/Shader06(Rim Lighting)" {
	Properties 
	{
		_Color ("AlbedoColor", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_BumpMap ("BumpTexture(凹凸贴图)", 2D) = "bump" {}

		_RimColor("RimColor", Color) = (0.26, 0.19, 0.16, 0.0)
		_RimPower ("RimPower", Range(0.5, 8.0)) = 3.0
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
		float4 _RimColor;
		float _RimPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 textureColor = tex2D(_MainTex, IN.uv_MainTex);
			float4 bumpValue = tex2D(_BumpMap, IN.uv_BumpMap);

			// 应用纹理 
			o.Albedo = textureColor.rgb * _Color.rgb;
			o.Alpha = textureColor.a * _Color.a;

			o.Normal = UnpackNormal(bumpValue);

			half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
