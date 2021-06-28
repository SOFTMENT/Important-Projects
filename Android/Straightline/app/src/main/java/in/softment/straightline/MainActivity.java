package in.softment.straightline;


import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

import com.canhub.cropper.CropImage;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.MetadataChanges;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firebase.firestore.SetOptions;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import in.softment.straightline.Adapter.BottomBarPagerAdapter;
import in.softment.straightline.Fragment.ChatFragment;
import in.softment.straightline.Fragment.HomeFragment;
import in.softment.straightline.Fragment.ProfileFragment;
import in.softment.straightline.Fragment.VideosFragment;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.LastMessageModel;
import in.softment.straightline.Model.TrackImagesModel;
import in.softment.straightline.Utils.MyFirebaseMessagingService;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;
import me.ibrahimsn.lib.OnItemSelectedListener;
import me.ibrahimsn.lib.SmoothBottomBar;

public class MainActivity extends AppCompatActivity {

    private ChatFragment chatFragment;
    private HomeFragment homeFragment;
    private ProfileFragment profileFragment;
    private SmoothBottomBar smoothBottomBar;
    private ViewPager viewPager;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Services.fullScreen(this);

        //UpdateToken
        updateToken();

        smoothBottomBar = findViewById(R.id.bottomBar);
        smoothBottomBar.setItemActiveIndex(0);
        viewPager = findViewById(R.id.viewpager);
        viewPager.setOffscreenPageLimit(4);
        setupViewPager(viewPager);
        viewPager.setCurrentItem(0);
        smoothBottomBar.setOnItemSelectedListener(new OnItemSelectedListener() {
            @Override
            public boolean onItemSelect(int i) {
                viewPager.setCurrentItem(i);
                return true;
            }
        });

    }


    public void updateToken() {

        Map<String, Object> map = new HashMap<>();
        map.put("token", MyFirebaseMessagingService.getToken(this));
        if (FirebaseAuth.getInstance().getCurrentUser() != null)
            FirebaseFirestore.getInstance().collection("Users").document(FirebaseAuth.getInstance().getCurrentUser().getUid()).set(map, SetOptions.merge());

    }
        //getAllChallenges
    private void getAllChallenges(){
        ProgressHud.show(MainActivity.this,"");
        FirebaseFirestore.getInstance().collection("Challenges").orderBy("time").whereGreaterThan("time",new Date()).addSnapshotListener(new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable @org.jetbrains.annotations.Nullable QuerySnapshot value, @Nullable @org.jetbrains.annotations.Nullable FirebaseFirestoreException error) {
                 ProgressHud.dialog.dismiss();
                if (error == null) {
                    ChallnageModel.challnageModels.clear();
                    if (value != null && !value.isEmpty()) {
                        for (DocumentSnapshot documentSnapshot : value.getDocuments()) {

                            ChallnageModel challnageModel = documentSnapshot.toObject(ChallnageModel.class);
                            ChallnageModel.challnageModels.add(challnageModel);
                        }
                    }
                    homeFragment.notifyAdapter();
                }
                else {
                    Services.showDialog(MainActivity.this,"ERROR",error.getLocalizedMessage());
                }
            }
        });
    }
    //getLastChatModelData
    private void getLastMessageData(){
        FirebaseFirestore.getInstance().collection("Chats").document(FirebaseAuth.getInstance().getCurrentUser().getUid()).collection("LastMessage").orderBy("date", Query.Direction.DESCENDING).addSnapshotListener(MetadataChanges.INCLUDE,new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable QuerySnapshot value, @Nullable FirebaseFirestoreException error) {
                if (error == null) {
                    LastMessageModel.lastMessageModels.clear();
                    if (value != null && !value.isEmpty()) {
                        for (DocumentSnapshot documentSnapshot : value.getDocuments()) {
                            LastMessageModel lastMessageModel = documentSnapshot.toObject(LastMessageModel.class);
                            LastMessageModel.lastMessageModels.add(lastMessageModel);
                        }

                    }

                    chatFragment.notifyAdapter();

                }
                else {

                }
            }
        });
    }

    private void getTrackImages() {
        FirebaseFirestore.getInstance().collection("TrackImages").get().addOnSuccessListener(new OnSuccessListener<QuerySnapshot>() {
            @Override
            public void onSuccess(QuerySnapshot queryDocumentSnapshots) {
                if (!queryDocumentSnapshots.isEmpty()) {
                    List<TrackImagesModel> trackImagesModels = queryDocumentSnapshots.toObjects(TrackImagesModel.class);
                    TrackImagesModel.trackImagesModels.addAll(trackImagesModels);
                }
                getAllChallenges();
            }
        });
    }

    private void setupViewPager(ViewPager viewPager) {
        BottomBarPagerAdapter adapter = new BottomBarPagerAdapter(getSupportFragmentManager());
        adapter.addFrag(new HomeFragment(this));
        adapter.addFrag(new ChatFragment(this));
        adapter.addFrag(new VideosFragment(this));
        adapter.addFrag(new ProfileFragment(this));

        viewPager.setAdapter(adapter);
    }

    public void initializeChatFragment(ChatFragment chatFragment){
        this.chatFragment = chatFragment;
        getLastMessageData();
    }


    public void initializeHomeFragment(HomeFragment homeFragment){
        this.homeFragment = homeFragment;
        getTrackImages();
    }

    public void initializeProfileFragment(ProfileFragment profileFragment) {
        this.profileFragment = profileFragment;

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE) {
            CropImage.ActivityResult result = CropImage.getActivityResult(data);

            if (resultCode == RESULT_OK) {
               profileFragment.cropURI(result.getUriContent());
            }
        }


    }


    @Override
    public void onBackPressed() {
        if (viewPager.getCurrentItem() == 0) {
           super.onBackPressed();
        }
        else {
            viewPager.setCurrentItem(0);
            smoothBottomBar.setItemActiveIndex(0);
        }
    }
}