package in.softment.kidsit;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FacebookAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GoogleAuthProvider;

import org.jetbrains.annotations.NotNull;

import java.util.Arrays;
import java.util.Objects;

import in.softment.kidsit.Utils.ProgressHud;
import in.softment.kidsit.Utils.Services;

public class SignInActivity extends AppCompatActivity {
    private GoogleSignInClient mGoogleSignInClient;
    private CallbackManager mCallbackManager;
    private FirebaseAuth mAuth;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_in);
        Services.fullScreen(this);
        TextInputEditText email = findViewById(R.id.etEmail);
        TextInputEditText password = findViewById(R.id.etPassword);

        mAuth = FirebaseAuth.getInstance();
        mAuth = FirebaseAuth.getInstance();
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestIdToken(getString(R.string.default_web_client_id))
                .requestEmail()
                .build();

        mGoogleSignInClient = GoogleSignIn.getClient(this, gso);
        findViewById(R.id.googleSignIn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                Intent signInIntent = mGoogleSignInClient.getSignInIntent();
                startActivityForResult(signInIntent, 909);

            }
        });


        mCallbackManager = CallbackManager.Factory.create();

        LoginManager.getInstance().registerCallback(mCallbackManager,
                new FacebookCallback<LoginResult>()
                {
                    @Override
                    public void onSuccess(LoginResult loginResult)
                    {
                        AuthCredential credential = FacebookAuthProvider.getCredential(loginResult.getAccessToken().getToken());
                        firebaseAuth(credential);

                    }

                    @Override
                    public void onCancel()
                    {

                        // App code
                    }

                    @Override
                    public void onError(FacebookException exception)
                    {

                        Services.showDialog(SignInActivity.this,"ERROR",exception.getLocalizedMessage());
                    }


                });

        findViewById(R.id.facebookSignIn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LoginManager.getInstance().logInWithReadPermissions(SignInActivity.this, Arrays.asList( "email", "public_profile"));
            }
        });
        findViewById(R.id.signInCard).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sEmail = email.getText().toString().trim();
                String sPassword = password.getText().toString().trim();

                if (sEmail.isEmpty()) {
                    Services.showCenterToast(SignInActivity.this,"Entrer l'adresse e-mail");
                }
                else if (sPassword.isEmpty()) {
                    Services.showCenterToast(SignInActivity.this,"Entrer le mot de passe");
                }
                else {
                    ProgressHud.show(SignInActivity.this,"");
                    FirebaseAuth.getInstance().signInWithEmailAndPassword(sEmail,sPassword).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull @NotNull Task<AuthResult> task) {
                            ProgressHud.dialog.dismiss();
                            if (task.isSuccessful()) {
                                FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
                                if (firebaseUser != null) {
                                    Services.getCurrentUserData(SignInActivity.this,firebaseUser.getUid(),true);
                                }
                            }
                            else{
                                Services.handleFirebaseERROR(SignInActivity.this, ((FirebaseAuthException) Objects.requireNonNull(task.getException())).getErrorCode());
                            }
                        }
                    });

                }
            }
        });

        //ResetPassword
        findViewById(R.id.resetPassword).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sEmail = email.getText().toString().trim();
                if (sEmail.isEmpty()) {
                    Services.showCenterToast(SignInActivity.this,"Entrer l'adresse e-mail");
                }
                else {
                    ProgressHud.show(SignInActivity.this,"");
                    FirebaseAuth.getInstance().sendPasswordResetEmail(sEmail).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull @NotNull Task<Void> task) {
                            ProgressHud.dialog.dismiss();
                            if (task.isSuccessful()) {
                                email.setText("");
                                Services.showDialog(SignInActivity.this,"RÉINITIALISER LE MOT DE PASSE","Nous avons envoyé un lien de réinitialisation de mot de passe sur votre adresse e-mail");
                            }
                            else {
                                Services.handleFirebaseERROR(SignInActivity.this, ((FirebaseAuthException) Objects.requireNonNull(task.getException())).getErrorCode());
                            }
                        }
                    });
                }
            }
        });

        //SignUpBtnTapped
        findViewById(R.id.signUp).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(SignInActivity.this, SignUpActivity.class));
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        // Result returned from launching the Intent from GoogleSignInApi.getSignInIntent(...);
        if (requestCode == 909) {
            Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
            try {
                // Google Sign In was successful, authenticate with Firebase
                GoogleSignInAccount account = task.getResult(ApiException.class);
                AuthCredential credential = GoogleAuthProvider.getCredential(account.getIdToken(), null);
                firebaseAuth(credential);
            } catch (ApiException e) {
                // Google Sign In failed, update UI appropriately
                Services.showDialog(SignInActivity.this,getString(R.string.error),getString(R.string.something_went_wrong));
            }
        }
        else {
            mCallbackManager.onActivityResult(requestCode, resultCode, data);
        }

    }

    private void firebaseAuth(AuthCredential credential) {

        ProgressHud.show(this,"");
        mAuth.signInWithCredential(credential)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        ProgressHud.dialog.dismiss();
                        if (task.isSuccessful()) {
                            // Sign in success, update UI with the signed-in user's information
                            if (mAuth.getCurrentUser() != null){
                                Services.getCurrentUserData(SignInActivity.this,mAuth.getCurrentUser().getUid(),true);
                            }

                        } else {
                            // If sign in fails, display a message to the user.
                            Services.showDialog(SignInActivity.this,getString(R.string.error), getString(R.string.something_went_wrong));
                        }
                    }
                });
    }
}