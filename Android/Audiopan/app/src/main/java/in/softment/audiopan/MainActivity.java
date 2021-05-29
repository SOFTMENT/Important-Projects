package in.softment.audiopan;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.media.AudioManager;
import android.media.MediaMetadataRetriever;
import android.media.MediaPlayer;
import android.media.audiofx.AudioEffect;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.airbnb.lottie.LottieAnimationView;
import com.bullhead.equalizer.DialogEqualizerFragment;

import java.io.File;

import in.softment.audiopan.Widget.VerticalSeekBar;

import static android.Manifest.permission.READ_EXTERNAL_STORAGE;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static android.os.Build.VERSION.SDK_INT;

public class MainActivity extends AppCompatActivity {

    private LottieAnimationView lottieAnimationView1, lottieAnimationView2;
    private MediaPlayer mediaPlayer1 = null, mediaPlayer2 = null;
    private boolean isAudio1IsPlaying = false, isAudio2IsPlaying = false;
    private SeekBar seekBar1,seekBar2;
    private VerticalSeekBar verticalSeekBar1, verticalSeekBar2;
    private int totalMilisecond = 0;
    private TextView startTime1, endTime1, startTime2, endTime2;
    private TextView title1, title2;

    private LinearLayout mainLL;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

    if (!checkPermissionForReadExtertalStorage()) {
        try {
            requestPermissionForReadExtertalStorage();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

        mainLL = findViewById(R.id.mainLL);
        findViewById(R.id.importbutton).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent_upload = new Intent();
                intent_upload.setType("audio/*");
                intent_upload.setAction(Intent.ACTION_GET_CONTENT);
                startActivityForResult(intent_upload,1);
            }
        });

        findViewById(R.id.equalizer1).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mediaPlayer1 != null) {
                    Intent intent = new Intent( );
                    intent.setAction("android.media.action.DISPLAY_AUDIO_EFFECT_CONTROL_PANEL");
                    if (intent.resolveActivity( getPackageManager()) != null )
                    {
                        intent.putExtra(AudioEffect.EXTRA_PACKAGE_NAME, getPackageName());
                        intent.putExtra(AudioEffect.EXTRA_AUDIO_SESSION, mediaPlayer1.getAudioSessionId());
                        intent.putExtra(AudioEffect.EXTRA_CONTENT_TYPE, AudioEffect.CONTENT_TYPE_MUSIC);
                        startActivityForResult( intent , 0 );
                    }
                    else
                    {

                    }
                }
                else {
                    Toast.makeText(MainActivity.this, "Please Import Audio", Toast.LENGTH_SHORT).show();
                }

            }
        });

        findViewById(R.id.equalizer2).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mediaPlayer2 != null) {
                    Intent intent = new Intent();
                    intent.setAction("android.media.action.DISPLAY_AUDIO_EFFECT_CONTROL_PANEL");
                    if (intent.resolveActivity(getPackageManager()) != null) {
                        intent.putExtra(AudioEffect.EXTRA_PACKAGE_NAME, getPackageName());
                        intent.putExtra(AudioEffect.EXTRA_AUDIO_SESSION, mediaPlayer2.getAudioSessionId());
                        intent.putExtra(AudioEffect.EXTRA_CONTENT_TYPE, AudioEffect.CONTENT_TYPE_MUSIC);
                        startActivityForResult(intent, 0);
                    } else {

                    }

                }
            }
        });


        title1  = findViewById(R.id.title1);
        //FOR 1st MEDIAPLAYER
        lottieAnimationView1 = findViewById(R.id.animation_view1);
        ImageView playPause1 = findViewById(R.id.playpause1);

        seekBar1 = findViewById(R.id.seekbar1);
        seekBar1.setProgress(0);

        verticalSeekBar1 = findViewById(R.id.volume1seek);
        verticalSeekBar1.setProgress(50);
        verticalSeekBar1.setMax(100);

        startTime1 = findViewById(R.id.startTime1);
        endTime1 = findViewById(R.id.endTime1);

        verticalSeekBar1.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {


                    if (mediaPlayer1 != null) {
                        mediaPlayer1.setVolume(i/100.0f, i/100.0f);
                    }

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        seekBar1.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if(mediaPlayer1 != null && fromUser){
                    mediaPlayer1.seekTo(progress * 1000);
                    int seconds = (int) (progress/ 1000) % 60 ;
                    int minutes = (int) ((progress / (1000*60)) % 60);

                    startTime1.setText(String.format("%02d", minutes)+":"+String.format("%02d", seconds));
                }
            }
        });
        Handler mHandler1 = new Handler();

        MainActivity.this.runOnUiThread(new Runnable() {

            @Override
            public void run() {
                if(mediaPlayer1 != null){
                    if (mediaPlayer1.getCurrentPosition() >= totalMilisecond - 1000) {
                        mediaPlayer1.pause();
                        playPause1.setImageResource(R.drawable.play);
                        startTime1.setText("00:00");
                        seekBar1.setProgress(0);
                        lottieAnimationView1.pauseAnimation();

                    }
                    else {
                        int mCurrentPosition = mediaPlayer1.getCurrentPosition() / 1000;
                        seekBar1.setProgress(mCurrentPosition);
                        int seconds = (int) (mCurrentPosition ) % 60 ;
                        int minutes = (int) ((mCurrentPosition / 60) % 60);

                        startTime1.setText(String.format("%02d", minutes)+":"+String.format("%02d", seconds));
                    }


                }
                mHandler1.postDelayed(this, 1000);
            }
        });



        playPause1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (isAudio1IsPlaying) {
                    if (mediaPlayer1 != null) {
                        lottieAnimationView1.pauseAnimation();
                        mediaPlayer1.pause();
                        isAudio1IsPlaying  = false;
                        playPause1.setImageResource(R.drawable.play);

                    }
                }
                else {
                    if (mediaPlayer1 != null) {
                        lottieAnimationView1.playAnimation();
                        mediaPlayer1.start();
                        isAudio1IsPlaying = true;
                        playPause1.setImageResource(R.drawable.pause);
                    }
                }
            }
        });

        //For 2nd Mediaplayer

        title2  = findViewById(R.id.title2);

        lottieAnimationView2 = findViewById(R.id.animation_view2);
        ImageView playPause2 = findViewById(R.id.playpause2);

        seekBar2 = findViewById(R.id.seekbar2);
        seekBar2.setProgress(0);

        verticalSeekBar2 = findViewById(R.id.volume2seek);
        verticalSeekBar2.setProgress(50);
        verticalSeekBar2.setMax(100);

        startTime2 = findViewById(R.id.startTime2);
        endTime2 = findViewById(R.id.endTime2);

        verticalSeekBar2.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int i, boolean b) {


                if (mediaPlayer2 != null) {
                    mediaPlayer2.setVolume(i/100.0f, i/100.0f);
                }

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }
        });

        seekBar2.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {

            }

            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if(mediaPlayer2 != null && fromUser){
                    mediaPlayer2.seekTo(progress * 1000);
                    int seconds = (int) (progress/ 1000) % 60 ;
                    int minutes = (int) ((progress / (1000*60)) % 60);

                    startTime1.setText(String.format("%02d", minutes)+":"+String.format("%02d", seconds));
                }
            }
        });
        Handler mHandler2 = new Handler();

        MainActivity.this.runOnUiThread(new Runnable() {

            @Override
            public void run() {
                if(mediaPlayer2 != null){
                    if (mediaPlayer2.getCurrentPosition() >= totalMilisecond - 1000) {
                        mediaPlayer2.pause();
                        playPause2.setImageResource(R.drawable.play);
                        startTime2.setText("00:00");
                        seekBar2.setProgress(0);
                        lottieAnimationView1.pauseAnimation();

                    }
                    else {
                        int mCurrentPosition = mediaPlayer2.getCurrentPosition() / 1000;
                        seekBar2.setProgress(mCurrentPosition);
                        int seconds = (int) (mCurrentPosition ) % 60 ;
                        int minutes = (int) ((mCurrentPosition / 60) % 60);

                        startTime2.setText(String.format("%02d", minutes)+":"+String.format("%02d", seconds));
                    }


                }
                mHandler2.postDelayed(this, 1000);
            }
        });



        playPause2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (isAudio2IsPlaying) {
                    if (mediaPlayer2 != null) {
                        lottieAnimationView2.pauseAnimation();
                        mediaPlayer2.pause();
                        isAudio2IsPlaying  = false;
                        playPause2.setImageResource(R.drawable.play);

                    }
                }
                else {
                    if (mediaPlayer2 != null) {
                        lottieAnimationView2.playAnimation();
                        mediaPlayer2.start();
                        isAudio2IsPlaying = true;
                        playPause2.setImageResource(R.drawable.pause);
                    }
                }
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode,int resultCode,Intent data){

        if(requestCode == 1){

            if(resultCode == RESULT_OK){

                //the selected audio.
                Uri uri = data.getData();
                mainLL.setVisibility(View.VISIBLE);
                audioPlayer1(uri);
                audioPlayer2(uri);

            }

        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    public void requestPermissionForReadExtertalStorage() throws Exception {
        try {
            ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.READ_EXTERNAL_STORAGE},
                    1);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public boolean checkPermissionForReadExtertalStorage() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            int result = checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE);
            return result == PackageManager.PERMISSION_GRANTED;
        }
        return false;
    }

    public void audioPlayer1(Uri myUri){
        //set up MediaPlayer

        try {
            mediaPlayer1 = new MediaPlayer();
            mediaPlayer1.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mediaPlayer1.setDataSource(getApplicationContext(), myUri);
            mediaPlayer1.prepare();
            mediaPlayer1.setVolume(0.5f,0.5f);
            MediaMetadataRetriever mmr = new MediaMetadataRetriever();
            mmr.setDataSource(this,myUri);
            String t = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE);
            title1.setText(t+" - 1");
            String durationStr = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            totalMilisecond = Integer.parseInt(durationStr);

            seekBar1.setMax(totalMilisecond/1000);


            int seconds = (int) (totalMilisecond / 1000) % 60 ;
            int minutes = (int) ((totalMilisecond / (1000*60)) % 60);

            endTime1.setText(String.format("%02d", minutes)+":"+String.format("%02d", seconds));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void audioPlayer2(Uri myUri){
        //set up MediaPlayer

        try {
            mediaPlayer2 = new MediaPlayer();
            mediaPlayer2.setAudioStreamType(AudioManager.STREAM_MUSIC);
            mediaPlayer2.setDataSource(getApplicationContext(), myUri);
            mediaPlayer2.prepare();
            mediaPlayer2.setVolume(0.5f,0.5f);
            MediaMetadataRetriever mmr = new MediaMetadataRetriever();
            mmr.setDataSource(this,myUri);
            String t = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE);
            title2.setText(t+" - 2");
            String durationStr = mmr.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            totalMilisecond = Integer.parseInt(durationStr);

            seekBar2.setMax(totalMilisecond/1000);

            int seconds = (int) (totalMilisecond / 1000) % 60 ;
            int minutes = (int) ((totalMilisecond / (1000*60)) % 60);

            endTime2.setText(String.format("%02d", minutes)+":"+String.format("%02d", seconds));

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}