package com.originaldevelopment.wallpaper;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;


import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.request.RequestOptions;


import java.util.List;

public class RecyclerViewAdapter extends RecyclerView.Adapter<RecyclerViewAdapter.MyViewHolder> {

    private List<Url> images;
    Context context;
    public RecyclerViewAdapter(Context context, List<Url> images) {
        this.images = images;
        this.context = context;
    }

    @NonNull
    @Override
    public RecyclerViewAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.recyclerviewitem,parent,false);
        return new MyViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerViewAdapter.MyViewHolder holder, final int position) {
        RequestOptions requestOptions = new RequestOptions().diskCacheStrategy(DiskCacheStrategy.ALL);
            Glide.with(context).load(images.get(position).getThumbnail()).centerCrop().placeholder(R.drawable.aloading).apply(requestOptions).into(holder.imageView);

            holder.view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(context,ShowImage.class);
                    intent.putExtra("url",images.get(position).getHigh());
                    intent.putExtra("ourl",images.get(position).getUrl());
                    intent.putExtra("medium",images.get(position).getMedium());
                    intent.putExtra("thum",images.get(position).getThumbnail());
                    context.startActivity(intent);
                }
            });

    }

    @Override
    public int getItemCount() {
        return images.size();
    }


    static class MyViewHolder extends  RecyclerView.ViewHolder {
        ImageView imageView;
        View view;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            view = itemView;
            imageView =  itemView.findViewById(R.id.imageview);



        }


    }
}
