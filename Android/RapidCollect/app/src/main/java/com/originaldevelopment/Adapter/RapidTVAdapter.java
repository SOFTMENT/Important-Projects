package com.originaldevelopment.Adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.appunite.appunitevideoplayer.PlayerActivity;
import com.originaldevelopment.Fragment.HomeFragment;
import com.originaldevelopment.Model.RapidTVModel;
import com.originaldevelopment.rapidcollect.MainActivity;
import com.originaldevelopment.rapidcollect.R;
import com.originaldevelopment.rapidcollect.RapidTV;

import java.util.List;

public class RapidTVAdapter extends RecyclerView.Adapter<RapidTVAdapter.MyViewHolder> {
    private Context context;
    private List<RapidTVModel> rapidTVModels;
    public RapidTVAdapter(Context context, List<RapidTVModel> rapidTVModels){
        this.context = context;
        this.rapidTVModels = rapidTVModels;
    }

    @NonNull
    @Override
    public RapidTVAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new MyViewHolder(LayoutInflater.from(context).inflate(R.layout.rapidtvrow,parent,false));

    }

    @Override
    public void onBindViewHolder(@NonNull RapidTVAdapter.MyViewHolder holder, int position) {
        final RapidTVModel rapidTVModel = rapidTVModels.get(position);
            holder.title.setText(rapidTVModel.getTitle());
            holder.desc.setText(rapidTVModel.getDesc());
            holder.imageView.setImageResource(rapidTVModel.getImage());
            holder.view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    context.startActivity(PlayerActivity.getVideoPlayerIntent(context,
                            rapidTVModel.getVideoUrl(),
                            rapidTVModel.getTitle()));
                }
            });
    }

    @Override
    public int getItemCount() {
        return rapidTVModels.size();
    }

    static class MyViewHolder extends RecyclerView.ViewHolder {
        private TextView title, desc;
        private ImageView imageView;
        private View view;
        MyViewHolder(@NonNull View itemView) {
            super(itemView);
            view = itemView;
            title = view.findViewById(R.id.title);
            desc = view.findViewById(R.id.details);
            imageView = view.findViewById(R.id.imageview);

        }
    }
}
