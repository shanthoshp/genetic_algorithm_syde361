
class Population {
  
  float mutationRate = 0.1;      // Mutation rate
  int generations = 0;            // Number of Generations Between Updates
  float fitness;
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
  
  Population(String p, float m, int num) {
    target = p;
    mutationRate = m;
    population = new DNA[num];
    for (int i = 0; i < population.length; i++) {
      population[i] = new DNA(target.length());
    }
    
    //for (int i = 0; i < generations; i++){ // set the number of times to update the GA between beats
          updateGA();
        //}
    
    matingPool = new ArrayList<DNA>();
    //finished = false;
    //generations = 0;
    
    //perfectScore = 1;
  }
  // Fitness function (returns floating point % of "correct" characters)
  
  
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
    generations++;
  }
}
