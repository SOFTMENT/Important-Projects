package in.softment.straightline;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.google.android.gms.tasks.Continuation;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.QuerySnapshot;
import com.google.firebase.storage.FirebaseStorage;
import com.google.firebase.storage.StorageReference;
import com.google.firebase.storage.UploadTask;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import in.softment.straightline.Adapter.ManageChallengeAdapter;
import in.softment.straightline.Adapter.SeeAllChallengesAdapter;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;


public class ManageChallengeActivity extends AppCompatActivity {

    private ManageChallengeAdapter manageChallengeAdapter;
    private ArrayList<ChallnageModel> challnageModels;
    private ChallnageModel challnageModel;
    private TextView no_challenge_availble;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_manage_challenge);
        RecyclerView recyclerView = findViewById(R.id.recyclerview);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        challnageModels = new ArrayList<>();
        manageChallengeAdapter = new ManageChallengeAdapter(this, challnageModels);
        recyclerView.setAdapter(manageChallengeAdapter);
        no_challenge_availble = findViewById(R.id.no_challenge_availble);

        //back
        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        getMyChallenges();
    }

    public void pickVideo(ChallnageModel challnageModel){
        this.challnageModel = challnageModel;
        Intent intent = new Intent(Intent.ACTION_PICK, MediaStore.Video.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(Intent.createChooser(intent,"Select Video"),543);

    }

    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK) {
            if (requestCode == 543) {
                Uri selectedImageUri = data.getData();
                uploadVideoOnFirebase(selectedImageUri);


            }
        }
        else {
            Log.d("VIDEO","WAH");

        }
    }


    public  void uploadVideoOnFirebase(Uri resultUri) {
       Services.showCenterToast(ManageChallengeActivity.this,ToastType.SUCCESS,"Video Uploaded...");
        StorageReference storageReference = FirebaseStorage.getInstance().getReference().child("ChallengeVideos").child(UserModel.data.uid).child("ksjsjs"+ ".mp4");
        UploadTask uploadTask = storageReference.putFile(resultUri);
        Task<Uri> uriTask = uploadTask.continueWithTask(new Continuation<UploadTask.TaskSnapshot, Task<Uri>>() {
            @Override
            public Task<Uri> then(@NonNull Task<UploadTask.TaskSnapshot> task) throws Exception {
                if (!task.isSuccessful()) {
                    ProgressHud.dialog.dismiss();
                    Services.showDialog(ManageChallengeActivity.this,"ERROR-1",task.getException().getLocalizedMessage());
                }
                return storageReference.getDownloadUrl();
            }
        }).addOnCompleteListener(new OnCompleteListener<Uri>() {
            @Override
            public void onComplete(@NonNull Task<Uri> task) {
                ProgressHud.dialog.dismiss();
                if (task.isSuccessful()) {
                    String downloadUri = String.valueOf(task.getResult());
                    Map<String,Object> map = new HashMap();
                    map.put("cid",challnageModel.cid);
                    map.put("title",challnageModel.title);
                    map.put("uid",challnageModel.uid);
                    map.put("url",downloadUri);
                    map.put("time",challnageModel.time);
                    map.put("location",challnageModel.location);
                    map.put("uplaodVideoTime",new Date());
                    FirebaseFirestore.getInstance().collection("Videos").document(challnageModel.getCid()).set(map);
                }
                else{
                    Services.showDialog(ManageChallengeActivity.this,"ERROR-2",task.getException().getLocalizedMessage());

                }


            }
        });
    }

    public void getMyChallenges() {
        ProgressHud.show(this,"");
        FirebaseFirestore.getInstance().collection("Challenges").whereEqualTo("uid", UserModel.data.uid).addSnapshotListener(new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable @org.jetbrains.annotations.Nullable QuerySnapshot value, @Nullable @org.jetbrains.annotations.Nullable FirebaseFirestoreException error) {
                ProgressHud.dialog.dismiss();

                if (error == null){
                    challnageModels.clear();
                    if (value != null) {
                        for (DocumentSnapshot documentSnapshot : value.getDocuments()) {
                            ChallnageModel challnageModel = documentSnapshot.toObject(ChallnageModel.class);
                            challnageModels.add(challnageModel);
                        }
                    }
                    if (challnageModels.size() > 0) {
                        no_challenge_availble.setVisibility(View.GONE);
                    }
                    else {
                        no_challenge_availble.setVisibility(View.VISIBLE);
                    }

                    manageChallengeAdapter.notifyDataSetChanged();
                }
                else {
                    Services.showDialog(ManageChallengeActivity.this,"ERROR",error.getLocalizedMessage());
                }
            }
        });
    }
}