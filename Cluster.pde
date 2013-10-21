class Cluster{
  
  Vector smallPlant = new Vector();
  int MAX_SMALLPlant = int(random(2,8));
  int x;
  int y;
  int originX;
  int originY;
  int c;
  int movementAmount;
  int trailAmount;
  ArrayList smPlants;
  
  Cluster(int _x,int _y){ // Cluster object constructor   
    x      = _x; 
    y      = _y; 
    originX = _x;
    originY = _y;
  }
  

  
  void initCluster(){ // Initiate cluster function
    smPlants = new ArrayList(MAX_SMALLPlant);
      for (int i=0;i<MAX_SMALLPlant;i++) { // add small plants until Max_SmallPlants is reached
        smallPlant.addElement(new SmallPlant(originX,originY,c));
        if (i>2){
         // soundgreen.trigger();}
      }  
    }
   }
    
  void runCluster(){
     stroke(200,247,int(random(100,255)),70);
     fill(255,0,0);
     for (int j=0;j<MAX_SMALLPlant;j++) {
       SmallPlant _smallPlant =  (SmallPlant)smallPlant.get(j);
       _smallPlant.update();
       _smallPlant.run();
     }
   }

  int update()   {  //These update functions are taken from Andy Best Tutorial 2.
    movementAmount = 0;
      for( int y = originY; y < (originY + 10); y++ ){    //  For loop that cycles through all of the pixels in the area the cluster occupies
        for( int x = originX; x < (originX + 10); x++ ){           
              if (brightness(grid.pixels[x + (y * width)])> 127){  //  and if the brightness is above 127 (in this case, if it is white)              
           
        movementAmount++;
            deletedClusters++; //  Add 1 to the variable that holds the number of deleted clusters
              }
        }
      }    
       if (movementAmount>2) {
         return 1;   //  Return 1 so that the cluster object is destroyed
          }else{                                 //  If less than 5 pixels of movement are detected,
          return 0;                              //  Returns '0' so that the cluster isn't destroyed
          }
       
      
  }
       
 
  int clusterPosition(){ // I have modified the update function here to assess whether a plant can grow based on the status of the trails image    
    for( int y = originY; y < (originY + 20); y++ ){    //  For loop that cycles through all of the pixels in the area the cluster occupies
      for( int x = originX; x < (originX + 20); x++ ){
        if ( x< width && x > 0 && y < height && y > 0 ){             //  If the current pixel is within the screen bondaries
          if (brightness(grid.pixels[x + (y * width)]) > 127){   //and is white recent movement
          trailAmount++;   //  Add 1 to the movementAmount variable.
          }
        }
      }
    }
  
   if (trailAmount > 5)  {            //  If more than 5 pixels of movement are detected in the cluster area
   return 1;   //  Return 1 so that the cluster object is destroyed
   }else{                                 //  If less than 5 pixels of movement are detected,
   return 0;                              //  Returns '0' so that the cluster isn't destroyed
   }
  }
}
 
