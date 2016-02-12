import java.io.StringWriter;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;
import javax.json.JsonWriter;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.PrintStream;

 
public class json_ex_write{
     
    public static void main(String[] args) {
        JsonObject personObject = Json.createObjectBuilder()
                .add("name", "Jack")
                .add("age", 13)
                .add("isMarried", false)
                .add("address", 
                     Json.createObjectBuilder().add("street", "Main Street")
                                               .add("city", "New York")
                                               .add("zipCode", "11111")
                                               .build()
                    )
                .add("phoneNumber", 
                     Json.createArrayBuilder().add("00-000-0000")
                                              .add("11-111-1111")
                                              .add("11-111-1112")
                                              .build()
                    )
                .build();
         
        StringWriter stringWriter = new StringWriter();
        JsonWriter writer = Json.createWriter(stringWriter);
        writer.writeObject(personObject);
        writer.close();
       

	String path = "./ex.json";


      try
      {
	PrintStream outputStream = new PrintStream(new FileOutputStream(path));
        System.setOut(outputStream);
        System.setErr(outputStream);
	System.out.println(stringWriter.getBuffer().toString());
      }
      catch (Exception e)
      {
        System.out.println("Output redirection failed, displaying results on standard output ("+e.getMessage()+")");
      }


    }
 
}
