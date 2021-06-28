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
import androidx.appcompat.widget.AppCompatButton;
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
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.canhub.cropper.CropImage;
import com.canhub.cropper.CropImageView;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.makeramen.roundedimageview.RoundedImageView;

import org.jetbrains.annotations.NotNull;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Objects;

import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

public class SignInActivity extends AppCompatActivity {


    private EditText email, password;
    private static final int STORAGE_PERMISSION_CODE = 4655;
    private static final int CAMERA_PERMISSION_CODE = 123;
    private int PICK_IMAGE_REQUEST = 1;
    private Uri resultUri = null;
    private RoundedImageView profileImage = null;
    private boolean isImageSelected = false;
    private AlertDialog alertDialog;
    private  String currentPhotoPath;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_in);


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(Color.WHITE);
        }



        email = findViewById(R.id.email);
        password = findViewById(R.id.password);

        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        findViewById(R.id.signup).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        //ResetPassword
        findViewById(R.id.reset).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String mEmail = email.getText().toString().trim();
                if (mEmail.isEmpty()) {
                    Services.showCenterToast(SignInActivity.this,ToastType.WARNING,"Enter Email Address");
                }
                else {
                  Services.resetPassword(SignInActivity.this,mEmail);
                }
            }
        });

        //SigIn
        findViewById(R.id.signIn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String mEmail = email.getText().toString().trim();
                String mPassword = password.getText().toString().trim();

                if (mEmail.isEmpty()) {
                    Services.showCenterToast(SignInActivity.this,ToastType.WARNING,"Enter Email Address");
                }
                else if (mPassword.isEmpty()) {
                    Services.showCenterToast(SignInActivity.this,ToastType.WARNING,"Enter Password");
                }
                else {
                    ProgressHud.show(SignInActivity.this,"Sign in...");
                    FirebaseAuth.getInstance().signInWithEmailAndPassword(mEmail,mPassword).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull @NotNull Task<AuthResult> task) {
                            ProgressHud.dialog.dismiss();
                            if (task.isSuccessful())  {
                                if (Services.isUserLoggedIn()) {
                                    Services.getCurrentUserData(SignInActivity.this, Objects.requireNonNull(FirebaseAuth.getInstance().getCurrentUser()).getUid());
                                }

                            }
                            else {
                               Services.showDialog(SignInActivity.this,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());
                            }
                        }
                    });
                }
            }
        });

        requestStoragePermission();

    }


    public void chooseImageUploadOption(){
        AlertDialog.Builder builder = new AlertDialog.Builder(SignInActivity.this);
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
                        .start(SignInActivity.this);
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

        alertDialog.show();
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
                Log.d("VIJAY","Hello "+currentPhotoPath);
            } catch (IOException ex) {
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {

                Uri photoURI = FileProvider.getUriForFile(SignInActivity.this,
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
                            CropImage.activity(Uri.fromFile(f)).setAspectRatio(1,1).start(SignInActivity.this);
                        }
                        catch (Exception e) {
                            Log.d("IAMRAM",e.getMessage());
                        }
                    }
                }
            });

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
                    Services.uploadImageOnFirebase(SignInActivity.this,FirebaseAuth.getInstance().getCurrentUser().getUid(),resultUri);
                }
                else {

                }

            }
        });
        builder.setCancelable(false);
        AlertDialog alertDialog = builder.create();
        alertDialog.show();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {

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
                Services.showDialog(SignInActivity.this, "ERROR",error.getLocalizedMessage());
            }
        }




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
                Services.showCenterToast(SignInActivity.this,ToastType.ERROR,"Oops you just denied the permission");
            }

        }

    }
}