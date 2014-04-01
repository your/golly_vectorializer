import java.io.*;
import java.net.*;
import java.util.*;

public class HTTPClientTCP {

  private Socket link;
  private String serverHost;
  private int serverPort;

  private HTTPRequest requestType;

  private String entityHeaders;
  private String entityBody;

  private boolean requestCompliant;
  
  private int contentLength;
  
  private String responseHeader;
  private byte[] responseBody;
  
  private static final String HTTPVersion = "1.0";
  private static final String CRLF = "\r\n";
  private static final int connectTimeout = 3000;
  
  public enum HTTPRequest {
    HEAD,GET,POST;
  }

  /* Constructors */
  HTTPClientTCP(String serverHost, int serverPort) {
    this.serverHost = serverHost;
    this.serverPort = serverPort;
    this.responseHeader = "";
    this.contentLength = 0;
    this.entityHeaders = "";
    this.entityBody = null;
    this.requestCompliant = false;
  }

  /* Getters */
  public String getResponseHeader() {
    return responseHeader;
  }
  public byte[] getResponseBody() { ///////////////////////// check on this from outside
    /* ensure we got expected bytes from server (if due) */
    byte[] answer = null;
    if (requestCompliant) {
      if (requestType == HTTPRequest.GET) {
	if (responseBody.length == contentLength) {
	  answer = responseBody;
	}
      } else {
	answer = responseBody;
      }
    }
    return answer;
  }

  /* Setters */
  public void setRequestType(HTTPRequest requestType) {
    this.requestType = requestType;
  }
  public void setRequestHeader(String requestHeader, int requestValue) {
    if (requestHeader.equals("Content-Length"))
      entityHeaders += requestHeader + ": " + requestValue + CRLF;
  }

  /* Methods */
  public void connect() throws IOException {
    SocketAddress sockAddr = new InetSocketAddress(serverHost, serverPort);
    link = new Socket();
    link.connect(sockAddr, connectTimeout);
    //link = new Socket(serverHost, serverPort);
    
  }

  // POST request
  public void request(String resource, String body) throws IOException {
    this.entityBody = body;
    this.requestType = HTTPRequest.POST; // enforce POST when body given
    request(resource);
  }

  // GET request
  public void request(String resource) throws IOException {
    
    /* 1st: compute request line */
    String requestLine = requestType + " /" + resource
      + " HTTP/" + HTTPVersion + CRLF;

    /////
    System.out.println("REQUEST SENT:\n" + requestLine);
    /////

    /* 2nd: send request */
    OutputStream out = link.getOutputStream();
    PrintWriter outw = new PrintWriter(out, false);
    
    outw.print(requestLine);
    if (entityHeaders != null)
      outw.print(entityHeaders); // not going to send any in this stripped version
    outw.print(CRLF);
    if (entityBody != null)
      outw.print(entityBody);
    outw.flush();
    
    /* 3rd: save response */
    InputStream input = link.getInputStream();
    BufferedInputStream inputBuffer = new BufferedInputStream(input);
    ByteArrayOutputStream outputBuffer = new ByteArrayOutputStream();

    int actualBytesRead;
    int totalBytesRead = 0;
    byte[] data = new byte[512];

    while ((actualBytesRead = inputBuffer.read(data, 0, data.length)) != -1) {
      outputBuffer.write(data, 0, actualBytesRead);
      totalBytesRead += actualBytesRead;
    }

    outputBuffer.flush();

    byte[] fullResponse = new byte[totalBytesRead];
    fullResponse = outputBuffer.toByteArray();

    System.out.println("(WHOLE) READ BYTES: "+totalBytesRead);

    workResponse(fullResponse, totalBytesRead);
  }

  private void workLine(String currentLine)
  {
    if (currentLine.equals("HTTP/1.1 200 OK")) requestCompliant = true;
    String[] tokens = currentLine.split(": ");
    if (tokens.length == 2)
    {
      String headerName = tokens[0];
      String headerValue = tokens[1];
      if (headerName.equals("Content-Length"))
	contentLength = Integer.parseInt(headerValue);
    }
  }
  private void workResponse(byte[] fullResponse, int totalBytesRead) throws UnsupportedEncodingException
  {
    /* converting to string to gather headers, especially Content-Length */
    String responseToString = new String(fullResponse, "UTF-8");
    String[] tokens = responseToString.split(CRLF);
    int i = 0;
    while(i < tokens.length) {
      String currentLine = tokens[i];
      workLine(currentLine);
      responseHeader += currentLine + CRLF;
      if (currentLine.matches("")) break; // blank line: headers got
      i++;
    }

    //////
    System.out.println("ANSWER RECEIVED:\n---\n" + responseHeader + "---");
    //////
    
    /* obtain and store body as a byte array */
    if (requestCompliant) {
	  /* getting resource if any */
	  int resourceLength = totalBytesRead - responseHeader.length();
          byte[] resource = new byte[resourceLength];
	  System.arraycopy(fullResponse, responseHeader.length(), resource, 0, resource.length);
	  /* saving body response */
	  responseBody = resource;
	  System.out.println("(BODY) GOT BYTES: " + responseBody.length);
      }
  }

  // public static void main(String args[]) {

  //   try {
  //     HTTPClientTCP test = new HTTPClientTCP("mm.sharped.net",3300);
  //     test.setRequestType(HTTPRequest.POST);
  //     test.connect();
  //     test.request("cgi-bum/mmupdate.icg","?lol");
  //     //test.request("cgi-bum/release/golly_vectorializer.app/Contents/Java/golly_vectorializer.jar");
  //     byte[] a = test.getResponseBody();
  //     String responseBody = new String(a, "UTF-8");
  //     System.out.println(responseBody);
  //   } catch(IOException e) {
  //     e.printStackTrace();
  //   }
    
  // }
}
