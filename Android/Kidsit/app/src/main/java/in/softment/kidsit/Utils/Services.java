package in.softment.kidsit.Utils;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.view.Gravity;
import android.view.View;
import android.view.WindowInsets;
import android.view.WindowInsetsController;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.UserInfo;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import in.softment.kidsit.AddUserInfoAvitivity;
import in.softment.kidsit.BookAppointmentActivity;
import in.softment.kidsit.HomeActivity;
import in.softment.kidsit.MainActivity;
import in.softment.kidsit.Models.ParentModel;
import in.softment.kidsit.R;
import in.softment.kidsit.SignInActivity;
import in.softment.kidsit.SignUpActivity;

public class Services {

    public static void handleFirebaseERROR(Context context, String errorCode){
        switch (errorCode) {

            case "ERROR_INVALID_CUSTOM_TOKEN":
                Services.showDialog(context,context.getString(R.string.error),"Le format de jeton personnalisé est incorrect. Veuillez vérifier la documentation.");
                break;


            case "ERROR_INVALID_CREDENTIAL":
                Services.showDialog(context,context.getString(R.string.error),"Les informations d'authentification fournies sont mal formées ou ont expiré.");

                break;

            case "ERROR_INVALID_EMAIL":
                Services.showDialog(context,context.getString(R.string.error),"L'adresse e-mail est mal formatée.");
                break;

            case "ERROR_WRONG_PASSWORD":
                Services.showDialog(context,context.getString(R.string.error),"Le mot de passe est invalide ou l'utilisateur n'a pas de mot de passe.");

                break;

            case "ERROR_USER_MISMATCH":
                Services.showDialog(context,context.getString(R.string.error),"Les informations d'identification fournies ne correspondent pas à l'utilisateur précédemment connecté.");

                break;

            case "ERROR_REQUIRES_RECENT_LOGIN":
                Services.showDialog(context,context.getString(R.string.error),"Cette opération est sensible et nécessite une authentification récente. Connectez-vous à nouveau avant de réessayer cette demande.");
                break;

            case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
                Services.showDialog(context,context.getString(R.string.error),"Un compte existe déjà avec la même adresse e-mail mais des identifiants de connexion différents. Connectez-vous à l'aide d'un fournisseur associé à cette adresse e-mail.");
                break;

            case "ERROR_EMAIL_ALREADY_IN_USE":
                Services.showDialog(context,context.getString(R.string.error),"L'adresse e-mail est déjà utilisée par un autre compte.");
                break;

            case "ERROR_CREDENTIAL_ALREADY_IN_USE":
                Services.showDialog(context,context.getString(R.string.error),"Ces informations d'identification sont déjà associées à un autre compte utilisateur.");

                break;

            case "ERROR_USER_DISABLED":
                Services.showDialog(context,context.getString(R.string.error),"Le compte utilisateur a été désactivé par un administrateur.");

                break;

            case "ERROR_USER_TOKEN_EXPIRED":
                Services.showDialog(context,context.getString(R.string.error),"L'identifiant de l'utilisateur n'est plus valide. L'utilisateur doit se reconnecter.");
                break;

            case "ERROR_USER_NOT_FOUND":
                Services.showDialog(context,context.getString(R.string.error),"Il n'y a pas de fiche utilisateur correspondant à cet identifiant. L'utilisateur a peut-être été supprimé.");
                break;

            case "ERROR_INVALID_USER_TOKEN":
                Services.showDialog(context,context.getString(R.string.error),"Il n'y a pas de fiche utilisateur correspondant à cet identifiant. L'utilisateur a peut-être été supprimé.");

                break;


            case "ERROR_WEAK_PASSWORD":
                Services.showDialog(context,context.getString(R.string.error),"Le mot de passe donné est invalide.");
                break;

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

    public static void showCenterToast(Context context, String message) {
        Toast toast = Toast.makeText(context, message, Toast.LENGTH_SHORT);
        toast.setGravity(Gravity.CENTER, 0,0);
        toast.show();
    }

    public static void addUserDataOnServer(Context context,String uid,String fullName,String phone, String emailAddress,String nos, String address, String city,String provider){
        Map<String,Object> user = new HashMap<>();
        user.put("uid",uid);
        user.put("fullName",fullName);
        user.put("phone",phone);
        user.put("emailAddress",emailAddress);
        user.put("nos",nos);
        user.put("address",address);
        user.put("city",city);
        user.put("registrationDate", FieldValue.serverTimestamp());

        ProgressHud.show(context,"");
        FirebaseFirestore.getInstance().collection("Parents").document(uid).set(user).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull Task<Void> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    if (provider.equalsIgnoreCase("custom")) {
                        Services.sentEmailVerificationLink(context);
                    }
                    else {
                        Services.getCurrentUserData(context, FirebaseAuth.getInstance().getCurrentUser().getUid(),true);
                    }
                }
                else {
                    showDialog(context, context.getString(R.string.error), task.getException().getLocalizedMessage());
                }
            }
        });
    }

    public static void sentEmailVerificationLink(Context context){
        if (FirebaseAuth.getInstance().getCurrentUser() != null) {
            ProgressHud.show(context,"");
            FirebaseAuth.getInstance().getCurrentUser().sendEmailVerification().addOnCompleteListener(new OnCompleteListener<Void>() {
                @Override
                public void onComplete(@NonNull Task<Void> task) {
                    ProgressHud.dialog.dismiss();

                    if (task.isSuccessful()) {
                        showDialog(context,"Vérifiez votre e-mail","Nous avons envoyé un lien de vérification sur votre adresse e-mail.");
                    }
                    else {
                        showDialog(context, context.getString(R.string.error), task.getException().getLocalizedMessage());
                    }
                }
            });
        }
        else {
            ProgressHud.dialog.dismiss();
        }
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
                if (title.equalsIgnoreCase("Vérifiez votre e-mail")) {
                    if (context instanceof SignUpActivity) {
                        ((SignUpActivity) context).finish();
                    }

                }

            }
        });

        if(!((Activity) context).isFinishing())
        {
            alertDialog.show();

        }

    }
    public static void logout(Context context) {
        FirebaseAuth.getInstance().signOut();
        Intent intent = new Intent(context, MainActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        context.startActivity(intent);
    }

    public static void getCurrentUserData(Context context,String uid, boolean showProgress) {

        if (showProgress) {
            ProgressHud.show(context,"");
        }

        FirebaseFirestore.getInstance().collection("Parents").document(uid).get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
            @Override
            public void onComplete(@NonNull Task<DocumentSnapshot> task) {
                if (showProgress) {
                    ProgressHud.dialog.dismiss();
                }

                if (task.isSuccessful()) {
                    DocumentSnapshot documentSnapshot = task.getResult();
                    if (documentSnapshot != null && documentSnapshot.exists()) {
                        documentSnapshot.toObject(ParentModel.class);

                        if (ParentModel.data != null) {
                            Intent intent = null;
                            intent = new Intent(context, HomeActivity.class);
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                            context.startActivity(intent);

                        }
                        else  {
                            showCenterToast(context,"Quelque chose s'est mal passé. Code - 101");
                        }
                    }
                    else {
                        Intent intent = new Intent(context, AddUserInfoAvitivity.class);
                        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK | Intent.FLAG_ACTIVITY_NEW_TASK);
                        context.startActivity(intent);

                    }
                }
                else {
                    Services.showDialog(context, context.getString(R.string.error), context.getString(R.string.something_went_wrong));

                }

            }
        });
    }
}
