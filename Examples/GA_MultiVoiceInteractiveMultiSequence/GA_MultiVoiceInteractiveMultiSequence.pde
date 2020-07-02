
// Adapted by Matt Borland from:
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Genetic Algorithm, Evolving a rhythmic pattern

// Demonstration of using a genetic algorithm to perform a search

// setup()
//  # Step 1: The Population 
//    # Create an empty population (an array or ArrayList)
//    # Fill it with DNA encoded objects (pick random values to start)

// draw()
//  # Step 1: Selection 
//    # Create an empty mating pool (an empty ArrayList)
//    # For every member of the population, evaluate its fitness based on some criteria / function, 
//      and add it to the mating pool in a manner consistant with its fitness, i.e. the more fit it 
//      is the more times it appears in the mating pool, in order to be more likely picked for reproduction.

//  # Step 2: Reproduction Create a new empty population
//    # Fill the new population by executing the following steps:
//       1. Pick two "parent" objects from the mating pool.
//       2. Crossover -- create a "child" object by mating these two parents.
//       3. Mutation -- mutate the child's DNA based on a given probability.
//       4. Add the child object to the new population.
//    # Replace the old population with the new population
//  
//   # Rinse and repeat

import controlP5.*;

ControlP5 cp5;

Slider2D s;
Slider s1;
Slider s2;
Slider s3;
Slider s4;
RadioButton r1;

Toggle tm1_0; 
Toggle tm1_1; 
Toggle tm1_2; 
Toggle tm1_3; 
Toggle tm1_4; 
Toggle tm1_5; 
Toggle tm1_6; 
Toggle tm1_7; 
Toggle tm1_8; 
Toggle tm1_9; 
Toggle tm1_10; 
Toggle tm1_11; 
Toggle tm1_12; 
Toggle tm1_13; 
Toggle tm1_14; 
Toggle tm1_15; 
Toggle tm2_0; 
Toggle tm2_1; 
Toggle tm2_2; 
Toggle tm2_3; 
Toggle tm2_4; 
Toggle tm2_5; 
Toggle tm2_6; 
Toggle tm2_7; 
Toggle tm2_8; 
Toggle tm2_9; 
Toggle tm2_10; 
Toggle tm2_11; 
Toggle tm2_12; 
Toggle tm2_13; 
Toggle tm2_14; 
Toggle tm2_15; 
Toggle tm3_0; 
Toggle tm3_1; 
Toggle tm3_2; 
Toggle tm3_3; 
Toggle tm3_4; 
Toggle tm3_5; 
Toggle tm3_6; 
Toggle tm3_7; 
Toggle tm3_8; 
Toggle tm3_9; 
Toggle tm3_10; 
Toggle tm3_11; 
Toggle tm3_12; 
Toggle tm3_13; 
Toggle tm3_14; 
Toggle tm3_15;

import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

// this library does a weird 0-indexing thing, so to send on MIDI channel 10, set this to 9, etc.
int channel = 0; 
int velocity1 = 100;
int velocity2 = 100;
int velocity3 = 100;

int midi1Note = 36;
int midi2Note = 38;
int midi3Note = 42;

float mutationRate = 0.1;      // Mutation rate
int totalPopulation = 100;      // Total Population
int generations = 10;            // Number of Generations Between Updates

DNA[] population;             // Array to hold the current population
ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
String target;                // Active Target phrase
String targetSeq1 = "000000000000000000000000000000000000000000000000"; // Stored Seq 1 Target phrase
String targetSeq2 = "000000000000000000000000000000000000000000000000"; // Stored Seq 2 Target phrase
String targetSeq3 = "000000000000000000000000000000000000000000000000"; // Stored Seq 3 Target phrase
String targetSeq4 = "000000000000000000000000000000000000000000000000"; // Stored Seq 4 Target phrase
String fittest;               // Variable to store the fittest gene
String targetMidi1 = "0000000000000000"; // These need to be 16 long to work with the other parts
String targetMidi2 = "0000000000000000"; // of the code. You can change their size, but would have
String targetMidi3 = "0000000000000000"; // to adjust some other parameters in the code below
PFont f;
int activeSeq = 0;

float tempo = 100; // A tempo value in beats per minute

float startTime = millis(); 
int beat = 0; //Index of beat

boolean m1_0 = false;
boolean m1_1 = false;
boolean m1_2 = false;
boolean m1_3 = false;
boolean m1_4 = false;
boolean m1_5 = false;
boolean m1_6 = false;
boolean m1_7 = false;
boolean m1_8 = false;
boolean m1_9 = false;
boolean m1_10 = false;
boolean m1_11 = false;
boolean m1_12 = false;
boolean m1_13 = false;
boolean m1_14 = false;
boolean m1_15 = false;

boolean m2_0 = false;
boolean m2_1 = false;
boolean m2_2 = false;
boolean m2_3 = false;
boolean m2_4 = false;
boolean m2_5 = false;
boolean m2_6 = false;
boolean m2_7 = false;
boolean m2_8 = false;
boolean m2_9 = false;
boolean m2_10 = false;
boolean m2_11 = false;
boolean m2_12 = false;
boolean m2_13 = false;
boolean m2_14 = false;
boolean m2_15 = false;

boolean m3_0 = false;
boolean m3_1 = false;
boolean m3_2 = false;
boolean m3_3 = false;
boolean m3_4 = false;
boolean m3_5 = false;
boolean m3_6 = false;
boolean m3_7 = false;
boolean m3_8 = false;
boolean m3_9 = false;
boolean m3_10 = false;
boolean m3_11 = false;
boolean m3_12 = false;
boolean m3_13 = false;
boolean m3_14 = false;
boolean m3_15 = false;

void setup() {
  size(980, 400, P2D);
//  size(980, 400); // use this one if the P2D gives an error   
  target = targetMidi1 + targetMidi2 + targetMidi3;
  stroke(0);
  cp5 = new ControlP5(this);
  s = cp5.addSlider2D("MutaGen")
         .setPosition(680,40)
         .setSize(100,100)
         .setMinMax(1,0.03,50,0.001)
         .setValue(10,0.01)
         .setColorBackground(color(40))
         .setColorForeground(color(180))
         .setColorActive(color(250));
         //.disableCrosshair()
         ;
         
      cp5.getController("MutaGen").getCaptionLabel().setColor(color(200));
  
  r1 = cp5.addRadioButton("radioButton")
         .setPosition(680,230)
         .setSize(35,35)
         .setColorForeground(color(180))
         .setColorActive(color(250))
         .setColorLabel(color(200))
         .setColorBackground(color(40))
         .setItemsPerRow(1)
         .addItem("Seq 1",1)
         .addItem("Seq 2",2)
         .addItem("Seq 3",3)
         .addItem("Seq 4",4)
         ;
          
  r1.activate(0);
  
 s1 = cp5.addSlider("tempo")
     .setPosition(730,186)
     .setRange(50,180)
     .setSize(200,15)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250));
     ;
     cp5.getController("tempo").getValueLabel().setColor(color(40));
    
   s2 = cp5.addSlider("midi1Note")
     .setPosition(780,240)
     .setRange(24,108)
     .setSize(84,15)
     .setCaptionLabel("Midi 1 Note Num")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250));
     ;
     cp5.getController("midi1Note").getValueLabel().setColor(color(40));
  
    s3 = cp5.addSlider("midi2Note")
     .setPosition(780,292)
     .setRange(24,108)
     .setSize(84,15)
     .setCaptionLabel("Midi 2 Note Num")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250));
     ;
     cp5.getController("midi2Note").getValueLabel().setColor(color(40));
  
    s4 = cp5.addSlider("midi3Note")
     .setPosition(780,344)
     .setRange(24,108)
     .setSize(84,15)
     .setCaptionLabel("Midi 3 Note Num")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250));
     ;
     cp5.getController("midi3Note").getValueLabel().setColor(color(40));
  
  
  // create a toggle
 tm1_0 = cp5.addToggle("m1_0")
     .setPosition(10+0*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_1 = cp5.addToggle("m1_1")
     .setPosition(10+1*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_2 = cp5.addToggle("m1_2")
     .setPosition(10+2*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_3 = cp5.addToggle("m1_3")
     .setPosition(10+3*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_4 = cp5.addToggle("m1_4")
     .setPosition(10+4*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_5 = cp5.addToggle("m1_5")
     .setPosition(10+5*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_6 = cp5.addToggle("m1_6")
     .setPosition(10+6*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_7 = cp5.addToggle("m1_7")
     .setPosition(10+7*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_8 = cp5.addToggle("m1_8")
     .setPosition(10+8*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_9 = cp5.addToggle("m1_9")
     .setPosition(10+9*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_10 = cp5.addToggle("m1_10")
     .setPosition(10+10*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_11 = cp5.addToggle("m1_11")
     .setPosition(10+11*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_12 = cp5.addToggle("m1_12")
     .setPosition(10+12*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_13 = cp5.addToggle("m1_13")
     .setPosition(10+13*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm1_14 = cp5.addToggle("m1_14")
     .setPosition(10+14*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm1_15 = cp5.addToggle("m1_15")
     .setPosition(10+15*28.5,height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
  // create a toggle
 tm2_0 = cp5.addToggle("m2_0")
     .setPosition(10+0*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_1 = cp5.addToggle("m2_1")
     .setPosition(10+1*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_2 = cp5.addToggle("m2_2")
     .setPosition(10+2*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_3 = cp5.addToggle("m2_3")
     .setPosition(10+3*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_4 = cp5.addToggle("m2_4")
     .setPosition(10+4*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_5 = cp5.addToggle("m2_5")
     .setPosition(10+5*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_6 = cp5.addToggle("m2_6")
     .setPosition(10+6*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_7 = cp5.addToggle("m2_7")
     .setPosition(10+7*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_8 = cp5.addToggle("m2_8")
     .setPosition(10+8*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_9 = cp5.addToggle("m2_9")
     .setPosition(10+9*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_10 = cp5.addToggle("m2_10")
     .setPosition(10+10*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_11 = cp5.addToggle("m2_11")
     .setPosition(10+11*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_12 = cp5.addToggle("m2_12")
     .setPosition(10+12*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_13 = cp5.addToggle("m2_13")
     .setPosition(10+13*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm2_14 = cp5.addToggle("m2_14")
     .setPosition(10+14*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm2_15 = cp5.addToggle("m2_15")
     .setPosition(10+15*28.5,2.5*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;     
     
  // create a toggle
 tm3_0 = cp5.addToggle("m3_0")
     .setPosition(10+0*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_1 = cp5.addToggle("m3_1")
     .setPosition(10+1*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_2 = cp5.addToggle("m3_2")
     .setPosition(10+2*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_3 = cp5.addToggle("m3_3")
     .setPosition(10+3*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_4 = cp5.addToggle("m3_4")
     .setPosition(10+4*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_5 = cp5.addToggle("m3_5")
     .setPosition(10+5*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_6 = cp5.addToggle("m3_6")
     .setPosition(10+6*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_7 = cp5.addToggle("m3_7")
     .setPosition(10+7*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_8 = cp5.addToggle("m3_8")
     .setPosition(10+8*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_9 = cp5.addToggle("m3_9")
     .setPosition(10+9*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_10 = cp5.addToggle("m3_10")
     .setPosition(10+10*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_11 = cp5.addToggle("m3_11")
     .setPosition(10+11*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_12 = cp5.addToggle("m3_12")
     .setPosition(10+12*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_13 = cp5.addToggle("m3_13")
     .setPosition(10+13*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
     
 tm3_14 = cp5.addToggle("m3_14")
     .setPosition(10+14*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;

 tm3_15 = cp5.addToggle("m3_15")
     .setPosition(10+15*28.5,4*height/5-40)
     .setSize(24,40)
     .setCaptionLabel("")
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     ;
  
  MidiBus.list(); 
  myBus = new MidiBus(this, -1, 1);

  population = new DNA[totalPopulation];

  for (int i = 0; i < population.length; i++) {
    population[i] = new DNA(target.length());
  }
  
  f = createFont("Courier",48,true);
  textFont(f,48);
  updateGA(); // Run the GA once to initialize everything
  noStroke();
  radioButton(1);
}

void draw() {
  if(millis()-startTime > 60/tempo/4*1000){
    updateTargetMidi1();
    updateTargetMidi2();
    updateTargetMidi3();
  
    target = targetMidi1 + targetMidi2 + targetMidi3;
  
    switch(activeSeq) {
      case(1): targetSeq1 = target; break;
      case(2): targetSeq2 = target; break;
      case(3): targetSeq3 = target; break;
      case(4): targetSeq4 = target; break;
    }

    generations = int(s.getArrayValue()[0]);
    mutationRate = s.getArrayValue()[1];
    startTime = millis(); // Reset the clock
    beat++; // Increment beat
    beat = beat%targetMidi1.length(); // modulo beat to wrap around to 0 at the end of the sequence
    if(fittest.charAt(beat)==49){ // we're in ASCII character land, so 1 = 49
      midi1On();
    }
    if(fittest.charAt(beat+16)==49){ // we're in ASCII character land, so 1 = 49
      midi2On();
    }
    if(fittest.charAt(beat+32)==49){ // we're in ASCII character land, so 1 = 49
      midi3On();
    }

    drawScreen();
    delay(20);
    if(fittest.charAt(beat)==49){ // we're in ASCII character land, so 1 = 49
      midi1Off();
    }
    if(fittest.charAt(beat+16)==49){ // we're in ASCII character land, so 1 = 49
      midi2Off();
    }
    if(fittest.charAt(beat+32)==49){ // we're in ASCII character land, so 1 = 49
      midi3Off();
    }
    
    for (int i = 0; i < generations; i++){ // set the number of times to update the GA between beats
      updateGA();
    }
  }
}

void drawScreen(){
  background(60);
  
  textFont(f,18);
  text("Mutation Rate:", 800, 60);
  text(mutationRate*100+"%",800,80);
  text("Gens/Step:", 800, 115);
  text(generations,800, 135);
  text("BPM:", 680, 200);
  
  textFont(f,24);

  fill(200);
  rect(10+beat*28.5,height/5+50,24,5);
  rect(10+beat*28.5,2.5*height/5+50,24,5);
  rect(10+beat*28.5,4*height/5+50,24,5);
  
  for (int i = 0; i < 16; i++){ // set the number of times to update the GA between beats
    if(int(fittest.charAt(i))==49){
      fill(255,200,200);
    } else {
      fill(200,200,255);
    }
    rect(10+i*28.5,height/5+5,24,40);
    
    if(int(fittest.charAt(i+16))==49){
      fill(255,200,200);
    } else {
      fill(200,200,255);
    }
    rect(10+i*28.5,2.5*height/5+5,24,40);
    
    if(int(fittest.charAt(i+32))==49){
      fill(255,200,200);
    } else {
      fill(200,200,255);
    }
    rect(10+i*28.5,4*height/5+5,24,40);
  }
  
  stroke(200);
  line(7,33,7,370);
  line(121,33,121,370);
  line(235,33,235,370);
  line(349,33,349,370);
  line(463.5,33,463.5,370);
  noStroke();
  
  fill(200);

  text("Goal", 480, height/5-13);
  text("Gene", 480, height/5+32);
  text("MIDI 1", 550, height/5+9.5);

  text("Goal", 480, 2.5*height/5-13);
  text("Gene", 480, 2.5*height/5+32);
  text("MIDI 2", 550, 2.5*height/5+9.5);

  text("Goal", 480, 4*height/5-13);
  text("Gene", 480, 4*height/5+32);
  text("MIDI 3", 550, 4*height/5+9.5);
}

void updateTargetMidi1(){
  targetMidi1 = "";
  if(m1_0){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_1){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_2){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_3){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_4){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_5){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_6){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_7){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_8){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_9){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_10){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_11){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_12){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_13){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_14){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
  if(m1_15){
    targetMidi1 += "1";  
  } else {
    targetMidi1 += "0";
  }
}

void radioButton(int a) {
  activeSeq = a;
  switch(activeSeq) {
    case(-1): target = "000000000000000000000000000000000000000000000000"; break;
    case(1): target = targetSeq1; break;
    case(2): target = targetSeq2; break;
    case(3): target = targetSeq3; break;
    case(4): target = targetSeq4; break;
  }
  updateScreenStates();
}

void updateScreenStates(){
  // Update screen states
    if(int(target.charAt(0))==49){
      tm1_0.setValue(1);
    } else {
      tm1_0.setValue(0);
    }    
    if(int(target.charAt(1))==49){
      tm1_1.setValue(1);
    } else {
      tm1_1.setValue(0);
    }    
    if(int(target.charAt(2))==49){
      tm1_2.setValue(1);
    } else {
      tm1_2.setValue(0);
    }    
    if(int(target.charAt(3))==49){
      tm1_3.setValue(1);
    } else {
      tm1_3.setValue(0);
    }    
    if(int(target.charAt(4))==49){
      tm1_4.setValue(1);
    } else {
      tm1_4.setValue(0);
    }    
    if(int(target.charAt(5))==49){
      tm1_5.setValue(1);
    } else {
      tm1_5.setValue(0);
    }    
    if(int(target.charAt(6))==49){
      tm1_6.setValue(1);
    } else {
      tm1_6.setValue(0);
    }    
    if(int(target.charAt(7))==49){
      tm1_7.setValue(1);
    } else {
      tm1_7.setValue(0);
    }    
    if(int(target.charAt(8))==49){
      tm1_8.setValue(1);
    } else {
      tm1_8.setValue(0);
    }    
    if(int(target.charAt(9))==49){
      tm1_9.setValue(1);
    } else {
      tm1_9.setValue(0);
    }    
    if(int(target.charAt(10))==49){
      tm1_10.setValue(1);
    } else {
      tm1_10.setValue(0);
    }    
    if(int(target.charAt(11))==49){
      tm1_11.setValue(1);
    } else {
      tm1_11.setValue(0);
    }    
    if(int(target.charAt(12))==49){
      tm1_12.setValue(1);
    } else {
      tm1_12.setValue(0);
    }    
    if(int(target.charAt(13))==49){
      tm1_13.setValue(1);
    } else {
      tm1_13.setValue(0);
    }    
    if(int(target.charAt(14))==49){
      tm1_14.setValue(1);
    } else {
      tm1_14.setValue(0);
    }    
    if(int(target.charAt(15))==49){
      tm1_15.setValue(1);
    } else {
      tm1_15.setValue(0);
    }
    

    if(int(target.charAt(16))==49){
      tm2_0.setValue(1);
    } else {
      tm2_0.setValue(0);
    }    
    if(int(target.charAt(17))==49){
      tm2_1.setValue(1);
    } else {
      tm2_1.setValue(0);
    }    
    if(int(target.charAt(18))==49){
      tm2_2.setValue(1);
    } else {
      tm2_2.setValue(0);
    }    
    if(int(target.charAt(19))==49){
      tm2_3.setValue(1);
    } else {
      tm2_3.setValue(0);
    }    
    if(int(target.charAt(20))==49){
      tm2_4.setValue(1);
    } else {
      tm2_4.setValue(0);
    }    
    if(int(target.charAt(21))==49){
      tm2_5.setValue(1);
    } else {
      tm2_5.setValue(0);
    }    
    if(int(target.charAt(22))==49){
      tm2_6.setValue(1);
    } else {
      tm2_6.setValue(0);
    }    
    if(int(target.charAt(23))==49){
      tm2_7.setValue(1);
    } else {
      tm2_7.setValue(0);
    }    
    if(int(target.charAt(24))==49){
      tm2_8.setValue(1);
    } else {
      tm2_8.setValue(0);
    }    
    if(int(target.charAt(25))==49){
      tm2_9.setValue(1);
    } else {
      tm2_9.setValue(0);
    }    
    if(int(target.charAt(26))==49){
      tm2_10.setValue(1);
    } else {
      tm2_10.setValue(0);
    }    
    if(int(target.charAt(27))==49){
      tm2_11.setValue(1);
    } else {
      tm2_11.setValue(0);
    }    
    if(int(target.charAt(28))==49){
      tm2_12.setValue(1);
    } else {
      tm2_12.setValue(0);
    }    
    if(int(target.charAt(29))==49){
      tm2_13.setValue(1);
    } else {
      tm2_13.setValue(0);
    }    
    if(int(target.charAt(30))==49){
      tm2_14.setValue(1);
    } else {
      tm2_14.setValue(0);
    }    
    if(int(target.charAt(31))==49){
      tm2_15.setValue(1);
    } else {
      tm2_15.setValue(0);
    } 
    
    if(int(target.charAt(32))==49){
      tm3_0.setValue(1);
    } else {
      tm3_0.setValue(0);
    }    
    if(int(target.charAt(33))==49){
      tm3_1.setValue(1);
    } else {
      tm3_1.setValue(0);
    }    
    if(int(target.charAt(34))==49){
      tm3_2.setValue(1);
    } else {
      tm3_2.setValue(0);
    }    
    if(int(target.charAt(35))==49){
      tm3_3.setValue(1);
    } else {
      tm3_3.setValue(0);
    }    
    if(int(target.charAt(36))==49){
      tm3_4.setValue(1);
    } else {
      tm3_4.setValue(0);
    }    
    if(int(target.charAt(37))==49){
      tm3_5.setValue(1);
    } else {
      tm3_5.setValue(0);
    }    
    if(int(target.charAt(38))==49){
      tm3_6.setValue(1);
    } else {
      tm3_6.setValue(0);
    }    
    if(int(target.charAt(39))==49){
      tm3_7.setValue(1);
    } else {
      tm3_7.setValue(0);
    }    
    if(int(target.charAt(40))==49){
      tm3_8.setValue(1);
    } else {
      tm3_8.setValue(0);
    }    
    if(int(target.charAt(41))==49){
      tm3_9.setValue(1);
    } else {
      tm3_9.setValue(0);
    }    
    if(int(target.charAt(42))==49){
      tm3_10.setValue(1);
    } else {
      tm3_10.setValue(0);
    }    
    if(int(target.charAt(43))==49){
      tm3_11.setValue(1);
    } else {
      tm3_11.setValue(0);
    }    
    if(int(target.charAt(44))==49){
      tm3_12.setValue(1);
    } else {
      tm3_12.setValue(0);
    }    
    if(int(target.charAt(45))==49){
      tm3_13.setValue(1);
    } else {
      tm3_13.setValue(0);
    }    
    if(int(target.charAt(46))==49){
      tm3_14.setValue(1);
    } else {
      tm3_14.setValue(0);
    }    
    if(int(target.charAt(47))==49){
      tm3_15.setValue(1);
    } else {
      tm3_15.setValue(0);
    }  
}

void updateTargetMidi2(){
  targetMidi2 = "";
  if(m2_0){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_1){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_2){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_3){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_4){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_5){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_6){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_7){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_8){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_9){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_10){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_11){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_12){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_13){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_14){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
  if(m2_15){
    targetMidi2 += "1";  
  } else {
    targetMidi2 += "0";
  }
}

void updateTargetMidi3(){
  targetMidi3 = "";
  if(m3_0){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_1){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_2){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_3){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_4){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_5){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_6){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_7){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_8){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_9){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_10){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_11){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_12){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_13){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_14){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
  if(m3_15){
    targetMidi3 += "1";  
  } else {
    targetMidi3 += "0";
  }
}

void updateGA(){
    float maxFit = 0;
    for (int i = 0; i < population.length; i++) {
    population[i].calcFitness(target);
    if(population[i].fitness > maxFit){
      maxFit = population[i].fitness;
      fittest = population[i].getPhrase();
    }
  }

  ArrayList<DNA> matingPool = new ArrayList<DNA>();  // ArrayList which we will use for our "mating pool"

  for (int i = 0; i < population.length; i++) {
    int nnnn = int(population[i].fitness * 100);  // Arbitrary multiplier, we can also use monte carlo method
    for (int j = 0; j <nnnn; j++) {              // and pick two random numbers
      matingPool.add(population[i]);
    }
  }

  for (int i = 0; i < population.length; i++) {
    int a = int(random(matingPool.size()));
    int b = int(random(matingPool.size()));
    DNA partnerA = matingPool.get(a);
    DNA partnerB = matingPool.get(b);
    DNA child = partnerA.crossover(partnerB);
    child.mutate(mutationRate);
    population[i] = child;
  }
}

void midi1On(){
  // Turn on a note - the equivalent of pressing a key down
  myBus.sendNoteOn(channel, midi1Note, velocity1); // Send a Midi noteOn
}

void midi1Off(){
  // Turn off a note - the equivalent of releasing a key
  myBus.sendNoteOff(channel, midi1Note, 0); // Send a Midi noteOff  
}

void midi2On(){
  // Turn on a note - the equivalent of pressing a key down
  myBus.sendNoteOn(channel, midi2Note, velocity2); // Send a Midi noteOn
}

void midi2Off(){
  // Turn off a note - the equivalent of releasing a key
  myBus.sendNoteOff(channel, midi2Note, 0); // Send a Midi noteOff  
}

void midi3On(){
  // Turn on a note - the equivalent of pressing a key down
  myBus.sendNoteOn(channel, midi3Note, velocity3); // Send a Midi noteOn
}

void midi3Off(){
  // Turn off a note - the equivalent of releasing a key
  myBus.sendNoteOff(channel, midi3Note, 0); // Send a Midi noteOff  
}
