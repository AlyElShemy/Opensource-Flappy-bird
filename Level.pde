class level {
  // init variables 
  private PImage background,pipe,ground;
  private PImage [] numbers = new PImage[10]; // array to store numbers bitmaps
  private int [] pipeshift = new int[10], heights = new int[10]; // store x position and height of a pipe
  private int shift = 0, score = 0, rate = 1, pipeX;
  private float pipeGap=21.2;
  private SoundFile point,hit;
  private Bird bird;
  private boolean dead = false, smacked = false;
  private PrintWriter HighScore;
  
  level(Bird bird)
  {

    this.bird = bird; // get bird object
    HighScore = createWriter("score.txt"); // create text file to store high score
    
    // load images 
    for (int i=0;i<=9;i++) numbers[i] = loadImage(i+".png"); // load numbers bitmaps
    background = loadImage("background-night.png"); // load background
    pipe = loadImage("pipe-green.png"); // load pipe
    ground = loadImage("base.png"); // load ground
    
    // load sound effects
    point = new SoundFile(OpenSourceFlappyBird.this,"point.wav"); // plus point 
    hit = new SoundFile(OpenSourceFlappyBird.this,"hit.wav"); // hit sound
    
    
    // generate random heights
    for (int j = 0; j <= pipeshift.length-1 ;j++)
    {
      pipeshift[j] = 0;
      heights[j] = int(random(400,500));
    }
    image(background,0,0); image(background,background.width,0); image(background,2*background.width,0); 
    image(ground,0,background.height); image(ground,ground.width,background.height);
  }
  
  void update ()
  { 
    // move background
    for(int i = 0; i <= 3; i++) image(background,i*(background.width)-shift,background.height/2); 
    
    // loop through each of the 10 pipes
    for (int k = 0; k <= pipeshift.length-1; k++)
    {
      // get the kth pipe position from the pipeshift array
      pipeX = width + pipe.width/2 - pipeshift[k]; // pipeshift is the offset of the center of the pipe bitmap from the screen's right side
      
      // collision detection
      if ((bird.x > pipeX - pipe.width/2 && bird.x < pipeX + pipe.width/2) && (bird.y > heights[k] - pipe.height/2 || bird.y < heights[k] - 300)) 
      dead = true ;
      
      // update score if the bird passes a pipe
      if (bird.x == pipeX && !dead )  
      {
        point.play(); // play plus sound 
        score += 1; // update score 
      }
   
      // draw pipe (two pipes: upper and lower pipe) :
      // 1) draw lower pipe
      image(pipe,pipeX,heights[k]); 
      
      // 2) draw upper pipe (we first rotate the bitmap 180 degrees then display it)
      pushMatrix();
      translate(pipeX,heights[k]-pipe.height/2 -300);
      rotate(PI);
      image(pipe,0,0);  
      popMatrix();
      
      // update pipe position 
      if (!dead) // if bird is alive
      {
        if (k!=0) // ignore first pipe
        {
          if ( pipeshift[k-1] > (pipe.width+pipeGap) && pipeshift[k] == 0 ) // if currently stationary and the pipe to the left has passed the pipe gap
          pipeshift[k] += rate; // start moving too
          else if (pipeshift[k] > 0) pipeshift[k] += rate; // if already moving then just keep moving
        }
        else pipeshift[k]+=rate; // first pipe starts moving right away
        
        if (pipeshift[k] == width + pipe.width ) // if the pipe goes the left most side of the screen
        {
          pipeshift[k]=0; // go back to original position on the right side
          heights[k] = int(random(400,500)); // generate a new random height for the next round
        }
      }  
    } // end of loop
   
    // draw ground
   for(int i = 0; i <= 3; i++)  image(ground,i*(ground.width)-shift,background.height+(ground.height/2));
    
   if (bird.y >= height-ground.height || bird.y <= 0 ) dead = true; // if bird hits ground or ceiling, kill it
   
   // update score display 
   if (score < 10) image(numbers[score],width-50,40); // <= 10 score range
   else if ( score <= 99) // <= 99 score range
   {
      image(numbers[floor(score/10)],width-50,40);
      image(numbers[score-(floor(score/10)*10)],width-25,40);
   }
   else if (score <= 999) // <= 999 score range
   {
      image(numbers[floor(score/100)],width-75,40);
      image(numbers[floor(score/10)-(floor(score/100)*10)],width-50,40);
      image(numbers[score-(floor(score/10)*10)],width-25,40);
   }
   
    if (!dead ) {
      shift +=rate ;
      smacked = false;
    }
    else {
     if (smacked == false ){
       hit.play();
       smacked = true;
     }
     if (bird.g > -10 && bird.bumped == false) bird.g -= 1;
     if (bird.g <= -10 ) bird.bumped = true ; 
     if (bird.bumped) bird.g += 2;
     bird.angle = -PI/4;
    }
    if ( shift == background.width) shift = 0; 
    if (bird.y >= height) start = false;
  }
  void reset(){
     shift = 0 ;
     score = 0;
     bird.bumped = false;
     bird.g = 2;
     bird.y = 340;
     bird.angle = 0;
     for (int j=0;j<=pipeshift.length-1;j++){
      pipeshift[j] = 0;
      heights[j] = int(random(400,500));
    }
     dead = false;
     
 
  }
}
