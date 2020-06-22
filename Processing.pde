PFont font; //object of type PFont
int timeStay, timePause, t, txtsize, c;
float x, y;
StringList lib;


/****************************************************/
  StringList textLibrary() { // text, that should be displayed in video
  StringList st = new StringList();
  st.append("blab?");
  st.append("blab !");
  st.append("blub!");
  return st;
}
/****************************************************/


void textParameters(){
    font = createFont("Arial",73,true); // Arial, 16 point, anti-aliasing on
    timeStay = 5000; //time text stays on screen
    timePause = 2000; //time no text on screen
    txtsize = 72; //font size
    x = width/2; //horizontal
    y = height/2; //vertical
     
      textSize(txtsize);
      textAlign(CENTER);
      textFont(font);
      text("mitte",500,400);
      
}

void setup() {
  size(1200, 700);  //size of screen - ADJUST HERE
  //noStroke(); //not sure why important so I guess it's really not
  //font for displaying text
  //time = millis(); //for displaying text only certain amount of time
    textParameters();
    lib=textLibrary(); //das wo der Text drin ist, wird später anders
    t = timeStay; 


}  

void draw() {

  background(0);
  //fill(0); //also seems to have no effect idk

//start of functionalities  
String[] lines = loadStrings("testRezept.txt");
String[] suchbegriffe = new String [lines.length]; //erstellt String-Array mit allen Suchbegriffen
String suchbegriff = "";  //hier wird der Suchbegriff gespeichert

// Zeilen der txt-Datei durchlaufen und Suchbegriff gefunden


/*----------------------------------------------------*/
    for (int i = 0 ; i < lines.length; i++) {
      for(int j=3; j<20; j++){
//
    //
        if(lines[i].charAt(j)!= ' '){
        String buchstabe = str(lines[i].charAt(j));
        suchbegriff = suchbegriff + buchstabe;
        
        } else { //Leerzeichen gefunden
      //speicher 1. suchbegriff in array suchbegriffe 
      suchbegriffe[i]=suchbegriff;
      suchbegriff="";
      println(suchbegriffe[i]);
      break;
        }
      }
    }
/*----------------------------------------------------*/
    
    
String txt="";
  background(0);
  if ((millis()-t)>(timePause+timeStay) && c < lib.size()-1) { // go to the next text
    c++;
    t=millis();
  }
else if ((millis()-t)>(timePause)) txt=""; // no text displayed
else txt=lib.get(c); // the text is displayed
text(txt,x,y);
 
/*------------------------------------*/
  
  
  
}
