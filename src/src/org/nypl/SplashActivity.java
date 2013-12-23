package org.nypl;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Timer;
import java.util.TimerTask;

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
import android.util.Log;
import android.view.Window;
//import org.nypl.HomeActivity.ExtractingTask;


public class SplashActivity extends Activity{
	
	final Handler handler = new Handler(); 
	Timer t = new Timer(); 
	String libraryFile = "playfromjson";
	ProgressDialog mProgressDialog;

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
    private ProgressDialog progressDialog;
	public void onCreate(Bundle savedInstanceState) {

		requestWindowFeature(Window.FEATURE_NO_TITLE);
	       super.onCreate(savedInstanceState);
	       setContentView(R.layout.s_splash);
	       
	       CONTENT_LOCATION = "Android/data/"+this.getPackageName()+File.separator+"contents";    
	       final File mfreeChapterFolder = new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION);
	       
		
		 
	       if(!mfreeChapterFolder.exists())
	   	   	{
	   	   		new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION).mkdirs();
	   	   	}
	      
	       
			


	   	   	File playsjson = new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+"playjsonformat.json");
	   	    File samplePlay =  new File(FilePath.getAbsolutePath()+File.separator+CONTENT_LOCATION+File.separator+"A65A647B-A4A3-48E5-A7B4-C181277CD5DB");
	   	   	if(!playsjson.exists())
	   	   	{
	   	   	copyFromAssets("playjsonformat.json");
	   	   	}
			if(!samplePlay.exists()){
				copyFromAssets("A65A647B-A4A3-48E5-A7B4-C181277CD5DB.epub");
				
			}

	    
	                            	   
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

	
   
	

}