package org.nypl.database;

import android.database.sqlite.SQLiteDatabase;
import android.util.Log;

/**
 * @author hcl
 *
 */
/**
 * @author hcl
 *
 */
/**
 * @author hcl
 *
 */
public class DatabaseTable {

	// Database table

	public static final String TABLE_NAME ="PLAY";
	public static final String TABLE_NAME2 ="VERSION";
	public static final String TABLE_NAME3 ="ANCHOR";
	public static final String TABLE_NAME4 ="MEDIA";
	public static final String TABLE_NAME5 ="PLAY_NOTE";
	public static final String TABLE_NAME6="AUDIO";
	/*Column Related to Play Table
	 * 
	 */
	public static final  String TABLE_PLAY_ID = "_id";
	public static final String TABLE_PLAY_LONG_ID = "PLAY_LONG_ID";
	public static final String TABLE_PLAY_NAME = "PLAY_NAME";
	public static final String TABLE_PLAY_IMAGE = "IMAGE";
	public static final String TABLE_PLAY_SCROLL_POSITION = "SCROLL_POSITION";
	public static final String TABLE_PLAY_AUTHORS = "AUTHORS";
	public static final String TABLE_PLAY_URL = "PLAY_URL";
	/*Column Related to Version Table
	 * 	
	 */
	public static final  String TABLE_ID = "_id";
	public static final  String TABLE_VERSION_ID = "VERSION_ID";
	public static final String TABLE_VERSION_HTML_FILE = "HTML_FILE";
	public static final String TABLE_VERSION_PLAY_ID = "PLAY_ID";
	public static final String TABLE_VERSION_NAME = "VERSION_NAME";
	public static final String TABLE_VERSION_BOOKMARK = "BOOKMARK";
	public static final String TABLE_VERSION_NOTE = "NOTE";
	public static final String TABLE_VERSION_AUDIO_NAME = "AUDIO_FILE_NAME";
	/**
	 * COlumn Related to Anchor table
	 */
	
	public static final  String TABLE_ANCHOR_ID = "_id";
	public static final  String TABLE_ANCHOR_PLAY_ID = "PLAY_ID";
	public static final String TABLE_ANCHOR_VERSION_PLAY_ID = "PLAY_VERSION_ID";
	public static final String TABLE_ANCHOR_HTML_ID = "ANCHOR_HTML_ID";
	/**
	 * COlumn Related to Media table
	 */
	
	public static final  String TABLE_MEDIA_ID = "_id";
	public static final  String TABLE_MEDIA_NAME = "MEDIA_NAME";

	
	/**
	 * COlumn Related to PLAY_NOTE table
	 */
	
	public static final  String TABLE_PLAY_NOTE_UNIQUE_ID = "_id";
	public static final  String TABLE_PLAY_NOTES = "NOTES";
	public static final  String TABLE_PLAY_NOTE_ID = "NOTE_ID";
	public static final  String TABLE_PLAY_NOTE_TEXT = "NOTE_TEXT";
	public static final  String TABLE_PLAY_NOTE_PLAY_ID = "PLAY_ID";
	public static final  String TABLE_PLAY_NOTE_VERSION_ID = "VERSION_ID";
	public static final  String TABLE_PLAY_NOTE_VERSION_NAME = "VERSION_NAME";

	
	/**
	 * COlumn Related to Audio table
	 */
	
	public static final  String TABLE_AUDIO_UNIQUE_ID = "_id";
	public static final  String TABLE_AUDIO_PLAY_ID = "PLAY_ID";
	public static final  String TABLE_AUDIO_CLIP_ID = "CLIP_ID";
	public static final  String TABLE_AUDIO_VERSION_ID = "VERSION_ID";
	public static final  String TABLE_AUDIO_CLIP_FROM = "CLIP_FROM";
	public static final  String TABLE_AUDIO_CLIP_TO = "CLIP_TO";
	public static final  String TABLE_AUDIO_PATH = "AUDIO_PATH";


	
	/**
	 * Database creation SQL statement
	 */
	private static final String DATABASE_CREATE = "create table " 
		+ TABLE_NAME
		+ "(" 
		+ TABLE_PLAY_ID + " integer primary key autoincrement, " 
		+ TABLE_PLAY_LONG_ID + " text not null, " 
		+ TABLE_PLAY_NAME + " text not null ,"
		+ TABLE_PLAY_IMAGE + " text not null ,"
		+ TABLE_PLAY_AUTHORS + " text,  " 
		+ TABLE_PLAY_SCROLL_POSITION + " text,  "
		+ TABLE_PLAY_URL+ " text "
		+ ");";

	private static final String DATABASE_CREATE2 = "create table " 
		+ TABLE_NAME2
		+ "("
		+ TABLE_ID + " integer primary key autoincrement, " 
		+ TABLE_VERSION_ID + " text not null, " 
		+ TABLE_VERSION_PLAY_ID + " text not null ," 
		+ TABLE_VERSION_HTML_FILE + " text not null ," 
		+ TABLE_VERSION_NAME + " text not null ," 
		+ TABLE_VERSION_AUDIO_NAME + " text  " 
		+ ");";

	private static final String DATABASE_CREATE3 = "create table " 
		+ TABLE_NAME3
		+ "(" 
		+ TABLE_ANCHOR_ID + " integer primary key autoincrement, " 
		+ TABLE_ANCHOR_PLAY_ID + " text not null ," 
		+ TABLE_ANCHOR_VERSION_PLAY_ID + " integer not null ," 
		+ TABLE_ANCHOR_HTML_ID + " text not null " 
		+ ");";
	
	private static final String DATABASE_CREATE4 = "create table " 
		+ TABLE_NAME4
		+ "(" 
		+ TABLE_MEDIA_ID + " text not null ," 
		+ TABLE_MEDIA_NAME + " text not null " 
		+ ");";
	

			
	
	
	private static final String DATABASE_CREATE5 = "create table " 
		+ TABLE_NAME5
		+ "(" 
		+ TABLE_PLAY_NOTE_UNIQUE_ID + " integer primary key autoincrement, " 
		+ TABLE_PLAY_NOTE_ID + " text not null , " 
		+ TABLE_PLAY_NOTES + " text not null , " 
		+ TABLE_PLAY_NOTE_TEXT + " text not null , " 
		+ TABLE_PLAY_NOTE_PLAY_ID + " text not null , " 
		+ TABLE_PLAY_NOTE_VERSION_ID + " text not null , " 
		+ TABLE_PLAY_NOTE_VERSION_NAME + " text not null  " 
		+ ");";
  

	 
	private static final String DATABASE_CREATE6 = "create table " 
			+ TABLE_NAME6
			+ "(" 
			+ TABLE_AUDIO_UNIQUE_ID + " text primary key , "
			+ TABLE_AUDIO_PLAY_ID + " text not null , " 
			+ TABLE_AUDIO_CLIP_ID + " text not null , " 
			+ TABLE_AUDIO_VERSION_ID + " text not null , " 
			+ TABLE_AUDIO_CLIP_FROM + " text not null , " 
			+ TABLE_AUDIO_CLIP_TO + " text not null  ,"
			+ TABLE_AUDIO_PATH + " text not null " 
			 
			+ ");";
	  
  
	public static void onCreate(SQLiteDatabase database) {
		Log.v("database create",""+database);
		   System.out.println(DATABASE_CREATE);
		database.execSQL(DATABASE_CREATE);
		database.execSQL(DATABASE_CREATE2);
		database.execSQL(DATABASE_CREATE3);
		database.execSQL(DATABASE_CREATE4);
		database.execSQL(DATABASE_CREATE5);
		database.execSQL(DATABASE_CREATE6);
	}

	//		public static void onUpgrade(SQLiteDatabase database, int oldVersion,
	//				int newVersion) {
	//			
	//			database.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
	//			onCreate(database);
	//		}


}
