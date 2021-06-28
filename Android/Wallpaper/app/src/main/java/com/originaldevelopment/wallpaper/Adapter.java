package com.originaldevelopment.wallpaper;


import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.PictureDrawable;
import android.net.Uri;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;
import androidx.viewpager.widget.PagerAdapter;



import com.bumptech.glide.Glide;
import com.bumptech.glide.RequestBuilder;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.bumptech.glide.load.model.StreamEncoder;
import com.bumptech.glide.request.RequestOptions;


import java.io.InputStream;
import java.io.Serializable;
import java.util.List;

import okhttp3.RequestBody;

public class Adapter extends PagerAdapter {

    private List<AllWallpaper> models;
    private Context context;
    private int[] staticimages;
    private int[] svgimages;





    public Adapter(List<AllWallpaper> models, Context context,int[] staticimages,int[] svgimages) {
        this.models = models;
        this.context = context;
        this.staticimages = staticimages;
        this.svgimages = svgimages;

    }

    @Override
    public int getCount() {
        return models.size();
    }

    @Override
    public boolean isViewFromObject(@NonNull View view, @NonNull Object object) {
        return view.equals(object);
    }

    @NonNull
    @Override
    public Object instantiateItem(@NonNull ViewGroup container, final int position) {
        LayoutInflater layoutInflater = LayoutInflater.from(context);
        View view = layoutInflater.inflate(R.layout.item, container, false);


        CardView cardView;
        ImageView imageView, clogo;
        TextView count, status;

        cardView = view.findViewById(R.id.ac);
        imageView = view.findViewById(R.id.image);
        count = view.findViewById(R.id.countimage);
        status = view.findViewById(R.id.status);
        clogo = view.findViewById(R.id.clogo);



        status.setText(models.get(position).getStatus());

        count.setText(models.get(position).getSize()+" Wallpapers");

        cardView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context,ShowSubCategory.class);
                intent.putExtra("list", (Serializable) models.get(position).getSubcategory());
                context.startActivity(intent);
            }
        });

//       RequestOptions requestOptions = new RequestOptions().diskCacheStrategy(DiskCacheStrategy.ALL);


//        GlideApp.with(context).
//                load(models.get(position).getSubcategory().get(0).getUrl().get(0).getHigh()).thumbnail(Glide.with(context)
//                .load(models.get(position).getSubcategory().get(0).getUrl().get(0).getMedium())).
//                apply(requestOptions).
//                into(imageView);
        imageView.setImageResource(staticimages[position]);
        clogo.setImageResource(svgimages[position]);



        view.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

            }
        });

        container.addView(view, 0);
        return view;
    }

    @Override
    public void destroyItem(@NonNull ViewGroup container, int position, @NonNull Object object) {
        container.removeView((View)object);

    }



}
