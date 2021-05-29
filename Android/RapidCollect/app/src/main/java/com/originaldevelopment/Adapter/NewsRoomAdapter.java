package com.originaldevelopment.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.originaldevelopment.NewsRoomWordpress.NewsRoomWordpress;
import com.originaldevelopment.rapidcollect.R;
import com.originaldevelopment.rapidcollect.ShowNewsRoomContent;

import java.util.List;

public class NewsRoomAdapter extends RecyclerView.Adapter<NewsRoomAdapter.ViewHolder> {

    private Context context;
    private List<NewsRoomWordpress> newsRoomWordpresses;
    public NewsRoomAdapter(Context context, List<NewsRoomWordpress> newsRoomWordpresses) {
        this.context = context;
        this.newsRoomWordpresses = newsRoomWordpresses;
    }

    @NonNull
    @Override
    public NewsRoomAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(context).inflate(R.layout.news_room_row,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull NewsRoomAdapter.ViewHolder holder, int position) {
        holder.setIsRecyclable(false);
        NewsRoomWordpress newsRoomWordpress =  newsRoomWordpresses.get(position);
        Glide.with(context).load(newsRoomWordpress.getEmbedded().getWpFeaturedmedia().get(0).getMediaDetails().getSizes().getMedium().getSourceUrl()).into(holder.imageView);
        holder.title.setText(newsRoomWordpress.getTitle().getRendered());
        holder.date.setText(newsRoomWordpress.getDate().substring(0,10));
        holder.view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, ShowNewsRoomContent.class);
                intent.putExtra("title", newsRoomWordpress.getTitle().getRendered());
                intent.putExtra("content", newsRoomWordpress.getContent().getRendered());
                intent.putExtra("date", newsRoomWordpress.getDate().substring(0,10));
                intent.putExtra("image", newsRoomWordpress.getEmbedded().getWpFeaturedmedia().get(0).getMediaDetails().getSizes().getFull().getSourceUrl());


                context.startActivity(intent);
            }
        });
    }

    @Override
    public int getItemCount() {
        return newsRoomWordpresses.size();
    }

    static class ViewHolder extends RecyclerView.ViewHolder {
        private ImageView imageView;
        private TextView title, date;
        private View view;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            view = itemView;
            imageView = itemView.findViewById(R.id.imageview);
            title = itemView.findViewById(R.id.title);
            date = itemView.findViewById(R.id.date);

        }
    }
}
