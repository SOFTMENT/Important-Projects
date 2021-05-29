package com.softmentclient.holli;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;

import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.AuthFailureError;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.softmentclient.holli.Service.MySingleton;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import static android.content.ContentValues.TAG;

public class AdminScreen extends AppCompatActivity {
    private final String user = "holliapp";
    private final String pass = "holli@2021";
    final private String FCM_API = "https://fcm.googleapis.com/fcm/send";
    final private String serverKey = "key=" + "AAAAzqhrqJ4:APA91bFrk_1sdG5tfXVLjH_0cGO0XFQr3eDsAaen6-Q5uTqdKtVbMyk4jldLpLF_fbnyWbH-D-zO5FgLkRBCrmjL9kYfSs4nsYovBb50ijau6WYJ6D7DXs47eWCNsRj6OEeg_C34uc6T";
    final private String contentType = "application/json";
    String NOTIFICATION_TITLE;
    String NOTIFICATION_MESSAGE;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin_screen);
        EditText username = findViewById(R.id.username);
        EditText password = findViewById(R.id.password);

        findViewById(R.id.back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });

        username.setPadding(12,0,12,0);
        password.setPadding(12,0,12,0);
        findViewById(R.id.login).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String sUsername = username.getText().toString();
                String sPassword = password.getText().toString();

                if (sUsername.equals(user) && sPassword.equals(pass)) {
                    AlertDialog.Builder builder = new AlertDialog.Builder(AdminScreen.this);
                    View view1 = getLayoutInflater().inflate(R.layout.notificationlayout,null);
                    AlertDialog alertDialog = builder.create();
                    alertDialog.setView(view1);

                    final EditText title = view1.findViewById(R.id.entertitle);
                    final EditText message = view1.findViewById(R.id.entermessage);
                    CardView sendnotification = view1.findViewById(R.id.sentnotification);
                    sendnotification.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            String sTitle = title.getText().toString();
                            String sMessage = message.getText().toString();
                            if (!sTitle.isEmpty()) {

                                if (!sMessage.isEmpty()) {
                                    NOTIFICATION_TITLE = sTitle;
                                    NOTIFICATION_MESSAGE = sMessage;
                                    JSONObject notification = new JSONObject();
                                    JSONObject notifcationBody = new JSONObject();
                                    try {
                                        notifcationBody.put("title", NOTIFICATION_TITLE);
                                        notifcationBody.put("message", NOTIFICATION_MESSAGE);
                                        notification.put("to", "/topics/holli");
                                        notification.put("data", notifcationBody);
                                    } catch (JSONException e) {

                                    }
                                    sendNotification(notification);

                                    Toast toast = Toast.makeText(AdminScreen.this, "Notification has been sent", Toast.LENGTH_SHORT);
                                    toast.setGravity(Gravity.CENTER,0,0);
                                    toast.show();
                                    title.setText("");
                                    message.setText("");

                                }
                                else {
                                    message.setError("Empty");
                                    message.requestFocus();
                                }
                            }
                            else {
                                title.requestFocus();
                                title.setError("Empty");
                            }

                        }
                    });
                    alertDialog.show();

                }
                else {
                    Toast.makeText(AdminScreen.this, "Username and Password is Incorrect", Toast.LENGTH_SHORT).show();
                }

            }
        });



    }

    private void sendNotification(JSONObject notification) {
        JsonObjectRequest jsonObjectRequest = new JsonObjectRequest(FCM_API, notification,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {


                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Toast.makeText(AdminScreen.this, "Request error", Toast.LENGTH_LONG).show();
                        Log.e("Notificationerror", error.getMessage());
                    }
                }){
            @Override
            public Map<String, String> getHeaders() throws AuthFailureError {
                Map<String, String> params = new HashMap<>();
                params.put("Authorization", serverKey);
                params.put("Content-Type", contentType);
                return params;
            }
        };
        MySingleton.getInstance(AdminScreen.this).addToRequestQueue(jsonObjectRequest);
    }
}