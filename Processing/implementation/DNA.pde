class DNA {
  int sym1;
  //int sym2;
  int density;
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
  
  void calcFitness (String target) {
     int score = 0;
     for (int i = 0; i < genes.length; i++) {
        if (genes[i] == target.charAt(i)) {
          score++;
        }
     }
     
     for (int i = 17; i < 32; i++){
       if( genes[i] != genes[i-1]){
         sym1++;
       }
     }
     if(sym1 < 11){
         score -= 8;
     }
     
     for (int i = 33; i < target.length(); i++){
       if(genes[i] == 49){
         density++;
       }
       
       
     }
     if(density > 2){
       score -= 10;
     }
     
     fitness = (float)score / (float)target.length();
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
  
  // Based on a mutation probability, picks a new random character
  void mutate(float mutationRate) {
    for (int i = 0; i < genes.length; i++) {
      if (random(1) < mutationRate) {
        genes[i] = (char) random(48,50); // Limit the Char to "0" or "1"
      }
    }
  }
}
