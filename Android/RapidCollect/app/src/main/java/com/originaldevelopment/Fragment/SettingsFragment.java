package com.originaldevelopment.Fragment;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.fragment.app.Fragment;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Switch;

import com.originaldevelopment.rapidcollect.MainActivity;
import com.originaldevelopment.rapidcollect.R;
import com.originaldevelopment.rapidcollect.WebViewActivity;

/**
 * A simple {@link Fragment} subclass.
 */
public class SettingsFragment extends Fragment {

    private SharedPreferences sharedPreferences;
    private Context context;

    public SettingsFragment(Context context) {
        // Required empty public constructor
        this.context = context;
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view =  inflater.inflate(R.layout.fragment_settings, container, false);
        ImageView back = view.findViewById(R.id.back);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MainActivity) context).changeTabPosition(0);
            }
        });

        RelativeLayout about = view.findViewById(R.id.about);
        RelativeLayout terms = view.findViewById(R.id.terms);

        about.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("ABOUT US");
            }
        });

        terms.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("TERMS & CONDITIONS");
            }
        });

        sharedPreferences = context.getSharedPreferences("switchnoti",Context.MODE_PRIVATE);
        Switch s  = view.findViewById(R.id.notification);
        s.setChecked(true);
        s.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean b) {
                sharedPreferences.edit().putBoolean("isEnable",b).apply();
            }
        });

        if (sharedPreferences.getBoolean("isEnable",true)) {
            s.setChecked(true);
        }
        else {
            s.setChecked(false);
        }



        return view;
    }

    public void gotoWeb(String title) {
        Intent intent = new Intent(context, WebViewActivity.class);
        intent.putExtra("title",title);
        startActivity(intent);
    }

}
