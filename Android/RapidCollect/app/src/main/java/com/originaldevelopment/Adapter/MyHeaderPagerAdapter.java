package com.originaldevelopment.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.viewpager.widget.PagerAdapter;

import com.originaldevelopment.rapidcollect.R;

public class MyHeaderPagerAdapter extends PagerAdapter {

    private Context context;
    private int[] images;
    private LayoutInflater layoutInflater;
    private int custom_posi = 0;
    public  MyHeaderPagerAdapter(Context context, int[] images) {
        this.images = images;
        this.context = context;
        layoutInflater = (LayoutInflater)context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

    }
    @Override
    public int getCount() {
        return 500;
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view == object;
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, int position) {

        if (custom_posi > 4) {
            custom_posi = 0;
        }
        View itemview = layoutInflater.inflate(R.layout.headerrow,container, false);
        ImageView imageView = itemview.findViewById(R.id.imageview);
        imageView.setImageResource(images[custom_posi]);
        custom_posi++;
        container.addView(itemview);
        return itemview;

    }

    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
        container.removeView((ImageView)object);
    }


}
