package in.softment.straightline.Fragment;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.DefaultItemAnimator;
import androidx.recyclerview.widget.DiffUtil;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.LinearInterpolator;
import android.widget.TextView;
import android.widget.Toast;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.List;


import in.softment.straightline.Adapter.HomeAdapter;
import in.softment.straightline.MainActivity;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.TrackImagesModel;
import in.softment.straightline.R;
import in.softment.straightline.SeeAllChallengeActivity;
import in.softment.straightline.Utils.KKViewPager;


public class HomeFragment extends Fragment {


    private Context context;
    private List<TrackImagesModel> trackImages;
    private ArrayList<ChallnageModel> challnageModels;
    private HomeAdapter adapter;
    private KKViewPager viewPager;
    private TextView no_challenge_available;
    public HomeFragment(Context context){
        this.context = context;
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_home, container, false);


        challnageModels = ChallnageModel.challnageModels;
        trackImages = TrackImagesModel.trackImagesModels;
        viewPager = view.findViewById(R.id.viewpager);

        view.findViewById(R.id.seeall).setOnClickListener(v -> {
            context.startActivity(new Intent(context, SeeAllChallengeActivity.class));
        });

        no_challenge_available = view.findViewById(R.id.no_challenge_availble);

        return view;
    }


    public void notifyAdapter(){
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