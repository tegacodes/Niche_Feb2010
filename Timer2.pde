class Timer2  {   //Timer class (Ref:Shiffmen, Daniel, 2008. Learning Processing.)
        int savedTime;     // When Timer started 
        int totalTime;     // How long Timer should last 
        Timer2(int tempTotalTime)  {  
             totalTime =  tempTotalTime; 
           }   
        // Starting the timer 
        void start()  {  
            savedTime = millis(); 
              }   
        boolean isFinished()  {  // Check how much time has passed 
                int passedTime  = millis()- savedTime; 
             if (passedTime  >totalTime) {  
                  return true; 
              }  else{  
                  return false; 
              }   
         }   
}
