import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import processing.sound.*;

Bird b;
level l;
Tracker t;
Boolean start = false, setup = false;
PImage message ;
void setup(){
size(680,610);
t = new Tracker();
b = new Bird(300,340);
l = new level (b);
message = loadImage("message.png");

imageMode(CENTER);
frameRate(120);
}
void draw (){
  
  if (setup == false){
   if (key == 10) {
     setup = true; 
     l.update();
   }
  }
  
  if (start == true && setup == true) {
  l.update();
  println(t.flap);
  b.update(keyPressed);
  
  } else  {
    if ((mousePressed||key == ' ') && setup == true) {
      start = true;
      l.reset();
    }
  image(message,width/2,height/2,message.width*1.2,message.height*1.2);
  }
  
 t.update();
 t.draw(setup);
 }
