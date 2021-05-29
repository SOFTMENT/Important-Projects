package com.originaldevelopment.rapidcollect;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.biometric.BiometricManager;
import androidx.biometric.BiometricPrompt;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import android.Manifest;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import java.util.concurrent.Executor;

public class LoginActivity extends AppCompatActivity {

    private EditText email, password;
    private Button login;
    private TextView forget, signup;
    private FirebaseAuth firebaseAuth;
    private ProgressHud progressHud;
    private static final int STORAGE_PERMISSION_CODE = 4655;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        NewCode.assistActivity(this);
        onWindowFocusChanged(true);
        firebaseAuth = FirebaseAuth.getInstance();




        if (firebaseAuth.getCurrentUser() != null ) {
            if (firebaseAuth.getCurrentUser().isEmailVerified()) {


                androidx.biometric.BiometricManager biometricManager = androidx.biometric.BiometricManager.from(this);
                if ( biometricManager.canAuthenticate() == BiometricManager.BIOMETRIC_SUCCESS){
                    Executor executor = ContextCompat.getMainExecutor(this);
                    BiometricPrompt biometricPrompt = new BiometricPrompt(this, executor, new BiometricPrompt.AuthenticationCallback() {
                        @Override
                        public void onAuthenticationSucceeded(@NonNull BiometricPrompt.AuthenticationResult result) {
                            Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                            startActivity(intent);
                            finish();
                        }
                    });

                    BiometricPrompt.PromptInfo promptInfo =  new  BiometricPrompt.PromptInfo.Builder().setTitle("VERIFY IDENTITY").setDeviceCredentialAllowed(true).build();
                    biometricPrompt.authenticate(promptInfo);

                }
                else{
                    Intent intent = new Intent(this, MainActivity.class);
                    startActivity(intent);
                    finish();
                }


            }

        }


        requestStoragePermission();
        email = findViewById(R.id.email);
        password = findViewById(R.id.password);
        login = findViewById(R.id.login);
        forget = findViewById(R.id.forget);
        signup = findViewById(R.id.signup);



        forget.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sEmail = email.getText().toString().trim();
                if (!sEmail.isEmpty()) {
                    ProgressHud.show(LoginActivity.this,"Wait...");
                    FirebaseAuth.getInstance().sendPasswordResetEmail(sEmail).addOnSuccessListener(new OnSuccessListener<Void>() {
                        @Override
                        public void onSuccess(Void aVoid) {
                            ProgressHud.dialog.dismiss();
                            Toast toast = Toast.makeText(LoginActivity.this, "Password Reset Link Has Been Sent On Your Email Address.", Toast.LENGTH_LONG);
                            toast.setGravity(Gravity.CENTER, 0, 0);
                            toast.show();

                        }
                    });
                }
                else {
                    email.setError("Empty");
                    email.requestFocus();
                }

            }
        });

        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sEmail = email.getText().toString().trim();
                String sPassword = password.getText().toString().trim();

                if (!sEmail.isEmpty()) {
                    if (!sPassword.isEmpty()) {
                        ProgressHud.show(LoginActivity.this,"Sign In...");
                        firebaseAuth.signInWithEmailAndPassword(sEmail,sPassword).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                            @Override
                            public void onComplete(@NonNull Task<AuthResult> task) {
                                if (task.isSuccessful()) {
                                   ProgressHud.dialog.dismiss();
                                    if (firebaseAuth.getCurrentUser().isEmailVerified()) {
                                        Intent intent = new Intent(LoginActivity.this, MainActivity.class);
                                        startActivity(intent);
                                        finish();
                                    }
                                    else {
                                        resentEmail();

                                    }
                                }
                                else {
                                    ProgressHud.dialog.dismiss();
                                    Toast toast = Toast.makeText(LoginActivity.this, task.getException().getMessage(), Toast.LENGTH_LONG);
                                    toast.setGravity(Gravity.CENTER, 0, 0);
                                    toast.show();
                                }
                            }
                        });
                    }
                    else {
                        password.requestFocus();
                        password.setError("Empty");
                    }
                }
                else{
                    email.requestFocus();
                    email.setError("Empty");
                }

            }
        });

        signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(LoginActivity.this, RegistrationActivity.class));
            }
        });
    }

    private void resentEmail() {
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Rapid Collect");
        builder.setMessage("You have not confirmed your email address yet. Please confirm before login.");
        builder.setCancelable(false);
        builder.setPositiveButton("Resend", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

                ProgressHud.show(LoginActivity.this,"Sending Confirmation Mail...");
                firebaseAuth.getCurrentUser().sendEmailVerification().addOnCompleteListener(new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                       ProgressHud.dialog.dismiss();
                        if (task.isSuccessful()) {
                            Toast toast = Toast.makeText(LoginActivity.this, "Done! Check Your Email Address.", Toast.LENGTH_SHORT);
                            toast.setGravity(Gravity.CENTER, 0, 0);
                            toast.show();
                        }
                    }
                });

            }
        });
        builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

            }
        });
        builder.show();
    }


    private void requestStoragePermission() {

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)
            return;

        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE)) {
            //If the user has denied the permission previously your code will come to this block
            //Here you can explain why you need this permission
            //Explain here why you need this permission
        }
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, STORAGE_PERMISSION_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == STORAGE_PERMISSION_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {


            } else {
                Toast.makeText(this, "Oops you just denied the permission", Toast.LENGTH_LONG).show();
            }
        }
    }

}
