// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VertexColor_Remap"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		_BaseColor("_BaseColor", Color) = (0,0,0,1)
		_colorFromRed("_colorFromRed", Color) = (1,1,1,1)
		_brightnessMaximum_Red("_brightnessMaximum_Red", Range( 1 , 1024)) = 2
		_brightnessFalloff_Red("_brightnessFalloff_Red", Range( 0 , 16)) = 2
		_colorFromGreen("_colorFromGreen", Color) = (1,1,1,1)
		_brightnessMaximum_Green("_brightnessMaximum_Green", Range( 1 , 1024)) = 2
		_brightnessFalloff_Green("_brightnessFalloff_Green", Range( 0 , 16)) = 2
		_colorFromBlue("_colorFromBlue", Color) = (1,1,1,1)
		_brightnessMaximum_Blue("_brightnessMaximum_Blue", Range( 1 , 1024)) = 2
		_brightnessFalloff_Blue("_brightnessFalloff_Blue", Range( 0 , 16)) = 2
		_brightnessFaloff_Alpha("_brightnessFaloff_Alpha", Range( 0 , 16)) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		ZTest LEqual
		Blend SrcAlpha One
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _BaseColor;
		uniform float4 _colorFromRed;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _colorFromGreen;
		uniform float4 _colorFromBlue;
		uniform float _brightnessFalloff_Red;
		uniform float _brightnessMaximum_Red;
		uniform float _brightnessFalloff_Green;
		uniform float _brightnessMaximum_Green;
		uniform float _brightnessFalloff_Blue;
		uniform float _brightnessMaximum_Blue;
		uniform float _brightnessFaloff_Alpha;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color48 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 break6 = ( tex2D( _MainTex, uv0_MainTex ) * i.vertexColor );
			float4 lerpResult8 = lerp( _BaseColor , _colorFromRed , break6.r);
			float4 lerpResult14 = lerp( _BaseColor , _colorFromGreen , break6.g);
			float4 lerpResult15 = lerp( _BaseColor , _colorFromBlue , break6.b);
			float4 break21 = saturate( ( lerpResult8 + lerpResult14 + lerpResult15 ) );
			float3 appendResult56 = (float3(( pow( break21.r , ( abs( _brightnessFalloff_Red ) + 1.0 ) ) * _brightnessMaximum_Red ) , ( pow( break21.g , ( abs( _brightnessFalloff_Green ) + 1.0 ) ) * _brightnessMaximum_Green ) , ( pow( break21.b , ( abs( _brightnessFalloff_Blue ) + 1.0 ) ) * _brightnessMaximum_Blue )));
			float4 lerpResult47 = lerp( color48 , float4( appendResult56 , 0.0 ) , pow( break21.a , ( 0.0 + abs( _brightnessFaloff_Alpha ) ) ));
			o.Emission = lerpResult47.rgb;
			o.Alpha = break6.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
415.2;202.4;944;600;-632.066;2560.988;2.878382;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;2;-659.8873,-310.1092;Inherit;True;Property;_MainTex;_MainTex;1;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-392.8596,-213.0153;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-146.466,-306.6448;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;1;-26.93404,-113.4074;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;217.495,-293.093;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;10;118.1271,-1202.62;Inherit;False;Property;_BaseColor;_BaseColor;2;0;Create;True;0;0;False;0;False;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;115.4107,-860.8294;Inherit;False;Property;_colorFromGreen;_colorFromGreen;6;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;12;119.8653,-689.5327;Inherit;False;Property;_colorFromBlue;_colorFromBlue;9;0;Create;True;0;0;False;0;False;1,1,1,1;0.2595295,0,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;6;387.8105,-206.8553;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;13;118.2982,-1028.667;Inherit;False;Property;_colorFromRed;_colorFromRed;3;0;Create;True;0;0;False;0;False;1,1,1,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;8;906.382,-1204.746;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;902.7405,-1035.899;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;15;903.3212,-847.6042;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;1192.528,-1207.427;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;17;1353.738,-1209.021;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;24;1639.379,-2003.417;Inherit;False;Property;_brightnessFalloff_Red;_brightnessFalloff_Red;5;0;Create;True;0;0;False;0;False;2;2;0;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;2105.242,-1417.742;Inherit;False;Property;_brightnessFalloff_Blue;_brightnessFalloff_Blue;11;0;Create;True;0;0;False;0;False;2;2;0;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;1855.872,-1679.482;Inherit;False;Property;_brightnessFalloff_Green;_brightnessFalloff_Green;8;0;Create;True;0;0;False;0;False;2;2;0;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;21;1563.36,-1209.4;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.WireNode;49;1526.65,-2008.218;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;36;2374.712,-1419.812;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;32;2134.484,-1678.479;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;53;1850.338,-1416.453;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;51;1712.249,-1670.618;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;26;1910.162,-2002.501;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;2497.658,-1417.025;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;50;1533.849,-2024.217;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;2030.083,-2002.843;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;52;1720.249,-1699.418;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;2265.307,-1680.247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;54;1861.039,-1436.325;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;2195.224,-1020.222;Inherit;False;Property;_brightnessFaloff_Alpha;_brightnessFaloff_Alpha;12;0;Create;True;0;0;False;0;False;2;2;0;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;30;2421.346,-1735.142;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;34;2626.181,-1471.833;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;2343.557,-1327.244;Inherit;False;Property;_brightnessMaximum_Blue;_brightnessMaximum_Blue;10;0;Create;True;0;0;False;0;False;2;2;1;1024;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;23;2165.321,-2061.014;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;46;2473.092,-1016.108;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;2101.02,-1585.724;Inherit;False;Property;_brightnessMaximum_Green;_brightnessMaximum_Green;7;0;Create;True;0;0;False;0;False;2;2;1;1024;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;1882.023,-1901.186;Inherit;False;Property;_brightnessMaximum_Red;_brightnessMaximum_Red;4;0;Create;True;0;0;False;0;False;2;2;1;1024;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;2612.983,-1038.404;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;2603.849,-1735.65;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;2349.685,-2059.224;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;2808.957,-1470.358;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;56;3146.882,-2066.161;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;48;3081.727,-2232.972;Inherit;False;Constant;_Color0;Color 0;9;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;42;2761.889,-1137.881;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;3796.526,-1190.714;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;4416.285,-344.5858;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;VertexColor_Remap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;8;5;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;2;2;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;5;0;3;0
WireConnection;5;1;1;0
WireConnection;6;0;5;0
WireConnection;8;0;10;0
WireConnection;8;1;13;0
WireConnection;8;2;6;0
WireConnection;14;0;10;0
WireConnection;14;1;11;0
WireConnection;14;2;6;1
WireConnection;15;0;10;0
WireConnection;15;1;12;0
WireConnection;15;2;6;2
WireConnection;16;0;8;0
WireConnection;16;1;14;0
WireConnection;16;2;15;0
WireConnection;17;0;16;0
WireConnection;21;0;17;0
WireConnection;49;0;21;0
WireConnection;36;0;37;0
WireConnection;32;0;33;0
WireConnection;53;0;21;2
WireConnection;51;0;21;1
WireConnection;26;0;24;0
WireConnection;35;0;36;0
WireConnection;50;0;49;0
WireConnection;25;0;26;0
WireConnection;52;0;51;0
WireConnection;31;0;32;0
WireConnection;54;0;53;0
WireConnection;30;0;52;0
WireConnection;30;1;31;0
WireConnection;34;0;54;0
WireConnection;34;1;35;0
WireConnection;23;0;50;0
WireConnection;23;1;25;0
WireConnection;46;0;43;0
WireConnection;44;1;46;0
WireConnection;57;0;30;0
WireConnection;57;1;28;0
WireConnection;58;0;23;0
WireConnection;58;1;27;0
WireConnection;59;0;34;0
WireConnection;59;1;38;0
WireConnection;56;0;58;0
WireConnection;56;1;57;0
WireConnection;56;2;59;0
WireConnection;42;0;21;3
WireConnection;42;1;44;0
WireConnection;47;0;48;0
WireConnection;47;1;56;0
WireConnection;47;2;42;0
WireConnection;0;2;47;0
WireConnection;0;9;6;3
ASEEND*/
//CHKSM=F8EA1736F2EA40309BE1C429FFC3F6E5EB5A6EA3