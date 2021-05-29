package com.originaldevelopment.Adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.RecyclerView;
import androidx.viewpager.widget.PagerAdapter;


import com.originaldevelopment.Fragment.ToDoFragment;
import com.originaldevelopment.Model.ToDoModel;
import com.originaldevelopment.rapidcollect.R;

import java.util.List;

public class ToDoAdapter extends RecyclerView.Adapter<ToDoAdapter.MyViewHolder> {
    private Context context;
    private List<ToDoModel> toDoModels;
    private boolean isDelete;
    private ToDoFragment toDoFragment;
    public ToDoAdapter(Context context, List<ToDoModel> toDoModels, ToDoFragment toDoFragment) {
        this.context = context;
        this.toDoModels = toDoModels;
        this.toDoFragment = toDoFragment;

    }


    @NonNull
    @Override
    public ToDoAdapter.MyViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new MyViewHolder(LayoutInflater.from(context).inflate(R.layout.todorow,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull ToDoAdapter.MyViewHolder holder, final int position) {
            holder.setIsRecyclable(false);
            ToDoModel toDoModel = toDoModels.get(position);
            holder.name.setText(toDoModel.getName());

            if (!toDoModel.isComplete()) {
                holder.status.setText("Incomplete");
                holder.status.setTextColor(context.getColor(R.color.colorPrimary));

            }
            else {

                holder.status.setText("Complete");
                holder.status.setTextColor(context.getColor(R.color.complete));
            }
            if (isDelete) {
                holder.delete.setVisibility(View.VISIBLE);

                holder.delete.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                    toDoFragment.deleteData(position);
                    }
                });
            }
            else {
                holder.delete.setVisibility(View.GONE);
            }
            holder.view.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    toDoFragment.showData(position);
                }
            });

    }

    @Override
    public int getItemCount() {
        return toDoModels.size();
    }

    public class MyViewHolder extends RecyclerView.ViewHolder {

        private View view;
        private TextView name, status;
        private ImageView delete;

        public MyViewHolder(@NonNull View itemView) {
            super(itemView);
            view = itemView;
            name = view.findViewById(R.id.name);
            status = view.findViewById(R.id.status);
            delete = view.findViewById(R.id.delete);



        }
    }

    public void setDelete(boolean b) {
        if (b) {
            isDelete = true;
            notifyDataSetChanged();

        }
        else {
         isDelete = false;
            notifyDataSetChanged();

        }

    }
}
