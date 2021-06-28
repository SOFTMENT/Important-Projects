package in.softment.straightline.Adapter;


import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupMenu;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.AppCompatButton;
import androidx.cardview.widget.CardView;
import androidx.viewpager.widget.PagerAdapter;

import com.bumptech.glide.Glide;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;
import com.makeramen.roundedimageview.RoundedImageView;

import org.jetbrains.annotations.NotNull;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import de.hdodenhof.circleimageview.CircleImageView;
import in.softment.straightline.ChatScreenActivity;
import in.softment.straightline.MainActivity;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.TrackImagesModel;
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.R;
import in.softment.straightline.ToastType;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

public class HomeAdapter extends PagerAdapter {


    private Context context;
    private ArrayList<ChallnageModel> challnageModels;
    private List<TrackImagesModel> trackImages;



    public HomeAdapter(Context context,ArrayList<ChallnageModel> challnageModels, List<TrackImagesModel> trackImages) {

        this.context = context;
        this.challnageModels = challnageModels;
        this.trackImages = trackImages;


    }

    @Override
    public int getCount() {
        return challnageModels.size();
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view.equals(object);
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, final int position) {
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View view = layoutInflater.inflate(R.layout.home_item_layout, container, false);


        ImageView imageView,more;
        CircleImageView profilePicture;
        TextView name, email, place, title, time, message;
        AppCompatButton acceptChallnage;
        RoundedImageView vehicleImage;

        vehicleImage = view.findViewById(R.id.vehicleImage);
        imageView = view.findViewById(R.id.image);
        more = view.findViewById(R.id.more);
        profilePicture = view.findViewById(R.id.profilePicture);
        name = view.findViewById(R.id.name);
        email = view.findViewById(R.id.email);
        place = view.findViewById(R.id.place);
        title = view.findViewById(R.id.title);
        time = view.findViewById(R.id.time);
        message = view.findViewById(R.id.message);
        acceptChallnage = view.findViewById(R.id.acceptChallenge);


        try {
            Glide.with(context).load(trackImages.get(position%trackImages.size()).getUrl()).placeholder(R.drawable.track2).into(imageView);
        }
        catch (Exception e) {
            imageView.setImageResource(R.drawable.track2);
        }



        ChallnageModel challnageModel = challnageModels.get(position);

        Glide.with(context).load(challnageModel.getVehicleImage()).placeholder(R.drawable.placeholder1).into(vehicleImage);

        Glide.with(context).load(challnageModel.profileImage).placeholder(R.drawable.placeholder).into(profilePicture);
        name.setText(challnageModel.getName());

        email.setText(challnageModel.getEmail());
        more.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showPopupMenu(more,challnageModel.cid, challnageModel.name);
            }
        });

       FirebaseFirestore.getInstance().collection("Challenges").document(challnageModel.cid).collection("Accepted").document(UserModel.data.uid).get().addOnCompleteListener(new OnCompleteListener<DocumentSnapshot>() {
            @Override
            public void onComplete(@NonNull @NotNull Task<DocumentSnapshot> task) {
                if (task.isSuccessful()) {
                    DocumentSnapshot document = task.getResult();
                    if (document.exists()) {
                       acceptChallnage.setEnabled(false);
                       acceptChallnage.setText("Accepted");
                    } else {
                        acceptChallnage.setEnabled(true);
                        acceptChallnage.setText("Accept Challenge");
                    }
                }
            }
        });


        place.setText(challnageModel.location);
        title.setText(challnageModel.title);
        time.setText(Services.convertDateToTimeString(challnageModel.time));
        message.setText(challnageModel.message);



            acceptChallnage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {

                    if (challnageModel.uid.equals(UserModel.data.uid)) {
                        Services.showDialog(context,"NOTE","You can not accept you own challenge.");

                    }
                    else {
                        acceptChallnage.setEnabled(false);
                        acceptChallnage.setText("Accepted");
                        acceptChallenge(challnageModel.cid, challnageModel.name, challnageModel.profileImage, challnageModel.uid, challnageModel.token, challnageModel.title);
                    }
                }
            });







        container.addView(view, 0);
        return view;
    }

    private void showPopupMenu(ImageView more,String cid, String name){
        PopupMenu popupMenu = new PopupMenu(context,more);
        popupMenu.getMenuInflater().inflate(R.menu.chatscreen_popup_menu,popupMenu.getMenu());
        popupMenu.setOnMenuItemClickListener(item -> {

            if (item.getItemId() == R.id.report) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                View view1 = ((MainActivity)context).getLayoutInflater().inflate(R.layout.report_reason_layout,null);
                AlertDialog alertDialog = builder.create();
                alertDialog.setView(view1);
                final EditText message = view1.findViewById(R.id.entermessage);
                CardView report = view1.findViewById(R.id.sentnotification);
                report.setOnClickListener(v -> {

                    String sMessage = message.getText().toString().trim();
                    if (!sMessage.equals("")) {
                        alertDialog.dismiss();
                        reportUser(sMessage,cid,name);
                    }
                    else {
                        Services.showCenterToast(context,ToastType.WARNING,"Enter Reason");
                    }

                });

                alertDialog.show();

            }
            return true;
        });
        popupMenu.show();
    }

    private void reportUser(String reason, String cid, String awayName){
        Map<String, String> map = new HashMap<>();
        map.put("reason",reason);
        map.put("challengeid",cid);
        map.put("username",awayName);
        FirebaseFirestore.getInstance().collection("ReportChallegne").document().set(map);

        Services.showDialog(context,"REPORTED","Thanks for reporting, Our internal team will check this issue.");
    }
    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
        container.removeView((View)object);

    }

    public void acceptChallenge(String cid, String awayName, String awayProfile, String awayUid, String awayToken,String challengeTitle){
        ProgressHud.show(context,"");
        Map<String, String> map = new HashMap<>();
        map.put("fullName", UserModel.data.fullName);
        map.put("profileImage",UserModel.data.profileImage);
        map.put("token",UserModel.data.token);
        map.put("uid",UserModel.data.uid);
        map.put("emailAddress",UserModel.data.emailAddress);
        DocumentReference documentReference = FirebaseFirestore.getInstance().collection("Challenges").document(cid).collection("Accepted").document(UserModel.data.uid);

        documentReference.set(map).addOnCompleteListener(new OnCompleteListener<Void>() {
            @Override
            public void onComplete(@NonNull @NotNull Task<Void> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {

                    Services.showCenterToast(context, ToastType.SUCCESS,"Challenge Accepted");
                    Intent intent = new Intent(context, ChatScreenActivity.class);
                    intent.putExtra("awayId",awayUid);
                    intent.putExtra("awayProfile",awayProfile);
                    intent.putExtra("awayName",awayName);
                    intent.putExtra("awayToken",awayToken);
                    intent.putExtra("ChallengeTitle",challengeTitle);
                    intent.putExtra("firstTime",true);
                    context.startActivity(intent);

                }
                else {
                    Services.showDialog(context,"ERROR", Objects.requireNonNull(task.getException()).getLocalizedMessage());
                }
            }
        });
    }


}
