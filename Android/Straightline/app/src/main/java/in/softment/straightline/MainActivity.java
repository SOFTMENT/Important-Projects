package in.softment.straightline;


import android.Manifest;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.viewpager.widget.ViewPager;

import com.airbnb.lottie.LottieAnimationView;
import com.canhub.cropper.CropImage;
import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
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
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.Utils.Constants;
import in.softment.straightline.Utils.MyFirebaseMessagingService;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;
import me.ibrahimsn.lib.OnItemSelectedListener;
import me.ibrahimsn.lib.SmoothBottomBar;

import static android.os.Build.VERSION.SDK_INT;

public class MainActivity extends AppCompatActivity {


    private ChatFragment chatFragment;
    private HomeFragment homeFragment;
    private ProfileFragment profileFragment;
    private SmoothBottomBar smoothBottomBar;
    private ViewPager viewPager;
    FusedLocationProviderClient mFusedLocationClient;
    public static final int REQUEST_CODE_PERMISSIONS = 101;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Services.fullScreen(this);

        //UpdateToken
        updateToken();
        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);

        smoothBottomBar = findViewById(R.id.bottomBar);
        smoothBottomBar.setItemActiveIndex(0);
        viewPager = findViewById(R.id.viewpager);
        viewPager.setOffscreenPageLimit(3);
        setupViewPager(viewPager);
        viewPager.setCurrentItem(0);
        smoothBottomBar.setOnItemSelectedListener(new OnItemSelectedListener() {
            @Override
            public boolean onItemSelect(int i) {
                viewPager.setCurrentItem(i);
                return true;
            }
        });


        Constants.requestLocationClass = "Main";

    }



    public void requestLocationPermission() {

        boolean foreground = ActivityCompat.checkSelfPermission(this,
                Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED;

        if (foreground) {
            if (Constants.requestLocationClass.equalsIgnoreCase("Main")) {
                getLastLocation();
            }
            else if (Constants.requestLocationClass.equalsIgnoreCase("Settings")){
                Intent intent = new Intent(MainActivity.this, CreateChallange.class);
                startActivity(intent);
            }


        } else {
            ActivityCompat.requestPermissions(this,
                    new String[]{Manifest.permission.ACCESS_COARSE_LOCATION}, REQUEST_CODE_PERMISSIONS);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_PERMISSIONS) {

            boolean foreground = false;

            for (int i = 0; i < permissions.length; i++) {
                if (permissions[i].equalsIgnoreCase(Manifest.permission.ACCESS_COARSE_LOCATION)) {
                    //foreground permission allowed
                    if (grantResults[i] >= 0) {
                        foreground = true;
                        break;
                    } else {
                        Services.showDialog(MainActivity.this,"Permission Required","We can't show challenges without location permission. Please allow location permission.");
                      //  Toast.makeText(getApplicationContext(), "Location Permission denied", Toast.LENGTH_SHORT).show();
                        break;
                    }
                }
            }

            if (foreground) {

                getLastLocation();


            }
        }
    }





    @SuppressLint("MissingPermission")
    private void getLastLocation() {
        // check if permissions are given


            // check if location is enabled
            if (isLocationEnabled()) {

                // getting last
                // location from
                // FusedLocationClient
                // object
                mFusedLocationClient.getLastLocation().addOnCompleteListener(new OnCompleteListener<Location>() {
                    @Override
                    public void onComplete(@NonNull Task<Location> task) {
                        Location location = task.getResult();
                        if (location == null) {
                            requestNewLocationData();
                        } else {
                            UserModel.data.latitude = location.getLatitude();
                            UserModel.data.longitude = location.getLongitude();

                           if (Constants.requestLocationClass.equalsIgnoreCase("Settings")){
                                Intent intent = new Intent(MainActivity.this, CreateChallange.class);
                                startActivity(intent);
                            }
                           else if (Constants.requestLocationClass.equalsIgnoreCase("Main")) {
                               getAllChallenges();
                           }
                        }
                    }
                });
            } else {
                Toast.makeText(this, "Please turn on" + " your location...", Toast.LENGTH_LONG).show();
                Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                startActivity(intent);
            }

    }


    @SuppressLint("MissingPermission")
    private void requestNewLocationData() {

        // Initializing LocationRequest
        // object with appropriate methods
        LocationRequest mLocationRequest = LocationRequest.create();
        mLocationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY);
        mLocationRequest.setInterval(5);
        mLocationRequest.setFastestInterval(0);
        mLocationRequest.setNumUpdates(1);

        mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
        mFusedLocationClient.requestLocationUpdates(mLocationRequest, mLocationCallback, Looper.myLooper());
    }

    private final LocationCallback mLocationCallback = new LocationCallback() {

        @Override
        public void onLocationResult(LocationResult locationResult) {

            Location mLastLocation = locationResult.getLastLocation();
            UserModel.data.latitude = mLastLocation.getLatitude();
            UserModel.data.longitude = mLastLocation.getLongitude();

            if (Constants.requestLocationClass.equalsIgnoreCase("Settings")){
                Intent intent = new Intent(MainActivity.this, CreateChallange.class);
                startActivity(intent);
            }
            else if (Constants.requestLocationClass.equalsIgnoreCase("Main")) {
                getAllChallenges();
            }
        }
    };

    private boolean isLocationEnabled() {
        LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        return locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) || locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
    }


    public void updateToken() {

        Map<String, Object> map = new HashMap<>();
        map.put("token", MyFirebaseMessagingService.getToken(this));
        if (FirebaseAuth.getInstance().getCurrentUser() != null)
            FirebaseFirestore.getInstance().collection("Users").document(FirebaseAuth.getInstance().getCurrentUser().getUid()).set(map, SetOptions.merge());

    }
        //getAllChallenges
    private void getAllChallenges(){

        FirebaseFirestore.getInstance().collection("Challenges").orderBy("time").whereGreaterThan("time",new Date()).addSnapshotListener(new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable @org.jetbrains.annotations.Nullable QuerySnapshot value, @Nullable @org.jetbrains.annotations.Nullable FirebaseFirestoreException error) {

                if (error == null) {
                    ChallnageModel.challnageModels.clear();
                    if (value != null && !value.isEmpty()) {

                        for (DocumentSnapshot documentSnapshot : value.getDocuments()) {

                            ChallnageModel challnageModel = documentSnapshot.toObject(ChallnageModel.class);
                            if (challnageModel != null) {

                                ChallnageModel.challnageModels.add(challnageModel);
                            }

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
                requestLocationPermission();
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