import hypermedia.video.*;
import processing.opengl.*; //for displaying animation on projector
import maxlink.*;

OpenCV opencv;

int vidWidth;
int vidHeight;


PImage camImage; // Creates a Pimage
PImage animationImg;  // animation image

PImage trailsImg;  //movement image with trail showing recent movement paths
PGraphics grid;

int cellSize;
int cols, rows;
int cycleMovement;

int totalMovement;  //variable counting pixels of movement in the capture area
int trailAmount;
//------------------------------------------
int PlantsAlive;
int clustersAlive;
int yellowAlive; // yellow plants alive 

int MAX_Plants = 5;
int MAX_Clusters = 35;
int MAX_YellowClusters = 70; //max yellow plants


int deletedClusters;
int deletedClustersYellow; 

int fadeCounter = 0; //integer to fade out old plants

LinkedList plants;
LinkedList clusters;
LinkedList yclusters; // array of yellow plants
LinkedList greensound;
int t;

Timer2 timer2; //timer dicating growth intervals of green and yellow clusters
Timer2 timer3; //timer for vine plant intervals
Timer2 timer4;
Timer2 timer5; //jump to more green clusters

//------------------------------------------
import ddf.minim.*;
//import ddf.minim.signals.*;
//import ddf.minim.effects.*;


color q; // dictating alpha component of the grid

MaxLink link = new MaxLink(this, "bouncer");

void setup() {


  size(1000,800);  
  vidWidth=width/10;
  vidHeight=height/10;
  opencv= new OpenCV( this);
  opencv.capture(vidWidth,vidHeight);

  trailsImg = new PImage(vidWidth,vidHeight);    //  Initialises the PImage that holds the trails image
  animationImg = new PImage(width,height);
  grid = createGraphics(width,height,P2D);
  //------------------------------------------ 
  background(0,0,0); //black background
  frameRate(60); 
  cellSize= width/vidWidth;

  cols = width / cellSize;
  rows = height / cellSize;


  deletedClusters = 0;
  deletedClustersYellow = 0;
  clustersAlive = 0;
  yellowAlive = 0;
  PlantsAlive=0;

  plants = new LinkedList();

  clusters = new LinkedList();
  clusters.add(new Cluster((int)random(width),(int)random(height)));



  yclusters = new LinkedList();    //Initialises the yellow cluster arraylist
  yclusters.add(new ClusterYellow((int)random(width),(int)random(height))); //adds coordinates for 1st yellow plant




    timer2 =new Timer2(5000); //interval of timer 2
  timer2.start();// start timer2

  timer3 =new Timer2(5000); //interval of timer 3
  timer3.start(); //start timer 3

  timer4 =new Timer2(100); //interval of timer 4
  timer4.start(); //start timer 4
  


  timer5 =new Timer2(60000); //interval of timer 4 - for the all clear - 4min
  timer5.start(); //start timer 4


  
  cycleMovement=0;
} 


//------------------------------------------
void draw() { 
  frame.setLocation(1680,0);//modify this to(1680,0) for projector and imac display 
  //FADE OUT BACKGROUND SEQUENCE
  if(fadeCounter++%20==0) {  //fades out older plants
    noStroke();
    fill(0,0,0,7); //fills screen with semitransparent rectangle
    rect(0,0,width,height);
    filter(BLUR,0.575); //also gradually blurs background animations
  }


  //------------------------------------------     
  //MOVEMENT DETECTION SEQUENCE  
  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);        //  Flips the image horizontally
  camImage = opencv.image(); // stores the unprocessed camera frame in openCV buffer
  opencv.absDiff();      //  Creates a difference image
  opencv.convert(OpenCV.GRAY);                //  Converts to greyscale
  opencv.blur(OpenCV.BLUR, 3);                //  Blur to remove camera noise
  opencv.threshold(20);                       //  Thresholds to convert to black and white
  //movementImg = opencv.image();           //  If you want an image of movement uncomment this

  //PLANT DELETION DUE TO MOVEMENT
  animationImg=get(); //Put display with animation into PImage animationImg


  totalMovement=0;
  for (int i =   0; i<  animationImg.width; i++ ) { 
    for (int j =  0; j< animationImg.height; j++){ //run through x and y of animationImg


      int m =  i+j*animationImg.width; //get each pixel of animationImg


      if(brightness(grid.pixels[m])>240){ // if movment is detected then the brightness>127 and pixel is white
        totalMovement++;
        if(totalMovement>600){
          cycleMovement++;
          if(cycleMovement>2550000){

            cycleMovement=600000;
          }

          color fgcolor = animationImg.pixels[m]; //get color of each pixel in animation
          float r1 =  red(fgcolor);  //get red, green and blue values
          float g1 = green(fgcolor); 
          float b1 = blue(fgcolor);

          if (r1>10){
            float r2 = abs(r1-29);     //then darken them as movement is detected - so gradually erase the plants 
            if (g1>10){
              float g2 = abs(g1-37);
              if (b1>10){
                float b2 = abs(b1-29);


                animationImg.pixels[m]=color(r2,g2,b2); //update animationImg with darkened rgb values
              }
            }
          }
        } 
      }
    }
  }
  //------------------------------------------  
  //TRAILS IMAGE TO TRACK RECENT MOVEMENT (REF: Andy Best, Tutorial 1) 
  trailsImg.blend(opencv.image(),0, 0, vidWidth,vidHeight, 0, 0, vidWidth,vidHeight, SCREEN ); //blend trails image with movement image that is in opencv
  opencv.copy( trailsImg ); // Copies trailsImg into OpenCV buffer to put effects on it
  opencv.brightness( -2 ); // Sets the brightness of the trails image to -20 so it will fade out
  trailsImg = opencv.image(); // Puts the modified image from the buffer back into trailsImg
  image(animationImg,0,0);
  //image(camImage,0,0);
 // image(trailsImg,0,vidWidth); //display animation image
  opencv.remember(OpenCV.SOURCE, OpenCV.FLIP_HORIZONTAL);    //  Remembers the camera image so to generate a difference image next frame. Since we've

  grid.beginDraw();
  // Begin loop for columns
  for (int i = 0; i < cols; i++) {
    // Begin loop for rows
    for (int j = 0; j < rows; j++) {

      // Where are we, pixel-wise?
      //int x = int(map(i,0,video.width,0,width))*cellSize;
      //int y = int(map(j,0,video.height,0,height))*cellSize;
      int x = i*cellSize;
      int y = j*cellSize;
      int loc = i+j*trailsImg.width;

      float r = red(trailsImg.pixels[loc]);

      // Make a new color with an alpha component
      q = color(r, r, r);

      // Code for drawing a single rect
      // Using translate in order for rotation to work properly
      grid.pushMatrix();
      grid.translate(x+cellSize/2, y+cellSize/2);
      // Rotation formula based on brightness
      // rotate((2 * PI * brightness(c) / 255.0));
      grid.rectMode(CENTER);
      grid.fill(q);
      grid.noStroke();
      // Rects are larger than the cell for some overlap
      grid.rect(0, 0, cellSize, cellSize);
      grid.popMatrix();
    }
  }
  grid.endDraw();

  //------------------------------------------   
  // GREEN CLUSTERS GROWTH SEQUENCE
  int g = int(random(0,3));// detirmining sound to be pulled out for green death
  //CHECK IF TRAILS IMAGE IS WHITE OR BLACK - IF WHITE (RECENT MOVEMENT) THEN DELETE CLUSTER OBJECT (REF: Andy Best, Tutorial 2)
  for (int j = clusters.size()-1; j >= 0; j--) {  //run through cluster arrayList
    Cluster _cluster = (Cluster) clusters.get(j); //pull out array element
    if(_cluster.clusterPosition()==1){    //  If the cluster's position function returns '1' - this indicates recent movement
      clusters.remove(j);                  //  then remove the plant object from the array
      _cluster = null;        //  and make the temporary cluster object null
      j--;                //  since plant is removed from the array, we need to subtract 1 from j
      clustersAlive--; //adjust plant counter

    //  AudioSample audioSample = (AudioSample) greensound.get(g);
    //  audioSample.trigger();
      if(clustersAlive<0){
        clustersAlive=0;
      } 
    }
    else{
      clusters.set(j,_cluster); //move temporary object back into the array
      _cluster=null; //make temporary cluster object null
      if (clustersAlive>1){
      }
    }
  }


  for (int i = clusters.size()-1; i >= 0; i--) { //run through adjusted clusters Arraylist
    Cluster cluster = (Cluster) clusters.get(i); //initiate and run clusters objects in array
    cluster.initCluster();
    cluster.runCluster();
    clustersAlive=clusters.size()-1;
  } 

  if (timer2.isFinished()){ //if timer finished and max clusters has not been reached, add cluster
    if(clustersAlive<=MAX_Clusters){
      clusters.add(new Cluster((int)random(width),(int)random(height)));   
      clustersAlive++;
    } 
    else{ 
      if(timer5.isFinished()){// if max clusters has been reached then remove 1st position in array - so that 1st plant dies
        clusters.remove(1);
        clustersAlive--; //adjust counter
      link.output("green");
      }
    }
    t = int(random(0,4));
    timer2 =new Timer2(t*1000); //interval of timer 2
    timer2.start(); //restart timer
  } 





  //------------------------------------------     
  //YELLOW CLUSTER GROWTH SEQUENCE

  //CHECK IF TRAILS IMAGE IS WHITE OR BLACK - IF BLACK (NO MOVEMENT) THEN DELETE CLUSTER OBJECT (REF: Andy Best, Tutorial 2)
  for (int j = yclusters.size()-1; j >= 0; j--) {  //run through yellow plant arrayList
    ClusterYellow _clusterYellow = (ClusterYellow) yclusters.get(j); //pull out array element
    if((_clusterYellow.position()==1)||(_clusterYellow.update()==1) ) {       //  If the cluster's position function returns '1'
      yclusters.remove(j);                  //  then remove the plant from the array
      _clusterYellow = null;        //  and make the temporary plant object null
      j--;                //  since plant is removed from the array, we need to subtract 1 from j
      yellowAlive--; //adjust plant counter
      if(yellowAlive<0){
        yellowAlive=0;
      }
    }
    else{
      yclusters.set(j,_clusterYellow); //move temporary object back into the array
      _clusterYellow=null; //make temporary plant object null
    }
  }


  for (int i = yclusters.size()-1; i >= 0; i--) { //run through adjusted yellow plant array
    ClusterYellow clusterYellow = (ClusterYellow) yclusters.get(i); //initialise and run yellow plant cluster
    clusterYellow.initClusterYellow();
    clusterYellow.runClusterYellow();
    yellowAlive=yclusters.size()-1;
  }


  if (timer4.isFinished()){ //if timer finished and max clusters has not been reached, add cluster
    if(yellowAlive<=MAX_YellowClusters){ //if there are not yet the max number of yellow plants add plant to arrayList
      yclusters.add(new ClusterYellow((int)random(width),(int)random(height)));
      yellowAlive++; //count plants in array
    }
    else{ // if max clusters has been reached then remove 1st position in array - so that 1st plant dies
      yclusters.remove(1);
      yellowAlive--; //adjust counter
    }
    timer4.start();
  }

  if (yellowAlive>2){  // this the component that controls the sound triggered by movement
  
   link.output("boing");

    }
    if(yellowAlive>10){
     link.output("bing");
    }  
     if(yellowAlive>20){
     link.output("bong");
  
  }
   if(yellowAlive>30){
     link.output("bung");
     println("bung");
   }
  //------------------------------------------     
  //VINE GROWTH SEQUENCE - VINE DOES NOT DIE DUE TO MOVEMENT, BUT MUST HAVE 3 GREEN CLUSTERS ALIVE TO BE EXIST.
  //ALSO WILL ONLY FLOWER IF NO MOVEMENT IS DETECTED IN THE MOVEMENT FRAME
  for (int j = plants.size()-1; j >= 0; j--) {  //run through yellow plant arrayList
    Plant _plant = (Plant) plants.get(j); //pull out array element
    if(_plant.update()==1 ) {       //  If the cluster's position function returns '1'
      plants.remove(j);                  //  then remove the plant from the array
      _plant = null;        //  and make the temporary plant object null
      j--;                //  since plant is removed from the array, we need to subtract 1 from j
      PlantsAlive--; //adjust plant counter
      if(PlantsAlive<0){
        PlantsAlive=0;
      }
    }
    else{
      plants.set(j,_plant); //move temporary object back into the array
      _plant=null; //make temporary plant object null
    }
  }



  if (clustersAlive>3){
    for(int j=0;j<plants.size();j++) {  
      Plant plant = (Plant) plants.get(j);
      plant.run();
      PlantsAlive=plants.size();
    }


    if (timer3.isFinished()){ // new plants will grow when timer 3 has finished
      if(PlantsAlive<MAX_Plants){
        plants.add(new Plant((int)random(width),(int)random(height))); //add at random coordinates
        for (int i = plants.size()-1; i >= 0; i--) { 
          Plant plant = (Plant) plants.get(i);
          plant.init();
        }
      }
      timer3.start();
    }
  }


  if (totalMovement>450000){
    MAX_Clusters=1;
    timer5.start();
    
  
   link.output("boing");
  }

  if(timer5.isFinished()){
    MAX_Clusters=35;
  }



  //------------------------------------------  
  //PRINT VARIABLES 
  //println(totalMovement+" totalMovement"); 
  println(totalMovement+"totalMovement");
  println(yellowAlive+"  yellow alive");         //prints plants that are alive
  // println (trailAmount);
 // println(cycleMovement+"cycleMovement");
}

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  frame.addNotify();
  // call PApplet.init() to take care of business
  super.init();  
}  




