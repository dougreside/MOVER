package org.nypl;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URL;
import java.net.URLConnection;
import java.util.Timer;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.view.Window;
//import org.nypl.HomeActivity.ExtractingTask;


public class SplashActivity extends Activity{
	
	final Handler handler = new Handler(); 
	Timer t = new Timer(); 
	String libraryFile = "playfromjson";
	ProgressDialog mProgressDialog;
	Context mCtx = this;
	// instantiate it within the onCreate method
	
	public static String CONTENT_LOCATION ;
	private File FilePath = Environment.getExternalStorageDirectory();
    public boolean haveNetworkConnection() {
        boolean haveConnectedWifi = false;
        boolean haveConnectedMobile = false;

        ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo[] netInfo = cm.getAllNetworkInfo();
        for (NetworkInfo ni : netInfo) {
            if (ni.getTypeName().equalsIgnoreCase("WIFI"))
                if (ni.isConnected())
                    haveConnectedWifi = true;
            if (ni.getTypeName().equalsIgnoreCase("MOBILE"))
                if (ni.isConnected())
                    haveConnectedMobile = true;
        }
        return haveConnectedWifi || haveConnectedMobile;
    }
   
	public void onCreate(Bundle savedInstanceState) {
		System.out.println("SPLASH!");
		requestWindowFeature(Window.FEATURE_NO_TITLE);
	       super.onCreate(savedInstanceState);
	       setContentView(R.layout.s_splash);
	       
	       CONTENT_LOCATION = "Android/data/"+this.getPackageName()+File.separator+"contents";    
	       final File mfreeChapterFolder = new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION);
	       
		
		 
	       if(!mfreeChapterFolder.exists())
	   	   	{
	   	   		new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION).mkdirs();
	   	   	}
	      
	       
			if (haveNetworkConnection()){
				
			
	       final DownloadFile df = new DownloadFile();
	       df.execute(this.getString(R.string.libraryURI),FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+"library.json");
			}
			else{
				startUp();
			}
	                          
	       
	   	   	}
	   	   	
	   	   	
	   	   	
	       
	   
	public void startUp(){

   	   	File playsjson = new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+"playjsonformat.json");
   	    File samplePlay =  new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+"A65A647B-A4A3-48E5-A7B4-C181277CD5DB");
   	   	if(!playsjson.exists())
   	   	{
   	   	copyFromAssets("playjsonformat.json");
   	   	}
		if(!samplePlay.exists()){
			copyFromAssets("A65A647B-A4A3-48E5-A7B4-C181277CD5DB.epub");
			
		}

    
                          System.out.println("starinup");  	   
                 // Intent intent = new Intent(SplashActivity.this, HomeActivity.class);
		  							Intent intent = new Intent(SplashActivity.this, PlaysListActivity.class);
        
									startActivity(intent);
                                  	SplashActivity.this.finish();
                                   
	}
	
	public void copyFromAssets(String fileName){
		 AssetManager assetManager = getAssets();
			InputStream inputStream = null;
			try{
	       inputStream = assetManager.open(fileName);
			
			 OutputStream output = new FileOutputStream(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+fileName);

	            byte data[] = new byte[1024];
	        
	            int count;
	            while ((count = inputStream.read(data)) != -1) {
	             //  System.out.println("count "+count);
	                output.write(data, 0, count);
	            }

	            output.flush();
	            output.close();
	            inputStream.close();
	            
			}
			catch (Exception e){
				System.out.println("Ow");
			}
	}

	private class DownloadFile extends AsyncTask<String,Integer,String> {
		@Override
		protected void onPostExecute(String outstring) {
				
			System.out.println("Download Complete");
			//new ExtractingTask("HTMLObject.zip", FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+"/").execute();
			 //CONTENT_LOCATION = "Android/data/"+getView().getContext().getPackageName()+File.separator+"contents";
		   //  System.out.println("UNZIP THIS: "+result);	
		     
		    	// PlaysAddActivity.processZipFile(result,mCtx);

	
			
		     startUp();
			super.onPostExecute(outstring);
	    	
			
		}
	    @Override
	    protected String doInBackground(String... params) {
	    	CONTENT_LOCATION = "Android/data/"+mCtx.getPackageName()+File.separator+"contents";
		     	String urlString = params[0];
	    	     String outstring =   params[1];
	        try {
	        	downloadContent(urlString,outstring);
	            
	            
	            String playjsonformat =   FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+"playjsonformat.json";
			     String jsonString = "";
			     String manifestString = "{\"Plays\":[";
			     try{ 
			    	 jsonString = readFile(outstring);
			    	// System.out.println(jsonString);
			     }
			     catch(IOException e){
			    	 System.out.println(e);
			    	 
			     }
			     JSONObject books;
			    
			     try {
			    	 books = new JSONObject(jsonString);	
			 		 JSONArray rows = books.getJSONObject("feed").getJSONArray("entry");
			 		 for (int i=0;i<rows.length();i++){
			 			 JSONObject row = (JSONObject)rows.get(i);
			 			
			 			 String bookTitle = row.getJSONObject("gsx$title").getString("$t");
			 			 String bookThumbnail = row.getJSONObject("gsx$thumbnail").getString("$t");
			 			 
			 			 String bookURL = row.getJSONObject("gsx$epub").getString("$t");
			 			 String bookAuthor = row.getJSONObject("gsx$author").getString("$t");
			 			 String bookuuid = row.getJSONObject("gsx$uuid").getString("$t");
			 			 //String bookCover = bookuuid+bookThumbnail.substring(bookThumbnail.lastIndexOf("."+1));
			 			
			 			downloadContent(bookThumbnail,FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+bookuuid+".jpg");
			 			 if (i>0){manifestString=manifestString+",";}
			 			 manifestString=manifestString+
			 					 "{\"playid\":\""+bookuuid+"\","+
			 					"\"playname\":\""+bookTitle+"\","+
			 					"\"imageurl\":\""+bookuuid+".jpg\","+
			 					"\"author\":\""+bookAuthor+"\","+
			 					"\"playUrl\":\""+bookURL+"\"}";
			 					
			 			 
			 		 }
			 		 manifestString=manifestString+"]}";
			 	   System.out.println(manifestString);
			 	   PrintWriter out = new PrintWriter(playjsonformat);
		           out.println(manifestString);
		           out.flush();
		           out.close();
			     }
			     catch (Exception e){
			    	 System.out.println(e);		    	 
			     }
			 
			
	            
	         	    	   	
	        } catch (Exception e) {
	        e.printStackTrace();
	        }
	        return outstring;
	    }
	    public void downloadContent(String urlString,String outstring){
	    	try{
	    	URL url = new URL(urlString);
	    	 URLConnection connection = url.openConnection();
	            connection.connect();
	            // this will be useful so that you can show a typical 0-100% progress bar
	            int fileLength = connection.getContentLength();
	            System.out.println("Downloading to: "+outstring);
	            // download the file
	            InputStream input = new BufferedInputStream(url.openStream());
	            OutputStream output = new FileOutputStream(outstring);

	            byte data[] = new byte[1024];
	            long total = 0;
	            int count;
	            while ((count = input.read(data)) != -1) {
	                total += count;
	                //publishing the progress....
	                publishProgress((int) (total * 100 / fileLength));
	                output.write(data, 0, count);
	            }

	            output.flush();
	            output.close();
	            input.close();
	    	
	    }
	    	catch (Exception e){
	    		System.out.println(e);
	    	}
	}
   
	String readFile(String fileName) throws IOException {
	    BufferedReader br = new BufferedReader(new FileReader(fileName));
	    try {
	        StringBuilder sb = new StringBuilder();
	        String line = br.readLine();

	        while (line != null) {
	            sb.append(line);
	            sb.append("\n");
	            line = br.readLine();
	        }
	        return sb.toString();
	    }
	    	finally {
	    
	        br.close();
	    }
	}


}}