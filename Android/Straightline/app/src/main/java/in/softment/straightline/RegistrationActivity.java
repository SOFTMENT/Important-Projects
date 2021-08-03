package in.softment.straightline;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

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
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.canhub.cropper.CropImage;
import com.canhub.cropper.CropImageView;
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
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthCredential;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FacebookAuthProvider;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.auth.GoogleAuthProvider;
import com.makeramen.roundedimageview.RoundedImageView;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Objects;

import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

public class RegistrationActivity extends AppCompatActivity {
    private FirebaseAuth mAuth;
    private EditText emailAddress, name, password;
    private CheckBox checkBox;
    private GoogleSignInClient mGoogleSignInClient;
    private final int RC_SIGN_IN = 1022;
    private RoundedImageView profileImage = null;
    private  String currentPhotoPath;
    private AlertDialog alertDialog;
    private static final int CAMERA_PERMISSION_CODE = 123;
    private static final int STORAGE_PERMISSION_CODE = 4655;
    private boolean isImageSelected = false;
    private Uri resultUri = null;

    private CallbackManager mCallbackManager;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registration);

        Services.fullScreen(this);

        mAuth = FirebaseAuth.getInstance();

        requestStoragePermission();

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

        findViewById(R.id.googleSignIn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent signInIntent = mGoogleSignInClient.getSignInIntent();
                startActivityForResult(signInIntent, RC_SIGN_IN);
            }
        });


        //FACEBOOK LOGIN
        mCallbackManager = CallbackManager.Factory.create();

        LoginManager.getInstance().registerCallback(mCallbackManager,
                new FacebookCallback<LoginResult>()
                {
                    @Override
                    public void onSuccess(LoginResult loginResult)
                    {
                        AuthCredential credential = FacebookAuthProvider.getCredential(loginResult.getAccessToken().getToken());
                        Services.firebaseAuthWithGoogle(RegistrationActivity.this,credential);

                    }

                    @Override
                    public void onCancel()
                    {


                        // App code
                    }

                    @Override
                    public void onError(FacebookException exception)
                    {

                        Services.showDialog(RegistrationActivity.this,"ERROR",exception.getLocalizedMessage());
                    }


                });


        findViewById(R.id.facebookSignIn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LoginManager.getInstance().logInWithReadPermissions(RegistrationActivity.this, Arrays.asList( "email", "public_profile"));
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



        // Configure Google Sign In
        GoogleSignInOptions gso = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
                .requestIdToken(getString(R.string.default_web_client_id))
                .requestEmail()
                .build();

        mGoogleSignInClient = GoogleSignIn.getClient(this, gso);
    }

    private void callCamera() {
        alertDialog.dismiss();
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Ensure that there's a camera activity to handle the intent
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                photoFile = createImageFile();

            } catch (IOException ex) {
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {

                Uri photoURI = FileProvider.getUriForFile(RegistrationActivity.this,
                        "in.softment.straightline.android.fileprovider",
                        photoFile);
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);

                cameraResultLauncher.launch(takePictureIntent);

            }
            else{
                Toast.makeText(this, "Null", Toast.LENGTH_SHORT).show();
            }
        }
        else {
            Toast.makeText(this, "Ok", Toast.LENGTH_SHORT).show();
        }
    }
    private File createImageFile() throws IOException {
        // Create an image file name
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String imageFileName = "JPEG_" + timeStamp + "_";
//        File storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES);
        File storageDir = getFilesDir();
        File image = File.createTempFile(
                imageFileName,  /* prefix */
                ".jpg",         /* suffix */
                storageDir      /* directory */
        );

        // Save a file: path for use with ACTION_VIEW intents
        currentPhotoPath = image.getAbsolutePath();
        Log.d("HELLO",currentPhotoPath);
        return image;
    }

    ActivityResultLauncher<Intent> cameraResultLauncher = registerForActivityResult(
            new ActivityResultContracts.StartActivityForResult(),
            new ActivityResultCallback<ActivityResult>() {
                @Override
                public void onActivityResult(ActivityResult result) {
                    if (result.getResultCode() == Activity.RESULT_OK) {
                        // There are no request codes
                        try {
                            File f = new File(currentPhotoPath);
                            profileImage.setImageURI(Uri.fromFile(f));
                            CropImage.activity(Uri.fromFile(f)).setAspectRatio(1,1).start(RegistrationActivity.this);
                        }
                        catch (Exception e) {
                            Log.d("IAMRAM",e.getMessage());
                        }
                    }
                }
            });


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

    public void choosePicture(Context context) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        View view = ((Activity)context).getLayoutInflater().inflate(R.layout.profile_pic_change_layout,null);
        builder.setView(view);
        this.profileImage = view.findViewById(R.id.profilePicture);
        this.profileImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                chooseImageUploadOption();
            }
        });
        view.findViewById(R.id.uploadProfilePicture).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isImageSelected) {
                    Services.uploadImageOnFirebase(RegistrationActivity.this,FirebaseAuth.getInstance().getCurrentUser().getUid(),resultUri);
                }
                else {

                }

            }
        });
        builder.setCancelable(false);
        AlertDialog alertDialog = builder.create();
        alertDialog.show();
    }


    public void chooseImageUploadOption(){
        AlertDialog.Builder builder = new AlertDialog.Builder(RegistrationActivity.this);
        builder.setCancelable(false);
        alertDialog = builder.create();
        View view = getLayoutInflater().inflate(R.layout.uploadoption,null);
        alertDialog.setView(view);
        TextView fromgallery = view.findViewById(R.id.gallery);
        TextView camera = view.findViewById(R.id.camera);
        TextView cancel = view.findViewById(R.id.cancel);

        fromgallery.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CropImage.activity()
                        .setGuidelines(CropImageView.Guidelines.ON)
                        .setAspectRatio(1,1)
                        .start(RegistrationActivity.this);
                alertDialog.dismiss();
            }
        });

        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                alertDialog.dismiss();
            }
        });

        camera.setOnClickListener(new View.OnClickListener() {
            @RequiresApi(api = Build.VERSION_CODES.M)
            @Override
            public void onClick(View v) {
                if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
                {
                    requestPermissions(new String[]{Manifest.permission.CAMERA}, CAMERA_PERMISSION_CODE);
                }else {
                    callCamera();
                }
            }
        });
//PrivacyPolicy
        findViewById(R.id.privacypolicy).setOnClickListener(v -> {
            Intent browserIntent = new Intent(Intent.ACTION_VIEW,
                    Uri.parse("https://softment.in/StraightLine/privacypolicy/"));
            startActivity(browserIntent);
        });
        alertDialog.show();
    }


    private void requestStoragePermission() {

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED)
            return;

        if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE)) {
            //If the user has denied the permission previously your code will come to this block
            //Here you can explain why you need this permission
            //Explain here why you need this permission
        }
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.CAMERA}, STORAGE_PERMISSION_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == STORAGE_PERMISSION_CODE) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {


            } else {
                Services.showCenterToast(RegistrationActivity.this,ToastType.ERROR,"Oops you just denied the permission");
            }

        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == RC_SIGN_IN) {
            Task<GoogleSignInAccount> task = GoogleSignIn.getSignedInAccountFromIntent(data);
            try {
                // Google Sign In was successful, authenticate with Firebase
                GoogleSignInAccount account = task.getResult(ApiException.class);
                AuthCredential credential = GoogleAuthProvider.getCredential(account.getIdToken(), null);
                Services.firebaseAuthWithGoogle(RegistrationActivity.this,credential);
            } catch (ApiException e) {
                Services.showDialog(this,"ERROR",e.getLocalizedMessage());

            }
        }
        else if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {

            CropImage.ActivityResult result = CropImage.getActivityResult(data);
            if (resultCode == RESULT_OK) {

                resultUri = result.getUriContent();
                isImageSelected = true;

                Bitmap bitmap = null;
                try {
                    bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), resultUri);
                    profileImage.setImageBitmap(bitmap);
                } catch (IOException e) {

                }

            }

            else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                Exception error = result.getError();
                Services.showDialog(RegistrationActivity.this, "ERROR",error.getLocalizedMessage());
            }

        }
        else {
            mCallbackManager.onActivityResult(requestCode, resultCode, data);
        }




    }



}