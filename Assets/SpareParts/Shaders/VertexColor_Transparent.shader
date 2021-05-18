// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/VertexColor_Transparent"
{
	Properties
	{
		_colorEmission("colorEmission", Color) = (0,0,0,0)
		_textureEmission("textureEmission", 2D) = "white" {}
		_softnessDistance("softnessDistance", Float) = 0
		_softnessRange("softnessRange", Range( 0 , 1)) = 0
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
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
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap vertex:vertexDataFunc 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 uv_tex4coord;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _colorEmission;
		uniform sampler2D _textureEmission;
		uniform float4 _textureEmission_ST;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _softnessDistance;
		uniform float _softnessRange;


		float3 mod3D289( float3 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 mod3D289( float4 x ) { return x - floor( x / 289.0 ) * 289.0; }

		float4 permute( float4 x ) { return mod3D289( ( x * 34.0 + 1.0 ) * x ); }

		float4 taylorInvSqrt( float4 r ) { return 1.79284291400159 - r * 0.85373472095314; }

		float snoise( float3 v )
		{
			const float2 C = float2( 1.0 / 6.0, 1.0 / 3.0 );
			float3 i = floor( v + dot( v, C.yyy ) );
			float3 x0 = v - i + dot( i, C.xxx );
			float3 g = step( x0.yzx, x0.xyz );
			float3 l = 1.0 - g;
			float3 i1 = min( g.xyz, l.zxy );
			float3 i2 = max( g.xyz, l.zxy );
			float3 x1 = x0 - i1 + C.xxx;
			float3 x2 = x0 - i2 + C.yyy;
			float3 x3 = x0 - 0.5;
			i = mod3D289( i);
			float4 p = permute( permute( permute( i.z + float4( 0.0, i1.z, i2.z, 1.0 ) ) + i.y + float4( 0.0, i1.y, i2.y, 1.0 ) ) + i.x + float4( 0.0, i1.x, i2.x, 1.0 ) );
			float4 j = p - 49.0 * floor( p / 49.0 );  // mod(p,7*7)
			float4 x_ = floor( j / 7.0 );
			float4 y_ = floor( j - 7.0 * x_ );  // mod(j,N)
			float4 x = ( x_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 y = ( y_ * 2.0 + 0.5 ) / 7.0 - 1.0;
			float4 h = 1.0 - abs( x ) - abs( y );
			float4 b0 = float4( x.xy, y.xy );
			float4 b1 = float4( x.zw, y.zw );
			float4 s0 = floor( b0 ) * 2.0 + 1.0;
			float4 s1 = floor( b1 ) * 2.0 + 1.0;
			float4 sh = -step( h, 0.0 );
			float4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
			float4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
			float3 g0 = float3( a0.xy, h.x );
			float3 g1 = float3( a0.zw, h.y );
			float3 g2 = float3( a1.xy, h.z );
			float3 g3 = float3( a1.zw, h.w );
			float4 norm = taylorInvSqrt( float4( dot( g0, g0 ), dot( g1, g1 ), dot( g2, g2 ), dot( g3, g3 ) ) );
			g0 *= norm.x;
			g1 *= norm.y;
			g2 *= norm.z;
			g3 *= norm.w;
			float4 m = max( 0.6 - float4( dot( x0, x0 ), dot( x1, x1 ), dot( x2, x2 ), dot( x3, x3 ) ), 0.0 );
			m = m* m;
			m = m* m;
			float4 px = float4( dot( x0, g0 ), dot( x1, g1 ), dot( x2, g2 ), dot( x3, g3 ) );
			return 42.0 * dot( m, px);
		}


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float customVertexStream_VertexOffset262 = v.texcoord1.x;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexWorldPosition266 = ase_vertex3Pos;
			float simplePerlin3D295 = snoise( vertexWorldPosition266*4.0 );
			simplePerlin3D295 = simplePerlin3D295*0.5 + 0.5;
			float vertexRandomness302 = simplePerlin3D295;
			float3 appendResult375 = (float3(v.texcoord1.y , v.texcoord1.z , v.texcoord1.w));
			float3 particleWorldPosition393 = appendResult375;
			float3 normalizeResult286 = normalize( ( vertexWorldPosition266 - particleWorldPosition393 ) );
			float3 vertexNormal452 = float3( 0,0,0 );
			float3 normalizeResult454 = normalize( ( normalizeResult286 + vertexNormal452 ) );
			float3 pushOutwards289 = ( vertexRandomness302 * normalizeResult454 * (-1.0 + (vertexRandomness302 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) );
			float3 rotatedValue317 = RotateAroundAxis( float3( 0,0,0 ), float3( 0.5,0,0 ), normalize( float3( 0,1,0 ) ), ( customVertexStream_VertexOffset262 * 0.5 ) );
			float3 rotateAroundAxis322 = rotatedValue317;
			float3 lerpResult347 = lerp( pushOutwards289 , rotateAroundAxis322 , 0.0);
			float3 vertexAnimation281 = ( customVertexStream_VertexOffset262 * lerpResult347 );
			v.vertex.xyz += vertexAnimation281;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float customVertexStream_Brightness136 = ( 1.0 + i.uv_tex4coord.w );
			float4 vertexColor105 = i.vertexColor;
			float2 uv0_textureEmission = i.uv_texcoord * _textureEmission_ST.xy + _textureEmission_ST.zw;
			float4 temp_output_114_0 = ( vertexColor105 * ( _colorEmission * tex2D( _textureEmission, uv0_textureEmission ) ) );
			float4 break478 = temp_output_114_0;
			float3 appendResult479 = (float3(break478.r , break478.g , break478.b));
			float3 normalizeResult480 = normalize( appendResult479 );
			float3 break481 = normalizeResult480;
			float smoothstepResult486 = smoothstep( 0.0 , 1.0 , pow( break481.x , 2.0 ));
			float smoothstepResult487 = smoothstep( 0.0 , 1.0 , pow( break481.y , 2.0 ));
			float smoothstepResult488 = smoothstep( 0.0 , 1.0 , pow( break481.z , 2.0 ));
			float3 appendResult489 = (float3(smoothstepResult486 , smoothstepResult487 , smoothstepResult488));
			float grayscale490 = Luminance(appendResult489);
			float smoothstepResult499 = smoothstep( 0.0 , 1.0 , pow( break478.a , 2.0 ));
			float lerpResult494 = lerp( grayscale490 , break478.a , smoothstepResult499);
			float alphaEmission118 = lerpResult494;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth35 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth35 = abs( ( screenDepth35 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _softnessDistance ) );
			float smoothstepResult71 = smoothstep( 0.0 , 1.0 , pow( distanceDepth35 , (0.0 + (_softnessRange - 0.0) * (16.0 - 0.0) / (1.0 - 0.0)) ));
			float alphaSoftness120 = smoothstepResult71;
			float alphaFinal127 = ( alphaEmission118 * alphaSoftness120 );
			float4 emission115 = ( ( customVertexStream_Brightness136 * temp_output_114_0 ) * alphaFinal127 );
			o.Emission = emission115.rgb;
			o.Alpha = alphaFinal127;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
259.2;59.2;1177;719;4728.652;822.1745;5.356682;True;False
Node;AmplifyShaderEditor.CommentaryNode;282;-2084.643,16.95438;Inherit;False;3853.016;1504.061;Shading;4;119;108;505;504;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;108;-2037.072,67.57071;Inherit;False;3797.503;1090.298;Emission;11;115;114;109;112;110;117;111;116;492;503;506;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;116;-1998.219,391.5593;Inherit;True;Property;_textureEmission;textureEmission;1;0;Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;276;-1480.237,-398.887;Inherit;False;805.3458;388.7928;Vertex Parameters;7;447;449;106;105;2;266;264;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;111;-1737.689,460.2416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-1463.795,-186.6788;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;105;-1272.326,-192.3676;Inherit;False;vertexColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;110;-1432.763,210.3097;Inherit;False;Property;_colorEmission;colorEmission;0;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;117;-1509.13,390.681;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;109;-1406.184,134.1639;Inherit;False;105;vertexColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;144;-654.7726,-788.6081;Inherit;False;827.74;775.2599; (Custom Vertex Stream sent by Particle System);6;136;135;262;143;393;475;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1206.682,373.6361;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;492;-928.0564,445.3937;Inherit;False;1673.238;702.4022;Alpha From GrayScale;7;498;496;491;495;478;493;502;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;475;-638.6573,-280.8973;Inherit;False;400.695;254;Center of Particle Mesh;2;374;375;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1057.748,348.4066;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;478;-878.0564,601.022;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TexCoordVertexDataNode;374;-619.8265,-229.6505;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;493;-638.2893,485.2068;Inherit;False;1179.051;411.3856;Smooth grayscaling;12;490;489;488;486;487;484;483;482;481;485;480;479;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;479;-627.507,627.5081;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;297;-1414.622,2154.317;Inherit;False;1311.589;648.7939;Push Outwards;6;289;288;304;468;456;399;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;264;-1461.573,-330.8532;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;375;-363.853,-183.7013;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;303;-1422.85,1861.949;Inherit;False;872.9097;265.9832;Per Vertex Randomness;4;302;398;295;397;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;480;-481.206,637.9919;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;-1290.772,-320.5703;Inherit;False;vertexWorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;399;-1400.491,2196.318;Inherit;False;587.1196;217.8582;Push away from Particle's center;4;394;284;286;283;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;393;-116.4955,-286.3299;Inherit;False;particleWorldPosition;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;397;-1412.151,1902.876;Inherit;False;266;vertexWorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BreakToComponentsNode;481;-336.1447,639.2071;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;485;-290.0146,556.3066;Inherit;False;Constant;_contrast;contrast;5;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;143;-641.9577,-514.4351;Inherit;False;475.9083;223.8256;Vertex Offset;1;141;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;394;-1392.549,2326.475;Inherit;False;393;particleWorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-1393.491,2241.318;Inherit;False;266;vertexWorldPosition;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;295;-1173.932,1901.665;Inherit;True;Simplex3D;True;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;119;-321.644,1173.264;Inherit;False;1038.979;307.7509;Softness;7;120;71;61;37;477;476;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;483;-71.14474,659.2071;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;495;-667.6151,1022.189;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;456;-1096.704,2421.815;Inherit;False;597.436;135.4071;Push towards the vertex normal;3;452;453;454;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PowerNode;484;-75.14474,778.2072;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;141;-633.6232,-465.5323;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;482;-72.14474,535.2068;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;283;-1107.063,2244.896;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;468;-912.4548,2577.686;Inherit;False;417.0767;217.3206;Invert Direction Randomly;2;474;473;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;-141.2584,-510.4162;Inherit;False;customVertexStream_VertexOffset;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;346;-1410.169,2817.87;Inherit;False;1063.758;354.2436;Rotate Around Object;4;322;317;465;457;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NormalizeNode;286;-963.2955,2243.685;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;496;-649.762,1030.078;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;486;64.9854,535.3065;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;502;199.5366,908.9103;Inherit;False;532.7783;217.0083;Smoothing alpha Interpolation to Grayscale alpha;3;500;494;499;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;452;-1082.287,2479.812;Inherit;False;vertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;487;64.9854,658.3068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;488;62.9854,777.3068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-238.2156,1320.182;Inherit;False;Property;_softnessRange;softnessRange;4;0;Create;True;0;0;False;0;0;0.05;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-217.5608,1233.318;Inherit;False;Property;_softnessDistance;softnessDistance;3;0;Create;True;0;0;False;0;0;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;302;-934.3331,1905.049;Inherit;False;vertexRandomness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;35;-35.72057,1217.264;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;473;-898.3431,2622.431;Inherit;False;302;vertexRandomness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;135;-645.6695,-736.5191;Inherit;False;475;206.2;Brightness;2;134;139;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;453;-753.8786,2461.852;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;457;-1384.233,2876.746;Inherit;False;262;customVertexStream_VertexOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;489;233.9854,629.3068;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;491;-695.1019,992.4484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;500;254.1998,999.4464;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;477;21.27942,1315.088;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;304;-767.6494,2340.669;Inherit;False;302;vertexRandomness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;474;-664.8031,2622.12;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;476;210.2794,1218.088;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;490;356.7615,622.9307;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;134;-638.6695,-696.5193;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;499;408.1682,997.7977;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;465;-1063.765,2877.36;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;454;-634.4512,2460.791;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WireNode;498;-676.5779,1001.113;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;288;-432.1373,2342.481;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;317;-896.3036,2864.409;Inherit;False;True;4;0;FLOAT3;0,1,0;False;1;FLOAT;90;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0.5,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;369.1446,1218.202;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;139;-277.5742,-695.7773;Inherit;False;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;494;583.9781,949.9894;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;505;746.2153,1178.966;Inherit;False;610.0821;157.4561;Final Opacity;3;118;21;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;503;459.2748,246.1024;Inherit;False;494.385;181.2976;adjusting HDR Brightness through Vertex Stream;2;138;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;540.446,1279.176;Inherit;False;alphaSoftness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;118;766.0118,1225.893;Inherit;False;alphaEmission;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-134.5483,-719.5473;Inherit;False;customVertexStream_Brightness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;322;-573.6248,2864.182;Inherit;False;rotateAroundAxis;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;279;-73.12603,1853.141;Inherit;False;885.8529;391.7207;VertexAnimation;7;281;330;331;347;323;293;348;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;289;-301.4541,2194.472;Inherit;False;pushOutwards;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;509.2749,296.1023;Inherit;False;136;customVertexStream_Brightness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;323;-43.41124,2076.892;Inherit;False;322;rotateAroundAxis;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-26.79896,2001.577;Inherit;False;289;pushOutwards;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;348;24.36812,2153.73;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;1010.16,1228.33;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;347;205.0198,2003.893;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;821.6306,326.9706;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;331;93.04581,1915.547;Inherit;False;262;customVertexStream_VertexOffset;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;1169.611,1219.433;Inherit;False;alphaFinal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;441.4789,1918.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;504;1359.611,324.6628;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;115;1568.923,320.006;Inherit;False;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;277;1860.513,349.9962;Inherit;False;648.6185;488;ResultingShader;4;146;131;133;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;281;600.2241,1909.331;Inherit;False;vertexAnimation;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;449;-869.3557,-354.2069;Inherit;False;vertexNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;146;1910.513,655.8183;Inherit;False;281;vertexAnimation;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;1921.705,581.6542;Inherit;False;127;alphaFinal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;398;-723.4399,1906.973;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;1921.921,442.9052;Inherit;False;115;emission;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;447;-1061.46,-349.3803;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;-1275.829,-99.58866;Inherit;False;alphaVertex;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2253.931,399.9963;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpareParts/VertexColor_Transparent;False;False;False;False;True;True;True;True;True;False;False;False;False;False;True;True;False;False;True;True;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;5;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;506;1306.611,274.6628;Inherit;False;252.4;144.8;Brightness reduced by opacity;0;;1,1,1,1;0;0
WireConnection;111;2;116;0
WireConnection;105;0;2;0
WireConnection;117;0;116;0
WireConnection;117;1;111;0
WireConnection;112;0;110;0
WireConnection;112;1;117;0
WireConnection;114;0;109;0
WireConnection;114;1;112;0
WireConnection;478;0;114;0
WireConnection;479;0;478;0
WireConnection;479;1;478;1
WireConnection;479;2;478;2
WireConnection;375;0;374;2
WireConnection;375;1;374;3
WireConnection;375;2;374;4
WireConnection;480;0;479;0
WireConnection;266;0;264;0
WireConnection;393;0;375;0
WireConnection;481;0;480;0
WireConnection;295;0;397;0
WireConnection;483;0;481;1
WireConnection;483;1;485;0
WireConnection;495;0;478;3
WireConnection;484;0;481;2
WireConnection;484;1;485;0
WireConnection;482;0;481;0
WireConnection;482;1;485;0
WireConnection;283;0;284;0
WireConnection;283;1;394;0
WireConnection;262;0;141;1
WireConnection;286;0;283;0
WireConnection;496;0;495;0
WireConnection;486;0;482;0
WireConnection;487;0;483;0
WireConnection;488;0;484;0
WireConnection;302;0;295;0
WireConnection;35;0;37;0
WireConnection;453;0;286;0
WireConnection;453;1;452;0
WireConnection;489;0;486;0
WireConnection;489;1;487;0
WireConnection;489;2;488;0
WireConnection;491;0;478;3
WireConnection;500;0;496;0
WireConnection;477;0;61;0
WireConnection;474;0;473;0
WireConnection;476;0;35;0
WireConnection;476;1;477;0
WireConnection;490;0;489;0
WireConnection;499;0;500;0
WireConnection;465;0;457;0
WireConnection;454;0;453;0
WireConnection;498;0;491;0
WireConnection;288;0;304;0
WireConnection;288;1;454;0
WireConnection;288;2;474;0
WireConnection;317;1;465;0
WireConnection;71;0;476;0
WireConnection;139;1;134;4
WireConnection;494;0;490;0
WireConnection;494;1;498;0
WireConnection;494;2;499;0
WireConnection;120;0;71;0
WireConnection;118;0;494;0
WireConnection;136;0;139;0
WireConnection;322;0;317;0
WireConnection;289;0;288;0
WireConnection;21;0;118;0
WireConnection;21;1;120;0
WireConnection;347;0;293;0
WireConnection;347;1;323;0
WireConnection;347;2;348;0
WireConnection;138;0;137;0
WireConnection;138;1;114;0
WireConnection;127;0;21;0
WireConnection;330;0;331;0
WireConnection;330;1;347;0
WireConnection;504;0;138;0
WireConnection;504;1;127;0
WireConnection;115;0;504;0
WireConnection;281;0;330;0
WireConnection;449;0;447;0
WireConnection;398;0;295;0
WireConnection;106;0;2;4
WireConnection;0;2;133;0
WireConnection;0;9;131;0
WireConnection;0;11;146;0
ASEEND*/
//CHKSM=F2D556ECC7C89DC7FA69E8983FCA46C06E4DBC77