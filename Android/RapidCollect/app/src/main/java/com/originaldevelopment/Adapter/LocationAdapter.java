package com.originaldevelopment.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.originaldevelopment.Model.LocationModel;
import com.originaldevelopment.rapidcollect.R;

import java.util.List;

public class LocationAdapter extends RecyclerView.Adapter<LocationAdapter.ViewHolder> {
    private Context context;
    private List<LocationModel> locationModels;
    public LocationAdapter(Context context, List<LocationModel> locationModels) {
        this.context = context;
        this.locationModels = locationModels;
    }

    @NonNull
    @Override
    public LocationAdapter.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(context).inflate(R.layout.location_row,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull LocationAdapter.ViewHolder holder, int position) {
        LocationModel locationModel = locationModels.get(position);
            holder.title.setText(locationModel.message);
            holder.date.setText(locationModel.date);
    }

    @Override
    public int getItemCount() {
        return locationModels.size();
    }

    public static class ViewHolder extends  RecyclerView.ViewHolder {
        private TextView title, date;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            title = itemView.findViewById(R.id.title);
            date = itemView.findViewById(R.id.date);
        }
    }
}
