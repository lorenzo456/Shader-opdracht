Shader "Custom/StarShader" {
	Properties{
	_Color("Color", Color) = (1,1,1,1)
	_MainTex("Texture", 2D) = "white" {}
	_RimColor("Rim Color", Color) = (0.26,0.19,0.16,0.0)
	_RimPower("Rim Power", Range(0.1,2.0)) = 1.0
	_RimSpeed("Rim Speed", Range(0,1.0)) = 1.0
	_XScrollSpeed("X Scroll Speed", Float) = 1
	_YScrollSpeed("Y Scroll Speed", Float) = 1

	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		CGPROGRAM
#pragma surface surf Lambert
		float _XScrollSpeed;
	float _YScrollSpeed;
	struct Input {
		float2 uv_MainTex;
		float2 uv_SubTex;
		float3 viewDir;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
	};
	sampler2D _MainTex;
	sampler2D _SubTex;
	float4 _RimColor;
	float _RimPower;
	fixed4 _Color;
	float _RimSpeed;

	void surf(Input IN, inout SurfaceOutput o) {
		fixed2 scrollUV = IN.uv_MainTex;
		fixed xScrollValue = _XScrollSpeed * _Time.x;
		fixed yScrollValue = _YScrollSpeed * _Time.x;
		scrollUV += fixed2(xScrollValue, yScrollValue);

		half4 c = tex2D(_MainTex, scrollUV);

		o.Albedo = c.rgb;
		o.Alpha = c.a;

		half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
		o.Emission = _RimColor.rgb * pow(rim, _RimPower += sin(_Time.y) * _RimSpeed);
	}
	ENDCG
	}
		Fallback "Diffuse"
}
