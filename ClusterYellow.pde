class ClusterYellow{
Vector yellowPlant = new Vector();
  int MAX_YellowPlant = int(random(1,4));
  int x;
  int y;
  int originX;
  int originY;
  int c;
  int movementAmount;
  int trailAmount;
  
  ArrayList yPlants;

  
  
  ClusterYellow(int _x,int _y){  //Object constructor for yellow clusters 
    x      = _x;  //coordinates of each cluster 
    y      = _y; 
    originX = _x;
    originY = _y;
  
  }
 
 
  
  void initClusterYellow(){  
    yPlants = new ArrayList(MAX_YellowPlant); //start an array to hold each tendril (called YellowPlant) that forms the cluster
    for (int i=0;i<MAX_YellowPlant;i++) { // add small plants until Max_YellowPlants is reached
      yellowPlant.addElement(new YellowPlant(originX,originY,c));          
       if (i>2){
         // soundyellow.trigger();
       }
    }
    }
    
  void runClusterYellow(){
    stroke(200,247,150,70); //color of plant
    for (int j=0;j<MAX_YellowPlant;j++) { //run through array of the tendrils
      YellowPlant _yellowPlant =  (YellowPlant) yellowPlant.get(j); //add each tendril ClusterYellow _clusterYellow = (ClusterYellow) yclusters.get(j);
      _yellowPlant.update();
      _yellowPlant.run(); //call run function
     
    }
  }
    

//THIS FUNCTION DETIRMINES WHETHER MOVEMENT HAPPENS IN THE CLUSTER AREA - IF SO THE PLANT DIES 

int update()   { // (Andy Best Tutorial 2)
    movementAmount = 0;
    for( int y = originY; y < (originY + (10-1)); y++ ){    //  For loop that cycles through all of the pixels in the area the bubble occupies
      for( int x = originX; x < (originX + (10-1)); x++ ){
        if ( x< width && x > 0 && y < height && y > 0 ){             //  If the current pixel is within the screen bondaries
          if (brightness(grid.pixels[x + (y * width)]) > 240){  //  and if the brightness is above 127 (in this case, if it is white)
            movementAmount++;   //  Add 1 to the movementAmount variable.
            return movementAmount;
          }
        }
      }
    }
  if (movementAmount > 1){              //  If more than 5 pixels of movement are detected in the cluster area
    deletedClustersYellow++; //  Add 1 to the variable that holds the number of deleted yellow clusters 
    return 1;   //  Return 1 so that the bubble object is destroyed
    }else{                                 //  If less than 5 pixels of movement are detected,
    return 0;                              //  Returns '0' so that the cluster isn't destroyed
    }
   }
  

//FUNCTION TO DETIRMINE WHETHER CONDITIONS EXIST FOR YELLOW CLUSTER TO GROW - TRAILS IMG = WHITE (recent movement)
 
  int position(){          
    for( int y = originY; y < (originY + 20); y++ ){    //  For loop that cycles through all of the pixels in the area the cluster occupies
      for( int x = originX; x < (originX + 20); x++ ){ 
         if ( x< width && x > 0 && y < height && y > 0 ){       //  If the current pixel is within the screen bondaries
          if (brightness(grid.pixels[x + (y * width)]) < 1){ //and is black ie. no movement 
          trailAmount++;   //  Add 1 to the trailAmount variable.
          }
         }
      }
    }
   if (trailAmount > 2)  {            //  If more than 5 pixels of black (ie no movement) in the trail image are detected in the cluster area 
     return 1;   //  Return 1 so that the cluster object is destroyed
     }else{                                 //  If less than 5 pixels of movement are detected, ( ie recent movement)
     return 0;                              //  Returns '0' so that the cluster isn't destroyed and grows

 }
   }
}
  

