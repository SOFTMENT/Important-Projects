package com.pvjsca.app.xxxdelivery;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.media.RingtoneManager;
import android.os.Build;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.app.TaskStackBuilder;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Random;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    String Channel_Name = "OnlineGames";
    String Channel_Id = "OnlineDDGames";
    NotificationChannel notificationChannel;
    int rq = 10;
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {

        super.onMessageReceived(remoteMessage);
        String title = "";
        String body = "";
        try {
            title = remoteMessage.getNotification().getTitle();
            body = remoteMessage.getNotification().getBody();

            Toast.makeText(this, "ON", Toast.LENGTH_SHORT).show();
        }
        catch (Exception e) {

        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            craeteNotificationChannel();

        }


        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this,Channel_Id)
                .setContentTitle(title).setAutoCancel(true).setStyle(new NotificationCompat.BigTextStyle().bigText(body));


        mBuilder.setSmallIcon(R.drawable.shop);
        mBuilder.setColor(getResources().getColor(R.color.colorAccent));
        mBuilder.setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION));

        mBuilder.setPriority(NotificationCompat.PRIORITY_DEFAULT);
        Intent notificationIntent = new Intent(this,MainActivity.class);
        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
        TaskStackBuilder taskStackBuilder = TaskStackBuilder.create(this);
        taskStackBuilder.addNextIntentWithParentStack(notificationIntent);
        // set intent so it does not start a new activity
        PendingIntent intent =  taskStackBuilder.getPendingIntent(0,PendingIntent.FLAG_UPDATE_CURRENT);

        mBuilder.setContentIntent(intent);

        NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

            notificationManager.createNotificationChannel(notificationChannel);

        }


        notificationManager.notify(new Random().nextInt(), mBuilder.build());



    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void craeteNotificationChannel() {
        notificationChannel = new NotificationChannel(Channel_Id,Channel_Name,NotificationManager.IMPORTANCE_DEFAULT);

        notificationChannel.enableLights(true);
        notificationChannel.enableVibration(true);
        notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
    }

    @Override
    public void onNewToken(@NonNull String s) {
        super.onNewToken(s);
    }
}
