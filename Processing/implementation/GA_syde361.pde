import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

int channel = 0; 
String targetMidi1;
String targetMidi2; 
String targetMidi3;
//int velocity1 = 120;
//int velocity2 = 120;
//int velocity3 = 100;
int midi1Note = 36;
int midi2Note = 38;
int midi3Note = 42;

float mutationRate = 0.1; 
int totalPopulation = 150;
int beat = 0;
Boolean currentlyOnFirst = true;
Population population;
int generations = 10;
float startTime = millis(); 
float tempo = 20;
PFont f;

void setup() {
  size(800, 300);
  background(c_very_dark);
  targetMidi1 =   "0000000000000000"; // These need to be 16 long to work with the other parts
  targetMidi2 =  "1000101000001000"; // of the code. You can change their size, but would have
  targetMidi3 =   "0001111111100010"; // adjsut some other parameters
  String target = targetMidi1 + targetMidi2 + targetMidi3;
  MidiBus.list(); 
  myBus = new MidiBus(this, -1, 1);

  population = new Population(target,mutationRate,totalPopulation);
  population.updateGA();

  f = createFont("Courier",48,true);
  textFont(f,20);
  noStroke();
}

void draw() {
      if(currentlyOnFirst == true){
        beginCard("Welcome to UCompose, please select a genre of music:", 0, 0, 800, 600);
        
        //text(,20,70);
        if(Button("Hip-hop",20,100)){
          currentlyOnFirst = false;
          
        }
        
        if(Button("R&B",20,150)){
          //screen++;
        }
        
        if(Button("Rock",20,200)){
          //screen++;
        }
      endCard();
      }
      else{
        drawScreen();
        //text("Here",20,100);
        redraw();
        if(millis()-startTime > 60/tempo/4*1000){
          startTime = millis();
          beat++;
          beat = beat%targetMidi1.length();
          
          population.updateGA();
          //text(population.fittest.substring(0,16),200,2*height/7);
        }
      }
  }

void drawScreen(){
   background(c_mid);
   textFont(f,18);
  
  fill(200,200,255);
   //text("MIDI 1", 550, height/5+9.5);
   
  //rect(10+beat*28.5,height/5+50,24,5); // these are the dashes that keep time
  //rect(10+beat*28.5,2.5*height/5+50,24,5);
  //rect(10+beat*28.5,4*height/5+50,24,5);
  
  for (int i = 0; i < 16; i++){ // set the number of times to update the GA between beats
    if(int(population.fittest.charAt(i))==49){
      fill(0,255,0);
    } else {
      fill(209, 210, 211);
    }
    rect(45+i*32,height/5+5,30,30,5);
    
    if(int(population.fittest.charAt(i+16))==49){
      fill(255,0,0); // fill for wanted beat 
    } else {
      fill(209, 210, 211); // fill for unwanted beat
    }
    //rectMode(RADIUS);
    rect(45+i*32,1.7*height/5+5,30,30,5);
    
    if(int(population.fittest.charAt(i+32))==49){
      fill(255,0,255);
    } else {
      fill(209, 210, 211);
    }
    rect(45+i*32,2.4*height/5+5,30,30,5);
  }
  
  stroke(200);
  
  noStroke();
  
}
