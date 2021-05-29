package in.softment.adminecde.Adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;

import in.softment.adminecde.Models.CategoryModel;
import in.softment.adminecde.R;

public class EditCategoriesAdapter extends RecyclerView.Adapter<EditCategoriesAdapter.ViewHolder> {

    private ArrayList<CategoryModel> categoryModels;
    private Context context;
    public EditCategoriesAdapter(Context context,ArrayList<CategoryModel> categoryModels) {
        this.context = context;
        this.categoryModels = categoryModels;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.edit_categories_layout_view,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {

        CategoryModel categoryModel = categoryModels.get(position);
        holder.cat_title.setText(categoryModel.title);
        holder.cat_edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //Coming Soon
            }
        });
        Glide.with(context).load(categoryModel.image).into(holder.cat_image);
    }

    @Override
    public int getItemCount() {
        return categoryModels.size();
    }

    static public class ViewHolder extends RecyclerView.ViewHolder {
        private ImageView cat_image, cat_edit;
        private TextView cat_title;
        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            cat_edit = itemView.findViewById(R.id.cat_edit);
            cat_image = itemView.findViewById(R.id.cat_image);
            cat_title = itemView.findViewById(R.id.cat_title);
        }
    }
}
