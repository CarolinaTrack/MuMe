import java.sql.Connection;
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
File file;

void setup()
{
  try {  // DB Connection and statement object
         Connection conn = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5433/aaron", "postgres","admin");
         System.out.println("connected");

         //******** bytea operation: file und file-name in Tabelle einfügen **************/
             // verzeichnis des files: println( new File( "myimage.jpg").getAbsolutePath());
         File file = new File("Zwiebeln würfeln.mov");
         FileInputStream fis = new FileInputStream(file);
         PreparedStatement ps = conn.prepareStatement("INSERT INTO kochvideos VALUES (?, ?)");
         ps.setString(1, "Zwiebeln würfeln");
         ps.setBinaryStream(2, fis, file.length());
         ps.executeUpdate();
         ps.close();
         fis.close();
         
        } 
         catch (Exception e) {
         e.printStackTrace();
         }
 
    
} //<>// //<>// //<>//
