// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpareParts/VertexColor_Opaque"
{
	Properties
	{
		_additiveColorAlbedo("additiveColorAlbedo", Color) = (0,0,0,0)
		_multiplyColorAlbedo("multiplyColorAlbedo", Color) = (0,0,0,0)
		_colorsWeightAlbedo("colorsWeightAlbedo", Range( 0 , 1)) = 0.5
		[HDR]_textureAlbedo("textureAlbedo", 2D) = "white" {}
		_aditiveColorEmission("aditiveColorEmission", Color) = (0,0,0,0)
		_multiplyColorEmission("multiplyColorEmission", Color) = (0,0,0,0)
		_colorsWeightEmission("colorsWeightEmission", Range( 0 , 1)) = 0.5
		_emissionBrightness("emissionBrightness", Range( 0 , 16)) = 0
		[HDR]_textureEmission("textureEmission", 2D) = "black" {}
		_metalness("metalness", Range( 0 , 1)) = 0
		_smoothness("smoothness", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite On
		ZTest LEqual
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _additiveColorAlbedo;
		uniform sampler2D _textureAlbedo;
		uniform float4 _textureAlbedo_ST;
		uniform float4 _multiplyColorAlbedo;
		uniform float _colorsWeightAlbedo;
		uniform sampler2D _textureEmission;
		uniform float4 _textureEmission_ST;
		uniform float4 _aditiveColorEmission;
		uniform float4 _multiplyColorEmission;
		uniform float _colorsWeightEmission;
		uniform float _emissionBrightness;
		uniform float _metalness;
		uniform float _smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv0_textureAlbedo = i.uv_texcoord * _textureAlbedo_ST.xy + _textureAlbedo_ST.zw;
			float4 tex2DNode12 = tex2D( _textureAlbedo, uv0_textureAlbedo );
			float4 temp_output_52_0 = ( _additiveColorAlbedo + tex2DNode12 );
			float grayscale64 = (temp_output_52_0.rgb.r + temp_output_52_0.rgb.g + temp_output_52_0.rgb.b) / 3;
			float4 temp_cast_1 = (grayscale64).xxxx;
			float4 lerpResult54 = lerp( (float4( 0,0,0,0 ) + (temp_output_52_0 - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (temp_cast_1 - float4( 0,0,0,0 ))) , ( tex2DNode12 * _multiplyColorAlbedo ) , _colorsWeightAlbedo);
			o.Albedo = ( lerpResult54 * i.vertexColor ).rgb;
			float2 uv0_textureEmission = i.uv_texcoord * _textureEmission_ST.xy + _textureEmission_ST.zw;
			float4 tex2DNode16 = tex2D( _textureEmission, uv0_textureEmission );
			float4 temp_output_66_0 = ( tex2DNode16 + _aditiveColorEmission );
			float grayscale69 = (temp_output_66_0.rgb.r + temp_output_66_0.rgb.g + temp_output_66_0.rgb.b) / 3;
			float4 temp_cast_4 = (grayscale69).xxxx;
			float4 lerpResult72 = lerp( (float4( 0,0,0,0 ) + (temp_output_66_0 - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (temp_cast_4 - float4( 0,0,0,0 ))) , ( _multiplyColorEmission * tex2DNode16 ) , _colorsWeightEmission);
			o.Emission = ( ( i.vertexColor * lerpResult72 ) * _emissionBrightness ).rgb;
			o.Metallic = _metalness;
			o.Smoothness = _smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
613.6;111.2;805;644;2026.067;690.2081;2.023485;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1397.315,432.7399;Inherit;True;Property;_textureEmission;textureEmission;8;1;[HDR];Create;True;0;0;False;0;None;None;False;black;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1405.238,-229.5591;Inherit;True;Property;_textureAlbedo;textureAlbedo;3;1;[HDR];Create;True;0;0;False;0;None;None;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-1138.319,495.1146;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1163.476,-167.0332;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-914.6288,429.5592;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;74;-858.322,623.1791;Inherit;False;Property;_aditiveColorEmission;aditiveColorEmission;4;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-955.9468,-230.5684;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-879.146,-401.5213;Inherit;False;Property;_additiveColorAlbedo;additiveColorAlbedo;0;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;66;-601.36,549.4016;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-639.9586,-347.4752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;69;-480.4372,610.5311;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-861.8784,258.2863;Inherit;False;Property;_multiplyColorEmission;multiplyColorEmission;5;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;70;-291.4421,549.4017;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;-871.3948,-44.09663;Inherit;False;Property;_multiplyColorAlbedo;multiplyColorAlbedo;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-603.8043,411.6978;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-385.9081,730.6525;Inherit;False;Property;_colorsWeightEmission;colorsWeightEmission;6;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;64;-519.0359,-286.3457;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-635.0662,-70.69427;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-387.8773,10.90026;Inherit;False;Property;_colorsWeightAlbedo;colorsWeightAlbedo;2;0;Create;True;0;0;False;0;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;56;-313.3673,-350.8098;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;-69.42879,385.5403;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;2;-120.0033,136.1914;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;54;-79.79897,-94.06738;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;96.42567,185.8143;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;76;260.1245,247.4854;Inherit;False;Property;_emissionBrightness;emissionBrightness;7;0;Create;True;0;0;False;0;0;0;0;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;96.59694,78.98232;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;470.9969,429.9139;Inherit;False;Property;_smoothness;smoothness;10;0;Create;True;0;0;False;0;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;466.9494,352.1911;Inherit;False;Property;_metalness;metalness;9;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;554.7858,182.0053;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;794.2535,98.50452;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SpareParts/VertexColor_Opaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;1;False;-1;3;False;-1;False;0;False;-1;-0.05;False;-1;False;0;Opaque;5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;0;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;1;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;17;2;18;0
WireConnection;15;2;10;0
WireConnection;16;0;18;0
WireConnection;16;1;17;0
WireConnection;12;0;10;0
WireConnection;12;1;15;0
WireConnection;66;0;16;0
WireConnection;66;1;74;0
WireConnection;52;0;4;0
WireConnection;52;1;12;0
WireConnection;69;0;66;0
WireConnection;70;0;66;0
WireConnection;70;2;69;0
WireConnection;19;0;8;0
WireConnection;19;1;16;0
WireConnection;64;0;52;0
WireConnection;11;0;12;0
WireConnection;11;1;53;0
WireConnection;56;0;52;0
WireConnection;56;2;64;0
WireConnection;72;0;70;0
WireConnection;72;1;19;0
WireConnection;72;2;71;0
WireConnection;54;0;56;0
WireConnection;54;1;11;0
WireConnection;54;2;65;0
WireConnection;6;0;2;0
WireConnection;6;1;72;0
WireConnection;5;0;54;0
WireConnection;5;1;2;0
WireConnection;75;0;6;0
WireConnection;75;1;76;0
WireConnection;0;0;5;0
WireConnection;0;2;75;0
WireConnection;0;3;51;0
WireConnection;0;4;50;0
ASEEND*/
//CHKSM=5ED02802D5A92305CA15CA44EE6ABD4E62BFC1E1