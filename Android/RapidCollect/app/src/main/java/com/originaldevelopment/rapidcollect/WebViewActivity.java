package com.originaldevelopment.rapidcollect;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageView;
import android.widget.TextView;

import com.airbnb.lottie.LottieAnimationView;

public class WebViewActivity extends AppCompatActivity {

    private LottieAnimationView lottieAnimationView;
    private WebView webView;
    private String title;
    private TextView toolbartitle;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web_view);


        lottieAnimationView = findViewById(R.id.animation_view);
        webView = findViewById(R.id.webview);
        title = getIntent().getStringExtra("title");
        toolbartitle = findViewById(R.id.toolbar_title);
        toolbartitle.setText(title);

        ImageView imageView = findViewById(R.id.back);
        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        webView.setWebChromeClient(new WebChromeClient());
        webView.setWebViewClient(new WebViewClient(){
            @Override
            public void onPageFinished(WebView view, String url) {
                try{
                    lottieAnimationView.pauseAnimation();
                }
                catch (Exception e) {

                }
                lottieAnimationView.setVisibility(View.GONE);
            }
        });

        WebSettings webSettings = webView.getSettings();


        webSettings.setDomStorageEnabled(true);
        webView.getSettings().setLoadWithOverviewMode(true);
        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.getSettings().setAllowFileAccess(true);
        webView.getSettings().setAppCachePath( getCacheDir().getAbsolutePath() );
        webView.getSettings().setAppCacheEnabled(true);
        webView.getSettings().setAllowContentAccess(true);
        webView.setScrollbarFadingEnabled(false);

        switch(title) {

            case "INSURANCE" :
                webView.loadUrl("https://micover.co.za");
                break;

            case "DEBT COLLECTION" :

                webView.loadUrl("https://rapidlegalservices.co.za");
                break;

            case "CASH BUNDLE" :

                webView.loadUrl("https://rapidcollect.co.za/rapid-cash-bundle/");
                break;

            case "COVID-19" :
                webView.loadUrl("https://sacoronavirus.co.za");
                break;

            case "DEBIT ORDERS" :
                webView.loadUrl("https://rapidcollect.co.za/debit-orders/");
                break;
            case "NAEDO":
                webView.loadUrl("https://rapidcollect.co.za/naedo/");
                break;

            case "RAPID AVS" :
               webView.loadUrl("https://rapidcollect.co.za/rapid-avs-ahv/");
                break;
            case "RAPID SDO":
                webView.loadUrl("https://rapidcollect.co.za/strike-date-optimization/");

                break;

            case "DEBI CHECK" :
                toolbartitle.setText("DebiCheck");
                webView.loadUrl("https://rapidcollect.co.za/debicheck/");
                break;
            case "digiMande":
                webView.loadUrl("https://rapidcollect.co.za/digimandate/");
                break;

            case "CLOUD INVOICING" :
                webView.loadUrl("https://rapidcollect.co.za/cloud-invoicing/");
                break;

            case "ACCREDITATION" :
                webView.loadUrl("https://rapidcollect.co.za/accreditation/");

                break;

            case "SUPPORTING DOCUMENTS" :
                webView.loadUrl("https://rapidcollect.co.za/fica/");
                break;

            case "CONTACT US":
                webView.loadUrl("https://rapidcollect.co.za/contact-us/");
                break;


            case "FAQs" :
                webView.loadUrl("https://rapidcollect.co.za/faq/");
                break;


            case "SECURE LOGIN" :
               webView.loadUrl("https://so.rapidcollect.co.za/scripts/users/sys_login.php");
               break;

            case "DEBT ORDERS" :
                toolbartitle.setText("DEBIT ORDERS");
                webView.loadUrl("https://rapidcollect.co.za/register-for-debit-orders/");
                break;

            case "PAYMENTS" :
                webView.loadUrl("https://rapidcollect.co.za/register-for-payments/");
                break;

            case "RAPID MOBILE NETWORK" :
                webView.loadUrl("https://www.rapidmobile.co.za");
                break;
//
//            case "rapidlegal" :
//                navigationItem.title = "RAPID LEGAL SERVICES"
//
//                loadWeb(myurl: "https://rapidlegalservices.co.za")
//                break
//
//            case "rapidlegalsystem" :
//                navigationItem.title = "RAPID COLLECTION SOFTWARE SYSTEM"
//
//                loadWeb(myurl: "https://www.rapidcss.co.za")
//                break
//
//            case "rapidgroup" :
//                navigationItem.title = "RAPID GROUP OF COMPANIES"
//
//                loadWeb(myurl: "https://www.rapidgroup.co.za")
//                break
//

            case "TERMS & CONDITIONS" :
                webView.loadUrl("https://rapidcollect.co.za/terms-and-conditions/");
                break;

            case "ABOUT US" :
                webView.loadUrl("https://rapidcollect.co.za/about-us/");
                break;

            case "DOCUMENTS" :
                webView.loadUrl("https://rapidcollect.co.za/fica");
                break;

            case  "RAPID PAYMENTS"  :

                webView.loadUrl("https://rapidpayments.africa");
                break;

            case "RAPID TELECOMS" :
                webView.loadUrl("https://rapidtelecoms.com");
                break;

            case "RAPID LEGAL SERVICES" :
                webView.loadUrl("https://rapidlegalservices.co.za");

                break;

            case  "RAPID COLLECTION SOFTWARE":
                webView.loadUrl("https://www.rapidcss.co.za");

                break;

            case "RAPID GROUP OF COMPANIES" :
                webView.loadUrl("https://www.rapidgroup.co.za");

                break;
            default :
                Log.d("OK","OK");
        }




    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            getWindow().getDecorView().setSystemUiVisibility(
                    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                            | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                            | View.SYSTEM_UI_FLAG_FULLSCREEN
                            | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
        }
    }
}
