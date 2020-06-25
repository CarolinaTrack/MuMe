String[] lines= {};
//Löst den Start aus
boolean start = false;
//Hier werden die Suchbegriffe für die Datenbank gespeichert
String[] searchTermArray = null;
//Zum Indexzählen
int index = 0;

PFont font; //object of type PFont
int timeStay, timePause, t, txtsize, c;
float x, y;

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
}

void setup() {
  size(1200, 700);
  //lädt die .txt Datei zeilenweise ein und packt jede Zeile in einen Index des Arrays
  lines = loadStrings("testRezept.txt");
  textParameters();
  t = timeStay;
  searchterms();
  
  for(int i=0;i<searchTermArray.length;i++){
    println(searchTermArray[i]);
  }

}  

String[] searchterms(){
    //geht jeden Index, also jede Zeile des Rezepts durch und sucht nach dem Startwort "Zubereitung"
    for (int i = 0; i < lines.length; i++) {
        if (lines[i].equals("Zubereitung")) {
                start = true;
                i = i + 2;
                searchTermArray = new String[lines.length - i];
            }

            if (start) {
                //Wort wird hier immer zurückgesetzt
                String searchTerm = "";
                //von uns festgelegt muss das gesuchte Wort ab dem 5. Character der Zeile starten (z. B. "10. " danach einlesen)
                lines[i] = lines[i].substring(4);

                //geht jeden Index, also jede Zeile des Rezepts ab +2 Zeilen nach "Zubereitung" durch
                for (int countWords = 0, j = 0; j < lines[i].length(); j++) {
                    //Der jeweilige Buchstabe an der stelle in der Zeile
                    char letter = lines[i].charAt(j);

                    if (letter == ' ') {
                        countWords++;
                    }
                    if (countWords == 2) {
                        break;
                    }
                    searchTerm += letter;
                }
                //speichert die Worte im Array am genannten Index
                searchTermArray[index] = searchTerm;
                index++;
            }
        }
       return searchTermArray;
}

void draw() {
//start of functionalities  
  String txt="";
  background(0);
  if ((millis()-t)>(timePause+timeStay) && c < searchTermArray.length-1) { // go to the next text
    c++;
    t=millis();
    }
  else if ((millis()-t)>(timePause)) txt=""; // no text displayed
  else txt=searchTermArray[c]; // the text is displayed
  text(txt,x,y);
}
