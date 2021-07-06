package in.softment.straightline;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Toast;

import com.canhub.cropper.CropImage;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.makeramen.roundedimageview.RoundedImageView;

import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.util.Objects;

import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

public class RegistrationActivity extends AppCompatActivity {
    private FirebaseAuth mAuth;
    private EditText emailAddress, name, password;
    private CheckBox checkBox;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registration);
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);
        Services.fullScreen(this);

        mAuth = FirebaseAuth.getInstance();


        emailAddress = findViewById(R.id.email);
        name = findViewById(R.id.name);
        password = findViewById(R.id.password);
        checkBox = findViewById(R.id.checkbox);

        findViewById(R.id.signIn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(RegistrationActivity.this, SignInActivity.class));
            }
        });

        //Create Account
        findViewById(R.id.createAccount).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String mEmail = emailAddress.getText().toString().trim();
                String mName = name.getText().toString().trim();
                String mPassword = password.getText().toString().trim();
                boolean isChecked = checkBox.isChecked();
                if (mEmail.isEmpty())  {
                    Services.showCenterToast(RegistrationActivity.this,ToastType.WARNING,"Enter Email Address");
                }
                else if (mName.isEmpty()) {
                    Services.showCenterToast(RegistrationActivity.this,ToastType.WARNING,"Enter Name");
                }
                else if (mPassword.isEmpty()) {
                    Services.showCenterToast(RegistrationActivity.this,ToastType.WARNING,"Enter Password");
                }
                else if (!isChecked) {
                    Services.showCenterToast(RegistrationActivity.this,ToastType.WARNING,"Accept Terms & Conditions");
                }
                else {
                    createAccount(RegistrationActivity.this,mName,mEmail,mPassword);
                }
            }
        });



    }



    public void createAccount(Context context, String mName,String mEmail, String mPassword) {
        ProgressHud.show(RegistrationActivity.this, "Creating Account...");
        FirebaseAuth.getInstance().createUserWithEmailAndPassword(mEmail, mPassword).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
            @Override
            public void onComplete(@NonNull @NotNull Task<AuthResult> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    emailAddress.setText("");
                    name.setText("");
                    password.setText("");
                    password.clearFocus();
                    if (Services.isUserLoggedIn()) {
                        Services.addCurrentUserData(context,FirebaseAuth.getInstance().getCurrentUser().getUid(),mName,mEmail);
                    }
                }
                else {
                    Services.showDialog(RegistrationActivity.this,"ERROR",task.getException().getLocalizedMessage());
                }

            }
        });

    }


}