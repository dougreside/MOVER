package org.nypl.database;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import org.nypl.MoverContentProvider;
import org.nypl.dataholder.PlaysBean;
import org.nypl.dataholder.VersionBean;



import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

public class VersionDAO {
	public static final String TABLE_NAME = "VERSION"; 
	public static final String COLUMN_NAME_VERSION_ID = "_id"; 
	public static final String COLUMN_NAME_VERSION_UUID = "VERSION_ID"; 
	public static final String COLUMN_NAME_VERSION_PLAY_ID = "PLAY_ID"; 
	public static final String COLUMN_NAME_VERSION_NAME = "VERSION_NAME"; 
	public static final String COLUMN_NAME_HTML_FILE = "HTML_FILE"; 

	public static final String COLUMN_NAME_NOTE = "NOTE"; 
	public static final String COLUMN_NAME_PLAY_NAME = "PLAY_NAME"; 
	public static final String COLUMN_NAME_PLAY_AUTHOR_NAME = "AUTHORS"; 
	public static final String COLUMN_NAME_PLAY_IMAGE = "IMAGE"; 


	private static int COLUMN_INDEX_VERSION_ID = -1; 
	private static int COLUMN_INDEX_VERSION_PLAY_ID = -1;
	private static int COLUMN_INDEX_VERSION_UUID = -1;
	private static int COLUMN_INDEX_VERSION_NAME = -1;
	private static int COLUMN_INDEX_HTML_FILE = -1;

	private static int COLUMN_INDEX_NOTE = -1;
	private static int COLUMN_INDEX_VERSION_PLAY_NAME =-1;
	private static int COLUMN_INDEX_VERSION_PLAY_AUHTOR_NAME =-1;
	private static int COLUMN_INDEX_VERSION_PLAY_IMAGE =-1;



	private static void setColumns(Cursor cursor){

		COLUMN_INDEX_VERSION_ID = cursor.getColumnIndex(COLUMN_NAME_VERSION_ID);
		COLUMN_INDEX_VERSION_UUID = cursor.getColumnIndex(COLUMN_NAME_VERSION_UUID);
		COLUMN_INDEX_VERSION_PLAY_ID = cursor.getColumnIndex(COLUMN_NAME_VERSION_PLAY_ID);
		COLUMN_INDEX_VERSION_NAME = cursor.getColumnIndex(COLUMN_NAME_VERSION_NAME);
		COLUMN_INDEX_HTML_FILE = cursor.getColumnIndex(COLUMN_NAME_HTML_FILE);
	
		COLUMN_INDEX_NOTE = cursor.getColumnIndex(COLUMN_NAME_NOTE);
		COLUMN_INDEX_VERSION_PLAY_NAME = cursor.getColumnIndex(COLUMN_NAME_PLAY_NAME);
		COLUMN_INDEX_VERSION_PLAY_AUHTOR_NAME = cursor.getColumnIndex(COLUMN_NAME_PLAY_AUTHOR_NAME);
		COLUMN_INDEX_VERSION_PLAY_IMAGE = cursor.getColumnIndex(COLUMN_NAME_PLAY_IMAGE);
	}
	public static ArrayList<VersionBean> getVersionOf(Context ctx,String PlayId){
		ArrayList<VersionBean> list = new ArrayList<VersionBean>();
		System.out.println("All versions for: "+PlayId);
		Cursor cursor =ctx.getContentResolver().query(Uri.withAppendedPath(MoverContentProvider.CONTENT_URI,
				MoverContentProvider.VERSION_PATH), null,  COLUMN_NAME_VERSION_PLAY_ID +" =\""+PlayId+"\"", null, null);
		///.query(MoverContentProvider.CONTENT_URI+"/"+MoverContentProvider.PLAY_PATH, null, null, null, null);
		System.out.println("CURSOR COUNT "+cursor.getCount());
		if(cursor != null && cursor.getCount()>0){
			setColumns(cursor);
			for(int i=0;i<cursor.getCount();i++){
				cursor.moveToPosition(i);
				VersionBean version = new VersionBean();
				version.setVersionID(cursor.getString(COLUMN_INDEX_VERSION_ID));
				version.setVersionUUID(cursor.getString(COLUMN_INDEX_VERSION_UUID));
				version.setVersionPlayID(cursor.getString(COLUMN_INDEX_VERSION_PLAY_ID));
				version.setVersionName(cursor.getString(COLUMN_INDEX_VERSION_NAME));
				version.setVersionHTMLFile(cursor.getString(COLUMN_INDEX_HTML_FILE));

				list.add(version);
			}
		}
		cursor.close();

		return list;

	}





	public static ArrayList<VersionBean> getPlayVersionHavingNotes(Context ctx,String search,String VersionId){
		ArrayList<VersionBean> list = new ArrayList<VersionBean>();
		Cursor cursor =ctx.getContentResolver().query(Uri.withAppendedPath(MoverContentProvider.CONTENT_URI,
				MoverContentProvider.VERSION_PLAY_PATH), null,  search, null,null);
		///.query(MoverContentProvider.CONTENT_URI+"/"+MoverContentProvider.PLAY_PATH, null, null, null, null);
		if(cursor != null && cursor.getCount()>0){
			setColumns(cursor);
			for(int i=0;i<cursor.getCount();i++){
				cursor.moveToPosition(i);
				VersionBean version = new VersionBean();
				version.setVersionPlayID(cursor.getString(COLUMN_INDEX_VERSION_PLAY_ID));
				version.setVersionID(cursor.getString(COLUMN_INDEX_VERSION_ID));
				version.setVersionPlayName(cursor.getString(COLUMN_INDEX_VERSION_PLAY_NAME));
				version.setVersionName(cursor.getString(COLUMN_INDEX_VERSION_NAME));
				version.setVersionHTMLFile(cursor.getString(COLUMN_INDEX_HTML_FILE));
				
				version.setNotes(cursor.getString(COLUMN_INDEX_NOTE));
				version.setAuthor(cursor.getString(COLUMN_INDEX_VERSION_PLAY_AUHTOR_NAME));
				version.setVersionPlayImage(cursor.getString(COLUMN_INDEX_VERSION_PLAY_IMAGE));
				list.add(version);
			}
		}
		cursor.close();

		return list;

	}
	
	
	public static ArrayList<VersionBean> getPlayVersionNotes(Context ctx,String search,String VersionId){
		ArrayList<VersionBean> list = new ArrayList<VersionBean>();
		Cursor cursor =ctx.getContentResolver().query(Uri.withAppendedPath(MoverContentProvider.CONTENT_URI,
				MoverContentProvider.VERSION_PLAY_NOTE_PATH), null,  VersionId, null,null);
		///.query(MoverContentProvider.CONTENT_URI+"/"+MoverContentProvider.PLAY_PATH, null, null, null, null);
		if(cursor != null && cursor.getCount()>0){
			setColumns(cursor);
			for(int i=0;i<cursor.getCount();i++){
				cursor.moveToPosition(i);
				VersionBean version = new VersionBean();
				version.setVersionPlayID(cursor.getString(COLUMN_INDEX_VERSION_PLAY_ID));
				version.setVersionID(cursor.getString(COLUMN_INDEX_VERSION_ID));
				version.setVersionPlayName(cursor.getString(COLUMN_INDEX_VERSION_PLAY_NAME));
				version.setVersionName(cursor.getString(COLUMN_INDEX_VERSION_NAME));
				version.setVersionHTMLFile(cursor.getString(COLUMN_INDEX_HTML_FILE));

				version.setNotes(cursor.getString(COLUMN_INDEX_NOTE));
				list.add(version);
			}
		}
		cursor.close();

		return list;

	}
	


	public static void putNotes(Context ctx, int versionId ,String Note) {
		int change = 0;
		ContentValues values = new ContentValues();
		values.put(COLUMN_NAME_NOTE, Note);
		change = ctx.getContentResolver().update(Uri.withAppendedPath(MoverContentProvider.CONTENT_URI,
				MoverContentProvider.VERSION_PATH), values, DatabaseTable.TABLE_VERSION_ID + "=" + versionId, null);
	}

	public static void deleteNotes(Context ctx, int versionId) {
		int change = 0;
		ContentValues values = new ContentValues();
		///values.put(COLUMN_NAME_NOTE,);
		change = ctx.getContentResolver().delete(Uri.withAppendedPath(MoverContentProvider.CONTENT_URI,
				MoverContentProvider.VERSION_PATH),  DatabaseTable.TABLE_VERSION_ID + "=" + versionId, null);
	}
}
