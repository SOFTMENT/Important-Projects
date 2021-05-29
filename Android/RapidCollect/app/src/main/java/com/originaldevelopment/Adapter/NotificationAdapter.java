package com.originaldevelopment.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.originaldevelopment.Model.NotificationModel;
import com.originaldevelopment.rapidcollect.R;
import java.util.List;

public class NotificationAdapter extends RecyclerView.Adapter<NotificationAdapter.MyViewHolder> {
    private Context context;
    private List<NotificationModel> notificationModels;


    public NotificationAdapter(Context context, List<NotificationModel> notificationModels) {
        this.context = context;
        this.notificationModels = notificationModels;

    }

    @NonNull
    @Override
    public NotificationAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new MyViewHolder(LayoutInflater.from(context).inflate(R.layout.notification_row,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull NotificationAdapter.MyViewHolder holder, int position) {
        holder.title.setText(notificationModels.get(position).title);
        holder.message.setText(notificationModels.get(position).message);
    }

    @Override
    public int getItemCount() {
        return notificationModels.size();
    }

    public static class MyViewHolder extends RecyclerView.ViewHolder {
        private TextView title, message;
        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            this.title = itemView.findViewById(R.id.title);
            this.message = itemView.findViewById(R.id.message);
        }
    }
}
