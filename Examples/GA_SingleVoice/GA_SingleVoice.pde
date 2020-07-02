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

import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

// this library does a weird 0-indexing thing, so to send on MIDI channel 10, set this to 9
int channel = 9; 
int pitch = 0;
int velocity = 127;

// Try changing these! See what happens...
float mutationRate = 0.2;      // Mutation rate
int totalPopulation = 10;      // Total Population

DNA[] population;             // Array to hold the current population
ArrayList<DNA> matingPool;    // ArrayList which we will use for our "mating pool"
String target;                // Target phrase
String fittest;               // Variable to store the fittest gene

PFont f; // A font variable

float tempo = 100; // A tempo value in beats per minute

float startTime = millis(); // a timer variable used to find the time since last step
int beat = 0; //Index of beat

void setup() {
  size(800, 200); // define the size of the window
  target = "1000100010001000"; // manually define a beat sequence to act as a target string

  MidiBus.list(); //List the midi devices available in the console
  myBus = new MidiBus(this, -1, 1); // Create a midi bus, no input, outputting to list item (1)

  population = new DNA[totalPopulation]; // Create an array to hold your genes

  for (int i = 0; i < population.length; i++) {
    population[i] = new DNA(target.length()); // Create each individual gene's array
  }
  
  f = createFont("Courier",48,true); // Define a font variable
  
  updateGA(); // Run the GA once to initialize everything
}

void draw() {
  if(millis()-startTime > 60/tempo/4*1000){
    startTime = millis(); // Reset the clock
    beat++; // Increment beat
    beat = beat%target.length(); // modulo beat to wrap around to 0 at the end of the sequence
    if(fittest.charAt(beat)==49){ // we're in ASCII character land, so "1" = 49
      drumKick(); //send midi note 36, which typically corresponds to a "kick" drum
    }
    
    drawScreen(); // function to draw items in the scene
    
    for (int i = 0; i < 10; i++){ // set the number of times to update the GA between beats
      updateGA(); // run one reproductive cycle i times
    }
  }
}

void drawScreen(){
  background(255);
  fill(0);
  textFont(f,48);
  text(target,10,height/4);
  text(fittest,10,3*height/4);
  fill(200,0,0);
  noStroke();
  circle(24+beat*28.5,height/2,28.5);
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

void drumKick(){
  // Turn on the note - the equivalent of pressing a key down
  myBus.sendNoteOn(channel, 36, velocity); // Send a Midi noteOn
  delay(10); // Wait a bit - sometimes if you send MIDI data too quickly it's a problem
  // Turn off the note - the equivalent of releasing a key
  myBus.sendNoteOff(channel, 36, 0); // Send a Midi noteOff  
}
