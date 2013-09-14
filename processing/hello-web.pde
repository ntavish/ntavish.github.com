//  background(2236962-7000000);

// Global variables
float radius = 50.0;
int X, Y;
int nX, nY;
int delay = 16;
bool firstrun=true;

PFont fontA;

// Setup the Processing Canvas
void setup()
{
  background( 2236962 );
  fontList = PFont.list();
  size( 600, 100 );
  frameRate( 30 );
}

// Main draw loop
void draw()
{
  // Fill canvas grey
  background( 2236962 );

  int brightness;
  if(firstrun)
  {  
     brightness=255;
     fill(#92BF6F, brightness);
     frameRate(0.1);
     firstrun=false;
  }
  else
  {
    brightness=random(50,255);
    fill(#92BF6F, brightness);
    if(brightness<100)
      frameRate(2);
    else
      if (brightness >240)
        frameRate(0.4);
      else
        frameRate(25);
  }
  fontA=loadFont("Courier new", 36)
  textFont(fontA, 70);
  text("nTavish", 20, 80);
}


void mousePressed() { 

  link("/"); 

}
