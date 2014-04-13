import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

public class SerializationManager
{
  public SerializationManager(){}

  public void serializeConfigurationAndSettings(GollyRleConfiguration config,
                                                GollyPatternSettings settings,
                                                String destination)
  {
    /* to serialize both let's use a map */
    Map<String, Object> objects2Serialize = new HashMap<String, Object>();
    objects2Serialize.put("config", config);
    objects2Serialize.put("settings", settings);

    try
    {
      /* opening an object stream */
      FileOutputStream fileOut = new FileOutputStream(destination);
      ObjectOutputStream out = new ObjectOutputStream(fileOut);

      /* writing the arraylist */
      out.writeObject(objects2Serialize);

      /* closing */
      out.close();
      fileOut.close();
    }
    catch(IOException e)
    {
      System.out.println("Error with file " + destination);
      e.printStackTrace();
    }

  }

  public void serializeConfiguration(GollyRleConfiguration config,
                                     String destination)
  {
    try
    {
      /* opening an object stream */
      FileOutputStream fileOut = new FileOutputStream(destination);
      ObjectOutputStream out = new ObjectOutputStream(fileOut);

      /* writing the arraylist */
      out.writeObject(config);

      /* closing */
      out.close();
      fileOut.close();
    }
    catch(IOException e)
    {
      System.out.println("Error with file " + destination);
      e.printStackTrace();
    }

  }

  public Map<String, Object> deserializeConfigurationAndSettings(String origin)
  {
    Map<String, Object> deserializedObjects = null;
    try
    {
      /* Trying to open the file */
      FileInputStream fileIn = new FileInputStream(origin);
      ObjectInputStream in = new ObjectInputStream(fileIn);

      /* Reading an arraylist */
       deserializedObjects = (HashMap<String, Object>) in.readObject();

      /* Closing the streams */
      in.close();
      fileIn.close();
    }
    catch(IOException e)
    {
      System.out.println("Error with file " + origin);
      e.printStackTrace();
    }
    catch(ClassNotFoundException e)
    {
      System.out.println("Class not found while deserializing !");
      e.printStackTrace();
    }

    return deserializedObjects;
  }

  public GollyRleConfiguration deserializeConfiguration(String origin)
  {
    GollyRleConfiguration config = null;
    try
    {
      /* Trying to open the file */
      FileInputStream fileIn = new FileInputStream(origin);
      ObjectInputStream in = new ObjectInputStream(fileIn);

      /* Reading an arraylist */
      config = (GollyRleConfiguration) in.readObject();

      println(config, config.getMatrixHeight(), config.getMatrixWidth());
      /* Closing the streams */
      in.close();
      fileIn.close();
    }
    catch(IOException e)
    {
      System.out.println("Error with file " + origin);
      e.printStackTrace();
    }
    catch(ClassNotFoundException e)
    {
      System.out.println("Class not found while deserializing !");
      e.printStackTrace();
    }
    return config;
  }
}






