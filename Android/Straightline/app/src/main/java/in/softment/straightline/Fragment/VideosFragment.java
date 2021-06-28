package in.softment.straightline.Fragment;

import android.app.DirectAction;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.text.Editable;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QuerySnapshot;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;

import in.softment.straightline.Adapter.SeeAllChallengesAdapter;
import in.softment.straightline.Adapter.VideosAdapter;
import in.softment.straightline.BuildConfig;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.VideoModel;
import in.softment.straightline.R;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;


public class VideosFragment extends Fragment {

    private Context context;
    private VideosAdapter videosAdapter;
    private ArrayList<VideoModel> videoModels;
    public VideosFragment(Context context) {
        this.context = context;
    }
    public View message;
    private  RecyclerView recyclerView;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_videos, container, false);
        message = view.findViewById(R.id.message);
        recyclerView = view.findViewById(R.id.recyclerview);
        recyclerView.setHasFixedSize(true);
        videoModels = new ArrayList<>();
        recyclerView.setLayoutManager(new LinearLayoutManager(context));
        videosAdapter = new VideosAdapter(context, videoModels);
        recyclerView.setAdapter(videosAdapter);
        view.findViewById(R.id.shareApp).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    Intent shareIntent = new Intent(Intent.ACTION_SEND);
                    shareIntent.setType("text/plain");
                    shareIntent.putExtra(Intent.EXTRA_SUBJECT, "My application name");
                    String shareMessage= "\nLet me recommend you this application\n\n";
                    shareMessage = shareMessage + "https://play.google.com/store/apps/details?id=" + BuildConfig.APPLICATION_ID +"\n\n";
                    shareIntent.putExtra(Intent.EXTRA_TEXT, shareMessage);
                    startActivity(Intent.createChooser(shareIntent, "choose one"));
                } catch(Exception e) {
                    //e.toString();
                }
            }
        });

        //SearchEDITTEXT
        EditText searchEDTEXT = view.findViewById(R.id.searchEditText);
        searchEDTEXT.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                videosAdapter.filter(s.toString(), videoModels);
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });

        getVideos();
        return view;
    }

    public void getVideos(){

        FirebaseFirestore.getInstance().collection("Videos").orderBy("uplaodVideoTime", Query.Direction.DESCENDING).addSnapshotListener(new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable @org.jetbrains.annotations.Nullable QuerySnapshot value, @Nullable @org.jetbrains.annotations.Nullable FirebaseFirestoreException error) {
                if (error == null) {
                    if (value != null) {
                        videoModels.clear();
                        for ( DocumentSnapshot documentSnapshot : value.getDocuments()){
                            VideoModel videoModel = documentSnapshot.toObject(VideoModel.class);
                            videoModels.add(videoModel);
                        }
                        if (videoModels.size() < 1) {
                            message.setVisibility(View.VISIBLE);
                            recyclerView.setVisibility(View.GONE);

                        }
                        else {
                            message.setVisibility(View.GONE);
                            recyclerView.setVisibility(View.VISIBLE);
                        }
                        videosAdapter.notifyDataSetChanged();
                    }
                }
                else{
                    Services.showDialog(context,"ERROR",error.getLocalizedMessage());
                }
            }
        });



    }
}

