// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/VertexColor_BirghtnessFalloff"
{
	Properties
	{
		_VertexStreamsWeight("_VertexStreamsWeight", Float) = 0
		_MainTex("_MainTex", 2D) = "white" {}
		_0Z_ProceduralTextureOpacity("_0Z_ProceduralTextureOpacity", Float) = 0
		_1X_tilingX("_1X_tilingX", Range( -4 , 4)) = 0
		_1Y_tilingY("_1Y_tilingY", Range( -4 , 4)) = 0
		_1Z_offsetX("_1Z_offsetX", Range( -4 , 4)) = 0
		_1W_offsetY("_1W_offsetY", Range( -4 , 4)) = 0
		_proceduralTextureFalloff("proceduralTextureFalloff", Range( 0 , 32)) = 0
		_brightnessMinimum("brightnessMinimum", Range( 0 , 2048)) = 0
		_brightnessMaximum("brightnessMaximum", Range( 0 , 2048)) = 0
		_falloffIntensity("falloffIntensity", Range( 0 , 1)) = 0
		_alphaFalloff("alphaFalloff", Range( 0 , 8)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha , OneMinusDstColor One
		
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 uv_tex4coord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _1X_tilingX;
		uniform float _VertexStreamsWeight;
		uniform float _1Y_tilingY;
		uniform float _1Z_offsetX;
		uniform float _1W_offsetY;
		uniform float _proceduralTextureFalloff;
		uniform float _0Z_ProceduralTextureOpacity;
		uniform float _alphaFalloff;
		uniform float _falloffIntensity;
		uniform float _brightnessMinimum;
		uniform float _brightnessMaximum;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float useVertexStreams69 = _VertexStreamsWeight;
			float lerpResult81 = lerp( _1X_tilingX , i.uv2_tex4coord2.x , useVertexStreams69);
			float lerpResult83 = lerp( _1Y_tilingY , i.uv2_tex4coord2.x , useVertexStreams69);
			float2 appendResult47 = (float2(lerpResult81 , lerpResult83));
			float lerpResult88 = lerp( _1Z_offsetX , i.uv2_tex4coord2.x , useVertexStreams69);
			float lerpResult89 = lerp( _1W_offsetY , i.uv2_tex4coord2.x , useVertexStreams69);
			float2 appendResult55 = (float2(lerpResult88 , lerpResult89));
			float2 uv_TexCoord46 = i.uv_texcoord * appendResult47 + appendResult55;
			float temp_output_28_0 = ( 1.0 - saturate( length( uv_TexCoord46 ) ) );
			float smoothstepResult76 = smoothstep( 0.0 , 1.0 , temp_output_28_0);
			float saferPower30 = max( ( smoothstepResult76 * temp_output_28_0 ) , 0.0001 );
			float temp_output_30_0 = pow( saferPower30 , _proceduralTextureFalloff );
			float4 temp_cast_0 = (temp_output_30_0).xxxx;
			float lerpResult66 = lerp( _0Z_ProceduralTextureOpacity , i.uv_tex4coord.z , useVertexStreams69);
			float4 lerpResult59 = lerp( ( tex2D( _MainTex, uv0_MainTex ) * temp_output_30_0 ) , temp_cast_0 , lerpResult66);
			float4 proceduralFalloff36 = lerpResult59;
			float4 temp_output_41_0 = ( i.vertexColor * proceduralFalloff36 );
			float4 temp_cast_1 = (_alphaFalloff).xxxx;
			float4 temp_output_38_0 = ( i.vertexColor.a * proceduralFalloff36 );
			float4 saferPower12 = max( temp_output_38_0 , 0.0001 );
			float4 temp_cast_2 = (_alphaFalloff).xxxx;
			float4 smoothstepResult15 = smoothstep( float4( 0,0,0,0 ) , temp_cast_1 , ( pow( saferPower12 , temp_cast_2 ) * _alphaFalloff ));
			float4 lerpResult9 = lerp( temp_output_41_0 , ( temp_output_41_0 * smoothstepResult15 ) , _falloffIntensity);
			float4 temp_cast_3 = (_brightnessMinimum).xxxx;
			float4 temp_cast_4 = (_brightnessMaximum).xxxx;
			o.Emission = (temp_cast_3 + (lerpResult9 - float4( 0,0,0,0 )) * (temp_cast_4 - temp_cast_3) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))).rgb;
			float4 lerpResult19 = lerp( temp_output_38_0 , smoothstepResult15 , _falloffIntensity);
			o.Alpha = lerpResult19.r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
571.2;206.4;944;600;4245.266;770.652;4.580486;True;False
Node;AmplifyShaderEditor.RangedFloatNode;68;-2864.321,-194.1607;Inherit;False;Property;_VertexStreamsWeight;_VertexStreamsWeight;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-2588.652,-201.7016;Inherit;False;useVertexStreams;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-4143.004,-676.5338;Inherit;False;Property;_1Z_offsetX;_1Z_offsetX;6;0;Create;True;0;0;False;0;False;0;0;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;86;-4077.435,-594.165;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;91;-4118.01,-67.30573;Inherit;False;69;useVertexStreams;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-4104.476,-431.462;Inherit;False;69;useVertexStreams;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-4112.963,-791.2487;Inherit;False;69;useVertexStreams;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;90;-4090.97,-230.0088;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-4156.697,-1045.526;Inherit;False;Property;_1Y_tilingY;_1Y_tilingY;5;0;Create;True;0;0;False;0;False;0;0;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;80;-4073.655,-1313.163;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-4134.702,-1396.214;Inherit;False;Property;_1X_tilingX;_1X_tilingX;4;0;Create;True;0;0;False;0;False;0;0;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-4100.697,-1150.46;Inherit;False;69;useVertexStreams;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-4144.565,-313.1626;Inherit;False;Property;_1W_offsetY;_1W_offsetY;7;0;Create;True;0;0;False;0;False;0;0;-4;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;84;-4085.922,-953.9517;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;81;-3817.229,-1389.94;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;83;-3815.176,-1051.413;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;89;-3820.225,-327.4699;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;88;-3806.689,-691.6262;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;47;-3268.22,-927.7091;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-3270.727,-784.4167;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3130.5,-920.6721;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0,1;False;1;FLOAT2;0,-0.5;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;24;-2918.84,-920.6918;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;43;-2759.362,-917.1061;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;28;-2594.462,-918.3499;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;62;-2581.471,-1287.589;Inherit;True;Property;_MainTex;_MainTex;1;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SmoothstepOpNode;76;-2425.961,-992.7413;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-2312.704,-1223.572;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;31;-2421.762,-824.001;Inherit;False;Property;_proceduralTextureFalloff;proceduralTextureFalloff;8;0;Create;True;0;0;False;0;False;0;2;0;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-2254.542,-944.1873;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;-1882.48,-846.6949;Inherit;False;Property;_0Z_ProceduralTextureOpacity;_0Z_ProceduralTextureOpacity;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-1866.65,-608.5048;Inherit;False;69;useVertexStreams;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;63;-2073.248,-1288.87;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;58;-1831.967,-770.9892;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;30;-2117.525,-921.1173;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1746.86,-1205.328;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;66;-1562.503,-846.2481;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;59;-1370.966,-947.3465;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-1191.783,-951.7142;Inherit;True;proceduralFalloff;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-1989.001,-95.97998;Inherit;False;36;proceduralFalloff;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;2;-2160.978,-159.2568;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-1755,67.62732;Inherit;False;Property;_alphaFalloff;alphaFalloff;12;0;Create;True;0;0;False;0;False;0;2;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1752.052,-61.25757;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;12;-1404,-67.3727;Inherit;False;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1246.356,-67.1994;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;15;-1115.9,-68.37271;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-1754.156,-157.0975;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-805.2878,-92.87271;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1057.6,145.6142;Inherit;False;Property;_falloffIntensity;falloffIntensity;11;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-522.5671,-81.13002;Inherit;False;Property;_brightnessMinimum;brightnessMinimum;9;0;Create;True;0;0;False;0;False;0;0;0;2048;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;9;-651.2958,-154.2925;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-521.267,-1.829955;Inherit;False;Property;_brightnessMaximum;brightnessMaximum;10;0;Create;True;0;0;False;0;False;0;2;0;2048;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-639.2429,101.8154;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;8;-249.5666,-152.6299;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;4;102.4505,-84.46111;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;SpareParts/VertexColor_BirghtnessFalloff;False;False;False;False;True;True;True;True;True;False;False;False;False;False;True;True;False;False;False;False;False;Off;1;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;5;4;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;69;0;68;0
WireConnection;81;0;57;0
WireConnection;81;1;80;1
WireConnection;81;2;82;0
WireConnection;83;0;54;0
WireConnection;83;1;84;1
WireConnection;83;2;85;0
WireConnection;89;0;56;0
WireConnection;89;1;90;1
WireConnection;89;2;91;0
WireConnection;88;0;53;0
WireConnection;88;1;86;1
WireConnection;88;2;87;0
WireConnection;47;0;81;0
WireConnection;47;1;83;0
WireConnection;55;0;88;0
WireConnection;55;1;89;0
WireConnection;46;0;47;0
WireConnection;46;1;55;0
WireConnection;24;0;46;0
WireConnection;43;0;24;0
WireConnection;28;0;43;0
WireConnection;76;0;28;0
WireConnection;64;2;62;0
WireConnection;77;0;76;0
WireConnection;77;1;28;0
WireConnection;63;0;62;0
WireConnection;63;1;64;0
WireConnection;30;0;77;0
WireConnection;30;1;31;0
WireConnection;75;0;63;0
WireConnection;75;1;30;0
WireConnection;66;0;67;0
WireConnection;66;1;58;3
WireConnection;66;2;70;0
WireConnection;59;0;75;0
WireConnection;59;1;30;0
WireConnection;59;2;66;0
WireConnection;36;0;59;0
WireConnection;38;0;2;4
WireConnection;38;1;37;0
WireConnection;12;0;38;0
WireConnection;12;1;13;0
WireConnection;10;0;12;0
WireConnection;10;1;13;0
WireConnection;15;0;10;0
WireConnection;15;2;13;0
WireConnection;41;0;2;0
WireConnection;41;1;37;0
WireConnection;16;0;41;0
WireConnection;16;1;15;0
WireConnection;9;0;41;0
WireConnection;9;1;16;0
WireConnection;9;2;11;0
WireConnection;19;0;38;0
WireConnection;19;1;15;0
WireConnection;19;2;11;0
WireConnection;8;0;9;0
WireConnection;8;3;5;0
WireConnection;8;4;6;0
WireConnection;4;2;8;0
WireConnection;4;9;19;0
ASEEND*/
//CHKSM=37EAFB0282F418A64AA94E3977B2C4FE9CA2663E