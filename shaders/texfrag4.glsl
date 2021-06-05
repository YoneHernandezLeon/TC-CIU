#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec4 vertTexCoord;

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

void main() {
  vec4 t = texture2D(texture, vertTexCoord.st);
  float aux = (t[0] + t[1] + t[2]) / 3;
  
  gl_FragColor = vec4(1-aux / 0.9, 1-aux / 0.9, 1-aux / 0.9, t[3]) * vertColor;
}
