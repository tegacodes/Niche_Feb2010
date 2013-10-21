class Point { //This point class was inspired by ArtCom, Garden. 
  float x,y;
  float angle;
  
  Point(float theX,float theY,float theAngle) {
    x = theX;
    y = theY;
    angle =  ((random(1)*(2*PI))-PI); //the angle 0 to 360
  }
  
}
