import themidibus.*; //Import the library
import controlP5.*;
MidiBus myBus; // The MidiBus

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

float mutationRate = 0.001; 
int totalPopulation = 150;
int beat = 0;
Boolean currentlyOnFirst = true;
Population population;
int generations = 20;
float startTime = millis(); 
float tempo = 20;
PFont f;

StringList suggestions = new StringList();
int currentSuggestion = 0;

ControlP5 cp5;
ScreenSwitchListener screenListener;
CallbackListener cb;
//PauseListener pauseListener;
//ControlFont font = new ControlFont(f,14);
Slider2D s;
Button pause;
Knob soundLevel;
int changeScreen;
int pauseScreen;

void setup() {
  size(1366, 768);
  
  background(c_very_dark);
  targetMidi1 =   "0000000000000000"; // These need to be 16 long to work with the other parts
  targetMidi2 =  "1000101000001000"; // of the code. You can change their size, but would have
  targetMidi3 =   "0001111111100010"; // adjsut some other parameters
  target = targetMidi1 + targetMidi2 + targetMidi3;
  MidiBus.list(); 
  myBus = new MidiBus(this, -1, 1);

  population = new Population(target,mutationRate,totalPopulation);
  population.updateGA(mutationRate);

  f = createFont("Courier",48,true);
  ControlFont font = new ControlFont(f,14);
  textFont(f,20);
  noStroke();
  
    cp5 = new ControlP5(this);
    screenListener = new ScreenSwitchListener();
    
  cp5.addButton("Hip-hop")
     .setValue(1)
     .setPosition(20,100)
     .setSize(100,30)
     .setColorBackground(color(51, 64, 80))
     .setFont(font)
     .addListener(screenListener)
     ;
     
  cp5.getController("Hip-hop")
     .getCaptionLabel()
     .toUpperCase(false)
     ;
  
  s = cp5.addSlider2D("MutaGen")
         //.setArrayValue(int,float)
         .setPosition(680,40)
         .setSize(100,100)
         .setMinMax(1,0.05,20,0.001)
         .setValue(1,0.02)
         .setColorBackground(color(40))
         .setColorForeground(color(180))
         .setColorActive(color(250))
         .setDecimalPrecision(1)
         .setVisible(false)
         ;
         
  cp5.getController("MutaGen")
     .getValueLabel()
     .setVisible(false)
     ;
  
  soundLevel = cp5.addKnob("volume")
                  .setRange(0,10)
                  .setValue(5)
                  .setPosition(710,180)
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
             .setValue(1)
             .setPosition(20,200)
             .setSize(100,30)
             .setColorBackground(color(51, 64, 80))
             .setFont(font)
             //.addListener(pauseListener)
             .setVisible(false)
             ;
      

    
    pause.addCallback(new CallbackListener(){
      public void controlEvent(CallbackEvent theEvent){
        if(theEvent.getAction() == ControlP5.ACTION_PRESSED){
          cp5.getController("Pause").setVisible(false);
          pauseScreen = (int)theEvent.getController().getValue();
        }
      }
    }
  );
}

void draw() {
      if(changeScreen == 0){
        beginCard("Welcome to UCompose, please select a genre of music:", 0, 0, 800, 600);
        
        //text(,20,70);
        //if(Button("Hip-hop",20,100)){
        //  currentlyOnFirst = false;
          
        //}
        
        if(Button("R&B",20,150)){
          //screen++;
        }
        
        if(Button("Rock",20,200)){
          //screen++;
        }
      endCard();
      }
       else if(changeScreen == 1){
        drawScreen();
        target = targetMidi1 +targetMidi2 + targetMidi3;
        //text("Here",20,100);
        redraw();
        if(millis()-startTime > 60/tempo/4*1000){
          startTime = millis();
          beat++;
          beat = beat%targetMidi1.length();
          
          s.setVisible(true);
          soundLevel.setVisible(true);
          cp5.getController("Pause").setVisible(true);
          generations = int(s.getArrayValue()[0]);
          mutationRate = s.getArrayValue()[1];
          cp5.getController("MutaGen")
             .setCaptionLabel("Mut/Gen" + "   " + s.getArrayValue()[1] + "," + int(s.getArrayValue()[0]) )
             //.setValue(true)
             //.setColorCaptionLabel(color(200))
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
    rect(45+i*32,300/5+5,30,30,5);
    
    if(int(population.fittest.charAt(i+16))==49){
      fill(255,0,0); // fill for wanted beat 
    } else {
      fill(209, 210, 211); // fill for unwanted beat
    }
    //rectMode(RADIUS);
    rect(45+i*32,1.7*300/5+5,30,30,5);
    
    if(int(population.fittest.charAt(i+32))==49){
      fill(255,0,255);
    } else {
      fill(209, 210, 211);
    }
    rect(45+i*32,2.4*300/5+5,30,30,5);
  }
  
   for (int i = 0; i < 16; i++){ // set the number of times to update the GA between beats
    if(int(population.fittest.charAt(i))==49){
      fill(0,255,0);
    } else {
      fill(209, 210, 211);
    }
    rect(45+i*32,3.8*300/5+5,30,30,5);
    
    if(int(population.fittest.charAt(i+16))==49){
      fill(255,0,0); // fill for wanted beat 
    } else {
      fill(209, 210, 211); // fill for unwanted beat
    }
    //rectMode(RADIUS);
    rect(45+i*32,4.5*300/5+5,30,30,5);
    
    if(int(population.fittest.charAt(i+32))==49){
      fill(255,0,255);
    } else {
      fill(209, 210, 211);
    }
    rect(45+i*32,5.2*300/5+5,30,30,5);
  }
  
  stroke(200);
  
  noStroke();
  
}

class ScreenSwitchListener implements ControlListener {
  //changeScreen;
  public void controlEvent(ControlEvent theEvent){
    //println(theEvent.getController().getValue());
    changeScreen = (int)theEvent.getController().getValue();
      
      
      cp5.getController("Hip-hop").remove();
      
      //ControlFont font = new ControlFont(f,14);
      
      
  }
}

//class PauseListener implements ControlListener {
//  public void controlEvent(ControlEvent theEvent){
//    //s.setVisible(true);
//    //soundLevel.setVisible(true);
//    cp5.getController("Pause").setVisible(false);
    
//  }
//}
