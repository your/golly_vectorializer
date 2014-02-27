import java.util.*;
import java.io.*;

public class GollyMatrixReader
{
    private ArrayList<ArrayList<Integer>> manualMatrix;
    private String manualFile;

    GollyMatrixReader(String manualFile) throws IOException
    {
	this.manualMatrix = new ArrayList<ArrayList<Integer>>();
	this.manualFile = manualFile;
    }

    /*** Utilities ***/
    public ArrayList<ArrayList<Integer>> parseMatrixFile() throws IOException
    {
	// read in the data
	try
	    {
		Scanner inputMatrix = new Scanner(new File(manualFile));
		while(inputMatrix.hasNextLine())
		    {
			Scanner colReader = new Scanner(inputMatrix.nextLine());
			ArrayList<Integer> colMatrix = new ArrayList<Integer>();
			while(colReader.hasNextInt())
			    {
				colMatrix.add(colReader.nextInt());
			    }
			manualMatrix.add(colMatrix);
		    }
	    }
	catch (IOException e)
	    {
		System.out.println("Exception caught: " + e.getMessage());
	    }
	return manualMatrix;
    }
 
}
