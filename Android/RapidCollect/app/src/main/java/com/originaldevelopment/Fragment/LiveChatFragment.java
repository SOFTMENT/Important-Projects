package com.originaldevelopment.Fragment;

import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.airbnb.lottie.LottieAnimationView;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.originaldevelopment.Adapter.LiveChatAdapter;
import com.originaldevelopment.Model.ChatModel;
import com.originaldevelopment.rapidcollect.MainActivity;
import com.originaldevelopment.rapidcollect.R;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * A simple {@link Fragment} subclass.
 */
public class LiveChatFragment extends Fragment {

    private LiveChatAdapter liveChatAdapter;
    private Context context;
    private DatabaseReference root;
    private FirebaseAuth firebaseAuth;
    private String uid;
    private List<ChatModel> chatModels;
    private EditText editText;
    RecyclerView recyclerView;
    private LottieAnimationView lottieAnimationView;
    public LiveChatFragment(Context context) {
        // Required empty public constructor
        this.context = context;
        root = FirebaseDatabase.getInstance().getReference().child("Livechat");
        chatModels = new ArrayList<>();

    }

    @Override
    public View onCreateView(LayoutInflater inflater, final ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment

        View view =  inflater.inflate(R.layout.fragment_live_chat, container, false);
        final ImageView sent = view.findViewById(R.id.sent);
        firebaseAuth = FirebaseAuth.getInstance();
        uid = firebaseAuth.getCurrentUser().getUid();
        ImageView back = view.findViewById(R.id.back);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MainActivity) context).changeTabPosition(0);
            }
        });
        lottieAnimationView = view.findViewById(R.id.animation_view);
        editText = view.findViewById(R.id.message);
        sent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sMessage = editText.getText().toString().trim();

                if (!sMessage.isEmpty()) {
                    editText.setText("");
                    sentMessage(sMessage, uid);

                }
                else {

                    editText.requestFocus();
                    editText.setError("Empty");

                }
            }
        });
        recyclerView = view.findViewById(R.id.recyclerview);
        recyclerView.setLayoutManager(new LinearLayoutManager(context));
        recyclerView.setHasFixedSize(true);
        liveChatAdapter = new LiveChatAdapter(context,chatModels,uid);
        recyclerView.setAdapter(liveChatAdapter);

        getdetails();
        return view;
    }

    private void sentMessage(String sMessage, String uid) {
        HashMap<String,String> hashMap = new HashMap<>();
        hashMap.put("message",sMessage);
        hashMap.put("sender",uid);
        root.child(uid).child("admin").child(root.child(uid).push().getKey().toString()).setValue(hashMap);
    }

    private void getdetails() {

        root.child(uid).child("admin").addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(@NonNull DataSnapshot dataSnapshot) {
                chatModels.clear();
                for (DataSnapshot dataSnapshot1 : dataSnapshot.getChildren()) {
                    ChatModel chatModel = dataSnapshot1.getValue(ChatModel.class);

                    chatModels.add(chatModel);

                }
                try {
                    lottieAnimationView.pauseAnimation();
                }
                catch (Exception e) {

                }
                lottieAnimationView.setVisibility(View.GONE);
                if (chatModels.size() > 0)
                recyclerView.smoothScrollToPosition(chatModels.size()-1);
                liveChatAdapter.notifyDataSetChanged();
            }

            @Override
            public void onCancelled(@NonNull DatabaseError databaseError) {

            }
        });
    }


}
