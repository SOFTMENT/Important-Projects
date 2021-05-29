package in.softment.serial_merchandiser;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.content.FileProvider;

import android.Manifest;
import android.app.DownloadManager;
import android.content.ContentValues;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.Picture;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.Method;
import java.net.URI;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private ImageView imageView;
    private CardView captureBtn;
    private TextView message, price,date;
    private LinearLayout ll;
    Uri imageUri;
    String mPath;
    String sMessage;
    String sPrice;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        checkStoragePermission();


        FirebaseDatabase.getInstance().getReference().child("Serial").child("enable").addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot snapshot) {
                if (snapshot != null && snapshot.exists()){
                   boolean b =  snapshot.getValue(Boolean.class);
                    if (!b) {
                        System.exit(0);
                    }
                }
            }

            @Override
            public void onCancelled(@NonNull DatabaseError error) {

            }
        });

        imageView = findViewById(R.id.img);
        price = findViewById(R.id.price);
        date = findViewById(R.id.date);
        captureBtn = findViewById(R.id.captureImage);
        message = findViewById(R.id.message);
        ll = findViewById(R.id.ll);



        findViewById(R.id.website).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse("https://www.made-in-prato.com"));
                startActivity(browserIntent);
            }
        });

        captureBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (checkStoragePermission()) {
                    if (checkCameraPermission() )
                    {
                        price.setVisibility(View.GONE);
                        showFileChooser();
                    }
                }



            }
        });

        findViewById(R.id.opengallery).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(Build.VERSION.SDK_INT>=24){
                    try{
                        Method m = StrictMode.class.getMethod("disableDeathOnFileUriExposure");
                        m.invoke(null);
                    }catch(Exception e){
                        e.printStackTrace();
                    }
                }
                Uri selectedUri = Uri.parse(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) + "/SerialMerchandiser/");
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(selectedUri, "*/*");

                if (intent.resolveActivityInfo(getPackageManager(), 0) != null)
                {
                    startActivity(intent);
                }
                else
                {
                    // if you reach this place, it means there is no any file
                    // explorer app installed on your device
                }
//
//                startActivity(new Intent(Picture.);
//                Intent intent = new Intent(Intent.ACTION_VIEW);
//              //  Uri mydir = Uri.parse("file:/"+Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)  + File.separator);
//                Uri photoURI = FileProvider.getUriForFile(MainActivity.this, getApplicationContext().getPackageName() + ".provider", new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + File.separator));
//                intent.setDataAndType(photoURI,"application/*");    // or use */*
//                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
//                startActivity(intent);
            }
        });
    }



    public boolean checkCameraPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
            {
                requestPermissions(new String[]{Manifest.permission.CAMERA}, 606);
                return false;
            }else {
                return true;
            }
        }
        return false;
    }

    public boolean checkStoragePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED)
            {
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 605);
                return false;
            }else {
                return true;
            }
        }
        return false;
    }
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if (requestCode == 606) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                showFileChooser();

            }
            else {

                Toast toast = Toast.makeText(MainActivity.this, "Permission Denied.", Toast.LENGTH_SHORT);
                toast.setGravity(Gravity.CENTER, 0, 0);
                toast.show();

            }
        }
    }

    public void showFileChooser() {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.TITLE, "New Picture");
        values.put(MediaStore.Images.Media.DESCRIPTION, "From your Camera");
        imageUri = getContentResolver().insert(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.putExtra("android.intent.extra.quickCapture",true);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri);
        startActivityForResult(intent, 2);



    }

    public void buttonDeleteFile(String filePath){
        File file = new File(filePath);
        if (file.exists()){
            file.delete();
        }
    }

    public static Bitmap rotateImage(Bitmap source, float angle) {
        Matrix matrix = new Matrix();
        matrix.postRotate(angle);
        return Bitmap.createBitmap(source, 0, 0, source.getWidth(), source.getHeight(),
                matrix, true);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 2) {
          //  Toast.makeText(this, ""+data.getEx, Toast.LENGTH_SHORT).show();
            AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
            View view = getLayoutInflater().inflate(R.layout.input_layout,null);
            EditText emessage = view.findViewById(R.id.message);
            EditText eprice = view.findViewById(R.id.price);
            CardView save = view.findViewById(R.id.save);
            AlertDialog alertDialog = builder.create();
            save.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {

                    sMessage = emessage.getText().toString().trim();
                    sPrice = eprice.getText().toString().trim();
                    if (sMessage.isEmpty() && sPrice.isEmpty()) {
                        Toast.makeText(MainActivity.this, "Please enter text and price", Toast.LENGTH_SHORT).show();
                    }
                    else {

                        message.setText(sMessage);
                        price.setText(sPrice);


                        date.setText(convertDateToString(new Date()));


                        alertDialog.dismiss();
                        Bitmap thumbnail = null;
                        try {
                            thumbnail = MediaStore.Images.Media.getBitmap(
                                    getContentResolver(), imageUri);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                        ExifInterface ei = null;
                        try {
                            ei = new ExifInterface(getRealPathFromURI(imageUri));
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        int orientation = ei.getAttributeInt(ExifInterface.TAG_ORIENTATION,
                                ExifInterface.ORIENTATION_UNDEFINED);

                        Bitmap rotatedBitmap = null;
                        switch(orientation) {

                            case ExifInterface.ORIENTATION_ROTATE_90:
                                rotatedBitmap = rotateImage(thumbnail, 90);
                                break;

                            case ExifInterface.ORIENTATION_ROTATE_180:
                                rotatedBitmap = rotateImage(thumbnail, 180);
                                break;

                            case ExifInterface.ORIENTATION_ROTATE_270:
                                rotatedBitmap = rotateImage(thumbnail, 270);
                                break;

                            case ExifInterface.ORIENTATION_NORMAL:
                            default:
                                rotatedBitmap = thumbnail;
                        }

                        imageView.setImageBitmap(rotatedBitmap);

                        ll.setVisibility(View.VISIBLE);




                        takeScreenshotNoteOnly();








                    }

                }
            });

            alertDialog.setView(view);
            alertDialog.show();



        }
    }

    public String getRealPathFromURI(Uri uri) {
        Cursor cursor = getContentResolver().query(uri, null, null, null, null);
        cursor.moveToFirst();
        int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
        return cursor.getString(idx);
    }

    private void takeScreenshot() {
        Date now = new Date();
        android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss", now);



            try {
                ll.setDrawingCacheEnabled(true);
                Bitmap bitmap = Bitmap.createBitmap(ll.getDrawingCache());
                ll.setDrawingCacheEnabled(false);

                Random generator = new Random();
                int n = 10000;
                n = generator.nextInt(n);
                String fname = "Image-"+ n +".jpg";

                File file1 = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) + "SerialMerchandiser");
                file1.mkdirs();
//

                File file2 = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) + "SerialMerchandiser/NoteAndPrice");
                file2.mkdirs();


                File file = new File (Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"/SerialMerchandiser/NoteAndPrice" , fname);


                file.getParentFile().mkdirs();

                Log.d("HELLO","vI");
           //  boolean b =  file.createNewFile();

          //      Log.d("HELLO",b+"");
                FileOutputStream out = new FileOutputStream(file);
                bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
                    out.flush();
                    out.close();

                buttonDeleteFile(getRealPathFromURI(imageUri));
               // Toast.makeText(this, "Image Saved", Toast.LENGTH_LONG).show();
            }
            catch (Exception e1) {
//                Toast toast =   Toast.makeText(this, ""+e1.getMessage(), Toast.LENGTH_SHORT);
//                toast.setGravity(Gravity.CENTER,0,0);
//                toast.show();
//                Log.d("PATH",e1.getLocalizedMessage());
            }






    }

    private void takeScreenshotNoteOnly() {
        Date now = new Date();
        android.text.format.DateFormat.format("yyyy-MM-dd_hh:mm:ss", now);



        try {
            ll.setDrawingCacheEnabled(true);
            Bitmap bitmap = Bitmap.createBitmap(ll.getDrawingCache());
            ll.setDrawingCacheEnabled(false);

            Random generator = new Random();
            int n = 10000;
            n = generator.nextInt(n);
            String fname = "Image-"+ n +".jpg";

            File file1 = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) + "SerialMerchandiser");
            file1.mkdirs();
//

            File file3 = new File (Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS) +"SerialMerchandiser/Note");
            file3.mkdirs();



            File    file =  new File (Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)+"/SerialMerchandiser/Note/"+fname);

            file.getParentFile().mkdirs();

            Log.d("HELLO","vI");
            //  boolean b =  file.createNewFile();

            //      Log.d("HELLO",b+"");
            FileOutputStream out = new FileOutputStream(file);
            bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out);
            out.flush();
            out.close();

            buttonDeleteFile(getRealPathFromURI(imageUri));


            price.setVisibility(View.VISIBLE);
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {

                    takeScreenshot();
                }
            },500);

            Toast.makeText(this, "Image Saved", Toast.LENGTH_LONG).show();
        }
        catch (Exception e1) {
            Toast toast =   Toast.makeText(this, ""+e1.getMessage(), Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER,0,0);
            toast.show();
           // Log.d("PATH",e1.getLocalizedMessage());
        }




    }
    public static  String convertDateToString(Date date) {
        if (date == null) {
            date = new Date();
        }
        date.setTime(date.getTime());
        String pattern = "dd-MMM-yyyy";
        DateFormat df = new SimpleDateFormat(pattern, Locale.getDefault());
        return  df.format(date);
    }
}