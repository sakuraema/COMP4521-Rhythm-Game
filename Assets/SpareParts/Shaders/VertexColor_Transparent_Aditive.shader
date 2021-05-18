// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/VertexColor_Transparent_Aditive"
{
	Properties
	{
		_textureEmission("textureEmission", 2D) = "white" {}
		_brightnessMinimum("brightnessMinimum", Float) = 0
		_brightnessMaximum("brightnessMaximum", Float) = 0
		_softnessDistance("softnessDistance", Float) = 0
		_softnessRange("softnessRange", Range( 0 , 1)) = 0
		_alphaFromGrayscaleThreshold("alphaFromGrayscaleThreshold", Float) = 2
		_brightnessFalloff("brightnessFalloff", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha , OneMinusDstColor One
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap 
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _textureEmission;
		uniform float4 _textureEmission_ST;
		uniform float _brightnessMinimum;
		uniform float _brightnessMaximum;
		uniform float _brightnessFalloff;
		uniform float _alphaFromGrayscaleThreshold;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _softnessDistance;
		uniform float _softnessRange;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 vertexColor105 = i.vertexColor;
			float2 uv0_textureEmission = i.uv_texcoord * _textureEmission_ST.xy + _textureEmission_ST.zw;
			float4 temp_output_114_0 = ( vertexColor105 * tex2D( _textureEmission, uv0_textureEmission ) );
			float4 emissionColor526 = temp_output_114_0;
			float4 temp_cast_0 = (_brightnessMinimum).xxxx;
			float4 temp_cast_1 = (_brightnessMaximum).xxxx;
			float grayscale542 = dot(temp_output_114_0.rgb, float3(0.299,0.587,0.114));
			float emissionGrayscale544 = grayscale542;
			float smoothstepResult535 = smoothstep( 0.0 , _alphaFromGrayscaleThreshold , ( pow( emissionGrayscale544 , _alphaFromGrayscaleThreshold ) * _alphaFromGrayscaleThreshold ));
			float emissionAlpha528 = temp_output_114_0.a;
			float lerpResult524 = lerp( smoothstepResult535 , emissionAlpha528 , emissionAlpha528);
			float emissionAlphaGrayscale538 = lerpResult524;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth35 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth35 = abs( ( screenDepth35 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _softnessDistance ) );
			float smoothstepResult71 = smoothstep( 0.0 , 1.0 , pow( distanceDepth35 , (0.0 + (_softnessRange - 0.0) * (16.0 - 0.0) / (1.0 - 0.0)) ));
			float alphaSoftness120 = smoothstepResult71;
			float smoothstepResult515 = smoothstep( 0.0 , _brightnessFalloff , ( ( pow( emissionGrayscale544 , _brightnessFalloff ) * _brightnessFalloff ) * emissionAlphaGrayscale538 * alphaSoftness120 ));
			float4 lerpResult513 = lerp( emissionColor526 , (temp_cast_0 + (emissionColor526 - float4( 0,0,0,0 )) * (temp_cast_1 - temp_cast_0) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) , smoothstepResult515);
			float4 emissionColorFinal549 = lerpResult513;
			o.Emission = emissionColorFinal549.rgb;
			float emissionAlphaFinal555 = smoothstepResult515;
			o.Alpha = emissionAlphaFinal555;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
253.6;469.6;860;442;767.8575;-137.3992;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;541;-1459.23,95.82658;Inherit;False;1445.597;485.6799;Vertex Coloring;10;116;111;109;117;114;530;526;528;542;544;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;276;-1480.237,-398.887;Inherit;False;805.3458;388.7928;Vertex Parameters;7;447;449;106;105;2;266;264;;1,1,1,1;0;0
Node;AmplifyShaderEditor.VertexColorNode;2;-1463.795,-186.6788;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;116;-1409.23,316.6239;Inherit;True;Property;_textureEmission;textureEmission;0;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;111;-1149.698,419.3064;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-1272.326,-192.3676;Inherit;False;vertexColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;117;-924.1385,316.7456;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;109;-812.1923,241.2285;Inherit;False;105;vertexColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-608.4305,241.0966;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;542;-462.7049,369.3381;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;544;-237.705,370.3381;Inherit;False;emissionGrayscale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;540;-1468.557,602.9619;Inherit;False;1244.071;296.6566;Alpha From Grayscale;8;527;537;538;524;529;535;533;531;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;119;-1459.815,917.4044;Inherit;False;993.1436;309.8344;Softness;7;120;71;476;477;35;37;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;527;-1325.671,667.3871;Inherit;False;544;emissionGrayscale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;537;-1415.893,742.8495;Inherit;False;Property;_alphaFromGrayscaleThreshold;alphaFromGrayscaleThreshold;6;0;Create;True;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;531;-1074.131,667.6414;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1420.318,977.4582;Inherit;False;Property;_softnessDistance;softnessDistance;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1440.973,1064.322;Inherit;False;Property;_softnessRange;softnessRange;5;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;530;-462.6322,222.8617;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;533;-925.2528,666.415;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;477;-1181.479,1059.228;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;528;-241.6322,285.8617;Inherit;False;emissionAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;35;-1238.479,961.4043;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;535;-802.2528,669.415;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;476;-992.4785,962.2283;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;553;-1456.64,1246.222;Inherit;False;1837.404;434.2897;Adding Brightness;16;518;547;516;548;539;517;522;515;545;507;513;549;554;555;556;557;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;529;-852.8085,804.3981;Inherit;False;528;emissionAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;-833.6132,962.3423;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;524;-646.932,680.7551;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;518;-1406.64,1563.024;Inherit;False;Property;_brightnessFalloff;brightnessFalloff;7;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;547;-1391.876,1348.757;Inherit;False;544;emissionGrayscale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-662.3119,1023.316;Inherit;False;alphaSoftness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;516;-1173.359,1354.264;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;538;-483.3456,679.0979;Inherit;False;emissionAlphaGrayscale;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;548;-1073.363,1521.274;Inherit;False;120;alphaSoftness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;517;-1015.587,1353.922;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;539;-1131.529,1446.113;Inherit;False;538;emissionAlphaGrayscale;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-840.3558,1355.006;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;526;-454.2767,145.8266;Inherit;False;emissionColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;545;-493.8656,1296.229;Inherit;False;526;emissionColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;515;-681.6761,1523.312;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;557;-508.2411,1413.709;Inherit;False;Property;_brightnessMinimum;brightnessMinimum;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;556;-509.2411,1488.709;Inherit;False;Property;_brightnessMaximum;brightnessMaximum;3;0;Create;True;0;0;False;0;False;0;16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;507;-267.8954,1388.111;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;554;-68.61707,1524.185;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;513;-32.25184,1296.236;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;555;-520.2713,1591.061;Inherit;False;emissionAlphaFinal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;277;1860.513,349.9962;Inherit;False;648.6185;488;ResultingShader;4;131;133;0;558;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;549;128.7638,1296.222;Inherit;False;emissionColorFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosVertexDataNode;264;-1461.573,-330.8532;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-1290.772,-320.5703;Inherit;False;vertexWorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;1921.921,442.9052;Inherit;False;549;emissionColorFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;1921.705,581.6542;Inherit;False;555;emissionAlphaFinal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;558;1923.714,662.2966;Inherit;False;528;emissionAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;447;-1061.46,-349.3803;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;449;-869.3557,-354.2069;Inherit;False;vertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1275.829,-99.58866;Inherit;False;alphaVertex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2253.931,399.9963;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpareParts/VertexColor_Transparent_Aditive;False;False;False;False;True;True;True;True;True;False;False;False;False;False;True;True;False;False;True;True;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;5;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;111;2;116;0
WireConnection;105;0;2;0
WireConnection;117;0;116;0
WireConnection;117;1;111;0
WireConnection;114;0;109;0
WireConnection;114;1;117;0
WireConnection;542;0;114;0
WireConnection;544;0;542;0
WireConnection;531;0;527;0
WireConnection;531;1;537;0
WireConnection;530;0;114;0
WireConnection;533;0;531;0
WireConnection;533;1;537;0
WireConnection;477;0;61;0
WireConnection;528;0;530;3
WireConnection;35;0;37;0
WireConnection;535;0;533;0
WireConnection;535;2;537;0
WireConnection;476;0;35;0
WireConnection;476;1;477;0
WireConnection;71;0;476;0
WireConnection;524;0;535;0
WireConnection;524;1;529;0
WireConnection;524;2;529;0
WireConnection;120;0;71;0
WireConnection;516;0;547;0
WireConnection;516;1;518;0
WireConnection;538;0;524;0
WireConnection;517;0;516;0
WireConnection;517;1;518;0
WireConnection;522;0;517;0
WireConnection;522;1;539;0
WireConnection;522;2;548;0
WireConnection;526;0;114;0
WireConnection;515;0;522;0
WireConnection;515;2;518;0
WireConnection;507;0;545;0
WireConnection;507;3;557;0
WireConnection;507;4;556;0
WireConnection;554;0;515;0
WireConnection;513;0;545;0
WireConnection;513;1;507;0
WireConnection;513;2;554;0
WireConnection;555;0;515;0
WireConnection;549;0;513;0
WireConnection;266;0;264;0
WireConnection;449;0;447;0
WireConnection;106;0;2;4
WireConnection;0;2;133;0
WireConnection;0;9;131;0
ASEEND*/
//CHKSM=763416650701CC4DF7B78589F56A3465A9A85394