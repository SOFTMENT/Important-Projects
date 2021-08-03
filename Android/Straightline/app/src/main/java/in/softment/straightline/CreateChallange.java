package in.softment.straightline;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.InputType;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TimePicker;

import com.canhub.cropper.CropImage;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.imageview.ShapeableImageView;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;
import com.makeramen.roundedimageview.RoundedImageView;

import org.jetbrains.annotations.NotNull;
import org.w3c.dom.Text;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import in.softment.straightline.Model.UserModel;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

public class CreateChallange extends AppCompatActivity {

    private EditText title, date, place, message;
    private Date actualDate;
    private LinearLayout oneLL;
    private RoundedImageView oneImage;
    private boolean oneImageSelected;
    private Uri imageURL;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_challange);

        Services.fullScreen(this);


        oneLL = findViewById(R.id.oneLL);
        oneImage = findViewById(R.id.oneImage);

        oneLL.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                showFileChooser();
            }
        });

        oneImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showFileChooser();
            }
        });
        title = findViewById(R.id.title);
        date = findViewById(R.id.date);
        place = findViewById(R.id.place);
        message = findViewById(R.id.message);

        date.setInputType(InputType.TYPE_NULL);
        date.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showDateTimeDialog(date);
            }
        });


        //BACK
        findViewById(R.id.back).setOnClickListener(v -> finish());

        //CreateChallenge
        findViewById(R.id.createChallenge).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sTitle = title.getText().toString().trim();
                String sDate = date.getText().toString().trim();
                String sPlace = place.getText().toString().trim();
                String sMessage = message.getText().toString().trim();

                if (sTitle.isEmpty()) {
                    Services.showCenterToast(CreateChallange.this,ToastType.WARNING,"Enter Title");
                }
                else if (sDate.isEmpty()) {
                    Services.showCenterToast(CreateChallange.this,ToastType.WARNING,"Choose Date");
                }
                else if (sPlace.isEmpty()){
                    Services.showCenterToast(CreateChallange.this,ToastType.WARNING,"Enter Place");
                }
                else if (sMessage.isEmpty()) {
                    Services.showCenterToast(CreateChallange.this,ToastType.WARNING,"Enter Message");
                }
                if (!oneImageSelected) {
                    Services.showCenterToast(CreateChallange.this,ToastType.WARNING,"Upload Vehicle Image");
                }
                else {
                    createChallenge(sTitle,sPlace,actualDate,sMessage);
                }
            }
        });



    }

    public void showFileChooser() {

        try {
            Intent intent = new Intent();
            intent.setType("image/*");
            intent.setAction(Intent.ACTION_GET_CONTENT);
            startActivityForResult(Intent.createChooser(intent, "Select Picture"), 1);
        }
        catch (Exception ignored) {

        }

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);


        if (requestCode == 1 && data != null && data.getData() != null) {
            Uri filepath = data.getData();
            CropImage.activity(filepath).setOutputCompressQuality(60).setAspectRatio(10,7).start(this);
        }
        else if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);

            if (resultCode == RESULT_OK) {

                Bitmap bitmap = null;
                try {

                    bitmap = MediaStore.Images.Media.getBitmap(getContentResolver(),result.getUriContent());
                    oneImage.setImageBitmap(bitmap);
                    oneImageSelected = true;
                    oneImage.setVisibility(View.VISIBLE);
                    oneLL.setVisibility(View.GONE);
                    imageURL = result.getUriContent();

                } catch (IOException e) {
                    Log.d("ERROR",e.getLocalizedMessage());
                }

            }
        }


    }

    private void createChallenge(String mTitle, String mPlace, Date mDate, String mMessage) {
        ProgressHud.show(CreateChallange.this,"");
        DocumentReference documentReference = FirebaseFirestore.getInstance().collection("Challenges").document();
        String cid = documentReference.getId();
        Map<String, Object> map = new HashMap<>();
        map.put("title",mTitle);
        map.put("location",mPlace);
        map.put("time",mDate);
        map.put("message",mMessage);
        map.put("name", UserModel.data.fullName);
        map.put("profileImage",UserModel.data.profileImage);
        map.put("uid",UserModel.data.uid);
        map.put("cid",cid);
        map.put("token",UserModel.data.token);
        map.put("email",UserModel.data.emailAddress);
        map.put("latitude",UserModel.data.latitude);
        map.put("longitude",UserModel.data.longitude);

        uploadImageOnFirebase(this,map, cid);

    }

    private void showDateTimeDialog(final EditText date_time_in) {
        final Calendar calendar=Calendar.getInstance();
        DatePickerDialog.OnDateSetListener dateSetListener=new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                calendar.set(Calendar.YEAR,year);
                calendar.set(Calendar.MONTH,month);
                calendar.set(Calendar.DAY_OF_MONTH,dayOfMonth);

                TimePickerDialog.OnTimeSetListener timeSetListener=new TimePickerDialog.OnTimeSetListener() {
                    @Override
                    public void onTimeSet(TimePicker view, int hourOfDay, int minute) {
                        calendar.set(Calendar.HOUR_OF_DAY,hourOfDay);
                        calendar.set(Calendar.MINUTE,minute);

                        actualDate = calendar.getTime();

                        date_time_in.setText(Services.convertDateToTimeString(actualDate));
                    }
                };

                new TimePickerDialog(CreateChallange.this,R.style.MyTimePickerDialogTheme,timeSetListener,calendar.get(Calendar.HOUR_OF_DAY),calendar.get(Calendar.MINUTE),false).show();
            }
        };

        new DatePickerDialog(CreateChallange.this,R.style.MyTimePickerDialogTheme,dateSetListener,calendar.get(Calendar.YEAR),calendar.get(Calendar.MONTH),calendar.get(Calendar.DAY_OF_MONTH)).show();

    }

    public void uploadImageOnFirebase(Context context, Map map, String cid) {
        ProgressHud.show(context,"");
        StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("VehicleImage").child(cid).child(cid+ ".png");
        UploadTask uploadTask = storageReference.putFile(imageURL);
        Task<Uri> uriTask = uploadTask.continueWithTask(new Continuation<UploadTask.TaskSnapshot, Task<Uri>>() {
            @Override
            public Task<Uri> then(@NonNull Task<UploadTask.TaskSnapshot> task) throws Exception {
                if (!task.isSuccessful()) {
                    ProgressHud.dialog.dismiss();
                    Services.showDialog(context,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());
                }
                return storageReference.getDownloadUrl();
            }
        }).addOnCompleteListener(new OnCompleteListener<Uri>() {
            @Override
            public void onComplete(@NonNull Task<Uri> task) {

                if (task.isSuccessful()) {
                    String downloadUri = String.valueOf(task.getResult());
                    map.put("vehicleImage",downloadUri);
                    FirebaseFirestore.getInstance().collection("Challenges").document(cid).set(map).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull @NotNull Task<Void> task) {
                            ProgressHud.dialog.dismiss();
                            if (task.isSuccessful()){
                                title.setText("");
                                message.setText("");
                                date.setText("");
                                place.setText("");
                                oneLL.setVisibility(View.VISIBLE);
                                oneImage.setVisibility(View.GONE);

                                Services.showDialog(CreateChallange.this,"Challenge Created","You have successfully created challenge, You can see all your challenge from Manage Challenge Section");
                            }
                            else {
                                Services.showDialog(CreateChallange.this,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());
                            }
                        }
                    });

                }
                else{
                    ProgressHud.dialog.dismiss();
                    Services.showDialog(context,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());

                }


            }
        });
    }

}