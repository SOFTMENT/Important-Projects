package in.softment.kidsit;

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

import java.util.Arrays;
import java.util.Objects;

import in.softment.kidsit.Utils.Cities;
import in.softment.kidsit.Utils.ProgressHud;
import in.softment.kidsit.Utils.Services;

public class SignUpActivity extends AppCompatActivity {

    private TextInputEditText etFullName, etPassword,etPhone,etEmail, etAddress, etNumberOfChildren;
    private AutoCompleteTextView etCity;
    private CheckBox checkBox;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);
        Services.fullScreen(this);



        etFullName = findViewById(R.id.etFullname);
        etPassword = findViewById(R.id.etPassword);
        etEmail = findViewById(R.id.etEmail);
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

        findViewById(R.id.signInText).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        findViewById(R.id.signUpCard).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sFullname = etFullName.getText().toString().trim();
                String sPassword = etPassword.getText().toString().trim();
                String sEmail = etEmail.getText().toString().trim();
                String sPhone = etPhone.getText().toString().trim();
                String sAddress = etAddress.getText().toString().trim();
                String sNumberOfChildren = etNumberOfChildren.getText().toString().trim();
                String sCity = etCity.getText().toString().trim();
                boolean isCheck = checkBox.isChecked();
                if (sFullname.isEmpty()) {
                    Services.showCenterToast(SignUpActivity.this,"Entrez le nom complet");
                }
                else if (sPassword.isEmpty()) {
                    Services.showCenterToast(SignUpActivity.this,"Entrer le mot de passe");
                }
                else if (sEmail.isEmpty()) {
                    Services.showCenterToast(SignUpActivity.this,"Entrer l'adresse e-mail");
                }
                else if (sPhone.isEmpty()) {
                    Services.showCenterToast(SignUpActivity.this,"Entrez le numéro de téléphone");
                }
                else if(sCity.isEmpty()) {
                    Services.showCenterToast(SignUpActivity.this,"Entrez la ville");
                }
                else if (!isCheck) {
                    Services.showCenterToast(SignUpActivity.this,"Veuillez accepter nos termes et conditions");
                }
                else {

                    ProgressHud.show(SignUpActivity.this,"La création du compte...");
                    FirebaseAuth.getInstance().createUserWithEmailAndPassword(sEmail, sPassword).addOnCompleteListener(new OnCompleteListener<AuthResult>() {
                        @Override
                        public void onComplete(@NonNull @org.jetbrains.annotations.NotNull Task<AuthResult> task) {
                            ProgressHud.dialog.hide();
                            if (task.isSuccessful()) {
                                FirebaseUser firebaseUser = FirebaseAuth.getInstance().getCurrentUser();
                                if (firebaseUser != null) {
                                    Services.addUserDataOnServer(SignUpActivity.this,firebaseUser.getUid(),sFullname,sPhone,sEmail,sNumberOfChildren,sAddress,sCity,"custom");
                                }
                            }
                            else {
                                Services.handleFirebaseERROR(SignUpActivity.this, ((FirebaseAuthException) Objects.requireNonNull(task.getException())).getErrorCode());
                            }

                        }
                    });
                }
            }
        });
    }


}