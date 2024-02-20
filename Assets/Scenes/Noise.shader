//☆*: .｡. o(≧▽≦)o .｡.:*☆
//Made by: ----:Me:---- (I have ADHD);

//(And im also very handsome)


Shader "Custom/Noise"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
                
            #pragma vertex vp
            #pragma fragment fp

            #include "UnityCG.cginc"

            //Initialization of stuff
            float _Resolution; //Number of pixels 
            float _PointDensity; //Density of points of voronoi
            float _ShellDistance; //Distance between shells
            int _ShellCount; //Number of shells
            int _ShellIndex; //Index of this apperent shell


            //Entery struct for vertex programm ^_^
            struct appdata {
                float4 position : POSITION; //obviously
                float3 normal : NORMAL; // normals we need to extrude our mesh along
                float2 uv : TEXCOORD0; //Well, im doin' some drawin' here, so kinda necessary
            };

            //And for interpolated data for fragment programm ^_~
            struct v2f {
                float4 position : POSITION; //Clipped and interpolated
                float2 uv : TEXCOORD0; //Same as before, but now INTERPOLATED!
            };

            //Random function float2 -> float2, was copied from 'Book of Shaders' (Im so grateful to all of you, who worked on this book),
            //only removed last multiplier because it was ruining whole thing (dunno why ＞︿＜)
            float2 random2(float2 p) {
                return frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3)))));
            }


            //Not much going on here
            v2f vp(appdata v) {
                v2f i; //Initialization of struct for interpolated data
                float shellHeight = float(_ShellIndex) / float(_ShellCount); // height of the shell, good naming is selfexplanatory
                shellHeight = shellHeight * _ShellDistance; // we need this line because our height normalized
                v.position.xyz += v.normal.xyz * shellHeight; // extruding our mesh along normal
                i.position = UnityObjectToClipPos(v.position); //Clipping
                i.uv = v.uv; //Initializing all variables in struct, even if theyre stay the same, we dont want to leave them unintialized, do we?
                return i; // And it goes for interpolation now  ☆ﾐ(o*･ω･)ﾉ
            }

            //But here...   X﹏X
            float4 fp(v2f i) : SV_TARGET { //Target? Are we shooting someone?

                float scale_point = 1 / _PointDensity; //Size of side of one cell of grid with points for voronoi
                float scale_pixel = 1 / _Resolution; //Same here, but for grid of pixels
                float h = float(_ShellIndex) / float(_ShellCount); // height, same as in vertex program, here we want to keep it normalized

                //Idea behind this one is that you count pixel as if it was in the center of cell of pixel grid it in   (*￣▽￣)b
                float2 new_pixel = float2(
                    floor(i.uv.x / scale_pixel) * scale_pixel + scale_pixel / 2, 
                    floor(i.uv.y / scale_pixel) * scale_pixel + scale_pixel / 2
                );

                //This is center of cell of voronoi in which pixel(new_pixel to be percise) is located <(￣︶￣)>
                //Its also important to remember that this is center of cell, so we can move from it only on half of point scale
                float2 cell_center = float2(
                    floor(new_pixel.x / scale_point) * scale_point + scale_point / 2,
                    floor(new_pixel.y / scale_point) * scale_point + scale_point / 2
                );

                float m_dist = 1.; //For minimal distance between point of voronoi and pixel
                
                //Loops that checks exactly nine points in nine tiles sorrounding pixel, no more, no less (i counted for you  (>ᴗ•)   )
                for (int j = -1; j <= 1; j++) {
                    for (int k = -1; k <= 1; k++) {
                        //God how much i struggled with body of this two poor loops (╥_╥)
                        float2 neighbor = cell_center + float2(float(j) * scale_point, float(k) * scale_point); //Center of neighbouring cell
                        float2 offset_point = neighbor + random2(neighbor) * (scale_point / 2); //Point in neighbouring cell
                        offset_point.x += (scale_point / 2) * sin(_Time.y + 5 * offset_point.x); //These 2 lines make points alive  (◕‿◕)♡
                        offset_point.y += (scale_point / 2) * sin(_Time.y + offset_point.y); //I came up with these formulas with help of Book of Shaders and Desmos
                        float2 diff = offset_point - new_pixel; //diff stands for difference.
                        m_dist = min(m_dist, length(diff)); //Lastly, but not leastly, shortest distance from pixel to point   
                        //Do it 8 more times and you will find m_dist!  (´꒳`)♡
                    }
                }

                //Finally ＼(≧▽≦)／
                if(m_dist < h * scale_point) discard;

                return float4(h, 0.5 + h / 2.0, 1, 1);
            }
            
            ENDCG //Here our little shader ends (o´ω`o)ﾉ
        }
    }
}
