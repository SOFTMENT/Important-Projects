package com.originaldevelopment.rapidcollect;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import com.originaldevelopment.Adapter.LiveChatAdapter;
import com.originaldevelopment.Adapter.RapidTVAdapter;
import com.originaldevelopment.Model.RapidTVModel;

import java.util.ArrayList;
import java.util.List;

public class RapidTV extends AppCompatActivity {
    private List<RapidTVModel> rapidTVModels;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_rapid_t_v);

        RecyclerView recyclerView = findViewById(R.id.recyclerview);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        rapidTVModels = new ArrayList<>();

        ((ImageView)findViewById(R.id.back)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

       RapidTVModel rapidTVModel = new RapidTVModel("Rapid Cash Bundle", "Rapid Cash Bundle, your fully integrated and digital collection solution, powered by Rapid Collect. ", "https://rapidcollect.co.za/Attachment_1586016358.mp4",R.drawable.v2);


        RapidTVModel rapidTVModel1 = new  RapidTVModel("Rapid Collect, Introductory Video",  "Rapid Collect, process explainer video.", "https://rapidcollect.co.za/Attachment_1586016367.mp4",R.drawable.v1);

        RapidTVModel rapidTVModel2 = new RapidTVModel("Introducing the digiMandate", "Welcome to the digiMandate, powered by Rapid Collect", "https://rapidcollect.co.za/Attachment_1586016321.mp4",R.drawable.v3);

        rapidTVModels.add(rapidTVModel1);
        rapidTVModels.add(rapidTVModel);
        rapidTVModels.add(rapidTVModel2);

        RapidTVAdapter rapidTVAdapter = new RapidTVAdapter(this,rapidTVModels);
        recyclerView.setAdapter(rapidTVAdapter);


    }

}
