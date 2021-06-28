package in.softment.straightline.Fragment;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.fragment.app.Fragment;

import android.provider.MediaStore;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.canhub.cropper.CropImage;
import com.canhub.cropper.CropImageView;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.FirebaseFirestore;

import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.util.Objects;

import de.hdodenhof.circleimageview.CircleImageView;
import in.softment.straightline.BuildConfig;
import in.softment.straightline.CreateChallange;
import in.softment.straightline.MainActivity;
import in.softment.straightline.ManageChallengeActivity;
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.R;
import in.softment.straightline.SignInActivity;
import in.softment.straightline.ToastType;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

import static android.app.Activity.RESULT_OK;

public class ProfileFragment extends Fragment {

    private Context context;
    CircleImageView circleImageView;
    Uri resultUri;
    public ProfileFragment(Context context){
        this.context = context;
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_profile, container, false);

        //CREATE CHALLENGE
        view.findViewById(R.id.createChallange).setOnClickListener(v -> {
            startActivity(new Intent(context, CreateChallange.class));

        });

        TextView versionName = view.findViewById(R.id.versionName);
        try {
            PackageInfo pInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            String version = pInfo.versionName;
            versionName.setText(version);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        //Logout
        view.findViewById(R.id.logout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Services.logout(context);
            }
        });
        circleImageView = view.findViewById(R.id.profile_image);
        circleImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                CropImage.activity()
                        .setGuidelines(CropImageView.Guidelines.ON)
                        .setAspectRatio(1,1)
                        .start((Activity) context);

            }
        });
        TextView name = view.findViewById(R.id.name);
        TextView email = view.findViewById(R.id.email);
        Glide.with(context).load(UserModel.data.profileImage).diskCacheStrategy(DiskCacheStrategy.DATA).placeholder(R.drawable.placeholder).into(circleImageView);
        name.setText(UserModel.data.fullName);
        email.setText(UserModel.data.emailAddress);

        //ShareApp
        view.findViewById(R.id.shareApp).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    Intent shareIntent = new Intent(Intent.ACTION_SEND);
                    shareIntent.setType("text/plain");
                    shareIntent.putExtra(Intent.EXTRA_SUBJECT, "Esquerda Compra Da Esquerda");
                    String shareMessage= "\nLet me recommend you this application\n\n";
                    shareMessage = shareMessage + "https://play.google.com/store/apps/details?id=" + BuildConfig.APPLICATION_ID +"\n\n";
                    shareIntent.putExtra(Intent.EXTRA_TEXT, shareMessage);
                    startActivity(Intent.createChooser(shareIntent, "choose one"));
                } catch(Exception e) {
                    //e.toString();
                }
            }
        });


        //PrivacyPolicy
        view.findViewById(R.id.privacypolicy).setOnClickListener(v -> {

        });

        //Terms&Conditions
        view.findViewById(R.id.termsandcondition).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

        //AppDeveloper
        view.findViewById(R.id.developer).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW,
                        Uri.parse("http://www.softment.in"));
                startActivity(browserIntent);
            }
        });

        //RateUs
        view.findViewById(R.id.rateUs).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = Uri.parse("market://details?id=" + context.getPackageName());
                Intent myAppLinkToMarket = new Intent(Intent.ACTION_VIEW, uri);
                try {
                    startActivity(myAppLinkToMarket);
                } catch (ActivityNotFoundException e) {
                    Toast.makeText(context, " unable to find market app", Toast.LENGTH_LONG).show();
                }
            }
        });

        view.findViewById(R.id.myChallenge).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, ManageChallengeActivity.class));
            }
        });


        //DeleteAccount
        view.findViewById(R.id.deleteAccount).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context,R.style.MyTimePickerDialogTheme);
                builder.setTitle("Delete");
                builder.setMessage("Are you sure you want to delete your account?");
                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        ProgressHud.show(context,"Deleting...");
                        FirebaseFirestore.getInstance().collection("Users").document(UserModel.data.uid).delete().addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull @NotNull Task<Void> task) {
                                if (task.isSuccessful()) {
                                    Objects.requireNonNull(FirebaseAuth.getInstance().getCurrentUser()).delete().addOnCompleteListener(new OnCompleteListener<Void>() {
                                        @Override
                                        public void onComplete(@NonNull @NotNull Task<Void> task) {
                                            ProgressHud.dialog.dismiss();
                                            if (task.isSuccessful()) {
                                                    Services.logout(context);
                                                }
                                            else{
                                                Services.showDialog(context,"ERROR",task.getException().getLocalizedMessage());
                                            }
                                        }
                                    });
                                }
                                else {
                                    Services.showDialog(context,"ERROR",task.getException().getLocalizedMessage());
                                    ProgressHud.dialog.dismiss();
                                }
                            }
                        });
                        dialog.dismiss();
                    }
                });

                builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                });

                builder.show();
            }
        });

        //ContactUs
        view.findViewById(R.id.contactUs).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });



        return view;
    }

    public void cropURI(Uri resultUri) {
        Bitmap bitmap = null;
        try {

            bitmap = MediaStore.Images.Media.getBitmap(context.getContentResolver(), resultUri);
            circleImageView.setImageBitmap(bitmap);
            Services.uploadImageOnFirebase(context,UserModel.data.uid,resultUri);

        } catch (IOException e) {
            Log.d("ERROR",e.getLocalizedMessage());
        }
    }


    @Override
    public void onAttach(@NonNull @NotNull Context context) {
        super.onAttach(context);
        ((MainActivity)context).initializeProfileFragment(this);
    }
}