Shader "Custom/test" {
	Properties{
		_MainTex("Base (RGB)", 2D) = "white" {}
	_XScrollSpeed("X Scroll Speed", Float) = 1
		_YScrollSpeed("Y Scroll Speed", Float) = 1

	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 200

		CGPROGRAM
#pragma surface surf Lambert

		sampler2D _MainTex;
	float _XScrollSpeed;
	float _YScrollSpeed;

	struct Input {
		float2 uv_MainTex;
	};

	void surf(Input IN, inout SurfaceOutput o) {
		fixed2 scrollUV = IN.uv_MainTex;
		fixed xScrollValue = _XScrollSpeed * _Time.x;
		fixed yScrollValue = _YScrollSpeed * _Time.x;
		scrollUV += fixed2(xScrollValue, yScrollValue);
		half4 c = tex2D(_MainTex, scrollUV);
		o.Albedo = c.rgb;
		o.Alpha = c.a;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
