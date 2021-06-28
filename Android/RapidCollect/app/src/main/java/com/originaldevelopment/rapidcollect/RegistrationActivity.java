package com.originaldevelopment.rapidcollect;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;

import android.Manifest;
import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import com.theartofdev.edmodo.cropper.CropImage;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import id.zelory.compressor.Compressor;
import id.zelory.compressor.FileUtil;

public class RegistrationActivity extends AppCompatActivity {

    private ImageView profile_image;
    private String downloadUri = "";
    private static final int STORAGE_PERMISSION_CODE = 4655;
    private int PICK_IMAGE_REQUEST = 1;
    private EditText firstname, lastname, phone,email, password, confirmpassword;
    private CheckBox checkBox;
    private TextView terms;
    private  Uri resultUri = null;
    public static final int CAMERA_REQUEST_CODE = 102;
    private static final int MY_CAMERA_PERMISSION_CODE = 100;
    private String sFirst = "", sLast = "", sPhone = "", sEmail = "";
    String currentPhotoPath;
    AlertDialog alertDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_registration);



        requestStoragePermission();
        TextView back = findViewById(R.id.back);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });


        Button signup = findViewById(R.id.signup);
        firstname = findViewById(R.id.firstname);
        lastname = findViewById(R.id.lastname);
        phone = findViewById(R.id.phone);
        password = findViewById(R.id.password);
        confirmpassword = findViewById(R.id.confirmpassword);
        email = findViewById(R.id.email);
        checkBox = findViewById(R.id.checkbox);
        terms = findViewById(R.id.terms);



        signup.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                 sFirst = firstname.getText().toString().trim();
                 sLast = lastname.getText().toString().trim();
                sPhone = phone.getText().toString();
                sEmail = email.getText().toString().trim();
                String sPassword = password.getText().toString();
                String sConfirmPassword = confirmpassword.getText().toString();

                if (!sFirst.isEmpty()) {
                    if (!sLast.isEmpty()) {
                        if (!sPhone.isEmpty()) {
                            if (!sEmail.isEmpty()) {
                                if (!sPassword.isEmpty()) {
                                    if (!sConfirmPassword.isEmpty()) {
                                        if (sPassword.equals(sConfirmPassword)) {
                                            if (checkBox.isChecked()) {
                                                if (resultUri != null) {
                                                   ProgressHud.show(RegistrationActivity.this,"Creating Account...");
                                                    FirebaseAuth.getInstance().createUserWithEmailAndPassword(sEmail, sPassword).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                                                        @Override
                                                        public void onComplete(@NonNull Task<AuthResult> task) {

                                                            if (task.isSuccessful()){
                                                                uploadImageOnFirebase();

                                                            }
                                                            else {
                                                                ProgressHud.dialog.dismiss();
                                                                Toast toast = Toast.makeText(RegistrationActivity.this, task.getException().getMessage(), Toast.LENGTH_LONG);
                                                                toast.setGravity(Gravity.CENTER, 0, 0);
                                                                toast.show();
                                                            }
                                                        }
                                                    });
                                                } else {
                                                    Toast toast = Toast.makeText(RegistrationActivity.this, "Please Upload Profile Pic", Toast.LENGTH_SHORT);
                                                    toast.setGravity(Gravity.CENTER, 0, 0);
                                                    toast.show();
                                                }
                                            } else {
                                                Toast toast = Toast.makeText(RegistrationActivity.this, "Accept Terms And Conditions", Toast.LENGTH_SHORT);
                                                toast.setGravity(Gravity.CENTER, 0, 0);
                                                toast.show();
                                            }
                                        } else {
                                            Toast toast = Toast.makeText(RegistrationActivity.this, "Password and Confirm Password Not Matching", Toast.LENGTH_SHORT);
                                            toast.setGravity(Gravity.CENTER, 0, 0);
                                            toast.show();
                                        }
                                    } else {
                                        confirmpassword.setError("Empty");
                                        confirmpassword.requestFocus();
                                    }
                                } else {
                                    password.setError("Empty");
                                    password.requestFocus();
                                }
                            } else {
                                email.setError("Empty");
                                email.requestFocus();
                            }
                        } else {
                            phone.setError("Empty");
                            phone.requestFocus();
                        }
                    } else {
                        lastname.setError("Empty");
                        lastname.requestFocus();
                    }
                }
                else {
                    firstname.setError("Empty");
                    firstname.requestFocus();
                }
            }

        });

        profile_image = findViewById(R.id.user_profile);
        TextView taptochange = findViewById(R.id.taptochange);

        taptochange.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
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
                      ShowFileChooser();
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
                  @Override
                  public void onClick(View v) {
                      if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
                      {
                          requestPermissions(new String[]{Manifest.permission.CAMERA}, MY_CAMERA_PERMISSION_CODE);
                      }else {
                                callCamera();
                      }
                  }
              });

              alertDialog.show();
            }
        });

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

                    Uri photoURI = FileProvider.getUriForFile(RegistrationActivity.this,
                            "com.originaldevelopment.android.fileprovider",
                            photoFile);
                    takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                    startActivityForResult(takePictureIntent, CAMERA_REQUEST_CODE);



            }
            else{
                Toast.makeText(this, "Null", Toast.LENGTH_SHORT).show();
            }
        }
        else {
            Toast.makeText(this, "Ok", Toast.LENGTH_SHORT).show();
        }
    }

    private void uploadImageOnFirebase() {
        StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("ProfilePicture").child(FirebaseAuth.getInstance().getCurrentUser().getUid()+ ".png");
        UploadTask uploadTask = storageReference.putFile(resultUri);
        Task<Uri> uriTask = uploadTask.continueWithTask(new Continuation<UploadTask.TaskSnapshot, Task<Uri>>() {
            @Override
            public Task<Uri> then(@NonNull Task<UploadTask.TaskSnapshot> task) throws Exception {
                if (!task.isSuccessful()) {
                    ProgressHud.dialog.dismiss();
                    throw  task.getException();
                }
                return storageReference.getDownloadUrl();
            }
        }).addOnCompleteListener(new OnCompleteListener<Uri>() {
            @Override
            public void onComplete(@NonNull Task<Uri> task) {
           
                if (task.isSuccessful()) {
                    downloadUri = String.valueOf(task.getResult());

                }
                else{
                    Toast toast = Toast.makeText(RegistrationActivity.this, task.getException().getMessage(), Toast.LENGTH_SHORT);
                    toast.setGravity(Gravity.CENTER, 0, 0);
                    toast.show();
                }
                
                uploadAllData();
            }
        });
    }

    private void uploadAllData() {
        HashMap<String,Object> hashMap = new HashMap<>();
        String fullname = sFirst.substring(0,1).toUpperCase()+sFirst.substring(1).toLowerCase()+" "+sLast.substring(0,1).toUpperCase()+sLast.substring(1).toLowerCase();
        hashMap.put("name",fullname);
        hashMap.put("mail",sEmail);
        hashMap.put("mobile",sPhone);
        hashMap.put("profileimage",downloadUri);
        hashMap.put("uid",FirebaseAuth.getInstance().getCurrentUser().getUid());
        hashMap.put("time",new Date().toString());

        FirebaseDatabase.getInstance().getReference().child("Users").child(FirebaseAuth.getInstance().getCurrentUser().getUid())
                .updateChildren(hashMap, new DatabaseReference.CompletionListener() {
                    @Override
                    public void onComplete(@Nullable DatabaseError databaseError, @NonNull DatabaseReference databaseReference) {
                        FirebaseAuth.getInstance().getCurrentUser().sendEmailVerification().addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull Task<Void> task) {
                              ProgressHud.dialog.dismiss();
                                if (task.isSuccessful()) {
                                    AlertDialog.Builder builder = new AlertDialog.Builder(RegistrationActivity.this);
                                    builder.setTitle("Thank You!");
                                    builder.setMessage("Your Rapid Collect account has been created successfully.\n\nKindly click the link sent to your provided email address in order to validate your account.");
                                    builder.setCancelable(false);
                                    builder.setNeutralButton("OK", new DialogInterface.OnClickListener() {
                                        @Override
                                        public void onClick(DialogInterface dialog, int which) {
                                                finish();
                                        }
                                    });
                                    builder.show();
                                }
                                else {
                                    Toast toast = Toast.makeText(RegistrationActivity.this, task.getException().getMessage(), Toast.LENGTH_SHORT);
                                    toast.setGravity(Gravity.CENTER, 0, 0);
                                    toast.show();
                                }


                            }
                        });
                    }
                });

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


            }

            else {
                Toast.makeText(this, "Oops you just denied the permission", Toast.LENGTH_LONG).show();
            }

        }
        else if (requestCode == MY_CAMERA_PERMISSION_CODE)
        {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED)
            {
               callCamera();
            }
            else
            {
                Toast.makeText(this, "camera permission denied", Toast.LENGTH_LONG).show();
            }
        }
    }
    public void ShowFileChooser() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select Picture"), PICK_IMAGE_REQUEST);

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == PICK_IMAGE_REQUEST && data != null && data.getData() != null) {

            Uri filepath = data.getData();
            CropImage.activity(filepath).setOutputCompressQuality(100)
                    .start(this);
        }
        else if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);
            if (resultCode == RESULT_OK) {
                resultUri = result.getUri();
                try {
                    File compressedImageFile = new Compressor.Builder(RegistrationActivity.this).setQuality(90).build().compressToFile(FileUtil.from(RegistrationActivity.this,resultUri));
                    resultUri = Uri.fromFile(compressedImageFile);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                Bitmap bitmap = null;
                try {
                    bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), resultUri);
                    profile_image.setImageBitmap(bitmap);
                } catch (IOException e) {

                }

            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                Exception error = result.getError();
            }
        }
        else  if (requestCode == CAMERA_REQUEST_CODE && resultCode == Activity.RESULT_OK)
        {

           try {
               File f = new File(currentPhotoPath);
               profile_image.setImageURI(Uri.fromFile(f));
               CropImage.activity(Uri.fromFile(f)).setOutputCompressQuality(100).start(this);
           }
           catch (Exception e) {
               Log.d("IAMRAM",e.getMessage());
           }
//
//
//            Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
//            resultUri = Uri.fromFile(f);
//            mediaScanIntent.setData(resultUri);
//            this.sendBroadcast(mediaScanIntent);

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



}
