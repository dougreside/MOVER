package org.nypl.parsing;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.nypl.MoverContentProvider;
import org.nypl.database.AudioDAO;
import org.nypl.database.CsvReader;
import org.nypl.database.PlayDAO;
import org.nypl.database.VersionDAO;
import org.nypl.dataholder.PlaysBean;
import org.nypl.dataholder.VersionBean;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;

public class VersionParser {
	
	public static SQLiteDatabase db1;
	public static Context context1;
	public static String CONTENT_LOCATION;
	public static String ProjectFolder;
	public static String parsePlayVersion(InputStream is, SQLiteDatabase db, Context context, String content_location) {
		db1 = db;
		context1 = context;
		CONTENT_LOCATION = content_location;
	
		SAXParserFactory factory = SAXParserFactory.newInstance();
		try {
			SAXParser parser = factory.newSAXParser();
			RssHandler handler = new RssHandler();
			parser.parse(is, handler);
			is.close();
			return handler.getXmlItems();
		} catch (Exception e) {
			throw new RuntimeException(e);
		} 

	}

	public  static class RssHandler extends DefaultHandler{
		private ArrayList<VersionBean> versionItemList;
		private ArrayList<PlaysBean> playsItemList;
		private VersionBean currentItem;
		private PlaysBean currentPlay=new PlaysBean();
		private StringBuilder builder;
		private String item_id;
		private String version_id;
		private String version_name;
		private String version_html_name;
		private String version_audio_name;
		private String playidfinal;
		private Boolean titleActive=false;
		private Boolean authorActive=false;
		public String getXmlItems(){
			return this.playidfinal;
		}

		@Override
		public void characters(char[] ch, int start, int length)
		throws SAXException {
			super.characters(ch, start, length);
			
			builder.append(ch, start, length);
			
		}

		@Override
		public void endElement(String uri, String localName, String name)
		throws SAXException {
			super.endElement(uri, localName, name);
			System.out.println("end: "+localName);
		//if (this.currentItem != null){
				System.out.println("Do do do "+localName);
				 if ((localName.equalsIgnoreCase(NAVPOINT))&&(this.currentItem != null)){
					 String versionname = builder.toString().trim();
					System.out.println("*******"+version_id);
					System.out.println("*******"+versionname);
					System.out.println("*******"+version_html_name);
					currentItem.setVersionPlayID(playidfinal);
					currentItem.setVersionID(version_id);
					currentItem.setVersionName(builder.toString());
					currentItem.setVersionHTMLFile(version_html_name);
					versionItemList.add(currentItem);
					System.out.println("Inserting version");
					if (db1!=null){
						System.out.println("db1 not null");
					CsvReader.insertVersionTable(db1,context1,version_id, playidfinal,version_html_name, versionname);
					}
					else{
						System.out.println("DB1 null but playidfinal is "+playidfinal);
						ContentValues cv = new ContentValues();
						cv.put(VersionDAO.COLUMN_NAME_VERSION_UUID,version_id);
						cv.put(VersionDAO.COLUMN_NAME_VERSION_PLAY_ID,playidfinal);
						cv.put(VersionDAO.COLUMN_NAME_VERSION_NAME,versionname);
						cv.put(VersionDAO.COLUMN_NAME_HTML_FILE,version_html_name);
						context1.getContentResolver().insert(Uri.parse(MoverContentProvider.CONTENT_URI+"/"+MoverContentProvider.VERSION_PATH), cv);

					}
				}
			
				 else if (localName.equalsIgnoreCase("text")){
					 if (titleActive){
						 System.out.println("Setting title");
						 currentPlay.setPlayName(builder.toString().trim());
						 titleActive = false;
					 }
					 else if (authorActive){
						 System.out.println("Setting author");
						 currentPlay.setPlayAuthors(builder.toString().trim());
						 authorActive = false;
					 }
				 }
	//	}
			//}
			//builder.setLength(0);    
		}

		@Override
		public void startDocument() throws SAXException {
			super.startDocument();
			versionItemList = new ArrayList<VersionBean>();
			builder = new StringBuilder();
		}
		
		@Override
		public void startElement(String uri, String localName, String name,
				Attributes attributes) throws SAXException {
			super.startElement(uri, localName, name, attributes);
			Cursor cursor2;
			ProjectFolder=CONTENT_LOCATION.substring(0,CONTENT_LOCATION.lastIndexOf("/"));
			File PlayFolder = new File(CONTENT_LOCATION);
			
			if(localName.equalsIgnoreCase(NAVMAP))
			{
	
			if (db1!=null){
			 cursor2 = db1.rawQuery("select * from PLAY where PLAY_LONG_ID=\""+playidfinal+"\"",null);
			}
			else{
			 cursor2 = context1.getContentResolver().query(Uri.parse(MoverContentProvider.CONTENT_URI+"/"+MoverContentProvider.PLAY_PATH), null, PlayDAO.COLUMN_NAME_PLAY_LONG_ID +"=\""+playidfinal+"\"", null, null);
			}	
		
			if (cursor2.getCount()==0){
			
			if (db1!=null){
			CsvReader.insertPlayTable(db1, context1, playidfinal, currentPlay.getPlayName(),"cover.jpeg", currentPlay.getPlayAuthors(),currentPlay.getPlayUrl()); 
			}
			else{
				ContentValues cv = new ContentValues();
				cv.put(PlayDAO.COLUMN_NAME_PLAY_LONG_ID, playidfinal);
				cv.put(PlayDAO.COLUMN_NAME_PLAY_NAME, currentPlay.getPlayName());
				cv.put(PlayDAO.COLUMN_NAME_PLAY_IMAGE, "cover.jpeg");
				cv.put(PlayDAO.COLUMN_NAME_PLAY_AUTHORS, currentPlay.getPlayAuthors());
				context1.getContentResolver().insert(Uri.parse(MoverContentProvider.CONTENT_URI+"/"+MoverContentProvider.PLAY_PATH), cv);

			}
			System.out.println("Inserted");
			PlayJsonParser.addPlayToJson(ProjectFolder+File.separator+"playjsonformat.json",playidfinal, currentPlay.getPlayName(), "cover.jpeg", "", currentPlay.getPlayAuthors(), "");
			}
			System.out.println("IS PLAY FOLDER NAMED RIGHT?");
		    if (PlayFolder.exists()){
		    	System.out.println(CONTENT_LOCATION);
		    	System.out.println(ProjectFolder+File.separator+playidfinal);
		    	PlayFolder.renameTo(new File(ProjectFolder+File.separator+playidfinal));
		    }
			this.currentItem = new VersionBean();

		    }
			else if(localName.equalsIgnoreCase("meta")){
			     if (attributes.getValue("name").equalsIgnoreCase("dtb:uid")){
			    	 playidfinal = attributes.getValue("content");
			     }
			}
			else if (localName.equalsIgnoreCase("navMap")){
				
			 }
			else if(localName.equalsIgnoreCase(NAVPOINT)){
				version_id =attributes.getValue(ID);
			 }
			 else if (localName.equalsIgnoreCase(CONTENT)){
				 version_html_name = attributes.getValue("src");
			 }
			 else if (localName.equalsIgnoreCase(TEXT)){
				 builder.delete(0, builder.length());
			 }
			 else if (localName.equalsIgnoreCase("docTitle")){
				 titleActive=true;
			 }


		}
		private static final  String NAVMAP = "navMap";
		private static final  String NAVPOINT = "navPoint";
		private static final  String TEXT = "text";
		private static final  String CONTENT = "content";
		private static final  String ID = "id";
		
		
		
	
	}

}
