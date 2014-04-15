import java.io.*;
import java.net.*;
import java.util.*;
import java.security.CodeSource;
import java.lang.Runtime;

/* NB. this class will work only to update jars
   contained into MacOSX packaged apps */
public class ApplicationUpdater {

  private HTTPClientTCP httpHandler;
  private String servHost;
  private int servPort;
  private String servScript;
  
  private String latestMD5;
  private String latestFilename;
  private int latestSize;

  private byte[] update;
  
  private String jarPath;
  private String appPath;
  private String remoteJarPath;

  private static final String updateExtension = ".update";
  private static final String updateScript = "update.sh";
  
  ApplicationUpdater(String servHost, int servPort,
                     String servScript, String remotePath,
		     CodeSource jarPath) {
    this.servHost = servHost;
    this.servPort = servPort;
    this.servScript = servScript;
    this.remoteJarPath = remotePath;
    findLocalPaths(jarPath);
  }
  
  private void findLocalPaths(CodeSource codeSource)
  {
    try {
      File jarFile = new File(codeSource.getLocation().toURI().getPath());
      String appPath = jarFile.getParentFile().getParentFile().getParentFile().getPath(); // root package
      this.appPath = appPath;
      String jarPath = jarFile.getPath();
      this.jarPath =  jarPath;
    } catch (URISyntaxException e) { e.printStackTrace(); } // won't ever happen
  }

  private String getChecksum(String file) throws Exception
  {
    MD5Checksum md5 = new MD5Checksum();
    return md5.getMD5Checksum(file);
  }

  private String generateRequest(String mainAppMD5) {
    return "?" + mainAppMD5;
  }
  
  public boolean updateAvailable() throws Exception, IOException
  {
    //String mainJarPath = getJarPath();
    //System.out.println(mainJarPath);
    String mainJarMD5 = getChecksum(jarPath);
    String request = generateRequest(mainJarMD5);

    /* setting up http handler */
    httpHandler = new HTTPClientTCP(servHost, servPort);
    /* setting POST */
    httpHandler.setRequestType(HTTPClientTCP.HTTPRequest.POST);
    /* setting content-length */
    httpHandler.setRequestHeader("Content-Length",request.length());
    /* connecting */
    httpHandler.connect();
    /* sending  POST request */
    httpHandler.request(servScript, request);
    /* gathering byte[] response */
    String header = new String(httpHandler.getResponseBody(), "UTF-8");
    /* parsing response: is update available? */
    boolean updateAvailable = parseResponse(header);
    /////
    System.out.println("RESPONSE FROM SCRIPT: "+header);
    ////
    return updateAvailable;
  }

  public void downloadUpdate() throws Exception, IOException
  {
    if (latestFilename != null)
    {
      httpHandler = new HTTPClientTCP(servHost, servPort);
      httpHandler.setRequestType(HTTPClientTCP.HTTPRequest.GET);
      httpHandler.connect();
      httpHandler.request(remoteJarPath + latestFilename);
      update = httpHandler.getResponseBody();

      ////
      System.out.println("DOWNLOADED: " + remoteJarPath + latestFilename);
      
      // ensure we got a valid update
      if (update != null && update.length == latestSize) {
        File toUpdate = new File(jarPath + updateExtension);
        FileOutputStream updater = new FileOutputStream(toUpdate, false); // true to append
        // false to overwrite.
        updater.write(update);
        updater.close(); // update has been saved

	////
	System.out.println("SAVED: " + jarPath + updateExtension);
	
      }
    }
  }

  public boolean updateReady()
  {
    boolean updateReady = false;
    File downloadedUpdate = new File(jarPath + updateExtension);
    if (downloadedUpdate.exists())
      updateReady = true;
    return updateReady;
  }

  // please call only if updateReady() returned true;
  // N.B. this will force application shutdown, act safe
  public void applyUpdate() throws IOException, InterruptedException {

    String[] tokens = appPath.split("/");
    String pkgName = tokens[tokens.length - 1];
    String appName = pkgName.substring(0, pkgName.length() - 4);

    File toUpdate = new File(jarPath);
    File savedUpdate = new File(jarPath + updateExtension);

    String scriptHeader = "#!/bin/sh";
    String killCommand = "kill $(ps x | grep '" + appName + "' | awk '{print $1}' | head -1)";
    //String killCommand = "pkill " + appName; // experimental new kill (it seems like it won't require app shutdown! WOW!)
    String moveCommand = "mv '" + savedUpdate + "' '" + toUpdate + "'";
    String sleepCommand = "sleep 2";
    String openCommand = "open -a '" + appPath + "'";

    String[] cmd0 = {"/bin/sh", "-c", "echo \"" +  scriptHeader + "\" > " + updateScript};
    String[] cmd1 = {"/bin/sh", "-c", "echo \"" +  killCommand + "\" >> " + updateScript};
    String[] cmd2 = {"/bin/sh", "-c", "echo \"" +  moveCommand + "\" >> " + updateScript};
    String[] cmd3 = {"/bin/sh", "-c", "echo \"" +  sleepCommand + "\" >> " + updateScript};
    String[] cmd4 = {"/bin/sh", "-c", "echo \"" +  openCommand + "\" >> " + updateScript};
    String[] cmd5 = {"/bin/sh", "-c", "chmod +x " + updateScript};
    String[] cmd6 = {"/bin/sh", "-c", "./" + updateScript};
    
    Runtime rt = Runtime.getRuntime(); 
    Process proc;
    proc = rt.exec(cmd0);
    proc.waitFor();
    proc = rt.exec(cmd1);
    proc.waitFor();
    proc = rt.exec(cmd3); // try to ensure app has been killed
    proc.waitFor();
    proc = rt.exec(cmd2);
    proc.waitFor();
    proc = rt.exec(cmd3);
    proc.waitFor();
    proc = rt.exec(cmd4);
    proc.waitFor();
    proc = rt.exec(cmd5);
    proc.waitFor();
    proc = rt.exec(cmd6);
    proc.waitFor();
 
    // getting killed now
  }

  public boolean updateSuccessfull() throws Exception {
    boolean success = false;
    if (updateAvailable() == false)
      success = true;
    return success;
  }
  
  /* Possible answers:
     Answer=:NoFilesFound
     Answer=:UpToDate
     Answer=:latestMD5:latestFilename:latestSize
  */
  private boolean parseResponse(String response) {
    boolean updateAvailable = false;
    Scanner scanner = new Scanner(response);
    while (scanner.hasNextLine()) {
      String line = scanner.nextLine();
      if (line.contains("Answer=:")) {
        StringTokenizer tokens = new StringTokenizer(line, ":", false);
        int i = 0;
        while (tokens.hasMoreElements()) {
          Object gotParameter = tokens.nextElement();
	  String stringParameter = gotParameter.toString();
          switch(i) {
          case 1:
            if (stringParameter.equals("NoFilesFound"))
	      updateAvailable = false;
	    else if (stringParameter.equals("UpToDate"))
              updateAvailable = false;
	    else {
              updateAvailable = true;
              latestMD5 = stringParameter;
            }
            break;
          case 2:
            latestFilename = stringParameter;
            break;
          case 3:
            latestSize = Integer.parseInt(stringParameter);
            break;
          }
          i++;
        }
        break;
      }
    }
    scanner.close();
    return updateAvailable;
  }

  // public static void  main(String args[]) {
  
  // try {
  //   CodeSource codeSource = ApplicationUpdater.class.getProtectionDomain().getCodeSource();
  //   ApplicationUpdater updater =
  //     new ApplicationUpdater("mm.sharped.net", 3300, "/cgi-bum/mmupdate.icg","cgi-bum/release/golly_vectorializer.app/Contents/Java/", codeSource);
  //   if (updater.updateAvailable()) {
  //     updater.downloadUpdate();
  //     if (updater.updateReady()) {
  //       updater.applyUpdate();
  //     }
  //   }
  //   } catch(Exception e) { e.printStackTrace(); }
  // }
}










