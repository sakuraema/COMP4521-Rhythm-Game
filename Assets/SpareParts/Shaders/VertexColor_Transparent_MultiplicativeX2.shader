// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/VertexColor_Transparent_MultiplicativeX2"
{
	Properties
	{
		[HDR]_colorEmisison("colorEmisison", Color) = (0,0,0,0)
		[HDR]_textureEmission("textureEmission", 2D) = "white" {}
		_softness("softness", Float) = 0
		_softnessRange("softnessRange", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest LEqual
		Blend DstColor SrcColor , OneMinusDstColor One
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap vertex:vertexDataFunc 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPosition35;
		};

		uniform float4 _colorEmisison;
		uniform sampler2D _textureEmission;
		uniform float4 _textureEmission_ST;
		uniform float _softnessRange;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _softness;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos35 = ase_vertex3Pos;
			float4 ase_screenPos35 = ComputeScreenPos( UnityObjectToClipPos( vertexPos35 ) );
			o.screenPosition35 = ase_screenPos35;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 colorVertex105 = i.vertexColor;
			float2 uv0_textureEmission = i.uv_texcoord * _textureEmission_ST.xy + _textureEmission_ST.zw;
			float4 tex2DNode117 = tex2D( _textureEmission, uv0_textureEmission );
			float4 emission115 = ( colorVertex105 * ( _colorEmisison * tex2DNode117 ) );
			o.Emission = emission115.rgb;
			float alphaEmission118 = ( _colorEmisison.a * tex2DNode117.a );
			float alphaVertex106 = i.vertexColor.a;
			float4 ase_screenPos35 = i.screenPosition35;
			float4 ase_screenPosNorm35 = ase_screenPos35 / ase_screenPos35.w;
			ase_screenPosNorm35.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm35.z : ase_screenPosNorm35.z * 0.5 + 0.5;
			float screenDepth35 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm35.xy ));
			float distanceDepth35 = abs( ( screenDepth35 - LinearEyeDepth( ase_screenPosNorm35.z ) ) / ( _softness ) );
			float smoothstepResult71 = smoothstep( ( _softnessRange * -32.0 ) , ( _softnessRange * 32.0 ) , distanceDepth35);
			float alphaSoftness120 = smoothstepResult71;
			float alphaFinal127 = ( alphaEmission118 * alphaVertex106 * alphaSoftness120 );
			o.Alpha = alphaFinal127;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
101.6;100.8;964;667;3268.018;1427.975;3.603822;True;False
Node;AmplifyShaderEditor.CommentaryNode;108;-1426.23,43.77961;Inherit;False;1328.622;477.1317;Emission;7;117;116;114;113;112;111;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;119;-1422.431,596.6974;Inherit;False;946.5881;346.5969;Softness;7;38;61;37;72;35;71;73;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;116;-1376.23,274.0292;Inherit;True;Property;_textureEmission;textureEmission;1;1;[HDR];Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;111;-1114.7,358.7115;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;38;-1372.431,649.9163;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;61;-1125.003,767.6158;Inherit;False;Property;_softnessRange;softnessRange;4;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1364.033,790.0772;Inherit;False;Property;_softness;softness;3;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1402.574,1439.62;Inherit;False;241.2;254;Vertex Color;1;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-827.5148,809.4942;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;32;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;35;-1100.508,646.6973;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;117;-882.1404,275.1509;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-822.5148,717.4943;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-32;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;110;-808.7733,93.77962;Inherit;False;Property;_colorEmisison;colorEmisison;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-472.5784,430.0737;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;-664.6428,648.6351;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;2;-1352.574,1489.62;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-1107.679,1444.915;Inherit;False;colorVertex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1102.316,1580.359;Inherit;False;alphaVertex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;-65.43777,438.2589;Inherit;False;alphaEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-427.0766,642.5449;Inherit;False;alphaSoftness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;126;-1409.563,997.5828;Inherit;False;462.4868;405.3873;Opacity;4;124;125;121;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;-615.3632,-34.08281;Inherit;False;105;colorVertex;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;125;-1382.422,1188.57;Inherit;False;120;alphaSoftness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;121;-1385.563,1039.868;Inherit;False;118;alphaEmission;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-1383.219,1114.152;Inherit;False;106;alphaVertex;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-471.6927,308.106;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-1109.476,1054.397;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-269.8224,310.0206;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;-64.1235,303.1726;Inherit;False;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-922.4426,1011.476;Inherit;False;alphaFinal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;519.7911,-440.9393;Inherit;False;115;emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;518.6968,-355.0153;Inherit;False;127;alphaFinal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;851.8016,-483.8481;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpareParts/VertexColor_Transparent_MultiplicativeX2;False;False;False;False;True;True;True;True;True;False;False;False;False;False;True;False;False;False;True;True;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;7;2;False;-1;3;False;-1;5;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;111;2;116;0
WireConnection;73;0;61;0
WireConnection;35;1;38;0
WireConnection;35;0;37;0
WireConnection;117;0;116;0
WireConnection;117;1;111;0
WireConnection;72;0;61;0
WireConnection;113;0;110;4
WireConnection;113;1;117;4
WireConnection;71;0;35;0
WireConnection;71;1;72;0
WireConnection;71;2;73;0
WireConnection;105;0;2;0
WireConnection;106;0;2;4
WireConnection;118;0;113;0
WireConnection;120;0;71;0
WireConnection;112;0;110;0
WireConnection;112;1;117;0
WireConnection;21;0;121;0
WireConnection;21;1;124;0
WireConnection;21;2;125;0
WireConnection;114;0;109;0
WireConnection;114;1;112;0
WireConnection;115;0;114;0
WireConnection;127;0;21;0
WireConnection;0;2;133;0
WireConnection;0;9;131;0
ASEEND*/
//CHKSM=66BA9301C24FB6E90B91F481C9EF6D82531DCFCD