package in.softment.adminecde.Adapters;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.makeramen.roundedimageview.RoundedImageView;

import java.util.ArrayList;

import in.softment.adminecde.Models.CategoryModel;
import in.softment.adminecde.R;

public class CategoriesAdaper  extends RecyclerView.Adapter<CategoriesAdaper.ViewHolder> {

   private Context context;
   private ArrayList<Drawable> categories_back_view;
   private ArrayList<CategoryModel> categoryModels;

    public CategoriesAdaper(Context context,ArrayList<Drawable> categories_back_view,ArrayList<CategoryModel> categoryModels){
        this.context = context;
        this.categories_back_view = categories_back_view;
        this.categoryModels = categoryModels;
    }
    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.categories_layout_view,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {

        CategoryModel categoryModel = categoryModels.get(position);
        holder.cat_image_rr.setBackground(categories_back_view.get(position % categories_back_view.size()));
        Glide.with(context).load(categoryModel.image).into(holder.cat_image);
        holder.cat_title.setText(categoryModel.title);

    }

    @Override
    public int getItemCount() {
        return categoryModels.size();
    }

    static public class ViewHolder extends RecyclerView.ViewHolder {

        private RelativeLayout cat_image_rr;
        private ImageView cat_image;
        private TextView cat_title;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            cat_image_rr = itemView.findViewById(R.id.cat_image_rr);
            cat_image = itemView.findViewById(R.id.cat_image);
            cat_title = itemView.findViewById(R.id.cat_title);
        }
    }
}
