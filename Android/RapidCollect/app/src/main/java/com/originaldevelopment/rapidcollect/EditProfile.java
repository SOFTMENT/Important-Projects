package com.originaldevelopment.rapidcollect;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.content.FileProvider;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.media.Image;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.UUID;

import id.zelory.compressor.Compressor;
import id.zelory.compressor.FileUtil;

import static com.originaldevelopment.rapidcollect.RegistrationActivity.CAMERA_REQUEST_CODE;

public class EditProfile extends AppCompatActivity {
    private ImageView userprofile;
    private EditText firstname, lastname,phone;
    private AlertDialog alertDialog;
    private int PICK_IMAGE_REQUEST = 1;
    private int PICK_FILE_REQUEST = 909;

    private Uri resultUri;
    private Uri downloadImageUri;
    private Uri downloadFileUri;
    String currentPhotoPath;
    public static final int CAMERA_REQUEST_CODE = 102;
    public static final int CAMERA_REQUEST_CODE_FILE = 1012;
    private static final int MY_CAMERA_PERMISSION_CODE = 100;
    private RadioGroup radioGroup;
    private Uri downloadUri;
    private String trading = "";
    private boolean flag = false;
    private File compressedImageFile;
    private FirebaseAuth firebaseAuth;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_edit_profile);

        userprofile = findViewById(R.id.user_profile);
        firstname = findViewById(R.id.firstname);
        lastname = findViewById(R.id.lastname);
        phone = findViewById(R.id.phone);
        firebaseAuth = FirebaseAuth.getInstance();

        ((ImageView) findViewById(R.id.back)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        String sname = getIntent().getStringExtra("name");
        String sPhone = getIntent().getStringExtra("phone");
        String sProfile = getIntent().getStringExtra("profile");

        TextView tool_bar = findViewById(R.id.toolbar_title);
        String stitle = getIntent().getStringExtra("title");
        if (stitle.equalsIgnoreCase("upload")) {

           tool_bar.setText("UPLOAD DOCUMENTS");
        }
        else {
            tool_bar.setText("EDIT PROFILE");
        }

        ((TextView)findViewById(R.id.check)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(EditProfile.this, WebViewActivity.class);
                intent.putExtra("title","SUPPORTING DOCUMENTS");
                startActivity(intent);
            }
        });

        radioGroup = findViewById(R.id.radiogroup);
        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                switch (checkedId) {
                    case R.id.sole :
                        trading = "Sole";
                        break;
                    case  R.id.pty :
                        trading = "Pty";
                        break;
                    case  R.id.closed:
                        trading = "Closed";
                        break;

                }
            }
        });


        Glide.with(this).load(sProfile).into(userprofile);
        phone.setText(sPhone);
        String []full = sname.split(" ");
        firstname.setText(full[0]);
        lastname.setText(full[1]);

        Button uploadbtn = findViewById(R.id.uploadbutton);
        TextView taptochange = findViewById(R.id.taptochange);
        taptochange.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(EditProfile.this);
                builder.setCancelable(false);
                alertDialog = builder.create();
                View view = getLayoutInflater().inflate(R.layout.uploadoption,null);
                alertDialog.setView(view);
                TextView fromgallery = view.findViewById(R.id.gallery);
                TextView camera = view.findViewById(R.id.camera);
                TextView cancel = view.findViewById(R.id.cancel);
                TextView title = view.findViewById(R.id.title);
                title.setText("Update Profile Image");



                fromgallery.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ShowImageChooser();
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
                            callCamera("image");
                        }
                    }
                });

                alertDialog.show();
            }
        });

       uploadbtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (trading.isEmpty()) {
                    Toast toast = Toast.makeText(EditProfile.this,"Select Trading Type",Toast.LENGTH_SHORT);
                    toast.setGravity(Gravity.CENTER,0,0);
                    toast.show();
                    return;
                }
                AlertDialog.Builder builder = new AlertDialog.Builder(EditProfile.this);
                builder.setCancelable(false);
                alertDialog = builder.create();
                View view = getLayoutInflater().inflate(R.layout.uploadoption,null);
                alertDialog.setView(view);
                TextView fromgallery = view.findViewById(R.id.gallery);
                TextView camera = view.findViewById(R.id.camera);
                TextView cancel = view.findViewById(R.id.cancel);
                TextView title = view.findViewById(R.id.title);
                title.setText("Upload Document");

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
                            callCamera("doc");
                        }
                    }
                });

                alertDialog.show();
            }
        });

        TextView submit = findViewById(R.id.submit);
        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sFirst = firstname.getText().toString().trim();
                String sLast = lastname.getText().toString().trim();
                String sEmail = phone.getText().toString().trim();

                if (!sFirst.isEmpty()) {
                    if (!sLast.isEmpty()) {
                        if (!sEmail.isEmpty()) {
                            try {
                               // kProgressHUD.setLabel("Updating...");
                                ProgressHud.show(EditProfile.this,"Updating...");
                                HashMap<String, Object> hashMap = new HashMap<>();
                                String fullname = sFirst.substring(0, 1).toUpperCase() + sFirst.substring(1).toLowerCase() + " " + sLast.substring(0, 1).toUpperCase() + sLast.substring(1).toLowerCase();
                                hashMap.put("name", fullname);
                                hashMap.put("mobile", sEmail);
                                if (downloadImageUri != null) {
                                    hashMap.put("profileimage", String.valueOf(downloadImageUri));
                                }
                                if (downloadFileUri != null) {
                                    hashMap.put("trading", trading);
                                }

                                FirebaseDatabase.getInstance().getReference().child("Users").child(firebaseAuth.getCurrentUser().getUid())
                                        .updateChildren(hashMap, new DatabaseReference.CompletionListener() {
                                            @Override
                                            public void onComplete(@Nullable DatabaseError databaseError, @NonNull DatabaseReference databaseReference) {
                                               ProgressHud.dialog.dismiss();
                                                Toast toast = Toast.makeText(EditProfile.this, "Updated", Toast.LENGTH_SHORT);
                                                toast.setGravity(Gravity.CENTER, 0, 0);
                                                toast.show();
                                                finish();
                                            }
                                        });
                            }
                            catch (Exception e) {
                                Log.d("VIJAYERROR",e.getMessage());
                            }
                        }
                    }
                }
            }
        });


    }

    private void callCamera(String type) {
        alertDialog.dismiss();
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Ensure that there's a camera activity to handle the intent
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            // Create the File where the photo should go
            File photoFile = null;
            try {
                photoFile = createImageFile();
            } catch (IOException ex) {
                Log.d("VIJAYERROR",ex.getMessage());
            }
            // Continue only if the File was successfully created
            if (photoFile != null) {
                Uri photoURI = FileProvider.getUriForFile(EditProfile.this,
                        "com.originaldevelopment.android.fileprovider",
                        photoFile);
                takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, photoURI);
                if (type.equals("doc"))
                    startActivityForResult(takePictureIntent, CAMERA_REQUEST_CODE_FILE);
                else
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

    public void ShowFileChooser() {
        Intent intent = new Intent();
        intent.setType("*/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select Document"), PICK_FILE_REQUEST);

    }
    public void ShowImageChooser() {
        Intent intent = new Intent();
        intent.setType("image/*");
        intent.setAction(Intent.ACTION_GET_CONTENT);
        startActivityForResult(Intent.createChooser(intent, "Select Image"), PICK_IMAGE_REQUEST);

    }

    private void uploadDocOnFirebase() {
     //   kProgressHUD.setLabel("Uploading Document");
        ProgressHud.show(EditProfile.this,"Uploading Document");
        StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("Documents").child(FirebaseAuth.getInstance().getCurrentUser().getUid()).child(trading).child(UUID.randomUUID().toString());
        UploadTask uploadTask = storageReference.putFile(downloadUri);
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
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    downloadFileUri = task.getResult();

                }
                else{
                    Toast toast = Toast.makeText(EditProfile.this, task.getException().getMessage(), Toast.LENGTH_SHORT);
                    toast.setGravity(Gravity.CENTER, 0, 0);
                    toast.show();
                }


            }
        });
    }



    private void uploadImageOnFirebase() {
      //  kProgressHUD.setLabel("Updating Profile Image");
        ProgressHud.show(EditProfile.this,"Updating Profile Image");
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
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {

                    downloadImageUri = task.getResult();

                }
                else{
                    Toast toast = Toast.makeText(EditProfile.this, task.getException().getMessage(), Toast.LENGTH_SHORT);
                    toast.setGravity(Gravity.CENTER, 0, 0);
                    toast.show();
                }


            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == PICK_IMAGE_REQUEST && data != null && data.getData() != null) {

            Uri filepath = data.getData();
            flag = false;
            CropImage.activity(filepath).setOutputCompressQuality(100)
                    .start(this);
        }
        else if (requestCode == PICK_FILE_REQUEST && data != null && data.getData() != null) {
                   downloadUri = data.getData();
                   uploadDocOnFirebase();


        }
        else if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);
            if (resultCode == RESULT_OK) {
                resultUri = result.getUri();
                Bitmap bitmap = null;
                try {
                    bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), resultUri);
                    userprofile.setImageBitmap(bitmap);

                    compressedImageFile = new Compressor.Builder(EditProfile.this).setQuality(90).build().compressToFile(FileUtil.from(EditProfile.this,resultUri));
                    resultUri = Uri.fromFile(compressedImageFile);
                    if (flag) {
                        downloadUri = Uri.fromFile(compressedImageFile);
                        uploadDocOnFirebase();
                    }
                    else{
                            resultUri = Uri.fromFile(compressedImageFile);
                            uploadImageOnFirebase();
                    }
                } catch (IOException e) {
                    Log.d("VIJAYEX",e.getLocalizedMessage());
                }

            } else if (resultCode == CropImage.CROP_IMAGE_ACTIVITY_RESULT_ERROR_CODE) {
                Exception error = result.getError();
            }
        }
        else  if (requestCode == CAMERA_REQUEST_CODE && resultCode == Activity.RESULT_OK)
        {
            File f = new File(currentPhotoPath);
            userprofile.setImageURI(Uri.fromFile(f));
            Log.d("tag", "ABsolute Url of Image is " + Uri.fromFile(f));
            flag = false;
            CropImage.activity(Uri.fromFile(f)).setOutputCompressQuality(100)
                    .start(this);
//
//            Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
//            resultUri = Uri.fromFile(f);
//            mediaScanIntent.setData(resultUri);
//            this.sendBroadcast(mediaScanIntent);

        }
        else if (requestCode == CAMERA_REQUEST_CODE_FILE && resultCode == Activity.RESULT_OK) {
            File f = new File(currentPhotoPath);
            downloadUri = Uri.fromFile(f);
            flag = true;
            CropImage.activity(downloadUri).setOutputCompressQuality(100).start(this);
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
        return image;
    }





}