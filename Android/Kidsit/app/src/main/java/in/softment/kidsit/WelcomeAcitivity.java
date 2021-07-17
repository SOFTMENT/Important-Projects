package in.softment.kidsit;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.UserInfo;

import java.util.Locale;

import in.softment.kidsit.Utils.Services;

public class WelcomeAcitivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_welcome_acitivity);
        Services.fullScreen(this);

        Locale locale = new Locale("es");
        Locale.setDefault(locale);
        Configuration config = new Configuration();
        config.locale = locale;
        getBaseContext().getResources().updateConfiguration(config, getBaseContext().getResources().getDisplayMetrics());
    }

    @Override
    protected void onStart() {
        super.onStart();
        FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();



        if ( firebaseUser != null) {
            for (UserInfo user: FirebaseAuth.getInstance().getCurrentUser().getProviderData()) {
                if (user.getProviderId().equals("facebook.com") || user.getProviderId().equals("google.com")) {
                    Services.getCurrentUserData(WelcomeAcitivity.this, firebaseUser.getUid(),false);
                    return;
                }
            }

            if (FirebaseAuth.getInstance().getCurrentUser().isEmailVerified()) {
                    Services.getCurrentUserData(WelcomeAcitivity.this, firebaseUser.getUid(),false);
            }
            else {
                gotoSignInPage();
            }

        }
        else {
            gotoSignInPage();
        }
    }

    public void gotoSignInPage(){
        Intent intent = new Intent(WelcomeAcitivity.this, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK| Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
        finish();
    }

}