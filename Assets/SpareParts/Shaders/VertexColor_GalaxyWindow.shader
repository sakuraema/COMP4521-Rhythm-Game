// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/Particle_Amplify_GalaxyWindow"
{
	Properties
	{
		_MainTex("_MainTex", 2D) = "white" {}
		[HDR]_colorGalaxy("colorGalaxy", Color) = (1.498039,1.498039,1.498039,1)
		[HDR]_galaxyTexture("galaxyTexture", CUBE) = "white" {}
		[HDR]_colorStars("colorStars", Color) = (1.498039,1.498039,1.498039,1)
		[HDR]_starsTexture("starsTexture", CUBE) = "white" {}
		[HDR]_colorFresnel("colorFresnel", Color) = (0,0,0,0)
		_fresnelBias("fresnelBias", Float) = 0
		_fresnelScale("fresnelScale", Float) = 0
		_fresnelPower("fresnelPower", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 viewDir;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _colorGalaxy;
		uniform samplerCUBE _galaxyTexture;
		uniform samplerCUBE _starsTexture;
		uniform float4 _colorStars;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _colorFresnel;
		uniform float _fresnelBias;
		uniform float _fresnelScale;
		uniform float _fresnelPower;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV23 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode23 = ( _fresnelBias + _fresnelScale * pow( 1.0 - fresnelNdotV23, _fresnelPower ) );
			float mulTime44 = _Time.y * 0.2;
			float2 appendResult46 = (float2(0.0 , mulTime44));
			float2 uv_TexCoord41 = i.uv_texcoord * float2( 4,4 ) + appendResult46;
			float gradientNoise40 = GradientNoise(uv_TexCoord41,1.0);
			gradientNoise40 = gradientNoise40*0.5 + 0.5;
			float4 temp_output_28_0 = ( ( ( ( _colorGalaxy * texCUBE( _galaxyTexture, i.viewDir ) ) + ( texCUBE( _starsTexture, i.viewDir ) * _colorStars ) ) * i.vertexColor ) + ( ( ( ( i.vertexColor * tex2D( _MainTex, uv0_MainTex ) ) * _colorFresnel ) * fresnelNode23 ) * gradientNoise40 ) );
			o.Emission = temp_output_28_0.rgb;
			o.Alpha = temp_output_28_0.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
				float3 worldNormal : TEXCOORD3;
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
				o.worldNormal = worldNormal;
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
				surfIN.viewDir = worldViewDir;
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
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
Version=18100
224.8;247.2;944;594;1127.742;-176.7014;1.3;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;65;-1002.617,524.5078;Inherit;True;Property;_MainTex;_MainTex;0;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-776.1179,589.4256;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1;-970.5546,-42.83881;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1002.824,-246.6801;Inherit;True;Property;_galaxyTexture;galaxyTexture;2;1;[HDR];Create;True;0;0;False;0;False;None;9718aac85c8b7ae4da6da49f69c7dad4;False;white;LockedToCube;Cube;-1;0;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.VertexColorNode;58;-284.7282,326.7529;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;44;-146.8339,1137.85;Inherit;False;1;0;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;66;-536.6749,523.7865;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1143.714,85.4596;Inherit;True;Property;_starsTexture;starsTexture;4;1;[HDR];Create;True;0;0;False;0;False;None;452e73aab56ed5b438eadce55e162455;False;white;LockedToCube;Cube;-1;0;1;SAMPLERCUBE;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-425.3313,1060.108;Inherit;False;Property;_fresnelPower;fresnelPower;8;0;Create;True;0;0;False;0;False;0;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-140.0988,705.5382;Inherit;False;Property;_colorFresnel;colorFresnel;5;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;46;57.55514,1115.479;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-414.326,971.1443;Inherit;False;Property;_fresnelScale;fresnelScale;7;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-404.326,899.1442;Inherit;False;Property;_fresnelBias;fresnelBias;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-9.851501,507.1832;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;4;-582.2422,-297.7307;Inherit;False;Property;_colorGalaxy;colorGalaxy;1;1;[HDR];Create;True;0;0;False;0;False;1.498039,1.498039,1.498039,1;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-652.7598,-118.0467;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-570.3206,283.0366;Inherit;False;Property;_colorStars;colorStars;3;1;[HDR];Create;True;0;0;False;0;False;1.498039,1.498039,1.498039,1;1.498039,1.498039,1.498039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-648.7643,86.58304;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToCube;False;Object;-1;Auto;Cube;6;0;SAMPLER2D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;23;-200.0713,885.9232;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-352.9089,-176.064;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;203.513,1091.247;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;4,4;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;192.1284,508.7201;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-345.623,92.52791;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;430.0073,1096.041;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;455.7928,863.2012;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-132.2073,-108.3198;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;762.268,682.1583;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;1.763659,-104.6988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;1132.179,-109.2657;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;60;1287.9,-6.904474;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1818.343,-148.2214;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SpareParts/Particle_Amplify_GalaxyWindow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;5;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;2;65;0
WireConnection;66;0;65;0
WireConnection;66;1;62;0
WireConnection;46;1;44;0
WireConnection;67;0;58;0
WireConnection;67;1;66;0
WireConnection;2;0;3;0
WireConnection;2;1;1;0
WireConnection;7;0;10;0
WireConnection;7;1;1;0
WireConnection;23;1;29;0
WireConnection;23;2;30;0
WireConnection;23;3;31;0
WireConnection;5;0;4;0
WireConnection;5;1;2;0
WireConnection;41;1;46;0
WireConnection;61;0;67;0
WireConnection;61;1;26;0
WireConnection;8;0;7;0
WireConnection;8;1;9;0
WireConnection;40;0;41;0
WireConnection;27;0;61;0
WireConnection;27;1;23;0
WireConnection;57;0;5;0
WireConnection;57;1;8;0
WireConnection;42;0;27;0
WireConnection;42;1;40;0
WireConnection;59;0;57;0
WireConnection;59;1;58;0
WireConnection;28;0;59;0
WireConnection;28;1;42;0
WireConnection;60;0;28;0
WireConnection;0;2;28;0
WireConnection;0;9;60;3
ASEEND*/
//CHKSM=251B4CB1851FB6DD2DD5749FFEB5FDC67F7BD6BE