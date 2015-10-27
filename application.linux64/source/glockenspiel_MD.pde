import arb.soundcipher.*;

SoundCipher sc = new SoundCipher();

int[] notes;
int pitch=30;
int nbre = 0;
int tooHigh = 30;
int tooLow = 30;
int sustain = 100;
import java.util.*;
import controlP5.*;



//UNITS TO DEFINE THE BLOCK POSITION
int x;
int units = 2;
int dist = 54 / units;//54 is the aprox distance between A4 and B4.
int wideCount = 1000 / units;
int space = 10;
IntList xpos;
int xposDef;
//int baseFreq = 440;
//DEFINE
ControlP5 cp5;
//Minim minim;
//AudioOutput au_out;
Block[] myBlocks;
Position[] p = new Position[units];
Check check;
//ArrayList<SineWave> tones;
//SineWave current_wave;

//;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Sound::

boolean isOn = true;
int noteJoue;
boolean joue = false;
int velocity = 127;
int channel = 0;
boolean drag = false;





void setup() {

  size(1000, 700);
  background(0);

  //BUTTONS
  cp5 = new ControlP5(this);
  
  SoundCipher.getMidiDeviceInfo();
  sc.setMidiDeviceOutput(1);

  // create a new button with name 'buttonA'
  cp5.addButton("LESS")
    .setValue(+2)
      .setPosition(10, 10)
        .setSize(100, 19)
          ;

  // and add another botton
  cp5.addButton("MORE")
    .setValue(-2)
      .setPosition(10, 30)
        .setSize(100, 19)
          ;



  //Initialize the check button 
  check = new Check(500, 600, "Check");

  // initiate the blocks array; positions array
  myBlocks = new Block[units];
  // println(myBlocks.length);

  notes = new int[127-tooLow];

  for (int i= 0; i<notes.length; i++) {

    notes[i] = pitch;
    pitch++;
    //println(pitch);
  }
  //MidiBus.list();       
  //myBus = new MidiBus(this, 0,0); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device. But if you have another synth it could be choosen from the list before



  // initiate the array of tones and populate it

  for (int i = 0; i < units; i++ ) {

    int wavePos = notes[i];
    p[i] = new Position(wavePos, wideCount*i, 350, "A_"+i); //Initialize each position  }
  }


  // xpos to suffle it!

  xpos = new IntList();

  for (int i = 0; i < units; i++) {
    xpos.append(i); //* wideCount + 100);
  }
  xpos.shuffle();



  // fill blocks with several tones (and positions)
  for (int i = 0; i < units; i++) {

    int note = notes[tooLow+i];
    int xposDef = xpos.get(i);
    Block b = new Block(note, xposDef * wideCount + (wideCount/2), 100, "block"+Integer.toString(i)); 
    myBlocks[i] = b;
  }
};

void draw() {
  background(0);


  for (int i = 0; i < units; i++) {
    p[i].display();
  }
  for (int i = 0; i < units; i++) {
    myBlocks[i].display();
  }
  check.display();

  if (mousePressed) {
    if (checkbox() == true) {
      everythingIsRight();
    }
  }
}

public void MORE() {

  units = units+1;
  if (units<24) {
    int dist = 54 / units;//54 is the aprox distance between A4 and B4.
    int wideCount = 1000 / units;
    int space = 10;
    IntList xpos;


    myBlocks = new Block[units];
    p = new Position[units];


    //minim = new Minim(this);
    // au_out = minim.getLineOut();

    // initiate the array of tones and populate it
    //    tones = new ArrayList<SineWave>();
    for (int i = 0; i < units; i++ ) {

      int wavePos = notes[i+tooLow];
      p[i] = new Position(wavePos, wideCount*i, 350, "A_"+i); //Initialize each position  }
    }

    xpos = new IntList();
    for (int i = 0; i < units; i++) {
      xpos.append(i); //* wideCount + 100);
    }
    xpos.shuffle();
    println(xpos);

    // fill blocks with several tones (and positions)
    for (int i = 0; i < units; i++) {
      //     
      int note = notes[i];

      int xposDef = xpos.get(i);
      Block b = new Block(note, xposDef * wideCount + (wideCount/2), 100, "block"+Integer.toString(i)); 
      myBlocks[i] = b;
    }
  } else {
    units=23;
  }
}
public void LESS() {
  units = units-1;
  if (units>0) {
    int dist = 54 / units;//54 is the aprox distance between A4 and B4.
    int wideCount = 1000 / units;
    int space = 10;
    IntList xpos;

    myBlocks = new Block[units];
    p = new Position[units];



    for (int i = 0; i < units; i++ ) {

      int wavePos = notes[i];
      p[i] = new Position(wavePos, wideCount*i, 350, "A_"+i); //Initialize each position  }
    }



    xpos = new IntList();

    for (int i = 0; i < units; i++) {
      xpos.append(i); //* wideCount + 100);
    }
    xpos.shuffle();

    // fill blocks with several tones (and positions)
    for (int i = 0; i < units; i++) {

      int note = notes[i];
      int xposDef = xpos.get(i);
      Block b = new Block( note, xposDef * wideCount + (wideCount/2), 100, "block"+Integer.toString(i)); 
      myBlocks[i] = b;
    }
  } else {
    units=1;
  }
}



void mousePressed() {


  for (int z = 0; z < myBlocks.length; z++) {
    p[z].display();



    joue = myBlocks[z].onMousePressed(mouseX, mouseY);

    if (joue && ! drag) {

      println("joue=======" + joue + "la note===" +notes[z]);
      pitch= notes[z];
      sc.playNote(pitch+24, velocity, 1.5);
      //myBus.sendNoteOn(channel, pitch, velocity);
      myBlocks[z].weAreMoving = true;
      joue=false;
    }
  }
}

void mouseDragged() {
  drag=true;
  for (int i = 0; i < myBlocks.length; i++) {
    p[i].display();
    if (myBlocks[i].weAreMoving) {
      int channel = 0;
      int velocity = 127;

      //myBus.sendNoteOff(channel, pitch, velocity);

      // first "erase it"
      fill(0);
      rect(myBlocks[i].x, myBlocks[i].y, myBlocks[i].width, myBlocks[i].height);



      // change the position
      myBlocks[i].x = mouseX;
      myBlocks[i].y = mouseY;

      // redraw
      fill(255, 0, 0); 
      rect(p[i].x, p[i].y, wideCount-space, 200);
      fill(255);
      rect(myBlocks[i].x, myBlocks[i].y, myBlocks[i].width, myBlocks[i].height);
    }
  }
}

void mouseReleased() {


  drag = false;
  delay(sustain);
 // myBus.sendNoteOff(channel, pitch, velocity);
  ;

  for (int i = 0; i < myBlocks.length; i++) {
    p[i].display();
    fill(255, 0, 0); 
    rect(p[i].x, p[i].y, wideCount-space, 200);
    fill(255);
    rect(myBlocks[i].x, myBlocks[i].y, myBlocks[i].width, myBlocks[i].height);

    if (myBlocks[i].weAreMoving) {
      myBlocks[i].weAreMoving = false;
    }
  }
}


boolean checkbox() {
  if (mouseX > check.x &&     
    mouseX < (check.x + check.width) && 
    mouseY > check.y &&
    mouseY < (check.y + check.height)) {        
    println("We are clicking on " + check.name);
    check.weAreMoving = true;
    return true;
  }  
  return false;
}

// check if blocks are inside positions

boolean inPosition(int rect_x, int rect_y, int rect_width, int rect_height, 
int pos_x, int pos_y, int pos_width, int pos_height) {

  if (rect_x > pos_x &&
    (rect_x + rect_width) < (pos_x +pos_width) && 
    rect_y > pos_y && 
    (rect_y + rect_height) < (pos_y + pos_height)) {   
    return true;
  } 
  return false;
}


//boolean unCorrectTone(SineWave tone, SineWave pos) { 
//  if (tone != pos) {
//    return true;
//  }
//  return false;
//}

boolean everythingIsRight() {
  for (int i = 0; i < units; i++) {
    if (!inPosition (myBlocks[i].x, myBlocks[i].y, myBlocks[i].width, myBlocks[i].height, 
    p[i].x, p[i].y, p[i].width, p[i].height)) {
      println("It is not correct due to position");
      fill(255);
      textAlign(CENTER);
      textSize(15);
      stroke(19);
      text("Not quite. Try again? ;)", width/2, 250, 200);
      return false;
    } else if (inPosition (myBlocks[i].x, myBlocks[i].y, myBlocks[i].width, myBlocks[i].height, 
    p[i].x, p[i].y, p[i].width, p[i].height)) {
      //      if (unCorrectTone(myBlocks[i].wave, p[i].wavePos)) {     
      //        println("It is not correct due to tone ");
      //        fill(255);
      //        //textAlign(CENTER);
      //        //textSize(15);
      //        //stroke(19);
      //        text("Not quite. Try again? ;)", width/2, 250, 200);
      //        return false;
      //      }
    }
  }
  println( "It is correct");
  fill(255);
  textAlign(CENTER);
  textSize(15);
  stroke(19);
  text("Good ear", width/2, 250, 200);
  return true;
}


void keyPressed() {
  if (!isOn) {
    //au_out.unmute();
    //   au_out.disableSignal(wave);
    //   } else {
    //   au_out.enableSignal(wave);
    //au_out.mute();
  }
  isOn = !isOn;
}

//import ddf.minim.*;
//import ddf.minim.signals.*;

class Block {
  //SineWave wave;
  int note;
  int x;
  int y;
  int width = 20;
  int height = 70;
  String name;
  boolean weAreMoving = false;

  // This is a constructor 
  Block(int note, int x, int y, String name) {
    //this.wave = wave;
    this.x = x;
    this.y = y;
    this.name = name;
    this.note = note;
  } 

  // This is called "overloading the constructor"
  // Lets you make a block without having to give it a name  
  //  Block(SineWave wave, int x, int y) {
  //    this(wave, x, y, "default");
  //  }

  //   Block(int x, int y) {
  //    this( x, y, "default");
  //  }

  void display() {
    fill(255);
    rect(x, y, width, height);
  }
  // @return wave is mouse_x and mouse y_ in the block, null otherwise 
  public boolean onMousePressed(int mouse_x, int mouse_y) {
    if (mouse_x > this.x && mouse_x < (this.x + this.width) && 
      mouse_y > this.y && mouse_y < (this.y + this.height)) {
      println("block: " + name + "il a été pressé");
      noteJoue = this.note;
      joue =true;
      return true;
    }
    joue = false;
    return false;
  }
}



class Check {
  int x;
  int y;
  int width = 60;
  int height = 60;
  String name;
  boolean weAreMoving = false;


  Check(int x, int y, String name) {
    this.x = x;
    this.y = y;
    this.name = name;
  }
  void display() {
    fill(0, 255, 0);
    stroke(255, 0, 0);
    rect(check.x, check.y, check.width, check.height);

    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(15);
    stroke(19);
    text("Check", 527, 635, height*0.35);

    fill(255);
    textAlign(CENTER);
    textSize(13);
    stroke(19);
    text("Each white piece has a different pitch. They must be placed inside one of the red colors\nattending to their pitches from the lowest to the highest.\nClick on them to hear their sounds and drag them to place them in their correct positions.", 500, 30, height*0.35);

    stroke(255);
    line(10, 137, 990, 137);
  }
}  


//import ddf.minim.*;
//import ddf.minim.signals.*;

class Position {
  int wavePos;
  int wideCount=1000/units;
  int x;
  int y;
  int width = wideCount-space;
  int height = 200;
  String name;
  boolean weAreMoving = false;

  Position (int wavePos, int x, int y, String name) {
    this.wavePos = wavePos;
    this.x = x;
    this.y = y;
    this.name = name;
  }
  void display() {
    fill(255, 0, 0); 
    rect(x, y, width, height);
  }
  void erase() {
    fill(0);
    rect(x, y, width, height);
  }
}

