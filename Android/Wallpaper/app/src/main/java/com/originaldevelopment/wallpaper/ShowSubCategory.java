package com.originaldevelopment.wallpaper;

import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;


import com.google.android.material.tabs.TabLayout;

import java.util.ArrayList;
import java.util.List;

public class ShowSubCategory extends AppCompatActivity {

    private  List<Subcategory>  subcategories;
    private CustomTabLayout tabLayout;
    private LinearLayout header;
    private int index2 = 0, index = 0, oldposi = 0;
    private Integer[] grad_temp = null;
    private TextView countimage;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_show_sub_category);

        header = findViewById(R.id.header);
        tabLayout = findViewById(R.id.tablayout);

        final Integer[] grad_temp = {
                R.drawable.onegg,
                R.drawable.fourgg,
                R.drawable.eightgg,
                R.drawable.twogg,
                R.drawable.sixgg,
                R.drawable.threegg,
                R.drawable.fivegg,
                R.drawable.sevengg
        };


        subcategories = (List<Subcategory>) getIntent().getExtras().getSerializable("list");

        for (int i =0 ; i<subcategories.size();i++) {
            tabLayout.addTab(tabLayout.newTab().setText(subcategories.get(i).getSname()));
        }



        countimage = findViewById(R.id.countimage);


        ViewPager viewPager2 = findViewById(R.id.showviewpager);

        Adapter2 adapter2 = new Adapter2(subcategories,this);
        viewPager2.setOffscreenPageLimit(2);
        viewPager2.setAdapter(adapter2);

        tabLayout.addOnTabSelectedListener(new TabLayout.ViewPagerOnTabSelectedListener(viewPager2));
        viewPager2.addOnPageChangeListener(new TabLayout.TabLayoutOnPageChangeListener(tabLayout));

        viewPager2.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                index2 = position;
                if (position > 6) {
                    position = position%7;
                }
                index = position;

                if (positionOffset > 0) {
                    if (position == oldposi) {

                        index += 1;

                    }

                }
                else if (positionOffset == 0){
                    oldposi = position;
                }


                countimage.setText(subcategories.get(index2).getUrl().size()+" wallpapers");

                header.setBackground(getDrawable(grad_temp[index]));
            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

    }


    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            getWindow().getDecorView().setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        }
    }



}
