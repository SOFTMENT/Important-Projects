package in.softment.straightline.Adapter;

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.VideoView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatButton;
import androidx.recyclerview.widget.RecyclerView;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

import in.softment.straightline.Model.LastMessageModel;
import in.softment.straightline.Model.VideoModel;
import in.softment.straightline.R;
import in.softment.straightline.Utils.Services;
import in.softment.straightline.VideoViewActivity;

public class VideosAdapter extends RecyclerView.Adapter<VideosAdapter.ViewHolder> {

    private Context context;
    private ArrayList<VideoModel> videoModels;

    public VideosAdapter(Context context, ArrayList<VideoModel> videoModels){
        this.videoModels = videoModels;
        this.context = context;
    }

    @NonNull
    @NotNull
    @Override
    public VideosAdapter.ViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.video_layout,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull VideosAdapter.ViewHolder holder, int position) {
        holder.setIsRecyclable(false);
        VideoModel videoModel = videoModels.get(position);
        holder.title.setText(videoModel.getTitle());
        holder.time.setText(Services.convertDateToTimeString(videoModel.time));
        holder.place.setText(videoModel.location);
        holder.watchVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, VideoViewActivity.class);
                intent.putExtra("url",videoModel.url);
                context.startActivity(intent);
            }
        });
    }

    @Override
    public int getItemCount() {
        return videoModels.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        TextView title, time, place;
        AppCompatButton watchVideo;
        public ViewHolder(@NonNull @NotNull View itemView) {
            super(itemView);
            time = itemView.findViewById(R.id.time);
            place = itemView.findViewById(R.id.place);
            title = itemView.findViewById(R.id.title);
            watchVideo = itemView.findViewById(R.id.watch);
        }
    }

    public void filter(String text,ArrayList<VideoModel> videoModels) {
        ArrayList<VideoModel> newlastMessageModels = new ArrayList<>();

        for (VideoModel lastMessageModel : videoModels) {

            if (lastMessageModel.getTitle().toLowerCase().contains(text.toLowerCase())) {
                newlastMessageModels.add(lastMessageModel);
            }
        }
        videoModels.clear();
        videoModels.addAll(newlastMessageModels);
        notifyDataSetChanged();
    }
}
