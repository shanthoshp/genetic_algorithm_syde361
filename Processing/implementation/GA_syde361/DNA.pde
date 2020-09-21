   //remove after sienna tests
  float fit=0;
  float fit_no_w=0;
  float score_og=0;
  float weight_og=0;
  float score_cl=0;
  float weight_cl=0;
  float score_op=0;
  float weight_op=0;
  float score_og_w=0;
  int dense=0;

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
    
     float score_original = 5;      // score of target // setting to 5 produced 1-2 beats regularly
     float score_closedHat = -5;  // score of symmetry  
     float score_openHat = 3;  // score of density
     
     float weight_original = (100*0.6);      // weight of target
     float weight_closedHat = (100*0.2);     // weight of symmetry
     float weight_openHat = (100*0.2);       // weight of density
     
            print("gens at suggestion: "+count);
            print('\n');
            print("mutation rate at suggestion: "+mutationRate);
            print('\n');

     for (int i = 0; i < genes.length; i++) {
       if (i<16) {
         if (genes[i] == 49) {
           print(1);
         }
         else{
           print(0);
         }
       }
        if (genes[i] == target.charAt(i)) {
          score_original++;
        }
     }
     
     print('\n');

     //the closed hat section of the beat is checked for symmetry
     for (int i = 16; i < 32; i++){
       if( genes[i] != genes[i-1]){
         sym1++;
         score_closedHat++;
       }
         if (genes[i] == 49) {
           print(1);
         }
         else{
           print(0);
         }
       
     }
     
     print('\n');
     
     if(sym1 < 11){
        score_closedHat -= 5;
     }

     //the open hat section of the beat is checked for low density of notes
     for (int i = 32; i < target.length(); i++){
       if(genes[i] == 49){
         density++;
         print(1);
       }
       else {
         print(0);
       }
     }
     print('\n');
     
     if(density > 2 || density == 0){
       score_openHat = -10; // ends up with the 2 beat stuff right away
       //score_openHat = -5;  // Consistently suggests beats with 3, 4, and 5 beats
     }
     
             dense=density;

            print("score original: "+score_original);
            print('\n');
            print("score og*weight: "+(score_original*weight_original/48.0));
            print('\n');
            print("score closed: "+score_closedHat);
            print('\n');
            print("score cl*weight: "+(score_closedHat*weight_closedHat/48.0));
            print('\n');
            print("Density: "+density);
            print('\n');
            print("score open: "+score_openHat);
            print('\n');
            print("score op*weight: "+(score_openHat*weight_openHat/48.0));
            print('\n');
            print("fitness no weight: "+(score_original + score_closedHat + score_openHat));
            //print('\n');
     
     //Fitness value is fluctuates around 90 to plus/minus 10 (where max is roughly 100)
     fitness = (score_original * weight_original + score_closedHat * weight_closedHat + score_openHat * weight_openHat) / (float)target.length();
     //fitness = float(score_original * weight_original + score_closedHat * weight_closedHat + score_openHat * weight_openHat) / (float)target.length();
               print('\n');


            print("fitness total: "+fitness);
            print('\n');
            print('\n');

     //remove after sienna tests
     //print("(float)target.length(): "+(float)target.length());
      fit=fitness;
      fit_no_w=score_original + score_closedHat + score_openHat;
      score_og=score_original;
      weight_og=weight_original;
      score_cl=score_closedHat;
      weight_cl=weight_closedHat;
      score_op=score_openHat;  
      weight_op=weight_openHat;
      
      score_og_w=score_original * weight_original;
      
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
