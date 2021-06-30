
// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Noob/Vertex Fragment Shaders/CustomTail(Not Export)" {
Properties {
    _NNN("使用内置Plane([x,z]范围[-5~5])", Int) = 1
	_TintColor ("Tint Color", Color) = (1,1,1,1)
	_MainTex ("Texture", 2D) = "white" {}

	_BezierPoint0("BezierPoint0", Vector) = (1,1,1,1)
	_BezierPoint1("BezierPoint1", Vector) = (1,1,1,1)
	_BezierPoint2("BezierPoint2", Vector) = (1,1,1,1)

	_TailStartSize("TailStartSize", Float) = 1.0
	_TailEndSize("TailEndSize", Float) = 1.0

	_TailDisplayEnd("TailDisplayEnd", Range(0.0, 1.0)) = 1.0
	_TailDisplaySize("TailDisplaySize", Range(0.0, 1.0)) = 0.2

	_ZWrite("ZWrite", Int) = 1

	[Enum(UnityEngine.Rendering.CullMode)]_Cull("_Cull", Int) = 2
	[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("SrcBlend", Int) = 5
	[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("DstBlend", Int) = 1	

    _Mode ("Mode", Float) = 0.0
}


    Category {
        Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}
        Blend [_SrcBlend][_DstBlend]
        ColorMask RGB
		ZWrite [_ZWrite]
        Cull [_Cull]
        
        SubShader {
            Pass {

                Tags{ "LightMode"="ForwardBase" }
                
                CGPROGRAM
                #pragma vertex vert alpha
                #pragma fragment frag alpha
                #pragma target 3.0
                #pragma multi_compile_fog

                #include "UnityCG.cginc"
                #include "Lighting.cginc"
                #include "ConvertColor.cginc"

                sampler2D _MainTex;

                float4 _BezierPoint0;
                float4 _BezierPoint1;
                float4 _BezierPoint2;

				float _TailDisplaySize;
				float _TailDisplayEnd;
				float _TailStartSize;
				float _TailEndSize;

                fixed4 _TintColor;

                float4 _MainTex_ST; // for TRANSFORM_TEX
				float4 diffuseFormat(float4 texColor, float2 texcoord);
                
                struct VertInput {
                    float4 vertex : POSITION;
					float4 vColor : COLOR;
                    float3 normal: NORMAL;
                    float2 texcoord : TEXCOORD0;
                };

                struct VertOutput {
                    float4 vertex : SV_POSITION;
                    fixed4 color : COLOR;
                    float2 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
                };
                
                

                VertOutput vert (VertInput v)
                {
                    VertOutput o;
                    UNITY_SETUP_INSTANCE_ID(v);

                    float3 a_bp0 = _BezierPoint0.xyz;
                    float3 a_bp1 = _BezierPoint1.xyz;
                    float3 a_bp2 = _BezierPoint2.xyz;
					float4 a_control = float4(max(0.0, min(1.0, _TailDisplayEnd - _TailDisplaySize)), min(1.0, _TailDisplayEnd), _TailStartSize, _TailEndSize);

					float3 positionUpdated = v.vertex / 10.0;

					positionUpdated.x = positionUpdated.x + 0.5;
					float progress = a_control.x + positionUpdated.x * (a_control.y - a_control.x);
					float progress2 = 1.0 - progress;
					float3 pp = a_bp1 + progress2 * progress2 * (a_bp0 - a_bp1) + progress * progress * (a_bp2 - a_bp1);
					float3 dtp = normalize(2.0 * progress2 * (a_bp1 - a_bp0) + 2.0 * progress * (a_bp2 - a_bp1));

                    float3 forward = floor(UNITY_MATRIX_V[2].xyz);
                    float3 viewDirection = forward;
                    float3 dotDtp = dot(dtp, viewDirection);

                    float3 projDtp = normalize(dtp - (dotDtp) * viewDirection);

                    float3 extend = normalize(float3(projDtp.y * viewDirection.z - projDtp.z * viewDirection.y, projDtp.z * viewDirection.x - projDtp.x * viewDirection.z, projDtp.x * viewDirection.y - projDtp.y * viewDirection.x));

					float size = a_control.z + (a_control.w - a_control.z) * progress;

                    positionUpdated = pp + positionUpdated.z * extend * size;

                    o.vertex = UnityObjectToClipPos(positionUpdated);
                    o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);

					float3 color;

					color = float3(1.0, 1.0, 1.0);

                    o.color = float4(color, 1.0) * v.vColor;

					UNITY_TRANSFER_FOG(o, o.vertex);

                    return o;
                }

                fixed4 frag (VertOutput i) : SV_Target
                {
					float4 texColor = float4(0.0, 0.0, 0.0, 0.0);

					// 主纹理处理
					texColor = diffuseFormat(texColor, i.texcoord);

                    float4 col = _TintColor * texColor;
                    col = col * i.color;

					UNITY_APPLY_FOG(i.fogCoord, col);

                    return col;
                }

				float4 diffuseFormat(float4 texColor, float2 texcoord) {

					texColor = tex2D(_MainTex, texcoord);

					return texColor;
				}

                ENDCG 
            }
        }	
    }
}
