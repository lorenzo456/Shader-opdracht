Shader "Custom/les4" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_NormalMap("NormalMap", 2D) = "blue" {}
	_NormalInfluence("Normal Influence", Range(0,1)) = 1
		_RimPower("Rim Power", Range(0 ,16)) = 8
	}
		SubShader{
		Tags
	{
		"RenderType" = "Transparent"
		"Queue" = "Transparent"
	}
		LOD 200

		GrabPass{}

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
#pragma target 3.0

		sampler2D _MainTex;
	sampler2D _GrabTexture;
	sampler2D _NormalMap;

	half _NormalInfluence;

	struct Input {
		float2 uv_MainTex;
		float4 screenPos;
		float3 worldPos;
		float3 viewDir;
		float3 worldNormal;
	};

	half _Glossiness;
	half _Metallic;
	fixed4 _Color;

	half _RimPower;

	void surf(Input IN, inout SurfaceOutputStandard o)
	{
		half2 uv = IN.screenPos.xy / IN.screenPos.w;
		//half2 uv = IN.worldPos.yz;

		//animeren!
		//uv.x += sin(_Time.z) * .1;
		//uv.y += cos(_Time.z) *.1;

		half3 norm = tex2D(_NormalMap, IN.uv_MainTex + half2(_Time.x, 0));
		half3 norm2 = tex2D(_NormalMap, IN.uv_MainTex * .5 + half2(0, _Time.x * .95));
		norm = norm * 2 - 1;
		norm2 = norm2 * 2 - 1;

		//op basis van normal!
		half2 offset = (norm.rg + norm2.rg) * .5 * _NormalInfluence;

		// Albedo comes from a texture tinted by color
		fixed4 c = tex2D(_GrabTexture, uv + offset);//* _Color;
		o.Albedo = c.rgb;
		// Metallic and smoothness come from slider variables
		o.Metallic = _Metallic;
		o.Smoothness = _Glossiness;
		o.Alpha = c.a;

		//RIM LIGHTING
		float dotProduct = dot(IN.viewDir, IN.worldNormal + half3(offset, 0));
		//invert, so we get 1 at edge
		dotProduct = abs(1 - dotProduct); //abs only if rendering inside of objects
										  //doe dotProduct acht keer, keer zichzelf
		dotProduct = pow(dotProduct, _RimPower);

		o.Emission = dotProduct * _Color.rgb;
	}
	ENDCG
	}
		FallBack "Diffuse"
}








