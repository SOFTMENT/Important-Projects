package in.softment.kidsit;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.CheckBox;
import android.widget.Toast;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputEditText;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.firestore.FieldValue;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.SetOptions;

import org.jetbrains.annotations.NotNull;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import in.softment.kidsit.Utils.Cities;
import in.softment.kidsit.Utils.ProgressHud;
import in.softment.kidsit.Utils.Services;

public class AddUserInfoAvitivity extends AppCompatActivity {

    private TextInputEditText etPhone,etAddress,etNumberOfChildren;
    private AutoCompleteTextView etCity;
    private CheckBox checkBox;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_add_user_info_avitivity);
        Services.fullScreen(this);

        etPhone = findViewById(R.id.etPhone);
        etAddress = findViewById(R.id.etAddress);
        etNumberOfChildren = findViewById(R.id.etNumberOfChildren);
        etCity = findViewById(R.id.etCity);
        etCity.setThreshold(1);
        checkBox = findViewById(R.id.checkBox);


        String[] cities = new Cities().names;
        Arrays.sort(cities);
        ArrayAdapter cityAdapter = new ArrayAdapter(this,R.layout.option_item,cities);
        etCity.setAdapter(cityAdapter);
        etCity.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                etCity.setText(cities[position]);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });



        findViewById(R.id.signUpCard).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                String sPhone = etPhone.getText().toString().trim();
                String sAddress = etAddress.getText().toString().trim();
                String sNumberOfChildren = etNumberOfChildren.getText().toString().trim();
                String sCity = etCity.getText().toString().trim();

                 if (sPhone.isEmpty()) {
                    Services.showCenterToast(AddUserInfoAvitivity.this,"Entrez le numéro de téléphone");
                }
                else if(sCity.isEmpty()) {
                    Services.showCenterToast(AddUserInfoAvitivity.this,"Entrez la ville");
                }

                else {

                    ProgressHud.show(AddUserInfoAvitivity.this,"");
                    FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
                    if (firebaseUser !=null) {
                        Map user = new HashMap();
                        user.put("uid",firebaseUser.getUid());
                        user.put("fullName",firebaseUser.getDisplayName());
                        user.put("phone",sPhone);
                        user.put("emailAddress",firebaseUser.getEmail());
                        user.put("nos",sNumberOfChildren);
                        user.put("address",sAddress);
                        user.put("city",sCity);
                        user.put("registrationDate", FieldValue.serverTimestamp());
                        FirebaseFirestore.getInstance().collection("Parents").document(firebaseUser.getUid()).set(user, SetOptions.merge()).addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull @NotNull Task<Void> task) {
                                ProgressHud.dialog.dismiss();
                                if (task.isSuccessful()) {
                                    Services.getCurrentUserData(AddUserInfoAvitivity.this,firebaseUser.getUid(),true);
                                }
                                else {
                                    Services.showDialog(AddUserInfoAvitivity.this,getString(R.string.error),getString(R.string.something_went_wrong));
                                }
                            }
                        });
                    }
                    else {
                        Services.logout(AddUserInfoAvitivity.this);
                    }
                }
            }
        });
    }


}