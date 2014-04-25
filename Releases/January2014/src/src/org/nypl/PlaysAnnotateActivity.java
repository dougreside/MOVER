package org.nypl;

import org.nypl.adapter.ViewPagerAdapter;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.widget.ImageView;

import com.actionbarsherlock.app.SherlockFragmentActivity;

public class PlaysAnnotateActivity extends SherlockFragmentActivity{
	
		@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.plays_annotate_activity);
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inPreferredConfig = Bitmap.Config.ARGB_8888;
		//((ImageView)findViewById(R.id.s_background_img)).setBackgroundDrawable(new BitmapDrawable(BitmapFactory.decodeResource(getResources(), R.drawable.img_background, options)));
	
		if(ViewPagerAdapter.mp!=null){
			//ViewPagerAdapter.mp.pause();
		ViewPagerAdapter.mp.release();
		ViewPagerAdapter.mHandler.removeCallbacks(ViewPagerAdapter.mUpdateTimeTask);
		}
	}

	@Override
	protected void onPause()
	{
		super.onPause();
		//Save state here
		if(ViewPagerAdapter.mp!=null){
			//ViewPagerAdapter.mp.pause();
		ViewPagerAdapter.mp.release();
		ViewPagerAdapter.mHandler.removeCallbacks(ViewPagerAdapter.mUpdateTimeTask);
		}
	}
	@Override
	protected void onResume()
	{
		
		if(ViewPagerAdapter.mp!=null){
			//ViewPagerAdapter.mp.pause();
		ViewPagerAdapter.mp.release();
		ViewPagerAdapter.mHandler.removeCallbacks(ViewPagerAdapter.mUpdateTimeTask);
		}
		super.onResume();
		
	}

}
