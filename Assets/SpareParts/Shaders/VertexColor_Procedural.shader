// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/VertexColor_Procedural"
{
	Properties
	{
		_tillingX("tillingX", Float) = 0
		_tillingY("tillingY", Float) = 0
		_offsetX("offsetX", Float) = 0
		_offsetY("offsetY", Float) = 0
		[HDR]_colorAlbedo("colorAlbedo", Color) = (0,0,0,0)
		_smoothStepAlbedoMin("smoothStepAlbedoMin", Float) = 0
		_smoothStepAlbedoMax("smoothStepAlbedoMax", Float) = 0
		[HDR]_colorEmission("colorEmission", Color) = (0,0,0,0)
		_smoothStepEmissonMin("smoothStepEmissonMin", Float) = 0
		_smoothStepEmissionMax("smoothStepEmissionMax", Float) = 0
		_noiseScale("noiseScale", Float) = 0
		_softness("softness", Float) = 0
		_softnessRange("softnessRange", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 screenPosition35;
		};

		uniform float4 _colorAlbedo;
		uniform float _smoothStepAlbedoMin;
		uniform float _smoothStepAlbedoMax;
		uniform float _tillingX;
		uniform float _tillingY;
		uniform float _offsetX;
		uniform float _offsetY;
		uniform float _noiseScale;
		uniform float _smoothStepEmissonMin;
		uniform float _smoothStepEmissionMax;
		uniform float4 _colorEmission;
		uniform float _softnessRange;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _softness;


		//https://www.shadertoy.com/view/XdXGW8
		float2 GradientNoiseDir( float2 x )
		{
			const float2 k = float2( 0.3183099, 0.3678794 );
			x = x * k + k.yx;
			return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
		}
		
		float GradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );
			return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
					lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos35 = ase_vertex3Pos;
			float4 ase_screenPos35 = ComputeScreenPos( UnityObjectToClipPos( vertexPos35 ) );
			o.screenPosition35 = ase_screenPos35;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 appendResult78 = (float2(_tillingX , _tillingY));
			float2 appendResult79 = (float2(_offsetX , _offsetY));
			float2 uv_TexCoord74 = i.uv_texcoord * appendResult78 + appendResult79;
			float temp_output_75_0 = length( uv_TexCoord74 );
			float smoothstepResult84 = smoothstep( _smoothStepAlbedoMin , _smoothStepAlbedoMax , temp_output_75_0);
			float gradientNoise90 = GradientNoise(uv_TexCoord74,_noiseScale);
			gradientNoise90 = gradientNoise90*0.5 + 0.5;
			float lerpResult92 = lerp( smoothstepResult84 , gradientNoise90 , smoothstepResult84);
			float4 temp_output_5_0 = ( _colorAlbedo * smoothstepResult84 * lerpResult92 * i.vertexColor );
			o.Albedo = temp_output_5_0.rgb;
			float smoothstepResult87 = smoothstep( _smoothStepEmissonMin , _smoothStepEmissionMax , temp_output_75_0);
			float lerpResult93 = lerp( smoothstepResult87 , gradientNoise90 , smoothstepResult87);
			float4 temp_output_6_0 = ( i.vertexColor * lerpResult93 * smoothstepResult87 * _colorEmission );
			o.Emission = temp_output_6_0.rgb;
			float4 ase_screenPos35 = i.screenPosition35;
			float4 ase_screenPosNorm35 = ase_screenPos35 / ase_screenPos35.w;
			ase_screenPosNorm35.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm35.z : ase_screenPosNorm35.z * 0.5 + 0.5;
			float screenDepth35 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm35.xy ));
			float distanceDepth35 = abs( ( screenDepth35 - LinearEyeDepth( ase_screenPosNorm35.z ) ) / ( _softness ) );
			float smoothstepResult71 = smoothstep( ( _softnessRange * -128.0 ) , ( _softnessRange * 128.0 ) , distanceDepth35);
			o.Alpha = ( temp_output_5_0 * temp_output_6_0 * smoothstepResult71 ).a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

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
				float4 customPack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;
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
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack2.xyzw = customInputData.screenPosition35;
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
				surfIN.screenPosition35 = IN.customPack2.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
Version=17800
428.8;148.8;964;667;1951.199;915.3115;2.619185;True;False
Node;AmplifyShaderEditor.RangedFloatNode;80;-1854.357,34.67151;Inherit;False;Property;_tillingX;tillingX;0;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-1854.357,109.6714;Inherit;False;Property;_tillingY;tillingY;1;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1866.357,183.6715;Inherit;False;Property;_offsetX;offsetX;2;0;Create;True;0;0;False;0;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1867.357,258.6714;Inherit;False;Property;_offsetY;offsetY;3;0;Create;True;0;0;False;0;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;78;-1728.048,57.49534;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;79;-1728.048,201.4953;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-1516.517,32.51221;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;-0.5,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;88;-1090.495,364.0294;Inherit;False;Property;_smoothStepEmissionMax;smoothStepEmissionMax;9;0;Create;True;0;0;False;0;0;-0.125;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;75;-1280.063,220.8615;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1110.28,-17.11655;Inherit;False;Property;_smoothStepAlbedoMax;smoothStepAlbedoMax;6;0;Create;True;0;0;False;0;0;-0.125;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1092.994,281.7858;Inherit;False;Property;_smoothStepEmissonMin;smoothStepEmissonMin;8;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-969.2415,104.9241;Inherit;False;Property;_noiseScale;noiseScale;10;0;Create;True;0;0;False;0;0;16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-1116.186,-97.26952;Inherit;False;Property;_smoothStepAlbedoMin;smoothStepAlbedoMin;5;0;Create;True;0;0;False;0;0;0.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;90;-813.5359,21.71359;Inherit;False;Gradient;True;False;2;0;FLOAT2;4,4;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1001.823,836.524;Inherit;False;Property;_softness;softness;11;0;Create;True;0;0;False;0;0;0.025;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;84;-819.6771,-205.2748;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-762.7932,814.0626;Inherit;False;Property;_softnessRange;softnessRange;12;0;Create;True;0;0;False;0;0;0.125;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;38;-1010.221,696.363;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;87;-810.177,218.5253;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;93;-567.3574,139.6383;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;92;-565.8234,-143.6312;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-460.3048,763.941;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-128;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-465.3048,855.941;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;128;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;35;-738.2992,693.144;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;4;-595.7944,-358.5603;Inherit;False;Property;_colorAlbedo;colorAlbedo;4;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.996078,2.996078,2.996078,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;8;-584.6572,347.4864;Inherit;False;Property;_colorEmission;colorEmission;7;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-566.0126,-25.15023;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-337.8742,-227.7003;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;-302.433,695.0818;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;16;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-330.8065,175.0648;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;23.08082,143.2785;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;22;161.2903,139.7493;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;410.9444,-222.6029;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SpareParts/VertexColor_Procedural;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;3;False;-1;True;0;False;-1;0;False;-1;False;7;Transparent;5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;78;0;80;0
WireConnection;78;1;81;0
WireConnection;79;0;82;0
WireConnection;79;1;83;0
WireConnection;74;0;78;0
WireConnection;74;1;79;0
WireConnection;75;0;74;0
WireConnection;90;0;74;0
WireConnection;90;1;91;0
WireConnection;84;0;75;0
WireConnection;84;1;85;0
WireConnection;84;2;86;0
WireConnection;87;0;75;0
WireConnection;87;1;89;0
WireConnection;87;2;88;0
WireConnection;93;0;87;0
WireConnection;93;1;90;0
WireConnection;93;2;87;0
WireConnection;92;0;84;0
WireConnection;92;1;90;0
WireConnection;92;2;84;0
WireConnection;72;0;61;0
WireConnection;73;0;61;0
WireConnection;35;1;38;0
WireConnection;35;0;37;0
WireConnection;5;0;4;0
WireConnection;5;1;84;0
WireConnection;5;2;92;0
WireConnection;5;3;2;0
WireConnection;71;0;35;0
WireConnection;71;1;72;0
WireConnection;71;2;73;0
WireConnection;6;0;2;0
WireConnection;6;1;93;0
WireConnection;6;2;87;0
WireConnection;6;3;8;0
WireConnection;21;0;5;0
WireConnection;21;1;6;0
WireConnection;21;2;71;0
WireConnection;22;0;21;0
WireConnection;0;0;5;0
WireConnection;0;2;6;0
WireConnection;0;9;22;3
ASEEND*/
//CHKSM=865FE83371B0230F91491B73CC67766829BB4160