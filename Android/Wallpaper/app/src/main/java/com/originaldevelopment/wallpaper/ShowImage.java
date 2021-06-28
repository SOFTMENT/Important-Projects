package com.originaldevelopment.wallpaper;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.content.FileProvider;

import android.app.WallpaperManager;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapRegionDecoder;
import android.graphics.Point;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.Toast;


import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.CustomTarget;
import com.bumptech.glide.request.target.Target;
import com.bumptech.glide.request.transition.Transition;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.rewarded.RewardItem;
import com.google.android.gms.ads.rewarded.RewardedAd;
import com.google.android.gms.ads.rewarded.RewardedAdCallback;
import com.google.android.gms.ads.rewarded.RewardedAdLoadCallback;

import com.originaldevelopment.wallpaper.API.Api;

import com.yalantis.ucrop.UCrop;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ShowImage extends AppCompatActivity {
    RewardedAd rewardedAd;

    private File myDir;
    LinearLayout premiumUser, setanddownload, setwallpaper;
    RelativeLayout options;
   CardView share;
   CardView downloadnset;
    private String imageName;
    private ProgressBar progressBar;
    private Bitmap bitmapImage;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_show_image);

        rewardedAd = new RewardedAd(this,
                "ca-app-pub-1786205224485658/1296966383");

        RewardedAdLoadCallback adLoadCallback = new RewardedAdLoadCallback() {
            @Override
            public void onRewardedAdLoaded() {
                // Ad successfully loaded.
            }

            @Override
            public void onRewardedAdFailedToLoad(int errorCode) {
                // Ad failed to load.
            }
        };





        CardView homeScreen, lockscreen, both;


        progressBar = findViewById(R.id.progressbar);
       options = findViewById(R.id.options);
        homeScreen = findViewById(R.id.homescreen);
        lockscreen = findViewById(R.id.lockscreen);
        both = findViewById(R.id.both);


        premiumUser = findViewById(R.id.premiumuser);
        setanddownload = findViewById(R.id.shareanddownload);
        setwallpaper = findViewById(R.id.setwallpaper);


        homeScreen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                crop();
            }
        });

        lockscreen.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                lockScreen();
            }
        });

        both.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                lockScreen();
            }
        });


        rewardedAd.loadAd(new AdRequest.Builder().build(), adLoadCallback);

        final ImageView imageView = findViewById(R.id.imageview);
        final CardView unlock = findViewById(R.id.unlock);
        unlock.setEnabled(false);
        unlock.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (rewardedAd.isLoaded()) {

                    RewardedAdCallback adCallback = new RewardedAdCallback() {
                        @Override
                        public void onRewardedAdOpened() {
                            // Ad opened.
                        }

                        @Override
                        public void onRewardedAdClosed() {
                            // Ad closed.
                        }

                        @Override
                        public void onUserEarnedReward(@NonNull RewardItem reward) {
                           premiumUser.setVisibility(View.GONE);
                           setanddownload.setVisibility(View.VISIBLE);
                        }

                        @Override
                        public void onRewardedAdFailedToShow(int errorCode) {
                            // Ad failed to display.
                        }
                    };
                    rewardedAd.show(ShowImage.this, adCallback);
                } else {
                    premiumUser.setVisibility(View.GONE);
                    setanddownload.setVisibility(View.VISIBLE);
                }
            }
        });

        final String url = getIntent().getStringExtra("url");
        final  String originalurl = getIntent().getStringExtra("ourl");

        String[] s = originalurl.split("/");
        imageName = s[s.length-1];


        final  String medium = getIntent().getStringExtra("medium");

        final  String thum = getIntent().getStringExtra("thum");

        RequestOptions requestOptions = new RequestOptions().diskCacheStrategy(DiskCacheStrategy.ALL);
        GlideApp.with(this).asBitmap().load(url).thumbnail(Glide.with(ShowImage.this).asBitmap().load(thum)).apply(requestOptions).listener(new RequestListener<Bitmap>() {
            @Override
            public boolean onLoadFailed(@Nullable GlideException e, Object model, Target<Bitmap> target, boolean isFirstResource) {
               Log.d("RATHOREvijay",e.getMessage());
                progressBar.setVisibility(View.GONE);
                unlock.setEnabled(true);
                return false;
            }

            @Override
            public boolean onResourceReady(Bitmap resource, Object model, Target<Bitmap> target, DataSource dataSource, boolean isFirstResource) {
                Log.d("RATHOREvijay",resource.toString());
                progressBar.setVisibility(View.GONE);
                unlock.setEnabled(true);
                bitmapImage = resource;
                return false;
            }
        }).into(new CustomTarget<Bitmap>() {
            @Override
            public void onResourceReady(@NonNull Bitmap resource, @Nullable Transition<? super Bitmap> transition) {
                Log.d("RATHOREv",resource.toString());
                imageView.setImageBitmap(resource);


            }

            @Override
            public void onLoadCleared(@Nullable Drawable placeholder) {

            }
        });



         share = findViewById(R.id.share);



         downloadnset = findViewById(R.id.downloadandset);
        downloadnset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {


                String root = Environment.getExternalStorageDirectory().toString();
                myDir = new File(root + "/3DWallpaper/"+imageName);

                if (!myDir.exists()) {

                    downloadImage("set");
                }
                else {
                    setanddownload.setVisibility(View.GONE);
                    setwallpaper.setVisibility(View.VISIBLE);
                }



            }
        });

       share.setOnClickListener(new View.OnClickListener() {
           @Override
           public void onClick(View v) {


               String root = Environment.getExternalStorageDirectory().toString();
               myDir = new File(root + "/3DWallpaper/"+imageName);

               if (!myDir.exists()) {
                   downloadImage("share");
               }
               else {
                   options.setVisibility(View.VISIBLE);
                   share.setEnabled(false);
                   downloadnset.setEnabled(false);
               }


           }
       });


       //SHARE OPTIONS
        LinearLayout insta, facebook, messenger, whatsapp,more;
        ImageView back;
        insta = findViewById(R.id.instagram);
        facebook = findViewById(R.id.facebook);
        messenger = findViewById(R.id.messenger);
        whatsapp = findViewById(R.id.whatsapp);
        more = findViewById(R.id.more);
        back = findViewById(R.id.back);

        more.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                shareImage();
            }
        });

        insta.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                shareOnInstagram();
            }
        });

        facebook.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                shareOnFacebook();
            }
        });

        messenger.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                shareOnMessenger();
            }
        });

        whatsapp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                shareOnWhatsApp();
            }
        });

        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                options.setVisibility(View.GONE);
                share.setEnabled(true);
                downloadnset.setEnabled(true);
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

    public void shareImage() {
        Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        try {
            InputStream stream = getContentResolver().openInputStream(uri);
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        sharingIntent.setType("image/jpeg");
        sharingIntent.putExtra(Intent.EXTRA_STREAM, uri);
        startActivity(Intent.createChooser(sharingIntent, "Share image using"));
    }


    public void shareOnWhatsApp() {
        Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
        Intent whatsappIntent = new Intent(Intent.ACTION_SEND);
        whatsappIntent.setType("text/plain");
        whatsappIntent.setPackage("com.whatsapp");
       // whatsappIntent.putExtra(Intent.EXTRA_TEXT, "The text you wanted to share");
        whatsappIntent.putExtra(Intent.EXTRA_STREAM, uri);
        whatsappIntent.setType("image/jpeg");
        whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        try {
          startActivity(whatsappIntent);
        } catch (android.content.ActivityNotFoundException ex) {
          Toast toast = Toast.makeText(ShowImage.this,"Whatsapp have not been installed.",Toast.LENGTH_SHORT);
          toast.setGravity(Gravity.CENTER,0,0);
          toast.show();
        }
    }

    public void shareOnInstagram() {
        Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
        Intent whatsappIntent = new Intent(Intent.ACTION_SEND);
        whatsappIntent.setType("text/plain");
        whatsappIntent.setPackage("com.instagram.android");
        // whatsappIntent.putExtra(Intent.EXTRA_TEXT, "The text you wanted to share");
        whatsappIntent.putExtra(Intent.EXTRA_STREAM, uri);
        whatsappIntent.setType("image/jpeg");
        whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        try {
            startActivity(whatsappIntent);
        } catch (android.content.ActivityNotFoundException ex) {
            Toast toast = Toast.makeText(ShowImage.this,"Instagram have not been installed.",Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER,0,0);
            toast.show();
        }
    }

    public void shareOnMessenger() {
        Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
        Intent whatsappIntent = new Intent(Intent.ACTION_SEND);
        whatsappIntent.setType("text/plain");
        whatsappIntent.setPackage("com.facebook.orca");
        // whatsappIntent.putExtra(Intent.EXTRA_TEXT, "The text you wanted to share");
        whatsappIntent.putExtra(Intent.EXTRA_STREAM, uri);
        whatsappIntent.setType("image/jpeg");
        whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        try {
            startActivity(whatsappIntent);
        } catch (android.content.ActivityNotFoundException ex) {
            Toast toast = Toast.makeText(ShowImage.this,"Messenger have not been installed.",Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER,0,0);
            toast.show();
        }
    }

    public void shareOnFacebook() {
        Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
        Intent whatsappIntent = new Intent(Intent.ACTION_SEND);
        whatsappIntent.setType("text/plain");
        whatsappIntent.setPackage("com.facebook.katana");
        // whatsappIntent.putExtra(Intent.EXTRA_TEXT, "The text you wanted to share");
        whatsappIntent.putExtra(Intent.EXTRA_STREAM, uri);
        whatsappIntent.setType("image/jpeg");
        whatsappIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);

        try {
            startActivity(whatsappIntent);
        } catch (android.content.ActivityNotFoundException ex) {
            Toast toast = Toast.makeText(ShowImage.this,"Facebook have not been installed.",Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER,0,0);
            toast.show();
        }
    }


    public void downloadImage(final String btn) {

                saveToInternalStorage();



                    Toast toast = Toast.makeText(ShowImage.this, "Download Completed!", Toast.LENGTH_SHORT);
                    toast.setGravity(Gravity.TOP, 0, 60);
                    toast.show();

                    if (btn.equals("set")) {
                        setanddownload.setVisibility(View.GONE);
                        setwallpaper.setVisibility(View.VISIBLE);
                    }
                    else {
                        options.setVisibility(View.VISIBLE);
                        share.setEnabled(false);
                        downloadnset.setEnabled(false);
                    }



    }

    private void saveToInternalStorage(){

        String root = Environment.getExternalStorageDirectory().toString();
        myDir = new File(root + "/3DWallpaper");

        if (!myDir.exists()) {
            if(myDir.mkdirs()) {
                Log.d("VIJAY","FOLDER CREATED");
            }
        }

        String name = imageName;
        myDir = new File(myDir, name);

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(myDir);
            // Use the compress method on the BitMap object to write image to the OutputStream
             bitmapImage.compress(Bitmap.CompressFormat.JPEG, 100, fos);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }

    private boolean writeResponseBodyToDisk(ResponseBody body) {
        try {
            // todo change the file location/name according to your needs


            if (!myDir.exists()) {
                if(myDir.mkdirs()) {
                    Log.d("VIJAY","FOLDER CREATED");
                }
            }



            InputStream inputStream = null;
            OutputStream outputStream = null;

            try {
                byte[] fileReader = new byte[4096];


                inputStream = body.byteStream();
                outputStream = new FileOutputStream(myDir);



                while (true) {
                    int read = inputStream.read(fileReader);

                    if (read == -1) {
                        break;
                    }

                    outputStream.write(fileReader, 0, read);


                }


                outputStream.flush();


                return true;
            } catch (IOException e) {
                return false;
            } finally {
                if (inputStream != null) {
                    inputStream.close();
                }

                if (outputStream != null) {
                    outputStream.close();
                }
            }
        } catch (IOException e) {
            return false;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK && requestCode == UCrop.REQUEST_CROP) {


                try {
                    final Uri resultUri = UCrop.getOutput(data);
                    Bitmap bitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), resultUri);

                        homeScreen(bitmap);
                   
                } catch (IOException e) {

                }
            }






    }



    public void homeScreen(Bitmap bitmap) {
        WallpaperManager wallpaperManager = WallpaperManager.getInstance(ShowImage.this);
        try {

            wallpaperManager.setBitmap(bitmap);
            Toast.makeText(this, "Updated Your Home Screen Wallpaper", Toast.LENGTH_SHORT).show();
            this.moveTaskToBack(true);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public void lockScreen() {
        try {
            Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(builder.build());
            Intent intent = new Intent(Intent.ACTION_ATTACH_DATA);
            intent.addCategory(Intent.CATEGORY_DEFAULT);
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);//add this if your targetVersion is more than Android 7.0+
            intent.setDataAndType(uri, "image/jpeg");
            intent.putExtra("mimeType", "image/jpeg");
            this.startActivity(Intent.createChooser(intent, "Set as:"));

        }
        catch (Exception e) {
            Log.d("vijay",e.getMessage());
        }
    }

    public void crop() {
        Display display = getWindowManager().getDefaultDisplay();
        Point point = new Point();
        display.getRealSize(point);

        Uri uri = FileProvider.getUriForFile(ShowImage.this,getApplicationContext().getPackageName() + ".provider",myDir);
        UCrop.of(uri,Uri.fromFile(new File(getCacheDir(), "CROPED_IMAGE")))
                .withAspectRatio(point.x, point.y)
                .start(ShowImage.this);
    }
}
