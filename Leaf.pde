class Leaf {
  float x,y;
  
  Leaf(float theX,float theY) {
    this.x = theX;
    this.y = theY;
  }
  
  
void leaf(float x, float  y, int size, float dir, float angle){
  pushMatrix();
  translate(x,y);
  scale(size);
  beginShape();
  rotate(-angle);
  vertex(1.0*dir,-0.7);
  bezierVertex(1.0*dir,-0.7,0.4*dir,-1.0,0.0,0);
bezierVertex(0.0,0.0,1.0*dir,0.4,1.0*dir,-0.7);
endShape();
popMatrix();
//soundvine.trigger();
}
}



