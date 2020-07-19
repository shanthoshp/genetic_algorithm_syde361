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

//Storage of the toggle states of each button in the sequencer
int instruments = 3;
int beats = 16;
boolean[][] sequencer_states = new boolean[instruments][beats];
//track if any of the instrument lines have been selected by the instrument button
boolean[] instrument_buttons = new boolean[instruments];


//UI variables
int margin_left = 205;
int margin_top = 120;
int title_height = 100;
TextInputSpecial song_title= new TextInputSpecial("my_beat");
PImage[] instrument_icons = new PImage[instruments];
PImage[] instrument_hovers = new PImage[instruments];


void setup() {
  size(1366, 768);
  background(black);
  clear();
  targetMidi1 =   "0000000000000000"; // These need to be 16 long to work with the other parts
  targetMidi2 =  "1000101000001000"; // of the code. You can change their size, but would have
  targetMidi3 =   "0001111111100010"; // adjsut some other parameters
  String target = targetMidi1 + targetMidi2 + targetMidi3;
  MidiBus.list(); 
  myBus = new MidiBus(this, -1, 1);

  population = new Population(target,mutationRate,totalPopulation);
  population.updateGA();

  f = createFont("Roboto",48,true);
  textFont(f,20);
  noStroke();
  
  // Initialize sequencer_states
  for (int i = 0; i < instruments; i++) {
    instrument_buttons[i]=false;
    for (int j = 0; j < beats; j++) {
      sequencer_states[i][j] = false;
    }
  }
  
  //Load icons for sequencer
  instrument_icons[0] = loadImage("assets/kick.png");
  instrument_icons[1] = loadImage("assets/snare.png");
  instrument_icons[2] = loadImage("assets/clap.png");
  instrument_hovers[0] = loadImage("assets/kick-hover.png");
  instrument_hovers[1] = loadImage("assets/snare-hover.png");
  instrument_hovers[2] = loadImage("assets/clap-hover.png");
}

void draw() {
      //if(currentlyOnFirst == true){
      //  beginCard("Welcome to UCompose, please select a genre of music:", 0, 0, 800, 600);
        
      //  //text(,20,70);
      //  if(Button("Hip-hop",20,100)){
      //    currentlyOnFirst = false;
          
      //  }
        
      //  if(Button("R&B",20,150)){
      //    //screen++;
      //  }
        
      //  if(Button("Rock",20,200)){
      //    //screen++;
      //  }
      //endCard();
      //}
      //else{
        

        drawScreen();

        redraw();
        
        if(millis()-startTime > 60/tempo/4*1000){
          startTime = millis();
          beat++;
          beat = beat%targetMidi1.length();
          
          population.updateGA();
          //text(population.fittest.substring(0,16),200,2*height/7);
        }
      //}
  }

void drawScreen(){
   background(black);
   textFont(f,18);
   
   String title = song_title.draw(margin_left,margin_top,900,70);
   
   drawDrumMachine();
       
  //for (int i = 0; i < 16; i++){ // set the number of times to update the GA between beats
  //  if(int(population.fittest.charAt(i))==49){
  //    fill(0,255,0);
  //  } else {
  //    fill(209, 210, 211);
  //  }
  //  rect(45+i*32,height/5+5,30,30,5);
    
  //  if(int(population.fittest.charAt(i+16))==49){
  //    fill(255,0,0); // fill for wanted beat 
  //  } else {
  //    fill(209, 210, 211); // fill for unwanted beat
  //  }
  //  //rectMode(RADIUS);
  //  rect(45+i*32,1.7*height/5+5,30,30,5);
    
  //  if(int(population.fittest.charAt(i+32))==49){
  //    fill(255,0,255);
  //  } else {
  //    fill(209, 210, 211);
  //  }
  //  rect(45+i*32,2.4*height/5+5,30,30,5);
  //}
  //  stroke(200);
  
  //  noStroke();
}
  
  void drawDrumMachine (){
   for (int i = 0; i < instruments; i++){
     instrument_buttons[i]=ImageButtonToggle(instrument_buttons[i], instrument_icons[i], instrument_hovers[i], margin_left, margin_top+title_height+i*57, 50, 50);
     print(instrument_buttons[i]);
     for (int j=0; j < beats; j++){
       boolean downbeat = (j%4 == 0);
       sequencer_states[i][j] = Square(sequencer_states[i][j], margin_left+ (j+1)*57, margin_top+title_height+i*57, 50, 50, i, downbeat);
     }
   }   
        print('\n');

 }
