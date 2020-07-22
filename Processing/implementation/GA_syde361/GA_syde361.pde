import themidibus.*; //Import the library
import controlP5.*;
MidiBus myBus; // The MidiBus
import arb.soundcipher.*;
SCScore score = new SCScore();
//this is new branch
int channel = 0; 
String targetMidi1;
String targetMidi2; 
String targetMidi3;
String target;
//int velocity1 = 120;
//int velocity2 = 120;
//int velocity3 = 100;
int midi1Note = 36;
int midi2Note = 38;
int midi3Note = 42;

StringList suggestions = new StringList();
int currentSuggestion = 0;
String nextButtonLabel = "+";
Boolean showBackButton = false;
Boolean showSuggestions = false;
String suggestionsLabel = "Show Suggestions";

boolean playing = false;

float mutationRate = 0.001; 
int totalPopulation = 150;
int beat = 0;
Boolean currentlyOnFirst = true;
Population population;
int generations = 20;
float startTime = millis(); 
float tempo = 60;
PFont f;

ControlP5 cp5;
ScreenSwitchListener screenListener;
PlayPauseListener playSong;
CallbackListener cb;
//PauseListener pauseListener;
//ControlFont font = new ControlFont(f,14);
Slider2D s;
Slider s1;
Button pause;
Button play;
Button resume;
Button playSuggestion;
Button getSuggestion;
Knob soundLevel;
int clickedButton;
int changeScreen;
int pauseScreen;
double volume = 80;

//Store toggle states of each button in the sequencer (this is the user's beat)
int instruments = 3;
int beats = 16;
boolean[][] sequencer_states = new boolean[instruments][beats];
boolean[][] suggestion_states = new boolean[instruments][beats];

//store the strings corresponding to sequencer states (this is the user's beat as a string for each instrument)
String user_beat;

//track if any of the instrument lines have been selected by the instrument button
boolean[] instrument_buttons = new boolean[instruments];


//UI variables
int margin_left = 205;
//int margin_left = 100;
int margin_top = 120;
int title_height = 100;
int machine_height = 375; //currently this is just a buffer to keep stuff from overlapping
TextInputSpecial song_title= new TextInputSpecial("my_beat");
PImage[] instrument_icons = new PImage[instruments];
PImage[] instrument_hovers = new PImage[instruments];

void setup() {
  size(1366, 768);
  background(black);
  suggestions.append("000000000000000000000000000000000000000000000000");
  
  
  
  targetMidi1 =   "1010000000100100"; // Kick drum
  targetMidi2 =   "1111111011111011"; // Closed hi-hat
  targetMidi3 =   "0000000100000100"; // Open hi-hat
  target = targetMidi1 + targetMidi2 + targetMidi3;
  MidiBus.list(); 
  myBus = new MidiBus(this, -1, 1);

  population = new Population(target,mutationRate,totalPopulation);
  population.updateGA(mutationRate);

  f = createFont("Roboto",48,true);
  ControlFont fontBPM = new ControlFont(f,15);
    ControlFont pause_play_buttons_font = new ControlFont(f,15);

  ControlFont font = new ControlFont(f,20);
  textFont(f,20);
  noStroke();
  
 // Initialize sequencer_states
  for (int i = 0; i < instruments; i++) {
    instrument_buttons[i]=false;
    user_beat = "000000000000000000000000000000000000000000000000";
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
  
  cp5 = new ControlP5(this);
  screenListener = new ScreenSwitchListener();
  playSong = new PlayPauseListener();
    
  cp5.addButton("Click Here To Get Started!")
     .setValue(1)
     .setPosition(550,550)
     .setSize(270,40)
     //.setColorBackground(color(51, 64, 80))
     .setColorBackground(0)

     .setFont(font)
     .addListener(screenListener)
     ;
     
  cp5.getController("Click Here To Get Started!")
     .getCaptionLabel()
     .toUpperCase(false)
     ;
  
  s = cp5.addSlider2D("MutaGen")
         //.setArrayValue(int,float)
         .setPosition(680,40+machine_height)

         .setSize(100,100)
         .setMinMax(1,0.05,20,0.001)
         .setValue(1,0.02)
         .setColorBackground(color(40))
         .setColorForeground(color(180))
         .setColorActive(color(250))
         .setDecimalPrecision(1)
         .setCaptionLabel("")
         .setVisible(false)
         ;
       
 s1 = cp5.addSlider("tempo")
     .setPosition(margin_left+60+((beats-6)*57),margin_top+52)
     .setRange(50,180)
     .setSize(130,35)
     .setCaptionLabel("BPM")
     .setFont(fontBPM)
     .setColorBackground(color(40))
     .setColorForeground(color(180))
     .setColorActive(color(250))
     .setVisible(false);
     ;
     cp5.getController("tempo").getValueLabel().setColor(color(40));
         
  cp5.getController("MutaGen")
     .getValueLabel()
     .setVisible(true)
     ;
  
  soundLevel = cp5.addKnob("volume")
                  .setRange(0,10)
                  .setValue(5)
                  .setPosition(705,215+machine_height)
                  .setRadius(25)
                  .setDragDirection(Knob.HORIZONTAL)
                  .showTickMarks()
                  .setColorBackground(color(40))
                  .setColorForeground(color(180))
                  .setColorActive(color(250))
                  .setVisible(false)
                  ;
  //pauseListener = new PauseListener();
  pause = cp5.addButton("Pause")
             .setValue(0)
             //.setPosition(20,200+machine_height+100)
             .setPosition(margin_left,margin_top+50) 
             .setSize(100,35)
             .setColorBackground(0)
             .setFont(pause_play_buttons_font)
             .setVisible(false)
             .addListener(playSong)
             ;
      
  play = cp5.addButton("Play")
             .setValue(1)
             .setPosition(margin_left + 100,margin_top+50)
             .setSize(100,35)
             .setColorBackground(color(255,255,255))
             .setColorCaptionLabel(0)
             .setFont(pause_play_buttons_font)
             .setVisible(false)
             //.addListener(playSong)
             ;

  resume = cp5.addButton("Generate")
             .setValue(2)
             .setPosition(280,200+machine_height+100)
             .setSize(100,30)
             .setColorBackground(color(51, 64, 80))
             .setFont(font)
             .setVisible(false)
             ;

    pause.addCallback(new CallbackListener(){
      public void controlEvent(CallbackEvent theEvent){
        if(theEvent.getAction() == ControlP5.ACTION_PRESSED){
          //cp5.getController("Pause").setVisible(true);
          pauseScreen = (int)theEvent.getController().getValue();
          
          playing = false;
        }
      }
    }
  );
  
  
   play.addCallback(new CallbackListener(){
      public void controlEvent(CallbackEvent theEvent){
        if(theEvent.getAction() == ControlP5.ACTION_PRESSED){

          //cp5.getController("Play").setVisible(true);
          playSound(volume, arrayToString(sequencer_states));

          print(user_beat);
          print('\n');
          
          playing = true;
          beat = 0;
        }
      }
    }
    );
    
    //functionality for volume control enabled
    soundLevel.addCallback(new CallbackListener(){
      public void controlEvent(CallbackEvent theEvent){
        if(theEvent.getAction() == ControlP5.ACTION_RELEASED || theEvent.getAction() == ControlP5.ACTION_RELEASEDOUTSIDE){
          volume = cp5.getController("volume").getValue()*16;
        }
      }
    }
    );
    
    //TO DO: Generate button is not wired up yet. Need to define button use case
    resume.addCallback(new CallbackListener(){
      public void controlEvent(CallbackEvent theEvent){
        if(theEvent.getAction() == ControlP5.ACTION_PRESSED){
          pauseScreen = (int)theEvent.getController().getValue();
          //draw();
        }
      }
    }
    );
}

String newSuggestion(){
  String new_suggestion = population.fittest;
  suggestions.append(new_suggestion);
  currentSuggestion = currentSuggestion + 1;
  return new_suggestion;
}

void draw() {
      if(changeScreen == 0){
        beginCard("UCompose", 0, 150, 1350, 1000);
        rect(width/4,height/4,width/2,height/2);
        fill(255);
          String str="Hello! I am a drum machine. I’ll run your beat through my genetic algorithm and suggest things you could add to make it even better.";
           textSize(25);
        text(str, 
        width/4, height/4, 
        width/2,  height/2 );
      }
       else if(changeScreen == 1){
        drawScreen();
        target = targetMidi1 +targetMidi2 + targetMidi3;
        user_beat = boolsToString(sequencer_states, instruments, beats);

        redraw();

        if(millis()-startTime > 60/tempo/4*1000){
          startTime = millis();
          if (playing){
            beat++;
            if (beat ==16){
              playing = false;} // take this out once it loops continuously
            beat = beat%targetMidi1.length();
          }
          

          //Each ControlP5 element is shown on the main beat maker page
          score.tempo(tempo*4);

          s1.setVisible(true);

          //generations = int(s.getArrayValue()[0]); // replaced by a single slider, see drawSuggestions
          //mutationRate = s.getArrayValue()[1]; // replaced by a single slider, see drawSuggestions
          cp5.getController("MutaGen")
             .setCaptionLabel("Mut/Gen" + "   " + s.getArrayValue()[1] + "," + int(s.getArrayValue()[0]) )
             ;
          
          if(pauseScreen == 0){
            for(int i = 0; i <generations; i++){
              population.updateGA(mutationRate);
            }
          }
          //text(population.fittest.substring(0,16),200,2*height/7);
        }
      }
  }

void drawScreen(){
   background(black);
   textFont(f,15);
   
   String title = song_title.draw(margin_left,margin_top - 75,900,70);
   GetSuggestionsButton(suggestionsLabel, margin_left+60+((beats-3)*57),margin_top+50,150,35);
 
   drawDrumMachine();
   
   if(showSuggestions==true){
   drawSuggestions();
   }


  //textAlign(CENTER);
  //text("Number of Generations: " + count, width*0.75,height*0.75);
  //text("BPM", width*0.75, height*0.9);
  
}

void drawDrumMachine (){
  //instruments and beats
  for (int i = 0; i < instruments; i++){
    instrument_buttons[i]=ImageButtonToggle(instrument_buttons[i], instrument_icons[i], instrument_hovers[i], margin_left, margin_top+title_height+i*57, 50, 50);
    for (int j=0; j < beats; j++){
      boolean downbeat = (j%4 == 0);
      sequencer_states[i][j] = Square(sequencer_states[i][j], margin_left+ (j+1)*57, margin_top+title_height+i*57, 50, 50, i, downbeat);
    }
  }
  
  //progress indicating highlight
  fill(255,150);
  rect(margin_left+(beat+1)*57-2,margin_top+title_height-2,54,57*instruments-7+4);
  
}

void drawSuggestions (){
   textFont(f,20);
   text("Suggestions for you: ",margin_left+100,margin_top+machine_height-60);
   PlaySuggestionsButton("PLAY", margin_left,margin_top+machine_height-30,100,35);
   
   //sliders - only for this version 
   fill(white);
   text("RANDOMNESS",width-700,margin_top+machine_height-30,110,35);
   mutationRate=SliderWhite(0.001, 0.05, mutationRate,width-570,margin_top+machine_height-27, 100, 25);
   print(mutationRate);
   print('\n');
   text("ITERATIONS",width-425,margin_top+machine_height-30,110,35);
   generations=int(SliderWhite(1, 20, float(generations),width-300,margin_top+machine_height-27, 100, 25));
   print(generations);
   print('\n');
   
  //instruments and beats
  for (int i = 0; i < instruments; i++){
    instrument_buttons[i]=ImageButtonToggle(instrument_buttons[i], instrument_icons[i], instrument_hovers[i], margin_left, margin_top+(2*machine_height/3)+title_height+i*57+40, 50, 50);
    for (int j=0; j < beats; j++){
      boolean downbeat = (j%4 == 0);
      suggestion_states[i][j] = SuggestionSquare(suggestion_states[i][j], margin_left+ (j+1)*57, margin_top+title_height+(2*machine_height/3)+i*57 +40, 50, 50, i, downbeat);
    }
  }
  
  if (showBackButton==true){
  SuggestionsButton("<",margin_left-57,margin_top+title_height+(2*machine_height/3)+(instruments/2)*57 +40, 50, 50);
  }
  SuggestionsButton(nextButtonLabel,margin_left+(beats+1)*57,margin_top+title_height+(2*machine_height/3)+(instruments/2)*57+40, 50, 50);
  
  //progress indicating highlight
  fill(255,150);
  rect(margin_left+(beat+1)*57-2,margin_top+title_height-2,54,57*instruments-7+4);
  
}

class ScreenSwitchListener implements ControlListener {
  //changeScreen;
  public void controlEvent(ControlEvent theEvent){
    //println(theEvent.getController().getValue());
    changeScreen = (int)theEvent.getController().getValue();
      
      
      cp5.getController("Click Here To Get Started!").remove();
      cp5.getController("Play").setVisible(true);
      cp5.getController("Pause").setVisible(true);
      //ControlFont font = new ControlFont(f,14);
      //getSuggestion.setVisible(true);
      
  }
}

class PlayPauseListener implements ControlListener {
  //changeScreen;
  
  boolean playing = false;
  public void controlEvent(ControlEvent theEvent){
    clickedButton = (int)theEvent.getController().getValue();      
    System.out.println(clickedButton);
    if(clickedButton == 1) {
      playing = true; //remember to make this false when playing
    }
    else if(clickedButton == 0) {
      playing = false;
    }
    else
      playing = false;
}
}
    

boolean[][] stringToArray(String sequence) {
 boolean[][] sequence_array = new boolean[instruments][beats];
  int i = 0;
    for (int j=0; j<instruments; j++){
      for (int k=0; k<beats; k++){
        if(sequence.charAt(i)=='0'){
          sequence_array[j][k] = false;
        } else {
          sequence_array[j][k] = true;
        }
      i++;
    }
    }
   return sequence_array;
}

String arrayToString(boolean[][] sequence_array){
  String sequence = "";
  for (int j=0; j<instruments; j++){
      for (int k=0; k<beats; k++){
        if (sequence_array[j][k]==true){
          sequence = sequence + "1";
        } else {
          sequence = sequence + "0";
        }
    }
    }
    println(sequence);
    return sequence;
}

//class PauseListener implements ControlListener {
//  public void controlEvent(ControlEvent theEvent){
//    //s.setVisible(true);
//    //soundLevel.setVisible(true);
//    cp5.getController("Pause").setVisible(false);
    
//  }
//}

 //Note that currently the "snare" sounds like a closed hat, and the "clap" sounds like 
 void playSound(double volume, String string) {
    
    score.empty();
    
    int[] midi1 = new int[16];
    int[] midi2 = new int[16];
    int[] midi3 = new int[16];
    
    for (int i = 0; i < 16; i++){ 
      midi1[i] = int(string.charAt(i));
      midi2[i] = int(string.charAt(i+16));
      midi3[i] = int(string.charAt(i+32));
    }
    
    for (int i = 0; i < 16; i++){    
      if (midi1[i]==49) {
        score.addNote(i/1, 9, 0, 40, volume, 0.25, 0.8, 64); //kick
      }
      if (midi2[i]==49) {
        score.addNote(i/1, 9, 0, 44, volume, 0.25, 0.8, 100); //closed hat
      }
      
      if (midi3[i]==49) {
        score.addNote(i/1, 9, 0, 60, volume, 0.25, 0.8, 20); //open hat
      }
    }
 
   score.play();
 }

String boolsToString (boolean[][] values, int rows, int cols){
  String output = "";
  
  for (int i = 0; i < rows; i++){
    for (int j = 0; j < cols; j++){
      if (values[i][j] == false){
        output = output + "0";
      }
      else {
        output = output + "1";
      }
    }
  }
  return output;
}
