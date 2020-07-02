// Adapted by Matt Borland from:
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// See the commenting in GA_SingleVoice to make sense of what is happening here

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

import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

// this library does a weird 0-indexing thing, so to send on MIDI channel 10, set this to 9
int channel = 0; 
int velocity1 = 120;
int velocity2 = 120;
int velocity3 = 100;

int midi1Note = 36;
int midi2Note = 38;
int midi3Note = 42;

float mutationRate = 0.1;      // Mutation rate
int totalPopulation = 150;      // Total Population
int generations = 10;            // Number of Generations Between Updates

DNA[] population;             // Array to hold the current population
ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
String target;                // Target phrase
String fittest;               // Variable to store the fittest gene
String targetMidi1;                // Target phrase
String targetMidi2;                // Target phrase
String targetMidi3;                // Target phrase
PFont f;

float tempo = 120; // A tempo value in beats per minute

float startTime = millis(); 
int beat = 0; //Index of beat
void setup() {
  size(800, 600);
  targetMidi1 =   "1010000010010000"; // These need to be 16 long to work with the other parts
  targetMidi2 =  "1000101000001000"; // of the code. You can change their size, but would have
  targetMidi3 =   "0000101000100010"; // adjsut some other parameters
  target = targetMidi1 + targetMidi2 + targetMidi3;
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
}

void draw() {
  if(millis()-startTime > 60/tempo/4*1000){
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
    delay(10);
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
  background(255);
  fill(200,200,255);
  circle(24+beat*28.5,2*height/7,28.5);
  fill(255,200,200);
  circle(24+beat*28.5,4*height/7,28.5);
  fill(200,255,200);
  circle(24+beat*28.5,6*height/7,28.5);
  
  fill(0);
  text("T: MIDI 1", 500, height/7);
  text(targetMidi1,10,height/7);
  text("G: MIDI 1", 500, 2*height/7);
  text(fittest.substring(0,16),10,2*height/7);

  text("T: MIDI 2", 500, 3*height/7);
  text(targetMidi2,10,3*height/7);  
  text("G: MIDI 2", 500, 4*height/7);
  text(fittest.substring(16,32),10,4*height/7);

  text("T: MIDI 3", 500, 5*height/7);
  text(targetMidi3,10,5*height/7);  
  text("G: MIDI 3", 500, 6*height/7);
  text(fittest.substring(32,48),10,6*height/7);  
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
