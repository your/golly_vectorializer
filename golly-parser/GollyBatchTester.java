import java.io.IOException;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
 
public class GollyBatchTester
{
   private static String fileFormat = ".rle";
   private static ArrayList<String> rlesList = new ArrayList<String>();

   public static void main(String[] args) throws IOException
   {
      System.out.println("Golly BATCH RLE file parser");
      if(args.length == 0)
      {
         System.err.println("Syntax: GollyBatchTester <DIR> [OPTIONS] -- (see GollyRleReader -h)\n");
         System.exit(1);
      }
      else
      {
         try
         {
            String parentDirectory = args[0];
            Path start = FileSystems.getDefault().getPath(parentDirectory);
            Files.walkFileTree(start,
               new SimpleFileVisitor<Path>()
               {
                  @Override
                  public FileVisitResult visitFile(Path file,
                     BasicFileAttributes attrs) throws IOException
                     {
                        if (file.toString().endsWith(fileFormat))
                        {
                          rlesList.add(file.toString());
                        }
			return FileVisitResult.CONTINUE;
                     }
               });
            // GollyRleReader reader = new GollyRleReader();
            // String[] actualFile = new String[1];

            for (int i = 0; i < rlesList.size(); ++i)
            {
               String actualFile = rlesList.get(i);
               args[0] = actualFile; // overwrite each time <FILE> field
               //String[] actualFile = new String[] {rlesList.get(i)};
               System.out.println("\n##### TESTING FILE: " + actualFile);
               try
               {
                 GollyRleReader.main(args);
               }
               catch(Exception e)
               {
                 System.err.println("Exception caught: " + e.getCause());
               }
               //GollyRleConfiguration config = reader.parseFile(args);
               //System.out.println("FILE is " + (validFile? "VALID": "NOT VALID"));
            }
            System.out.println();
         }
         catch (IOException e)
         {
            e.printStackTrace();
            System.err.println("ERROR: It seems like something went wrong!");
         }
      }
   }
}
