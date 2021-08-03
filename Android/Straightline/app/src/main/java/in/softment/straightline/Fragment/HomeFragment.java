package in.softment.straightline.Fragment;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.AppCompatButton;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.DiffUtil;

import android.text.SpannableString;
import android.text.style.UnderlineSpan;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.LinearInterpolator;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.SetOptions;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import in.softment.straightline.Adapter.HomeAdapter;
import in.softment.straightline.MainActivity;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.TrackImagesModel;
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.R;
import in.softment.straightline.SeeAllChallengeActivity;
import in.softment.straightline.ToastType;
import in.softment.straightline.Utils.KKViewPager;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;


public class HomeFragment extends Fragment {


    private Context context;
    private List<TrackImagesModel> trackImages;
    private ArrayList<ChallnageModel> challnageModels;
    private HomeAdapter adapter;
    private KKViewPager viewPager;
    private TextView no_challenge_available;
    private LinearLayout totalMiles;
    private TextView totalMilesText;
    public HomeFragment(Context context){
        this.context = context;
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_home, container, false);


        challnageModels = new ArrayList<>();
        trackImages = TrackImagesModel.trackImagesModels;
        viewPager = view.findViewById(R.id.viewpager);

       totalMiles = view.findViewById(R.id.totalMiles);
       totalMilesText = view.findViewById(R.id.totalMilesText);
        setUI();
        totalMiles.setOnClickListener(v -> {
            AlertDialog.Builder builder = new AlertDialog.Builder(context);
            View view1 = getLayoutInflater().inflate(R.layout.change_miles_layout,null);
            EditText etMiles = view1.findViewById(R.id.enterMiles);
            AppCompatButton update = view1.findViewById(R.id.update);
            AppCompatButton seeAll = view1.findViewById(R.id.showAll);
            AlertDialog alertDialog = builder.create();
            alertDialog.setView(view1);
            update.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    String sMiles = etMiles.getText().toString().trim();
                    if (sMiles.isEmpty()) {
                        Services.showCenterToast(context, ToastType.WARNING,"Enter Miles");
                        return;
                    }
                    int miles = Integer.parseInt(sMiles);
                    Map map = new HashMap();
                    map.put("miles", miles);
                    alertDialog.dismiss();
                    ProgressHud.show(context,"");
                    FirebaseFirestore.getInstance().collection("Users").document(UserModel.data.uid).set(map, SetOptions.merge()).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull @NotNull Task<Void> task) {

                                 ProgressHud.dialog.dismiss();
                                 UserModel.data.miles = miles;
                                 Services.showCenterToast(context,ToastType.SUCCESS,"Miles Updated");
                                 notifyAdapter();
                                 setUI();

                        }
                    });
                }
            });

            seeAll.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    int miles = -1;
                    Map map = new HashMap();
                    map.put("miles", miles);
                    alertDialog.dismiss();
                    ProgressHud.show(context,"");
                    FirebaseFirestore.getInstance().collection("Users").document(UserModel.data.uid).set(map, SetOptions.merge()).addOnCompleteListener(new OnCompleteListener<Void>() {
                        @Override
                        public void onComplete(@NonNull @NotNull Task<Void> task) {

                            ProgressHud.dialog.dismiss();
                            UserModel.data.miles = miles;
                            Services.showCenterToast(context,ToastType.SUCCESS,"Miles Updated");
                            notifyAdapter();
                            setUI();

                        }
                    });
                }

            });

            alertDialog.show();

        });

        no_challenge_available = view.findViewById(R.id.no_challenge_availble);

        return view;
    }



    public void setUI(){
        int miles = UserModel.data.getMiles();
        if (miles == -1) {
            SpannableString content = new SpannableString("All Challenges");
            content.setSpan(new UnderlineSpan(), 0, content.length(), 0);
            totalMilesText.setText(content);
        }
        else {

            SpannableString content = new SpannableString(miles+" Miles");
            content.setSpan(new UnderlineSpan(), 0, content.length(), 0);
            totalMilesText.setText(content);
        }

    }

    public void notifyAdapter(){
        challnageModels.clear();
        challnageModels.addAll(ChallnageModel.filterChallengesBasedOnMiles(UserModel.data.getMiles()));

        if (challnageModels.size() > 0) {
            no_challenge_available.setVisibility(View.GONE);
        }
        else{
            no_challenge_available.setVisibility(View.VISIBLE);
        }
        adapter = new HomeAdapter(context,challnageModels, trackImages);
        viewPager.setAdapter(adapter);
        viewPager.setPadding(10, 0, 130, 0);
        viewPager.setAnimationEnabled(true);
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onAttach(@NonNull @NotNull Context context) {
        super.onAttach(context);
        ((MainActivity)context).initializeHomeFragment(this);
    }
}