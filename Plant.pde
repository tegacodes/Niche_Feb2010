class Plant { //This plant class was heavily influenced from ArtCom, Garden. 
  int count, index;
  float x,y,rnd,angle,x1,y1,v,speed;
  float timer,end;
  int originX;
  int originY;
  Vector points = new Vector();
  Leaf [] l; //Array that holds red leaves
    int movementAmount;

  Plant(int _x,int _y) { //Plant object
    x      = _x; 
    y      = _y; 
    originX = _x;
    originY = _y;
  }

  void init() {  // initial function to generate long tendrils
    angle  = (random(1)*(2*PI))-PI; //angle from 0-360
    x1     = x;
    y1     = y;   
    v      = 0;
    speed  = 3;
    count  = 0;
    timer  = 0;
    end    = random(300); // how long before they end - dictates how long the tendrils are

  }

  void run() { // run plant growth



    if (totalMovement<20){ //only if there is some movement in the frame does the vine produce flowers
      //WHITE FLOWERS
      noStroke();
      fill(int(random(150,255)),255,255,200);
      rnd = random(1);
      if(rnd>.90) { // how long until flowers are added
        for(int i=0;i<int(random(20));i++) {
          ellipse(x+(int)random(12)-4,y+(int)random(15)-5,int(random(5)),int(random(5))); // array containing clusters of white flower info
          //soundwhite.trigger();
        }
      }
      //RED LEAVES
      int f = int(random(6));
      l = new Leaf[f]; 
      noStroke();
      rnd = random(1);
      if(rnd>.90) { // how long until flowers are added
        int e;
        int d = int(random(-1,1)); // 50% chance of being position or negative - 
        if (d>0){ //dictates the direction of the leaf growth
          e=1;
        }
        else{
          e=-1;
        } 
        fill(int(random(150,255)),int(random(30,80)),32,int(random(50,70)));
        for(int i=0;i<f;i++) {
          //Leaf.leaf(x,y,33,angle); // array containing clusters of white flower info
          l [i] = new Leaf(x,y); //call new plant with random coordinates
          l [i].leaf(x,y,int(random(8,10)),e,angle); // call init function
        }
      }
    }

    x += cos(angle)*speed; //generates the direction of growth in creating next point for the line to follow
    y += sin(angle)*speed;

    points.add(new Point(x,y,angle)); //adds new point object
    v += random(1)*.04 - .02;
    v *= .93;
    angle += v;  //detirmines change in angle


    stroke(38,int(random(50,60)),8,150); // aesthetics of the tendril 
    stroke(color(100,cycleMovement/10000,int(random(100,150)),103));
    strokeWeight(random(1,3.5));
    line(x,y,x1,y1); //line of the vine
    smooth();
    timer++;


    if(x>width || x<0 || y>height || y<0 || timer>end) { // if out of bounds or timer is up
      if(points.size()>10) { // if there are more than 10 points in array
        for(int i=0;i<min(40,(points.size()-10)/4);i++) {  
          points.remove(10+int(random(points.size()-10))); // remove points in excess of 10
        }
      }

      index = int(random(1)*points.size()); //get index of one object in points array
      Point tmpElement =  (Point)points.get(index); //put element at that index in temp element
      x = tmpElement.x; //that point becomes x
      y = tmpElement.y;//that point becomes y
      angle  = (random(1)*(2*PI))-PI;  
      timer = 0;
      end = random(900);
      angle = tmpElement.angle; //put random angle in tempElement
    }
    x1 = x; // new coordinates become x1 and y1
    y1 = y;

  }
  int update()   {  //These update functions are taken from Andy Best Tutorial 2.
    movementAmount = 0;
      for( int y = originY; y < (originY + 10); y++ ){    //  For loop that cycles through all of the pixels in the area the cluster occupies
        for( int x = originX; x < (originX + 10); x++ ){           
          if ( x< width && x > 0 && y < height && y > 0 ){ 
              if (brightness(grid.pixels[x + (y * width)])> 180){  //  and if the brightness is above 127 (in this case, if it is white)              
           
        movementAmount++;
              }
              }
        }
      }    
       if (movementAmount>2) {
         return 1;   //  Return 1 so that the cluster object is destroyed
          }else{                                 //  If less than 5 pixels of movement are detected,
          return 0;                              //  Returns '0' so that the cluster isn't destroyed
          }
       
      
  }
}




