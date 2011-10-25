package org.nypl.labs.mover;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

import com.phonegap.api.Plugin;
import com.phonegap.api.PluginResult;
import com.phonegap.api.PluginResult.Status;

public class DecompressPlugin extends Plugin {


	 
	/** 
	 * 
	 * @author jon 
	 */ 

	  private String _zipFile; 
	  private String _location; 
	  public static final String ACTION="unzip";
	/*  public Decompress(String zipFile, String location) { 
	    _zipFile = zipFile; 
	    _location = location; 
	 
	    _dirChecker(""); 
	  } */
	 
	  public boolean unzip() { 
	    try  { 
	      FileInputStream fin = new FileInputStream(_zipFile); 
	      ZipInputStream zin = new ZipInputStream(fin); 
	      ZipEntry ze = null; 
	      while ((ze = zin.getNextEntry()) != null) { 
	        Log.v("Decompress", "Unzipping " + ze.getName()); 
	 
	        if(ze.isDirectory()) { 
	          _dirChecker(ze.getName()); 
	        } else { 
	          FileOutputStream fout = new FileOutputStream(_location + ze.getName()); 
	          for (int c = zin.read(); c != -1; c = zin.read()) { 
	            fout.write(c); 
	          } 
	 
	          zin.closeEntry(); 
	          fout.close(); 
	        } 
	         
	      } 
	      zin.close(); 
	      return true;
	    } catch(Exception e) { 
	      Log.e("Decompress", "unzip", e); 
	      return false;
	    } 
	
	  } 
	 
	  private void _dirChecker(String dir) { 
	    File f = new File(_location + dir); 
	 
	    if(!f.isDirectory()) { 
	      f.mkdirs(); 
	    } 
	  } 
	
	
	
	
	
	@Override
	public PluginResult execute(String action, JSONArray data, String callbackId) {
	// TODO Auto-generated method stub
		PluginResult result = null;

		try {
		 _zipFile = data.getString(0);
		 _location = data.getString(1);
		unzip();
		
		//JSONObject fileInfo = getDirectoryListing(new File(fileName));
		//Log.d("DirectoryListPlugin", "Returning "+ fileInfo.toString());
		result = new PluginResult(Status.OK, "Unzip complete");
		} 
		catch  (JSONException jsonEx) {
		//Log.d("DirectoryListPlugin", "Got JSON Exception "+ jsonEx.getMessage());
		result = new PluginResult(Status.JSON_EXCEPTION);
		}
		
		return result;
		
	}

}
