package com.originaldevelopment.wallpaper;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.transition.TransitionManager;
import androidx.viewpager.widget.ViewPager;

import android.Manifest;
import android.animation.ArgbEvaluator;
import android.animation.LayoutTransition;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Bundle;
import android.os.SystemClock;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;


import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;
import com.google.gson.Gson;
import com.originaldevelopment.wallpaper.API.Api;
import com.originaldevelopment.wallpaper.Custom.TransTextView;

import com.originaldevelopment.wallpaper.Model.Model;


import org.w3c.dom.Text;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.TimeUnit;


import okhttp3.Cache;
import okhttp3.CacheControl;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;

import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import okhttp3.ResponseBody;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

import static java.security.AccessController.getContext;

public class MainActivity extends AppCompatActivity {

    KKViewPager viewPager;
    Adapter adapter;

    Integer[] grad = null;
    int index = 0;
    int index2 = 0;
    int oldposi = 0;
    private TextView category;
    private List<AllWallpaper> wallpaperApis = new ArrayList<>();
    Animation animation;
    private ImageView splash;
    private int[] staticimages;
    private int[] svgimages;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);


        MobileAds.initialize(this, new OnInitializationCompleteListener() {
            @Override
            public void onInitializationComplete(InitializationStatus initializationStatus) {
            }
        });
        setContentView(R.layout.activity_main);
        splash = findViewById(R.id.splash);

        staticimages = new int[]{R.drawable.one,R.drawable.two,
        R.drawable.three,R.drawable.four,R.drawable.five,R.drawable.six,R.drawable.seven,R.drawable.eight
        };

        svgimages = new int[]{R.drawable.sone,R.drawable.stwo,R.drawable.sthree,R.drawable.sfour,R.drawable.sfive,
                R.drawable.ssix,
        R.drawable.sseven,R.drawable.seight
        };


        getDetails();



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

    public void getDetails() {



        Api api = getCacheEnabledRetrofit(this).create(Api.class);

        Call<List<AllWallpaper>> call = api.getData();
        call.enqueue(new Callback<List<AllWallpaper>>() {
            @Override
            public void onResponse(Call<List<AllWallpaper>> call, retrofit2.Response<List<AllWallpaper>> response) {

                splash.setVisibility(View.GONE);
                   wallpaperApis.addAll(response.body());
                   updateUI();
            }

            @Override
            public void onFailure(Call<List<AllWallpaper>> call, Throwable t) {
                Log.d("vijay",t.getLocalizedMessage());
            }
        });


    }


    public static Boolean hasNetwork(Context context) {
        Boolean isConnected = false; // Initial Value
        ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetwork = connectivityManager.getActiveNetworkInfo();
        if (activeNetwork != null && activeNetwork.isConnectedOrConnecting())
           return  true;
        else {

            return false;
        }

    }

    public static Retrofit getCacheEnabledRetrofit(final Context context) {
        OkHttpClient okHttpClient = new OkHttpClient.Builder()
                .cache(new Cache(context.getCacheDir(), 5 * 1024 * 1024))
                .addInterceptor(new Interceptor() {
                    @Override
                    public okhttp3.Response intercept(Chain chain) throws IOException {
                        Request request = chain.request();
                        if(hasNetwork(context))
                            request = request.newBuilder().header("Cache-Control", "public, max-age=" + 60).build();
                        else {
                            request = request.newBuilder().header("Cache-Control", "public, only-if-cached, max-stale=" + 60 * 60 * 24 * 7).build();
                        }
                        return chain.proceed(request);
                    }
                })
                .build();

        Retrofit retrofit = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create())
                .client(okHttpClient)
                .baseUrl(Api.BASE_URL)
                .build();

        return retrofit;
    }



    public void updateUI() {


        if (checkSelfPermission(android.Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},10);
        }

        adapter = new Adapter(wallpaperApis, this,staticimages, svgimages);

        viewPager = findViewById(R.id.viewPager);
        viewPager.setAdapter(adapter);
        viewPager.setPadding(10, 0, 130, 0);
        viewPager.setOffscreenPageLimit(wallpaperApis.size()-1);
        viewPager.setAnimationEnabled(true);
        category = findViewById(R.id.categoryname);




        final Integer[] grad_temp = {
                R.drawable.oneg,
                R.drawable.twog,
                R.drawable.threeg,
                R.drawable.fourg,
                R.drawable.fiveg,
                R.drawable.sixg,
                R.drawable.seveng,
                R.drawable.eightg
        };



        grad = grad_temp;

        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
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




                viewPager.setBackground(getDrawable(grad[index]));

                animation = AnimationUtils.loadAnimation(MainActivity.this,R.anim.anim);
                category.setText(wallpaperApis.get(index2).getCname().toUpperCase());
                category.startAnimation(animation);



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
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if(grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){

        }

    }

}
