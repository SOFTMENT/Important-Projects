package com.originaldevelopment.Adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.google.firebase.auth.FirebaseAuth;
import com.originaldevelopment.Model.ChatModel;
import com.originaldevelopment.rapidcollect.R;

import java.util.List;

public class LiveChatAdapter extends RecyclerView.Adapter<LiveChatAdapter.MyHolder> {

    private int LEFT_MESSAGE = 0;
    private int RIGHT_MESSAGE = 1;
    private List<ChatModel> chatModels;
    private Context context;
    private String uid = "";
    public LiveChatAdapter(Context  context, List<ChatModel> chatModels,String uid) {
        this.context = context;
        this.chatModels = chatModels;
        this.uid = uid;
    }

    @NonNull
    @Override
    public LiveChatAdapter.MyHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == LEFT_MESSAGE) {
            return new MyHolder(LayoutInflater.from(context).inflate(R.layout.left_message, parent, false));
        }
        else {
            return new MyHolder(LayoutInflater.from(context).inflate(R.layout.right_message, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(@NonNull LiveChatAdapter.MyHolder holder, int position) {

        holder.message.setText(chatModels.get(position).getMessage());

    }

    @Override
    public int getItemCount() {
        return chatModels.size();
    }

    static class MyHolder extends RecyclerView.ViewHolder {
        private TextView message;
        MyHolder(@NonNull View itemView) {
            super(itemView);
            message = itemView.findViewById(R.id.message);

        }
    }

    @Override
    public int getItemViewType(int position) {
        if (chatModels.get(position).getSender().equals(uid)) {
            return RIGHT_MESSAGE;
        }
        else {
            return LEFT_MESSAGE;
        }
    }
}
