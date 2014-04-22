public class GollyFileSaver
{
    private static final char startingPrefix = 'p';
    private static final char startingActiveState = 'A';
	private static final int states = 24;
	
	private String getInnerLetter(int reminder)
	{
	    char letter = reminder + startingActiveState;
		return String.valueOf(letter);
	}
	
	private String translateCellState(String prefix, String letter)
	{
	    return prefix + letter;
	}
	
	private String getPrefixLetter(int state)
	{
	    String prefix = "";
		if(state > 0)
		{
		    char prefixChar = startingPrefix + state - 1;
			prefix = String.valueOf(prefixChar);
		}
		return prefix;
	}
	
	private String translateCellState(int state)
	{
	    int reminder = state % states;
		int prefix = state / states;
		
		String prefixString = getPrefixLetter(prefix);
		String innerLetter = getInnerLetter(reminder);
		
		return prefixString + innerLetter;
	}
	
	public void exportConfigurationToRle(GollyRleConfiguration config, String path)
	{
	    File exportingFile = new File(path);
		InputStreamBuffer io = new InputStreamBuffer();
	}

}