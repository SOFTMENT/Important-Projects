package com.originaldevelopment.rapidcollect;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;

import com.airbnb.lottie.LottieAnimationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.originaldevelopment.Adapter.LocationAdapter;
import com.originaldevelopment.Model.LocationModel;

import java.util.ArrayList;
import java.util.List;

public class LocationHistory extends AppCompatActivity {
    private List<LocationModel> locationModels;
    private LocationAdapter locationAdapter;
    private DatabaseReference root;
    private LottieAnimationView lottieAnimationView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_location_history);

        RecyclerView recyclerView = findViewById(R.id.recyclerview);
        recyclerView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager  = new LinearLayoutManager(this);
        linearLayoutManager.setReverseLayout(true);
        linearLayoutManager.setStackFromEnd(true);
        recyclerView.setLayoutManager(linearLayoutManager);
        locationModels = new ArrayList<>();
        locationAdapter = new LocationAdapter(this, locationModels);
        recyclerView.setAdapter(locationAdapter);
        root = FirebaseDatabase.getInstance().getReference().child("LocationHistory");

        lottieAnimationView = findViewById(R.id.animation_view);
        ImageView back = findViewById(R.id.back);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        getDetails();




    }


    private void getDetails() {

        root.child(FirebaseAuth.getInstance().getCurrentUser().getUid()).limitToLast(25).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                try {
                    lottieAnimationView.pauseAnimation();
                }
                catch (Exception e){

                }
                lottieAnimationView.setVisibility(View.GONE);

                for (DataSnapshot dataSnapshot1 : dataSnapshot.getChildren()) {
                    LocationModel locationModel = dataSnapshot1.getValue(LocationModel.class);
                    locationModels.add(locationModel);
                }
                locationAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }
}