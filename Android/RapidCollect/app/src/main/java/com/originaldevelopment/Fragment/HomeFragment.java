package com.originaldevelopment.Fragment;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.appcompat.app.ActionBarDrawerToggle;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.drawerlayout.widget.DrawerLayout;
import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import android.os.Environment;
import android.os.Handler;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.google.firebase.auth.FirebaseAuth;
import com.originaldevelopment.Adapter.MyHeaderPagerAdapter;

import com.originaldevelopment.Interface.UserData;
import com.originaldevelopment.Model.UserModel;
import com.originaldevelopment.rapidcollect.Calculator;
import com.originaldevelopment.rapidcollect.Currency_Calc;
import com.originaldevelopment.rapidcollect.EditProfile;
import com.originaldevelopment.rapidcollect.LocationHistory;
import com.originaldevelopment.rapidcollect.LoginActivity;
import com.originaldevelopment.rapidcollect.MainActivity;
import com.originaldevelopment.rapidcollect.Notifications;
import com.originaldevelopment.rapidcollect.ProgressHud;
import com.originaldevelopment.rapidcollect.R;
import com.originaldevelopment.rapidcollect.RapidTV;
import com.originaldevelopment.rapidcollect.SecurityInfo;
import com.originaldevelopment.rapidcollect.SendMail;
import com.originaldevelopment.rapidcollect.WebViewActivity;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.Timer;
import java.util.TimerTask;

/**
 * A simple {@link Fragment} subclass.
 */
public class HomeFragment extends Fragment implements UserData {
    private  Context context;
    private ViewPager headerviewpager;
    private int current_pos = 0;
    private Timer timer;
    private LinearLayout dotlayout;
    private int dotcustomposi = 0;
    private ActionBarDrawerToggle actionBarDrawerToggle;
    private ImageView profile;
    private TextView name, email;
    private UserModel userModel;
    private MainActivity mainActivity;

    private LinearLayout regitration, securelogin,messages, newsroom, livechat, rapidtv,
    debitorders, neado, debicheck, rapidavs, rapidsdo, digimandate, cloudinvoicing, aboutus, accreditation,
    faqs, covid19, contactus, cashbundle, debtcollection, insurance;

    private LinearLayout mhome, mlocation, mcalculator, mtdo, mnewsroom, mcurrency , mupload, mlivechat , mnotification,
    msecurity, msettings, mlogout, rapidpayments,rapidtelecoms, rapidleagal, rapidsoftware, rapidgroupofcom , rapidmobile, mdownload;

    public HomeFragment(Context context) {
        this.context = context;
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for context fragment

        final View view = inflater.inflate(R.layout.fragment_home, container, false);

        Toolbar toolbar = view.findViewById(R.id.toolbar);


        ((MainActivity)context).setSupportActionBar(toolbar);
        ((MainActivity)context).getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        ((MainActivity)context).getSupportActionBar().setHomeButtonEnabled(true);

        profile = view.findViewById(R.id.profileImageview);
        name = view.findViewById(R.id.menuname);
        email = view.findViewById(R.id.menuemail);

        TextView editprofile = view.findViewById(R.id.editprofile);
        editprofile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, EditProfile.class);
                intent.putExtra("name",userModel.getName());
                intent.putExtra("phone",userModel.getMobile());
                intent.putExtra("profile",userModel.getProfileimage());
                intent.putExtra("title","editprofile");
                startActivity(intent);
            }
        });


        final DrawerLayout drawerLayout = view.findViewById(R.id.drawer);
        actionBarDrawerToggle = new ActionBarDrawerToggle((MainActivity)context, drawerLayout,R.string.open,R.string.close);
        drawerLayout.addDrawerListener(actionBarDrawerToggle);
        actionBarDrawerToggle.syncState();
        //HOME BLOCK START
        regitration = view.findViewById(R.id.registration);
        securelogin = view.findViewById(R.id.login);
        messages = view.findViewById(R.id.message);
        newsroom = view.findViewById(R.id.newsroom);
        livechat = view.findViewById(R.id.livechat);
        rapidtv = view.findViewById(R.id.rapidtv);
        debitorders = view.findViewById(R.id.debitorders);
        neado = view.findViewById(R.id.naedo);
        debicheck = view.findViewById(R.id.debicheck);
        rapidavs = view.findViewById(R.id.rapidavs);
        rapidsdo = view.findViewById(R.id.rapidsdo);
        digimandate = view.findViewById(R.id.digimande);
        cloudinvoicing = view.findViewById(R.id.cloudinvoicing);
        aboutus = view.findViewById(R.id.aboutus);
        accreditation = view.findViewById(R.id.accreditation);
        faqs = view.findViewById(R.id.faqs);
        covid19 = view.findViewById(R.id.covid19);
        contactus = view.findViewById(R.id.contactus);
        cashbundle = view.findViewById(R.id.cashbundle);
        debtcollection = view.findViewById(R.id.debtcollection);
        insurance = view.findViewById(R.id.insurance);

        //END

        //MENU START
        mhome = view.findViewById(R.id.mhome);
        mlocation = view.findViewById(R.id.mlocation);
        mcalculator = view.findViewById(R.id.mcalculator);
        mtdo = view.findViewById(R.id.mtodo);
        mnewsroom = view.findViewById(R.id.mnewsroom);
        mcurrency = view.findViewById(R.id.mcurrencyconvertor);
        mupload = view.findViewById(R.id.mupload);
        mlivechat = view.findViewById(R.id.mlivechat);
        mnotification = view.findViewById(R.id.mnotification);
        msecurity = view.findViewById(R.id.msecurityinfo);
        msettings = view.findViewById(R.id.msettings);
        mlogout = view.findViewById(R.id.mlogout);
        rapidpayments = view.findViewById(R.id.rapidpayements);
        rapidtelecoms = view.findViewById(R.id.rapidtelecoms);
        rapidleagal = view.findViewById(R.id.rapidlegalservices);
        rapidsoftware = view.findViewById(R.id.rapidcollectionsoftware);
        rapidgroupofcom = view.findViewById(R.id.rapidgroypofcompanies);
        rapidmobile = view.findViewById(R.id.rapidmobile);
        mdownload = view.findViewById(R.id.mdownload);
        //END

        ((ImageButton) view.findViewById(R.id.noti)).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, Notifications.class));
            }
        });

        mhome.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();

            }
        });

        mlocation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                startActivity(new Intent(context, LocationHistory.class));

            }
        });

        mcalculator.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
            startActivity(new Intent(context, Calculator.class));
            }
        });

        mtdo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                ((MainActivity) context).changeTabPosition(1);
            }
        });

        mnewsroom.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                ((MainActivity) context).changeTabPosition(3);
            }
        });

        mcurrency.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, Currency_Calc.class));
            }
        });

        mupload.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, EditProfile.class);
                intent.putExtra("name",userModel.getName());
                intent.putExtra("email",userModel.getMail());
                intent.putExtra("profile",userModel.getProfileimage());
                intent.putExtra("title","upload");
                startActivity(intent);
            }
        });

        mlivechat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                ((MainActivity) context).changeTabPosition(2);
            }
        });

        mnotification.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, Notifications.class));
            }
        });

        msecurity.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                startActivity(new Intent(context, SecurityInfo.class));
            }
        });

        msettings.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                ((MainActivity) context).changeTabPosition(4);
            }
        });

        mlogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (FirebaseAuth.getInstance().getCurrentUser() != null) {

                     FirebaseAuth.getInstance().signOut();
                     Intent intent = new Intent(context, LoginActivity.class);
                     intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                    startActivity(intent);




                }
            }
        });
        mdownload.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);

                View view1 = getLayoutInflater().inflate(R.layout.downloadonboard,null);
                TextView textView = view1.findViewById(R.id.download);
                TextView textView1 = view1.findViewById(R.id.sendemail);

                final AlertDialog alertDialog =  builder.create();
                alertDialog.setView(view1);

                textView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();
                       downloadSyllabus();
                    }
                });
                textView1.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();

                            sendEmail(FirebaseAuth.getInstance().getCurrentUser().getEmail());

                    }
                });


                alertDialog.show();

            }
        });


        rapidmobile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                gotoWeb("RAPID MOBILE NETWORK");
            }
        });



        rapidpayments.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                gotoWeb("RAPID PAYMENTS");
            }
        });

        rapidtelecoms.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                gotoWeb("RAPID TELECOMS");
            }
        });

        rapidleagal.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                gotoWeb("RAPID LEGAL SERVICES");
            }
        });

        rapidsoftware.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                gotoWeb("RAPID COLLECTION SOFTWARE");
            }
        });

        rapidgroupofcom.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                drawerLayout.closeDrawers();
                gotoWeb("RAPID GROUP OF COMPANIES");
            }
        });

        regitration.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);

                View view1 = getLayoutInflater().inflate(R.layout.registration_option,null);
                TextView textView = view1.findViewById(R.id.debt);
                TextView textView1 = view1.findViewById(R.id.payment);

                final AlertDialog alertDialog =  builder.create();
                alertDialog.setView(view1);

                textView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();
                        gotoWeb("DEBT ORDERS");
                    }
                });
                textView1.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();
                        gotoWeb("PAYMENTS");
                    }
                });


                alertDialog.show();

            }
        });

        securelogin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("SECURE LOGIN");
            }
        });

        messages.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, Notifications.class));
            }
        });

        newsroom.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity mainActivity = (MainActivity)context;
                mainActivity.changeTabPosition(3);
            }
        });

        livechat.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MainActivity mainActivity = (MainActivity)context;
                mainActivity.changeTabPosition(2);
            }
        });

        rapidtv.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, RapidTV.class));
            }
        });

        debitorders.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("DEBIT ORDERS");
            }
        });

        neado.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("NAEDO");
            }
        });

        debicheck.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("DEBI CHECK");
            }
        });

        rapidavs.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("RAPID AVS");
            }
        });

        rapidsdo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("RAPID SDO");
            }
        });

        digimandate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("digiMandate");
            }
        });

        cloudinvoicing.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("CLOUD INVOICING");

            }
        });

        aboutus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("ABOUT US");
            }
        });

        accreditation.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("ACCREDITATION");
            }
        });

        faqs.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("FAQs");
            }
        });

        covid19.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("COVID-19");
            }
        });

        contactus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("CONTACT US");
            }
        });

        cashbundle.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("CASH BUNDLE");

            }
        });

        debtcollection.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("DEBT COLLECTION");
            }
        });

        insurance.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gotoWeb("INSURANCE");
            }
        });


        actionBarDrawerToggle.getDrawerArrowDrawable().setColor(Color.WHITE);
        drawerLayout.setScrimColor(getResources().getColor(android.R.color.transparent));

        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                    drawerLayout.openDrawer(Gravity.START);
            }
        });
        ImageButton cast = view.findViewById(R.id.cast);
        cast.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                try {
                    startActivity(new Intent("android.settings.WIFI_DISPLAY_SETTINGS"));
                } catch (ActivityNotFoundException e) {
                    e.printStackTrace();
                    try {
                        startActivity(new Intent("com.samsung.wfd.LAUNCH_WFD_PICKER_DLG"));
                    } catch (Exception e2) {
                        try {
                            startActivity(new Intent("android.settings.CAST_SETTINGS"));
                        } catch (Exception e3) {
                            Toast.makeText(context.getApplicationContext(), "Device not supported", Toast.LENGTH_LONG).show();
                        }
                    }
                }
            }
        });
        dotlayout = view.findViewById(R.id.dotlayout);
        headerviewpager = view.findViewById(R.id.headerviewpager);
        int[] images = {R.drawable.b1, R.drawable.b2,R.drawable.b3,R.drawable.b4,R.drawable.b5};
        MyHeaderPagerAdapter myHeaderPagerAdapter = new MyHeaderPagerAdapter(context,images);
        headerviewpager.setAdapter(myHeaderPagerAdapter);
        createSlideShow();
        preparedots(dotcustomposi++);
        headerviewpager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (dotcustomposi > 4) {
                    dotcustomposi = 0;
                }

                preparedots(dotcustomposi++);
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        return view;
    }

    private void preparedots(int dotcustomposi) {
        if (dotlayout.getChildCount() > 0) {
            dotlayout.removeAllViews();
        }

        ImageView[] dots = new ImageView[5];
        for (int i = 0 ; i < 5;i++) {
            dots[i] = new ImageView(context);
            if (i == dotcustomposi) {
                dots[i].setImageDrawable(ContextCompat.getDrawable(context,R.drawable.active_dot));
            }
            else {
                dots[i].setImageDrawable(ContextCompat.getDrawable(context,R.drawable.inactive_dot));
            }

            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,ViewGroup.LayoutParams.WRAP_CONTENT);
            layoutParams.setMargins(10,0,10,0);
            dotlayout.addView(dots[i],layoutParams);

        }

    }

    public void createSlideShow() {
        final Handler handler  = new Handler();
        final Runnable runnable = new Runnable() {
            @Override
            public void run() {
                if (current_pos == 500){
                    current_pos = 0;
                }
                headerviewpager.setCurrentItem(current_pos++, true);

                handler.postDelayed(this,2500);
            }
        };
    handler.postDelayed(runnable,2500);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {

        if (actionBarDrawerToggle.onOptionsItemSelected(item)) {

            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    public void gotoWeb(String title) {
        Intent intent = new Intent(context, WebViewActivity.class);
        intent.putExtra("title",title);
        startActivity(intent);
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        ((MainActivity) context).initializeUserData(this);
         mainActivity = ((MainActivity)context);

    }


    @Override
    public void updateUserData(UserModel userModel) {
        this.userModel = userModel;
        Glide.with(context).load(userModel.getProfileimage()).into(profile);
        name.setText(userModel.getName());
        email.setText(userModel.getMail());


    }

    public void sendEmail(String email) {
        //Creating SendMail object
        SendMail sm = new SendMail(getContext(), email, "RAPID COLLECT REGISTRATION / ON-BOARDING DOCUMENTS (L3)", "<p>Good day <strong>"+ mainActivity.getUserName() +"</strong><br /><br />Thank you for taking the time to enquire for the Rapid Collect services.</p>\n" +
                "<p><span style=\"color: #ff0000;\">Rapid Collect</span>, is your Smart Debit Order and Payments Solutions Partner of Choice!<br /><br />To continue the registration process we require detailed information about yourself and your business. Please click on the link below to be re-directed to the necessary on-boarding and vetting documentation. This contains a list of supporting documents that are required as well.</p>\n" +
                "<p><br /><a href=\"https://rapidcollect.co.za/wp-content/uploads/2020/07/L3-On-Boarding_Registration-Pack-Rapid-Collect.zip \">Click here to download documents</a> which contains all the required documents as outlined below.<br /><br />These required documents contain all the necessary information as required by our vetting department, to complete the registration process with Rapid Collect.</p>\n" +
                "<p><br /><span style=\"color: #ff0000;\"><strong>Document Submission Requirements</strong>:</span></p>\n" +
                "<ol>\n" +
                "<li>Complete All documents correctly and completely;</li>\n" +
                "<li>All documents must be clearly legible, no blurred copies;</li>\n" +
                "<li>Copy of ID must be in colour;</li>\n" +
                "<li>Please Retain the Original documents for collection by us, at a later stage, when we do a <strong>site inspection</strong>.</li>\n" +
                "</ol>\n" +
                "<p><br /><span style=\"color: #ff0000;\"><strong>We require the following documents Fully completed and signed by the client (L3)</strong>:</span></p>\n" +
                "<ol>\n" +
                "<li>Addendum A &ndash; Mandatory Required Docs - Rapid Collect V1.1</li>\n" +
                "<li>Addendum B &ndash; Nature of Transactions &ndash; Rapid Collect V1.1</li>\n" +
                "<li>Addendum C &ndash; POA &ndash; Business Address SA &ndash; Rapid Collect V1.1</li>\n" +
                "<li>Addendum D &ndash; Company Resolution &ndash; Rapid Collect</li>\n" +
                "<li>Addendum E &ndash; ABSA Debit Order Abuse Letter</li>\n" +
                "<li>Addendum F &ndash; NAEDO/Debicheck Sample Mandate Wording for Transcription &ndash; Rapid Collect V1.1</li>\n" +
                "<li>Addendum G &ndash; Accountant Authorisation/Confirmation Letter &ndash; Rapid Collect</li>\n" +
                "<li>Addendum H &ndash; Rapid Collect Terms and Conditions for L3 User V1.1</li>\n" +
                "<li>Addendum I &ndash; Request For Services Application &ndash; Rapid Collect V1.1</li>\n" +
                "<li>Addendum J1 &ndash; NEW EDO PSSF Beneficiary Application Form V3.03</li>\n" +
                "<li>Addendum J2 &ndash; Pre-Vetting Questionnaire &ndash; Rapid Collect V1.1</li>\n" +
                "<li>Addendum K &ndash; Rapid Pricing Quotation V1.1</li>\n" +
                "<li>Addendum L &ndash; Official Client Checklist &ndash; Rapid Collect V1.1</li>\n" +
                "<li>Addendum M &ndash; Sample Mandate Confirmation to be signed by client (L3)</li>\n" +
                "<li>ABSA User Pre-Screening Document (To be Fully Completed and Signed together with the supporting Documents)</li>\n" +
                "</ol>\n" +
                "<p>Once you have all the documents ready together with all the relevant documents being certified, please scan and email the documents to: <a href=\"mailto:vetting@rapidcollect.co.za\">vetting@rapidcollect.co.za</a></p>\n" +
                "<p>If the files are too large to send as an attachment in an email, please send us a <u>weTransfer or Dropbox link</u> with all the above documents (uploaded) together with all the required supporting documents to: <a href=\"mailto:vetting@rapidcollect.co.za\">vetting@rapidcollect.co.za</a><br /><br /><span style=\"color: #ff0000;\"><strong>The Process</strong>:</span></p>\n" +
                "<ol>\n" +
                "<li>Only once we have received all of the above documents will your application begin to be processed.</li>\n" +
                "<li>Once all documents have been received you will be sent an invoice for your &ldquo;<strong>sign up fee&rdquo;</strong>.</li>\n" +
                "<li>This must be paid immediately upon receipt of the invoice in order for vetting to proceed.</li>\n" +
                "<li>Rapid Collect will then process your application, upon PASA and Bank approval, final agreement will be sent to you for signature and upon receipt of returned signed agreement, our compliance department will initiate your EDO PSSF Beneficiary membership registration.</li>\n" +
                "<li>The EDO PSSF will invoice you directly for this fee which you will receive via email as registered with Rapid Collect.</li>\n" +
                "<li>It could take approximately +/-14 days from the time we receive payment for the Rapid Collect application processing fee until your user profile is created on the Rapid Collect SO system and you are given access to capture / upload your debit orders.</li>\n" +
                "</ol>\n" +
                "<p><br />For any further information, please do not hesitate to contact us as follows:</p>\n" +
                "<p>Ashleigh Mervyn: <a href=\"mailto:ashleigh@rapidcollect.co.za\">ashleigh@rapidcollect.co.za</a></p>\n" +
                "<p>Bertram Witbooi: <a href=\"mailto:bertram@rapidcollect.co.za\">bertram@rapidcollect.co.za</a></p>\n" +
                "<p>Liza: <a href=\"mailto:liza@rapidcollect.co.za\">liza@rapidcollect.co.za</a></p>\n" +
                "<p><strong>Compliance / Sales Department:</strong></p>\n" +
                "<p>Compliance Department: <a href=\"mailto:compliance@rapidcollect.co.za\">compliance@rapidcollect.co.za</a></p>\n" +
                "<p>Sales Department: <a href=\"mailto:sales@rapidcollect.co.za\">sales@rapidcollect.co.za</a></p>\n" +
                "<p>&nbsp;Kind Regards</p>\n" +
                "<p><strong>THE <span style=\"color: #ff0000;\">RAPID COLLECT</span> SALES AND ON-BOARDING TEAM</strong></p>\n" +
                "<p>&nbsp;</p>\n" +
                "<p>&nbsp;</p>\n" +
                "<p>&nbsp;</p>\n" +
                "<p>&nbsp;</p>\n" +
                "<p>&nbsp;</p>\n" +
                "<p>&nbsp;</p>\n" +
                "<p><strong>Disclaimer</strong>:&nbsp;\"This message may contain confidential information, including any attachments, that is legally privileged and is intended only for the use of the parties to whom it is&nbsp;addressed. If you are not an intended recipient, you are hereby notified that any disclosure, copying, distribution or use of any information in this message is strictly prohibited&nbsp;and illegal. If you have received this message in error, please notify the sender immediately and delete the message.\"</p>\n" +
                "<p>Sovereign Confidentiality Notice:&nbsp;This private email message, including any attachment(s) is limited to the sole use of the intended recipient and may contain Privileged and/or&nbsp;Confidential Information. Any and All Political, Private or Public Entities, Federal, State, or Local Corporate Government(s), Municipality(ies), International Organizations,&nbsp;Corporation(s), Agent(s), Investigator(s), or Informant(s) , et. al., and/or Third Party(ies) working in collusion collecting and/or monitoring My email(s), and any other means&nbsp;of spying and collecting these communications, without my Exclusive Permission are Barred from Any and All Unauthorized Review, Use, Disclosure or Distribution. With Explicit&nbsp;Reservation of All My Rights, Without Prejudice and Without Recourse to Me. Any omission does not constitute a waiver of any and/or ALL Intellectual Property Rights or&nbsp;Reserved Rights. NOTICE TO PRINCIPLE IS NOTICE TO AGENT. NOTICE TO AGENT IS NOTICE TO PRINCIPLE</p>\n" +
                "<p>This disclaimer and notice forms part of the content of this e-mail for purposes of section 11 of the Electronic Communications and Transactions Act, 2002 (Act No. 25 of 2002)</p>\n" +
                "<p><strong>Please consider your environmental responsibility before printing this e-mail.</strong></p>");

        sm.execute();
    }


    public void downloadSyllabus() {

        if (Build.VERSION.SDK_INT >= 23)
        {
            if (checkPermission())
            {
                downlod();
            } else {

                requestPermission(); // Code for permission
            }
        }
        else
        {
            downlod();
        }



    }

    private boolean checkPermission() {
        int result = ContextCompat.checkSelfPermission(context, android.Manifest.permission.WRITE_EXTERNAL_STORAGE);
        if (result == PackageManager.PERMISSION_GRANTED) {
            return true;
        } else {
            return false;
        }
    }

    private void requestPermission() {

        if (ActivityCompat.shouldShowRequestPermissionRationale(mainActivity, android.Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
            Toast.makeText(context, "Write External Storage permission allows us to do store images. Please allow this permission in App Settings.", Toast.LENGTH_LONG).show();
        } else {
            ActivityCompat.requestPermissions(mainActivity, new String[]{android.Manifest.permission.WRITE_EXTERNAL_STORAGE}, 10);
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 10:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                  downlod();
                } else {
                    Log.e("value", "Permission Denied, You cannot use local drive .");
                }
                break;
        }
    }

    public void downlod() {

        DownloadFile df = new DownloadFile();
        String filename = "On-Boarding-Pack.zip";
        String root = Environment.getExternalStorageDirectory().toString();
        String fullFileNmae = root+"/"+filename;
        File file = new File(fullFileNmae);
        if (file.exists()) {
            Toast toast = Toast.makeText(context, "Successfully Downloaded!\nOn-Boarding-Pack.zip File", Toast.LENGTH_SHORT);
            toast.setGravity(Gravity.CENTER,0,0);
            toast.show();
        }
        else
            df.execute("https://rapidcollect.co.za/wp-content/uploads/2020/07/L3-On-Boarding_Registration-Pack-Rapid-Collect.zip", filename);

    }

    public class DownloadFile extends AsyncTask<String, String, String> {



        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            ProgressHud.dialog.dismiss();
            ProgressHud.show(context,"Downloading...");
        }


        @Override
        protected String doInBackground(String... f_url) {
            int count;
            try {


                URL url = new URL(f_url[0]);
                URLConnection conection = url.openConnection();
                conection.connect();
                // getting file length
                int lenghtOfFile = conection.getContentLength();

                // input stream to read file - with 8k buffer
                InputStream input = new BufferedInputStream(url.openStream(), 8192);

                // Output stream to write file
                //OutputStream output;
                String root = Environment.getExternalStorageDirectory().toString();
                String fullFileNmae = root +"/On-Boarding-Pack.zip";
                /*for(int i=0;i<Integer.MAX_VALUE;i++)
                {
                    fullFileNmae="/sdcard/Download/"+filename+'(' + i + ')' +ex;
                }*/
                OutputStream output = new FileOutputStream(fullFileNmae);

                //OutputStream output = new FileOutputStream("/storage/syllabus"+ex);

                byte data[] = new byte[1024];

                long total = 0;

                while ((count = input.read(data)) != -1) {
                    total += count;
                    // publishing the progress....
                    // After this onProgressUpdate will be called
                    publishProgress("" + (int) ((total * 100) / lenghtOfFile));

                    // writing data to file

                    output.write(data, 0, count);

                }

                // flushing output
                output.flush();

                // closing streams
                output.close();
                input.close();

                return fullFileNmae;
            } catch (Exception e) {
                Log.e("Error: ", e.getMessage());
            }

            return null;
        }

        @Override
        protected void onPostExecute(String file_url) {
            ProgressHud.dialog.dismiss();
            // Log.d("URIASAS",file_url);

            if (file_url == null) {
                Toast toast = Toast.makeText(context, "Downlad Failed!", Toast.LENGTH_SHORT);
                toast.setGravity(Gravity.CENTER,0,0);
                toast.show();
            } else {
                Toast toast = Toast.makeText(context, "Successfully Downloaded!\nOn-Boarding-Pack.zip File", Toast.LENGTH_SHORT);
                toast.setGravity(Gravity.CENTER,0,0);
                toast.show();
            }
        }

    }
}
