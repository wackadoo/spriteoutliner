#ifdef GL_ES
precision mediump float;
#endif
 

varying vec2 v_texCoord;
uniform sampler2D u_texture;
uniform vec3 u_color;



 
void main()
{
  vec4 normalColor = texture2D(u_texture, v_texCoord).rgba;
  gl_FragColor = vec4(u_color.r, u_color.g, u_color.b, normalColor.a);
}