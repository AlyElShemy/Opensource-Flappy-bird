
class Tracker {
  public Capture video;
  private OpenCV opencv;
  private ArrayList<Contour> contours;
  private float scale = 2.062, streamX=10, streamY=10;
  private PImage src,colorFilteredImage;
  int rangeLow = 20;
  int rangeHigh = 35;
  int timer = 0 ;
  public boolean flap = false;
  Tracker() {
    video = new Capture(OpenSourceFlappyBird.this, 640/2, 480/2);
    opencv = new OpenCV(OpenSourceFlappyBird.this, 640/2, 480/2);
    contours = new ArrayList<Contour>();
    video.start();
  }
  void update() {
    if (flap == true && timer < 1 ){
      timer += 1;
    }
    if (flap == true && timer == 1){
      timer = 0 ;
      flap = false;
    }
    if (video.available()) {
      video.read();
    }
    opencv.loadImage(video);
    opencv.useColor();
    src = opencv.getSnapshot();
    opencv.useColor(HSB);
    
    // <4> Copy the Hue channel of our image into 
    //     the gray channel, which we process.
    opencv.setGray(opencv.getH().clone());
 colorFilteredImage = opencv.getSnapshot();
    // <5> Filter the image based on the range of 
    //     hue values that match the object we want to track.
    opencv.inRange(rangeLow, rangeHigh);

contours = opencv.findContours(true, true);
  }
  void draw (Boolean setup) {
    fill(73,175,78);
    if (setup == true) scale = 0.5;
    rect(streamX - 5, streamY-5 , video.width*scale+10, video.height*scale+10);
    image(video, streamX+scale*video.width/2, streamY+scale*video.height/2, video.width*scale, video.height*scale);

    if (flap) fill(115,191,46);
    else fill(255,0,0);
    rect(streamX+(scale*video.width)-20,streamY+5,15,15);
     if (mousePressed ){
       color c = get(mouseX,mouseY);
       println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
       int hue = int(map(hue(c), 0, 255, 0, 180));
       println("hue to detect: " + hue);
       rangeLow = hue - 5;
       rangeHigh = hue + 5; 
    }
   
   //image(colorFilteredImage, streamX+scale*video.width/2, video.height*scale+streamY+scale*video.height/2, video.width*scale, video.height*scale);
    fill(255);
    text("frame rate : "+int(frameRate), 15, 23);
    if (contours.size() > 0) {
    // <9> Get the first contour, which will be the largest one
    Contour biggestContour = contours.get(0);
    
    // <10> Find the bounding box of the largest contour,
    //      and hence our object.
    Rectangle r = biggestContour.getBoundingBox();
    
    // <11> Draw the bounding box of our object
    noFill(); 
    strokeWeight(2); 
    stroke(255, 0, 0);
    //rect(r.x, r.y, r.width, r.height);
    
    // <12> Draw a dot in the middle of the bounding box, on the object.
    noStroke(); 
    fill(255, 0, 0);
    ellipse(scale*(r.x+streamX + r.width/2), scale*(r.y + r.height/2+streamY), 10, 10);
   // println(r.height);
    if (r.height < 30) flap = true;

  }
  }
}
