
import processing.serial.*;
Serial myPort;  
import processing.video.*;
int linefeed = 10;   // Linefeed in ASCII
int numSensors = 2;  // we will be expecting for reading data from four sensors
int sensors[];       // array to read the 4 values
int pSensors[];      // array to store the previuos reading, usefur for comparing
int vol;
int v1;
String inBuffer="";
String inBuffer2="";
String inBuffer3="";
float mux=1;

import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;

AudioOutput out;
Minim minim;
AudioSample kick;
AudioSample snare;
AudioSample movie1;
AudioSample movie2;
AudioSample movie3;
AudioInput in;

float gain = 200;
float[] myBuffer;


void setup() {

  size(512, 200, P3D);
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
in = minim.getLineIn(Minim.MONO,2048);
  // load BD.wav from the data folder
  kick = minim.loadSample( "BD.mp3", 512);
  movie1 = minim.loadSample( "1.mp3", 512);
  movie3 = minim.loadSample( "3.mp3", 512);


  if ( kick == null ) println("Didn't get kick!");

  // load SD.wav from the data folder
  snare = minim.loadSample("SD.wav", 512);
  if ( snare == null ) println("Didn't get snare!");
  println(Serial.list()); 
  myPort = new Serial(this, Serial.list()[9], 57600);

  myPort.bufferUntil(linefeed);
  
  in = minim.getLineIn(Minim.MONO,2048);

  myBuffer = new float[in.bufferSize()];
}



void draw() {
  background(0);
  stroke(255);
  //println(map(sensors[0],30,80,0,1));
  for (int i = 0; i < in.bufferSize(); ++i) {
    myBuffer[i] = in.left.get(i);
  }

 for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    float x1 = map(i, 0, myBuffer.length, 0, width);
    float x2 = map(i+1, 0, myBuffer.length, 0, width);
    line(x1, 100 - myBuffer[i]*gain, x2, 100 - myBuffer[i+1]*gain);
  }


  if ((pSensors != null)&&(sensors != null)) { 
    for (int i=0; i < numSensors; i++) {
      float f = sensors[i] - pSensors[i];  // actual - previous value

      if (f > 0) {
        sounds();
      }

      if (f < 0) {
        sounds();
      }
    }
  }
}

void sounds() {

  SineWave mySine;
  PianoNote newNote;
  mux =map(sensors[0],30,80,1,20);
  float pitch = 0;
  println(sensors[1]);
  println(mux);
  switch(sensors[1]) {
  case 500:
    //movie1.trigger();
    //movie1.play();

    //delay(500);
    if (v1!=500) {
      pitch = 262* mux;
    }
    break;
    
  case 's': 
    pitch = 277; 
    break;
  case 'x': 
    pitch = 294; 
    break;
    
  case 450: 
    if (v1!=450) {
      movie3.trigger();
    }
    break;
    
  case 'c': 
    pitch = 330; 
    break;
    
  case 'v': 
    pitch = 349; 
    break;
    
  case 400: 
    if (v1!=400) {
    pitch = 370* mux;
    } 
    break;
    
  case 'b': 
    pitch = 392; 
    break;
  case 'h': 
    pitch = 415; 
    break;
  case 350: 
    if (v1!=350) {
    pitch = 440* mux;
    }  
    break;
  case 'j': 
    pitch = 466; 
    break;
  case 'm': 
    pitch = 494; 
    break;
  case 300: 
   if (v1!=300) {
    pitch = 523;
    } 
    break;
  case 'l': 
    pitch = 554; 
    break;
  case '.': 
    pitch = 587; 
    break;
  case 250: 
    if (v1!=250) {
    pitch = 622* mux;
    }  
    break;
  case 200: 
    //movie1.stop();
if (v1!=200) {
    pitch = 659* mux;
    }     break;
  }
  v1=sensors[1];
  if (pitch > 0) {
     newNote = new PianoNote(pitch, map(sensors[0],30,80,0,1));
    //newNote = new PianoNote(pitch, .2);
  }
  //super.stop();
  /*
     if ( sensors[0] ==500  ) {
   movie1.stop();
   movie1.trigger();}
   
   if ( sensors[0] ==300  ) {
   movie3.stop();
   movie3.trigger();}
   */
}


void keyPressed() 
{

}

void serialEvent(Serial myPort) {



  // read the serial buffer:

  String myString = myPort.readStringUntil(linefeed);



  // if you got any bytes other than the linefeed:

  if (myString != null) {
    myString = trim(myString);
    pSensors = sensors;
    sensors = int(split(myString, ','));

    for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
      //print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
    }
    println();
  }
}

class PianoNote implements AudioSignal
{
  private float freq;
  private float level;
  private float alph;
  private SineWave sine;

  PianoNote(float pitch, float amplitude)
  {
    freq = pitch;
    level= mux/30;
    //println(level);
    //level = .8;
    sine = new SineWave(freq, level, out.sampleRate());
    alph = .99;  // Decay constant for the envelope
    out.addSignal(this);
  }

  void updateLevel()
  {
    // Called once per buffer to decay the amplitude away
    level = level * alph;
    sine.setAmp(level);

    // This also handles stopping this oscillator when its level is very low.
    if (level < 0.01) {
      out.removeSignal(this);
    }
    // this will lead to destruction of the object, since the only active 
    // reference to it is from the LineOut
  }

  void generate(float [] samp)
  {
    // generate the next buffer's worth of sinusoid
    sine.generate(samp);
    // decay the amplitude a little bit more
    updateLevel();
  }

  // AudioSignal requires both mono and stereo generate functions
  void generate(float [] sampL, float [] sampR)
  {
    sine.generate(sampL, sampR);
    updateLevel();
  }
}
