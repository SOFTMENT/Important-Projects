package in.softment.straightline;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.PopupMenu;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import de.hdodenhof.circleimageview.CircleImageView;
import in.softment.straightline.Adapter.LiveChatAdapter;
import in.softment.straightline.Model.AllMessagesModel;
import in.softment.straightline.Model.UserModel;

import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;

public class ChatScreenActivity extends AppCompatActivity {

    private LiveChatAdapter liveChatAdapter;
    private List<AllMessagesModel> chatModels;
    private EditText editText;
    RecyclerView recyclerView;
    private LinearLayoutManager linearLayoutManager;
    private String uid;
    private String awayId;
    private String awayName;
    private String awayProfile;
    private String awayToken;
    private String challengeTitle;
    private boolean isFirstTime;
    private ImageView more;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat_screen);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            window.setStatusBarColor(getColor(R.color.main_color));
        }
        FirebaseAuth firebaseAuth = FirebaseAuth.getInstance();
        uid = firebaseAuth.getCurrentUser().getUid();

        awayId = getIntent().getStringExtra("awayId");
        awayProfile = getIntent().getStringExtra("awayProfile");
        awayName = getIntent().getStringExtra("awayName");
        awayToken = getIntent().getStringExtra("awayToken");
        isFirstTime = getIntent().getBooleanExtra("firstTime",false);
        challengeTitle = getIntent().getStringExtra("ChallengeTitle");

        //MoreImage
        more = findViewById(R.id.more);
        more.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                showPopupMenu();
            }
        });

        TextView name = findViewById(R.id.name);
        CircleImageView profile_image = findViewById(R.id.profile_image);

        name.setText(awayName);
        Glide.with(this).load(awayProfile).placeholder(R.drawable.placeholder).into(profile_image);

        Map<String,Object> isReadMap = new HashMap<>();
        isReadMap.put("isRead",true);
        FirebaseFirestore.getInstance().collection("Chats").document(uid).collection("LastMessage").document(awayId).update(isReadMap);

        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        chatModels = new ArrayList<>();

        final ImageView sent = findViewById(R.id.sent);
        editText = findViewById(R.id.message);
        sent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sMessage = editText.getText().toString().trim();

                if (!sMessage.isEmpty()) {
                    editText.setText("");
                    sentMessage(sMessage);
                }
                else {
                    editText.requestFocus();
                    editText.setError("Empty");
                }
            }
        });

        recyclerView = findViewById(R.id.recyclerview);
        linearLayoutManager = new LinearLayoutManager(this);
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.setHasFixedSize(true);
        liveChatAdapter = new LiveChatAdapter(this,chatModels,uid);
        recyclerView.setAdapter(liveChatAdapter);

        getAllChats();

        if (isFirstTime) {
            sentMessage("I accept your challenge.\n\nTitle - "+challengeTitle);
        }
    }

    private void getAllChats() {
        ProgressHud.show(this,"Loading...");

        FirebaseFirestore.getInstance().collection("Chats").document(uid).collection(awayId).orderBy("date").addSnapshotListener((value, error) -> {
            ProgressHud.dialog.dismiss();
            if (error == null) {
                chatModels.clear();
                if (value != null && !value.isEmpty()) {
                    for (DocumentSnapshot documentSnapshot : value.getDocuments()) {
                        AllMessagesModel allMessagesModel = documentSnapshot.toObject(AllMessagesModel.class);
                        chatModels.add(allMessagesModel);

                    }
                }


                if (chatModels.size() > 0) {
                    recyclerView.post(new Runnable() {
                        @Override
                        public void run() {
                            recyclerView.scrollToPosition(chatModels.size() - 1);

                        }
                    });
                }

                liveChatAdapter.notifyDataSetChanged();

            }

        });


    }





    private void sentMessage(String sMessage) {
        HashMap<String,Object> hashMap = new HashMap<>();
        hashMap.put("message",sMessage);
        hashMap.put("senderUid",uid);
        String messageId = FirebaseFirestore.getInstance().collection("Chats").document().getId();
        hashMap.put("messageId",messageId);
        hashMap.put("senderImage",UserModel.data.getProfileImage());
        hashMap.put("date",new Date());
        hashMap.put("senderName", UserModel.data.fullName);


        FirebaseFirestore.getInstance().collection("Chats").document(uid).collection(awayId).document(messageId).set(hashMap).addOnCompleteListener(task -> {
            FirebaseFirestore.getInstance().collection("Chats").document(awayId).collection(uid).document(messageId).set(hashMap);

            HashMap<String,Object> hashMap12 = new HashMap<>();
            hashMap12.put("message",sMessage);
            hashMap12.put("senderUid",awayId);
            hashMap12.put("isRead",true);
            hashMap12.put("senderImage",awayProfile);
            hashMap12.put("date",new Date());
            hashMap12.put("senderName", awayName);
            hashMap12.put("senderToken",awayToken);

            FirebaseFirestore.getInstance().collection("Chats").document(uid).collection("LastMessage").document(awayId).set(hashMap12);

            HashMap<String,Object> hashMap1 = new HashMap<>();
            hashMap1.put("message",sMessage);
            hashMap1.put("senderUid",uid);
            hashMap1.put("isRead",false);
            hashMap1.put("senderImage", UserModel.data.getProfileImage());
            hashMap1.put("date",new Date());
            hashMap1.put("senderName", UserModel.data.getFullName());
            hashMap1.put("senderToken", UserModel.data.token);
            FirebaseFirestore.getInstance().collection("Chats").document(awayId).collection("LastMessage").document(uid).set(hashMap1);

            Services.sentPushNotification(ChatScreenActivity.this,UserModel.data.getFullName(),sMessage,awayToken);
        });
    }

    private void showPopupMenu(){
        PopupMenu popupMenu = new PopupMenu(this,more);
        popupMenu.getMenuInflater().inflate(R.menu.chatscreen_popup_menu,popupMenu.getMenu());
        popupMenu.setOnMenuItemClickListener(item -> {

            if (item.getItemId() == R.id.report) {
                AlertDialog.Builder builder = new AlertDialog.Builder(ChatScreenActivity.this);
                View view1 = getLayoutInflater().inflate(R.layout.report_reason_layout,null);
                AlertDialog alertDialog = builder.create();
                alertDialog.setView(view1);
                final EditText message = view1.findViewById(R.id.entermessage);
                CardView report = view1.findViewById(R.id.sentnotification);
                report.setOnClickListener(v -> {

                    String sMessage = message.getText().toString().trim();
                    if (!sMessage.equals("")) {
                        alertDialog.dismiss();
                        reportUser(sMessage);
                    }
                    else {
                        Services.showCenterToast(ChatScreenActivity.this,ToastType.WARNING,"Enter Reason");
                    }

                });

                alertDialog.show();

            }
            return true;
        });
        popupMenu.show();
    }


    private void reportUser(String reason){
        Map<String, String> map = new HashMap<>();
        map.put("reason",reason);
        map.put("userid",awayId);
        map.put("username",awayName);
        FirebaseFirestore.getInstance().collection("Report").document().set(map);

        Services.showDialog(this,"REPORTED","Thanks for reporting, Our internal team will check this issue.");
    }

}
