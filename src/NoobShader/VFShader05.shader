// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Noob/Vertex Fragment Shaders/Shader05(SkyReflection Bump Texture)" {
	Properties 
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpTex("Bump Texture", 2D) = "bump" {}
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
				float4 tangent : TANGENT;
				float2 uv : TEXCOORD0;
				half3 normal : TEXCOORD1;
				half3 bumpUV : TEXCOORD2;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				half3 worldPos : TEXCOORD1;
				/// these three vectors will hold a 3x3 rotation matrix
				/// that transforms from tangent to world space
				// tangent.x, bitangent.x, normal.x
				half3 tspace0 : TEXCOORD2;
				// tangent.y, bitangent.y, normal.y
				half3 tspace1 : TEXCOORD3;
				// tangent.z, bitangent.z, normal.z
				half3 tspace2 : TEXCOORD4;

				float2 bumpUV : TEXCOORD5;
			};

			sampler2D _MainTex;
			sampler2D _BumpTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f output;

				//将顶点位置从对象空间转换为所谓的“剪辑空间”
				output.pos = UnityObjectToClipPos(v.vertex);
				//output.vertex = UnityObjectToClipPos(v.vertex);

				output.uv = TRANSFORM_TEX(v.uv, _MainTex);

				output.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;

				half3 worldBitangent = cross(worldNormal, worldTangent) * tangentSign;

				output.tspace0 = half3(worldTangent.x, worldBitangent.x, worldNormal.x);
				output.tspace1 = half3(worldTangent.y, worldBitangent.y, worldNormal.y);
				output.tspace2 = half3(worldTangent.z, worldBitangent.z, worldNormal.z);

				output.bumpUV = v.bumpUV;

				return output;
			}

			fixed4 frag(v2f input) : SV_Target
			{
				/// sample the texture
				fixed4 mainTexColor = tex2D(_MainTex, input.uv);

				half3 tnormal = UnpackNormal(tex2D(_BumpTex, input.bumpUV));

				half3 worldNormal;

				worldNormal.x = dot(input.tspace0, tnormal);
				worldNormal.y = dot(input.tspace1, tnormal);
				worldNormal.z = dot(input.tspace2, tnormal);
			
				float3 worldViewDir = normalize(UnityWorldSpaceViewDir(input.worldPos));
				half3 worldRefl = reflect(-worldViewDir, worldNormal);

				half4 skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, worldRefl);

				half3 skyColor = DecodeHDR(skyData, unity_SpecCube0_HDR);

				mainTexColor.rgb = skyColor;
				mainTexColor.a = 0;

				return mainTexColor;
			}

			ENDCG
		}
	}
}
