package com.originaldevelopment.Fragment;

import android.content.Context;
import android.os.Bundle;

import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.airbnb.lottie.LottieAnimationView;
import com.originaldevelopment.API.Api;
import com.originaldevelopment.Adapter.NewsRoomAdapter;
import com.originaldevelopment.NewsRoomWordpress.NewsRoomWordpress;
import com.originaldevelopment.rapidcollect.MainActivity;
import com.originaldevelopment.rapidcollect.R;

import java.util.ArrayList;
import java.util.List;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * A simple {@link Fragment} subclass.
 */
public class NewsRoomFragment extends Fragment {

    private Context context;
    private List<NewsRoomWordpress> newsRoomWordpresses;
    private NewsRoomAdapter newsRoomAdapter;
    private LottieAnimationView lottieAnimationView;

    public NewsRoomFragment(Context context) {
        // Required empty public constructor
        this.context = context;
        newsRoomWordpresses = new ArrayList<>();
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_news_room, container, false);
        RecyclerView recyclerView = view.findViewById(R.id.recyclerview);
        recyclerView.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(context);

        ImageView back = view.findViewById(R.id.back);
        back.setOnClickListener(v -> {
            MainActivity mainActivity = (MainActivity) context;
            mainActivity.changeTabPosition(0);
        });
        lottieAnimationView = view.findViewById(R.id.animation_view);

        recyclerView.setLayoutManager(linearLayoutManager);
        newsRoomAdapter = new NewsRoomAdapter(context, newsRoomWordpresses);
        recyclerView.setAdapter(newsRoomAdapter);
        getDetails();
        return view;
    }

    private void getDetails() {
        Api.getApi().getPost("https://rapidcollect.co.za/wp-json/wp/v2/posts?_embed&categories=96&fields=title,content,_embedded").enqueue(new Callback<List<NewsRoomWordpress>>() {
            @Override
            public void onResponse(Call<List<NewsRoomWordpress>> call, Response<List<NewsRoomWordpress>> response) {
                newsRoomWordpresses.addAll(response.body());
                Log.d("VIJAY",newsRoomWordpresses.size()+"");
                try {
                    lottieAnimationView.pauseAnimation();
                }
                catch (Exception e) {

                }
                lottieAnimationView.setVisibility(View.GONE);
                newsRoomAdapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(Call<List<NewsRoomWordpress>> call, Throwable t) {
                Log.d("VIJAY",t.getLocalizedMessage());

            }
        });
    }
}
