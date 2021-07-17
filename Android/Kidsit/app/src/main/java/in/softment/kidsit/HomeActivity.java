package in.softment.kidsit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.view.GravityCompat;
import androidx.drawerlayout.widget.DrawerLayout;

import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import in.softment.kidsit.Models.ParentModel;
import in.softment.kidsit.Utils.Services;

public class HomeActivity extends AppCompatActivity {

    private LinearLayout navigationVIEW;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);
        Services.fullScreen(this);

        DrawerLayout drawerLayout = findViewById(R.id.drawer_layout);
        navigationVIEW = findViewById(R.id.navigationVIEW);

        ParentModel parentModel = ParentModel.data;
        if (parentModel == null) {
            Services.logout(this);
            return;
        }

        //Name
        TextView name = findViewById(R.id.name);
        name.setText(parentModel.fullName);

        TextView email = findViewById(R.id.email);
        email.setText(parentModel.emailAddress);

        //MENU
        findViewById(R.id.menu).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.openDrawer(GravityCompat.START);
            }
        });

        findViewById(R.id.closeBtn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawer(GravityCompat.START);
            }
        });

        //Home
        findViewById(R.id.home).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawer(GravityCompat.START);
            }
        });

        //Booking Activity
        findViewById(R.id.booking).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(HomeActivity.this, BookAppointmentActivity.class));
            }
        });

        //Logout
        findViewById(R.id.logout).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Services.logout(HomeActivity.this);
            }
        });
    }
}