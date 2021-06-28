package in.softment.straightline.Utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;

import com.android.volley.AuthFailureError;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.SetOptions;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import org.jetbrains.annotations.NotNull;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

import es.dmoral.toasty.Toasty;
import in.softment.straightline.MainActivity;
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.R;
import in.softment.straightline.RegistrationActivity;
import in.softment.straightline.SignInActivity;
import in.softment.straightline.ToastType;


public class Services {



    public static String getTimeAgo(long time) {
        final int SECOND_MILLIS = 1000;
        final int MINUTE_MILLIS = 60 * SECOND_MILLIS;
        final int HOUR_MILLIS = 60 * MINUTE_MILLIS;
        final int DAY_MILLIS = 24 * HOUR_MILLIS;
        if (time < 1000000000000L) {
            // if timestamp given in seconds, convert to millis
            time *= 1000;
        }

        long now = System.currentTimeMillis();
        if (time > now || time <= 0) {
            return null;
        }

        // TODO: localize
        final long diff = now - time;
        if (diff < MINUTE_MILLIS) {
            return "just now";
        } else if (diff < 2 * MINUTE_MILLIS) {
            return "a minute ago";
        } else if (diff < 50 * MINUTE_MILLIS) {
            return diff / MINUTE_MILLIS + " minutes ago";
        } else if (diff < 90 * MINUTE_MILLIS) {
            return "hour ago";
        } else if (diff < 24 * HOUR_MILLIS) {
            return diff / HOUR_MILLIS + " hours ago";
        } else if (diff < 48 * HOUR_MILLIS) {
            return "yesterday";
        } else {
            return diff / DAY_MILLIS + " days ago";
        }
    }

    public static void sentPushNotification(Context context,String title, String message, String token) {
        final String FCM_API = "https://fcm.googleapis.com/fcm/send";
        final String serverKey = "key=" + "AAAAWcgCoR4:APA91bF3PbFyY348xjaAmURjz57VjpPvNAAP4myoyKDROf4OvULdTcrfxGV_TrpBgsqvKFOuSpUoQHGUwbttawk_03F3jkZ4iF7bKIWxBinhPSwtr2EHhZ_rbcpOqhn2AUkwFp7pB4F6";
        final String contentType = "application/json";
        String NOTIFICATION_TITLE;
        String NOTIFICATION_MESSAGE;

        JSONObject notification = new JSONObject();
        JSONObject notifcationBody = new JSONObject();
        try {
            notifcationBody.put("title", title);
            notifcationBody.put("message", message);
            notification.put("to", token);
            notification.put("data", notifcationBody);
        } catch (JSONException e) {

        }

        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(FCM_API, notification,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {


                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {


                    }
                }){
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                params.put("Authorization", serverKey);
                params.put("Content-Type", contentType);
                return params;
            }
        };
        MySingleton.getInstance(context).addToRequestQueue(jsonObjectRequest);


    }

    public static boolean isUserLoggedIn(){
        if (FirebaseAuth.getInstance().getCurrentUser() != null) {
            return true;
        }
        else {
            return false;
        }
    }

    public static void fullScreen(Activity activity){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            final WindowInsetsController insetsController = activity.getWindow().getInsetsController();
            if (insetsController != null) {
                insetsController.hide(WindowInsets.Type.statusBars());
            }
        } else {
            activity.getWindow().setFlags(
                    WindowManager.LayoutParams.FLAG_FULLSCREEN,
                    WindowManager.LayoutParams.FLAG_FULLSCREEN
            );
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

    public static  String convertDateToTimeString(Date date) {
        if (date == null) {
            date = new Date();
        }
        date.setTime(date.getTime());
        String pattern = "dd-MMM-yyyy, hh:mm a";
        DateFormat df = new SimpleDateFormat(pattern, Locale.getDefault());
        return  df.format(date);
    }

    public static void showCenterToast(Context context, ToastType type, String message) {
        Toast toasty = null;
        if (type == ToastType.SUCCESS) {
          toasty  = Toasty.success(context, message, Toasty.LENGTH_SHORT,true);
        }
        else if (type == ToastType.ERROR) {
            toasty  = Toasty.error(context, message, Toasty.LENGTH_SHORT,true);
        }
        else if (type == ToastType.INFO) {
            toasty  = Toasty.info(context, message, Toasty.LENGTH_SHORT,true);
        }
        else {
            toasty  = Toasty.warning(context, message, Toasty.LENGTH_SHORT,true);
        }

       toasty.setGravity(Gravity.CENTER,0,0);
       toasty.show();

    }

    public static void logout(Context context) {
        FirebaseAuth.getInstance().signOut();
        Intent intent = new Intent(context, RegistrationActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        context.startActivity(intent);
    }


    public static String toUpperCase(String str) {
        String[] names = str.split(" ");
        str = "";
        for (int i = 0; i< names.length ; i++){
            str += names[i].substring(0,1).toUpperCase() + names[i].substring(1).toLowerCase() +" ";
        }
     return str;
    }
    public static void showDialog(Context context,String title,String message) {

        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setCancelable(false);
        Activity activity = (Activity) context;
        View view = activity.getLayoutInflater().inflate(R.layout.error_message_layout, null);
        TextView titleView = view.findViewById(R.id.title);
        TextView msg = view.findViewById(R.id.message);
        titleView.setText(title);
        msg.setText(message);
        builder.setView(view);
        AlertDialog alertDialog = builder.create();
        view.findViewById(R.id.ok).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                alertDialog.dismiss();

                if (title.equalsIgnoreCase("Challenge Created")) {
                    ((Activity) context).finish();
                }

            }
        });
        alertDialog.show();
    }

    public static void sentEmailVerificationLink(Context context){
        ProgressHud.show(context,"");
        if (FirebaseAuth.getInstance().getCurrentUser() != null) {
            FirebaseAuth.getInstance().getCurrentUser().sendEmailVerification().addOnCompleteListener(new OnCompleteListener<Void>() {
                @Override
                public void onComplete(@NonNull Task<Void> task) {
                    ProgressHud.dialog.dismiss();
                    if (task.isSuccessful()) {
                        showDialog(context,"Verify Your Email Address","We have sent verification link on your mail address.Please verify email before login.");
                    }
                    else {
                        showDialog(context,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());
                    }
                }
            });
        }
        else {
                ProgressHud.dialog.dismiss();
        }
    }

    public static void resetPassword(Context context, String email){
        ProgressHud.show(context,"Resetting...");
        FirebaseAuth.getInstance().sendPasswordResetEmail(email).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull @NotNull Task<Void> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    Services.showDialog(context,"RESET PASSWORD","We have sent password reset link on your mail address.");
                }
                else {
                    Services.showDialog(context,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());
                }
            }
        });
    }

    public static void addCurrentUserData(Context context,String uid, String name, String emailAddress) {
        ProgressHud.show(context,"");
        Map<String, Object> map = new HashMap<>();
        map.put("fullName", Services.toUpperCase(name));
        map.put("emailAddress",emailAddress);
        map.put("uid",uid);
        FirebaseFirestore.getInstance().collection("Users").document(uid).set(map).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull @NotNull Task<Void> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                   Services.sentEmailVerificationLink(context);
                }
                else {
                    showDialog(context,"ERROR",task.getException().getLocalizedMessage());
                }
            }
        });

    }

    public static void getCurrentUserData(Context context,String uid) {
        if (!Objects.requireNonNull(FirebaseAuth.getInstance().getCurrentUser()).isEmailVerified()) {
            sentEmailVerificationLink(context);
            return;
        }

        ProgressHud.show(context,"");
        FirebaseFirestore.getInstance().collection("Users").document(uid).get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    DocumentSnapshot documentSnapshot = task.getResult();
                    if (documentSnapshot != null && documentSnapshot.exists()) {
                        documentSnapshot.toObject(UserModel.class);

                        if (UserModel.data != null) {
                            if (UserModel.data.getProfileImage().isEmpty()) {
                                if (context instanceof SignInActivity) {
                                    ((SignInActivity)context).choosePicture(context);
                                }

                                return;
                            }
                            Intent intent = new Intent(context, MainActivity.class);
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                            context.startActivity(intent);

                    }
                        else  {
                           showCenterToast(context,ToastType.ERROR,"Something Went Wrong. Code - 101");
                        }
                    }
                    else {
                        FirebaseAuth.getInstance().signOut();
                        showCenterToast(context,ToastType.ERROR,"You record has been deleted.");
                    }
                }
                else {
                    showCenterToast(context,ToastType.ERROR,"Something Went Wrong. Code - 102");
                }

            }
        });
    }

    public static void uploadImageOnFirebase(Context context,String uid, Uri resultUri) {
        ProgressHud.show(context,"Profile Updating...");
        StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("Users").child("ProfilePicture").child(uid+ ".png");
        UploadTask uploadTask = storageReference.putFile(resultUri);
        Task<Uri> uriTask = uploadTask.continueWithTask(new Continuation<UploadTask.TaskSnapshot, Task<Uri>>() {
            @Override
            public Task<Uri> then(@NonNull Task<UploadTask.TaskSnapshot> task) throws Exception {
                if (!task.isSuccessful()) {
                    ProgressHud.dialog.dismiss();
                    Services.showDialog(context,"ERROR",task.getException().getLocalizedMessage());
                }
                return storageReference.getDownloadUrl();
            }
        }).addOnCompleteListener(new OnCompleteListener<Uri>() {
            @Override
            public void onComplete(@NonNull Task<Uri> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    String downloadUri = String.valueOf(task.getResult());
                    updateProfileImage(context,uid,downloadUri);

                }
                else{
                    Services.showDialog(context,"ERROR",task.getException().getLocalizedMessage());

                }


            }
        });
    }

    public static void updateProfileImage(Context context, String uid, String downloadURL){
        ProgressHud.show(context,"");
        Map<String, String> map = new HashMap<>();
        map.put("profileImage",downloadURL);
        FirebaseFirestore.getInstance().collection("Users").document(uid).set(map, SetOptions.merge()).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull @NotNull Task<Void> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    UserModel.data.profileImage = downloadURL;
                    Intent intent = new Intent(context, MainActivity.class);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    context.startActivity(intent);
                }
                else {
                    Services.showDialog(context,"ERROR",task.getException().getLocalizedMessage());
                }
            }
        });
    }
}
