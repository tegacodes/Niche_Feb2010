class SmallPlant { //This Smallplant class was inspired by ArtCom, Garden. 
int count, index;
  float x,y,rnd,angle,x1,y1,v,speed;
  float timer,end;
  int originX;
  int originY;
  int deletedSmallPlants;
  int c;
  int movementAmount; 
  
 SmallPlant(int _x,int _y,int c) { //small plant object constructor
     x      = _x;
     y      = _y;
     originX = _x;
     originY = _y;
     init();
     c = c;
  }
  
  void init() { //initial plant functi0n 
    angle  = (random(1)*(2*PI))-PI;
    x1     = x;
    y1     = y;  
    v      = 0;
    count  = 0;
    timer  = 0;    
  }
  
   void run() { //run plant growth
    speed  = random(1.5,3);
    c = color(200,250,int(random(100,220)),103);  
    x += cos(angle)*speed;
    y += sin(angle)*speed;
    v += random(1)*.04 - .02;// ranging from 0.2 to 0
    v *= .97;// times 0.97
    angle += v; //increase angle
   
    strokeWeight(int(random(0,4))); // random stroke weight
    
    stroke(c);
    line(x,y,x1,y1); // line of tendril
    smooth();
    end    = random(500); // random length of tendril
    timer++;
        
    if(x>width || x<0 || y>height || y<0 ||timer>end) { // if out of bounds or timer has ended go back to origin and start again
        x =  originX; // this is coordinates to start
        y =  originY;
        angle  = (random(1)*(2*PI))-PI; //angle 0-360
        timer = 0;
        end = random(500);
        }
    x1 = x;
    y1 = y;
  }
  
  
int update(){ // (Andy Best Tutorial 2)             
  movementAmount = 0; //  Create and set a variable to hold the amount of white pixels detected in the area where the smallPlant is
    for( int y = originY; y < (originY + (10-1)); y++ ){    //  For loop that cycles through all of the pixels in the area the smallPlant occupies
      for( int x = originX; x < (originX + (10-1)); x++ ){
        if ( x< width && x > 0 && y < height && y > 0 ){             //  If the current pixel is within the screen bondaries
          if (brightness(grid.pixels[x + (y * width)]) > 127)  //  and if the brightness is above 127 (in this case, if it is white)
        {
        movementAmount++;                                         //  Add 1 to the movementAmount variable.
        }
      }
    }
  }
  if (movementAmount > 1)      {         //  If more than 5 pixels of movement are detected in the smallPlant area
    deletedSmallPlants++; //  Add 1 to the variable that holds the number of deleted smallPlants
    return 1;   //  Return 1 so that the smallPlant object is destroyed
    }else{                                 //  If less than 5 pixels of movement are detected,
    return 0;                              //  Returns '0' so that the smallPlant isn't destroyed
    } 
  }
}


