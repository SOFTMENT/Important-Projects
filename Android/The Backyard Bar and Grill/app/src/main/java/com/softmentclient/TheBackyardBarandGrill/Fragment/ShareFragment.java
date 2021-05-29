package com.softmentclient.TheBackyardBarandGrill.Fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.fragment.app.Fragment;

import com.softmentclient.TheBackyardBarandGrill.MainActivity;
import com.softmentclient.TheBackyardBarandGrill.R;


public class ShareFragment extends Fragment {

    MainActivity context;
   public ShareFragment(MainActivity context) {
      this.context = context;
   }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        return inflater.inflate(R.layout.fragment_home, container, false);
    }



}