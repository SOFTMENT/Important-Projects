package in.softment.straightline;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Toast;

import com.airbnb.lottie.LottieAnimationView;
import com.google.firebase.auth.FirebaseAuth;

import in.softment.straightline.Utils.Services;

public class WelcomeScreen extends AppCompatActivity {

    LottieAnimationView lottieAnimationView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
        setContentView(R.layout.activity_welcome_screen);
        Services.fullScreen(this);
        lottieAnimationView = findViewById(R.id.animation);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                if (FirebaseAuth.getInstance().getCurrentUser() != null) {
                    if (FirebaseAuth.getInstance().getCurrentUser().isEmailVerified()) {

                        Services.getCurrentUserData(WelcomeScreen.this,FirebaseAuth.getInstance().getCurrentUser().getUid(),false);
                    }
                    else{
                        Intent intent = new Intent(WelcomeScreen.this,RegistrationActivity.class);
                        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                        startActivity(intent);
                    }

                }
                else {
                    Intent intent = new Intent(WelcomeScreen.this,RegistrationActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                    startActivity(intent);
                }
            }
        },2000);
    }
}