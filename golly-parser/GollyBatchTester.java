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
      if(args.length == 0)
      {
         System.err.println("Syntax: GollyBatchTester <DIR>");
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
            GollyRleReader reader = new GollyRleReader();
            String[] actualFile = new String[1];

            for (int i = 0; i < rlesList.size(); ++i)
            {
               actualFile[0] = rlesList.get(i);
               try
               {
                  System.out.println("\n##### TESTING FILE: " + actualFile[0]);
                  reader.main(actualFile);
               }
               catch (Exception e)
               {
                 System.err.println("ERROR: ???");
               }
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
