package com.originaldevelopment.rapidcollect;

import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.app.TimePickerDialog;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.Spanned;
import android.text.format.DateFormat;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import com.originaldevelopment.Model.ToDoModel;

import java.time.LocalDate;
import java.util.Calendar;
import java.util.Date;

import io.realm.Realm;
import io.realm.RealmResults;

public class ToDoAddDetails extends AppCompatActivity {

    private int mYear;
    private int mMonth;
    private int mDay;
    private int mHour;
    private int mMinute;
    private Date myDate = null;
    private Calendar c;
    private Realm realm;
    private EditText name, details;
    private TextView sdate;
    private TextView cancel;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_to_do_add_details);

        mYear= Calendar.getInstance().get(Calendar.YEAR);
        mMonth=Calendar.getInstance().get(Calendar.MONTH)+1;
        mDay=Calendar.getInstance().get(Calendar.DAY_OF_MONTH) ;
        mHour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY) ;
        mMinute = Calendar.getInstance().get(Calendar.MINUTE);
        EditText editText = findViewById(R.id.datepicker);
        editText.setFocusable(false);
        cancel = findViewById(R.id.cancel);
        cancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        sdate = findViewById(R.id.sdate);

        editText.setFilters(new InputFilter[] {
                new InputFilter() {
                    public CharSequence filter(CharSequence src, int start,
                                               int end, Spanned dst, int dstart, int dend) {
                        return src.length() < 1 ? dst.subSequence(dstart, dend) : "";
                    }
                }
        });

        name = findViewById(R.id.name);
        details = findViewById(R.id.details);

        Button add = findViewById(R.id.add);
        add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String sName = name.getText().toString().trim();
                String sDetails = details.getText().toString();
                if (!sName.isEmpty()) {
                    if (!sDetails.isEmpty()) {
                        if (myDate != null) {
                            saveData(sName, sDetails, myDate);
                        }
                        else {
                            Toast toast = Toast.makeText(ToDoAddDetails.this, "Please Select Date And Time.",Toast.LENGTH_SHORT);
                            toast.setGravity(Gravity.CENTER, 0, 0);
                            toast.show();
                        }


                    }
                    else {
                        details.setError("Empty");
                        details.requestFocus();
                    }
                }
                else {
                    name.setError("Empty");
                    name.requestFocus();
                }

            }
        });
        realm  = Realm.getDefaultInstance();
        editText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {




                c = Calendar.getInstance();
                int mYearParam = mYear;
                int mMonthParam = mMonth-1;
                int mDayParam = mDay;




                DatePickerDialog datePickerDialog = new DatePickerDialog(ToDoAddDetails.this,
                        new DatePickerDialog.OnDateSetListener() {

                            @Override
                            public void onDateSet(DatePicker view, int year,
                                                  int monthOfYear, int dayOfMonth) {
                                mMonth = monthOfYear;
                                mYear=year;
                                mDay=dayOfMonth;
                                show_Timepicker();



                            }
                        }, mYearParam, mMonthParam, mDayParam);

                datePickerDialog.show();
            }
        });
    }
    private void show_Timepicker() {

        TimePickerDialog timePickerDialog = new TimePickerDialog(ToDoAddDetails.this,
                new TimePickerDialog.OnTimeSetListener() {

                    @Override
                    public void onTimeSet(TimePicker view, int pHour, int pMinute) {
                        mHour = pHour;
                        mMinute = pMinute;

                        c.set(mYear,mMonth,mDay,mHour,mMinute);
                        myDate  = c.getTime();

                     String dateformat =    DateFormat.format("yyyy MMMM dd, hh:mm a",myDate).toString();
                     sdate.setVisibility(View.VISIBLE);
                     sdate.setText(dateformat);
                    }
                }, mHour, mMinute, true);

        timePickerDialog.show();
    }

    public void saveData(final String name, final String details, final Date date) {
        realm.executeTransactionAsync(new Realm.Transaction() {
            @Override
            public void execute(Realm bgRealm) {
                ToDoModel task = bgRealm.createObject(ToDoModel.class);
                task.setName(name);
                task.setDetails(details);
                task.setCompletionDate(date);
                task.setStartDate(new Date());
                task.setComplete(false);

            }
        }, new Realm.Transaction.OnSuccess() {
            @Override
            public void onSuccess() {
                Toast toast = Toast.makeText(ToDoAddDetails.this, "Task Created!",Toast.LENGTH_SHORT);
                toast.setGravity(Gravity.CENTER, 0, 0);
                toast.show();
                finish();
            }
        }, new Realm.Transaction.OnError() {
            @Override
            public void onError(Throwable error) {
                // Transaction failed and was automatically canceled.
            }
        });
    }


}
