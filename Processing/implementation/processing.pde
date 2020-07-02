// Genetic Algorithm

// A class to describe a psuedo-DNA, i.e. genotype
//   Here, a virtual organism's DNA is an array of character.
//   Functionality:
//      -- convert DNA into a string
//      -- mate DNA with another set of DNA
//      -- mutate DNA


class DNA {

  // The genetic sequence
  char[] genes;
  
  float fitness;
  
  // Constructor (makes a random DNA)
  DNA(int num) {
    genes = new char[num];
    for (int i = 0; i < genes.length; i++) {
      genes[i] = (char) random(48,50);  // Pick from range of chars
    }
  }
  
  // Converts character array to a String
  String getPhrase() {
    return new String(genes);
  }
  
  // Crossover
  DNA crossover(DNA partner) {
    // A new child
    DNA child = new DNA(genes.length);
    
    int midpoint = int(random(genes.length)); // Pick a midpoint
    
    // Half from one, half from the other
    for (int i = 0; i < genes.length; i++) {
      if (i > midpoint) child.genes[i] = genes[i];
      else              child.genes[i] = partner.genes[i];
    }
    return child;
  }
  
  // Fitness function (returns floating point % of "correct" characters)
  void calcFitness (String target) {
     int score = 0;
     for (int i = 0; i < genes.length; i++) {
        if (genes[i] == target.charAt(i)) {
          score++;
        }
     }
     fitness = (float)score / (float)target.length();
  }
  
  // Based on a mutation probability, picks a new random character
  void mutate(float mutationRate) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < mutationRate) {
        genes[i] = (char) random(48,50); // Limit the Char to "0" or "1"
      }
    }
  }
}


class Population {
    
  DNA[] mutation(DNA[] population, float mutationRate){
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
    return population;
  }
  
   void updateGA(DNA[] population, String fittest, String target,  float mutationRate) {
    DNA[] new_population = mutation(population, mutationRate);
    float maxFit = 0;
    for (int i = 0; i < new_population.length; i++) {
      new_population[i].calcFitness(target);
      if(new_population[i].fitness > maxFit){
        maxFit = new_population[i].fitness;
        fittest = new_population[i].getPhrase();
      }
    }
  }
}
  
    
    
    
    
    
   
  
  

  
  
  
  
  
  
  
  
  
  
  
  
