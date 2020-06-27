import java.sql.Connection; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.swing.filechooser.FileSystemView;
import javax.swing.ImageIcon;
import java.awt.Image;
import processing.video.*;
import java.io.*;
import processing.core.PApplet;
import com.hamoid.*;

int textDuration=3000;
int globalfor = 0;
int globalfortimestart = 0;
int displayEndTime;

String[] lines= {};
String[] newLines= {};
//Löst den Start aus
boolean start = false;
//Hier werden die Suchbegriffe für die Datenbank gespeichert
String[] searchTermArray = null;
//Zum Indexzählen
int index = 0;

PFont font; //object of type PFont
int timeStay, timePause, t, txtsize, c;
float x, y;
String txt="";
int currentTime;
String searchTermLine;
Movie myMovie;
File file;
File dir;
Movie [] movArray={};
Movie currentMovie;
VideoExport videoExport;
// Press 'q' to finish saving the movie and exit.

// In some systems, if you close your sketch by pressing ESC, 
// by closing the window, or by pressing STOP, the resulting 
// movie might be corrupted. If that happens to you, use
// videoExport.endMovie() like you see in this example.

// In other systems pressing ESC produces correct movies
// and .endMovie() is not necessary.


void setup()
{
  size(1920, 1080);
  background(0);
  //lädt die .txt Datei zeilenweise ein und packt jede Zeile in einen Index des Arrays
  lines = loadStrings("Bratkartoffeln.txt");
  textParameters();
  t = timeStay;
  searchterms();
  try 
  {    
    // DB Connection and statement object
    Connection conn = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5433/aaron", "postgres", "admin");
    System.out.println("connected");

    /******** bytea operation: retrieve video ***********************************************/
    for (int i=0; i<searchTermArray.length; i++)
    {
      PreparedStatement ps = conn.prepareStatement("SELECT video FROM kochvideos WHERE name=?");
      ps.setString(1, searchTermArray[i]); //suchbegriff
      ResultSet rs = ps.executeQuery();

      if (rs != null) 
      {
        if (rs.next()) 
        {
          println(searchTermArray[i]+" "+"gefunden");
          byte[] vidBytes = rs.getBytes(1);
          ByteArrayInputStream bis = new ByteArrayInputStream(vidBytes);
          dir = new File("E:\\Documents\\Aaron\\htw\\4. Semester\\mume\\processing-3.5.4\\sketch_200622a\\aktuell\\data");
          file=file.createTempFile("vid", ".mov", dir);
          //file=new File("E:\\Documents\\Aaron\\htw\\4. Semester\\mume\\processing-3.5.4\\sketch_200622a\\aktuell\\data" + "\\" + );
          // https://www.baeldung.com/java-how-to-create-a-file
          saveStream(file, bis);
          String fileName = file.getName();
          myMovie=new Movie(this, fileName);
          movArray[i]=myMovie;
          newLines[i]=null;
          /* retrieve img: byte[] imgBytes = rs.getBytes(1);
           Image awtImage = new ImageIcon(imgBytes).getImage();
           PImage img = new PImage(awtImage);
           display img: image(img, 0, 0, width/2, height/2);*/
          //newLines[i]=null;
        } else
        { //<>//
          println(searchTermArray[i]+" "+"nicht gefunden"); //<>//
          newLines[i]=searchtermNotFound(searchTermArray[i]);
          movArray[i]=null;
        }
        rs.close();
      }
      ps.close();
    }
  } 
  catch (Exception e) 
  {
    e.printStackTrace();
  }
  /****************************************************************************/
  videoExport = new VideoExport(this,"E:\\Documents\\Aaron\\htw\\4. Semester\\mume\\Bratkartoffeln.mp4");
  videoExport.startMovie();
}  

void textParameters() {
  txtsize = 50; //font size
  font = createFont("Arial", txtsize, true); // Arial, 16 point, anti-aliasing on
  timeStay = 5000; //time text stays on screen
  timePause = 2000; //time no text on screen
  x = width/2; //horizontal
  y = height/2; //vertical

  textAlign(CENTER);
  textFont(font);
}
String searchtermNotFound(String string) {
  String lineNotFound="";  
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].contains(string)) {     
      lineNotFound=lines[i];
      break;
    }
  }
  return lineNotFound;
}
String[] searchterms() {
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
  newLines=new String[searchTermArray.length];
  movArray=new Movie[searchTermArray.length];
  return searchTermArray;
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}
 

void draw()
{
  if (globalfor<movArray.length) {
    if (movArray[globalfor] == null) {
      if (globalfortimestart == 0) //<>//
      {
        globalfortimestart = millis();
        displayEndTime = globalfortimestart + textDuration;
        background(0);
      }

      text(newLines[globalfor], x, y);
      if (millis() > displayEndTime) {
        globalfor++;
        globalfortimestart = 0;
      }
    } else {
      if (globalfortimestart == 0)
      {
        currentMovie = movArray[globalfor];
        currentMovie.play();
        globalfortimestart = millis();
        displayEndTime = globalfortimestart + int(currentMovie.duration())*1000;
      }

      image(currentMovie, 0, 0);

      if (millis() > displayEndTime) {
        globalfor++;
        globalfortimestart = 0;
      }
    }
    videoExport.saveFrame();
  } else
  {
    videoExport.endMovie();
    exit();
  }
}
