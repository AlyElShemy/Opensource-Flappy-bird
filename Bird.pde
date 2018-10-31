
class Bird {
 private PImage [] Frames = new PImage[3];
 private float AnimationCounter = 0 ;
 public Boolean bumped = false; 
 private SoundFile wing;
 public int x,y;
 public float g = 2 ,jumpSpeed = 0,angle = 0;
 Bird (int x, int y){
 this.x = x;
 this.y = y ;
 wing = new SoundFile(OpenSourceFlappyBird.this,"wing.wav"); // wing sound
 for (int i=0;i<=2;i++) Frames[i]=loadImage("bluebird"+Integer.toString(i+1)+".png"); //load frames
 }
 public void update (Boolean flapping){
   if (floor(AnimationCounter) == 3) AnimationCounter = 0 ; 
   pushMatrix();
   translate(x,y);
   if (!flapping) {
     jumpSpeed=0;
     y+=g;
   }
   else {
     if (jumpSpeed<5) jumpSpeed+=1;
     y -= jumpSpeed;
     
   }
   rotate(angle);
   image(Frames[floor(AnimationCounter)],0,0);
   popMatrix();
   if (flapping || AnimationCounter != 0 ) AnimationCounter += 0.3 ;
   if  (AnimationCounter-floor(AnimationCounter) <0.1 && AnimationCounter != 0 ) wing.play();
 }

  
}
