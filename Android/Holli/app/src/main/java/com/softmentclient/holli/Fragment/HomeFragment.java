package com.softmentclient.holli.Fragment;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.webkit.CookieManager;
import android.webkit.JavascriptInterface;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AlertDialog;
import androidx.cardview.widget.CardView;
import androidx.fragment.app.Fragment;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.android.volley.AuthFailureError;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.github.ybq.android.spinkit.SpinKitView;
import com.github.ybq.android.spinkit.sprite.Sprite;
import com.github.ybq.android.spinkit.style.Wave;
import com.google.firebase.installations.Utils;
import com.google.gson.JsonElement;
import com.softmentclient.holli.AdminScreen;
import com.softmentclient.holli.Api.MyApi;
import com.softmentclient.holli.Const;
import com.softmentclient.holli.Interface.RefreshCall;
import com.softmentclient.holli.MainActivity;
import com.softmentclient.holli.MyResponse;
import com.softmentclient.holli.R;
import com.softmentclient.holli.Service.MySingleton;
import com.softmentclient.holli.Service.WriteHandlingWebResourceRequest;
import com.softmentclient.holli.Service.WriteHandlingWebViewClient;

import org.apache.http.util.EncodingUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.POST;
import retrofit2.http.Query;

import static android.content.ContentValues.TAG;


public class HomeFragment extends Fragment implements RefreshCall {

    private WebView myWebView;
    private FrameLayout frameLayout;
    private ProgressBar progressBar;
    private MainActivity mainActivity;
    private boolean flag = false;
    private SpinKitView lottieAnimationView;
    boolean loadingFinished = true;
    boolean redirect = false;
    public HomeFragment(Context context) {
        mainActivity = (MainActivity)context;

    }


    @SuppressLint("JavascriptInterface")
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = getLayoutInflater().inflate(R.layout.fragment_home,container,false);

        lottieAnimationView = view.findViewById(R.id.spin_kit);
        Sprite doubleBounce = new Wave();
        lottieAnimationView.setIndeterminateDrawable(doubleBounce);

        final SwipeRefreshLayout swipeRefreshLayout = view.findViewById(R.id.swipe);
        myWebView = view.findViewById(R.id.webpage);
        frameLayout = view.findViewById(R.id.frame);
        progressBar = view.findViewById(R.id.progressbar);

        if (android.os.Build.VERSION.SDK_INT >= 21) {
            CookieManager.getInstance().setAcceptThirdPartyCookies(myWebView, true);
        } else {
            CookieManager.getInstance().setAcceptCookie(true);
        }
        view.findViewById(R.id.admin).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getContext(), AdminScreen.class));

            }
        });

        myWebView.setWebViewClient(new WebViewClient() {

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String urlNewString) {
                if (!loadingFinished) {
                    redirect = true;
                }

                Log.d("HELLOBOSS",urlNewString);
                loadingFinished = false;
                myWebView.loadUrl(urlNewString);
                return true;
            }

            @Override
            public void onPageStarted(WebView view, String url, Bitmap favicon) {
                loadingFinished = false;
            }


            @Override
            public void onPageFinished(WebView view, String url) {
                if (!redirect) {
                    loadingFinished = true;
                    //HIDE LOADING IT HAS FINISHED
                } else {
                    redirect = false;
                }
            }
        });





        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                myWebView.reload();
                swipeRefreshLayout.setRefreshing(false);
            }
        });




        myWebView.setWebChromeClient(new ChromeClinet());

        WebSettings webSettings = myWebView.getSettings();


        webSettings.setDomStorageEnabled(true);
        myWebView.getSettings().setLoadWithOverviewMode(true);
        myWebView.getSettings().setUseWideViewPort(true);
        myWebView.getSettings().setJavaScriptEnabled(true);
        myWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        myWebView.getSettings().setAllowFileAccess(true);
        myWebView.getSettings().setCacheMode( WebSettings.LOAD_DEFAULT);
       myWebView.requestFocusFromTouch();
        if ( !isNetworkAvailable(getContext()) ) {
            myWebView.getSettings().setCacheMode( WebSettings.LOAD_CACHE_ELSE_NETWORK );
        }

        myWebView.getSettings().setAllowContentAccess(true);
        myWebView.setScrollbarFadingEnabled(false);


        myWebView.addJavascriptInterface(new PaymentInterface(), "PaymentInterface");
        String textId = "SM"+System.currentTimeMillis();
        String checkSum = "NoCheckSum";


        String json = "{\"amount\":\"20.00\",\"channel\":\"WEB\",\"furl\":\"https://softment.in/freecharge.php\",\"merchantId\":\"B8fXTGrWIElOsR\",\"merchantTxnId\":\"123456797\",\"surl\":\"https://softment.in/freecharge.php\"}";
        try {
            checkSum =  generateChecksum(json,"e8c26740-e012-4196-9299-5c1bf8df3ac8");
        } catch (Exception e) {
            e.printStackTrace();
        }

        Log.d("JSON",json);
        Log.d("Checksum",checkSum);


        myWebView.setScrollbarFadingEnabled(false);

        progressBar.setMax(100);
        progressBar.setProgress(0);


     String url  = "https://checkout.freecharge.in/api/v1/co/pay/init";
        String data = null;
        try {
            data = "access_token="+ URLEncoder.encode(checkSum, "UTF-8")+ "&merchantId="+ URLEncoder.encode("B8fXTGrWIElOsR", "UTF-8")+"&checksum="+URLEncoder.encode(checkSum, "UTF-8")+"&amount="+URLEncoder.encode("20.00", "UTF-8")+"&furl="+URLEncoder.encode("https://softment.in/freecharge.php", "UTF-8")+"&channel="+URLEncoder.encode("WEB", "UTF-8")+"&merchantTxnId="+URLEncoder.encode("123456797", "UTF-8")+"&surl="+URLEncoder.encode("https://softment.in/freecharge.php", "UTF-8");
            Log.d("VIJAY",data);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        Log.d("VIJAY",data);
//       Log.d("URL",url);

            myWebView.postUrl(url, data.getBytes());



//        String finalCheckSum = checkSum;
//        String finalCheckSum1 = checkSum;
//        new MyApi().getMyHtmlCall().create(PayTm.class).generateTokenCall("Bearer " + checkSum,"300.00","WEB",checkSum,"https://softment.in/freecharge.php","B8fXTGrWIElOsR","929292929292911441","https://softment.in/freecharge.php").enqueue(new Callback<ResponseBody>() {
//            @Override
//            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> response) {
//
//                myWebView.loadUrl("https://login.freecharge.in/login?callbackurl=https://checkout.freecharge.in/payment");
//            }
//
//            @Override
//            public void onFailure(Call<ResponseBody> call, Throwable t) {
//                Log.d("VIJAY",t.getMessage());
//
//            }
//        });


//
//
//        new MyApi().getRetrofit().create(PayTmServiceInterface.class).getValue(checkSum).enqueue(new Callback<JsonElement>() {
//            @Override
//            public void onResponse(Call<JsonElement> call, Response<JsonElement> response) {
//                Log.d("VIJAY",response.toString());
//            }
//
//            @Override
//            public void onFailure(Call<JsonElement> call, Throwable t) {
//                Log.d("VIJAY1",t.getMessage());
//
//            }
//        });
        return view;
    }


    interface PayTm {


        @FormUrlEncoded
        @POST("api/v1/co/pay/init")
        Call<ResponseBody> generateTokenCall(
                @Header("Authorization") String token,
                @Field("amount") String amount,
                @Field("channel") String channel,
                @Field("checksum") String checksum,
                @Field("furl") String furl,
                @Field("merchantId" ) String merchantId,
                @Field("merchantTxnId") String merchantTxnId,
                @Field("surl") String surl

        );

    }


    public String generateChecksum(String jsonString, String merchantKey)
            throws Exception {
        MessageDigest md;
        String plainText = jsonString.concat(merchantKey);


        try {
            md = MessageDigest.getInstance("sha-256");
        } catch (NoSuchAlgorithmException e)
        {
            throw new Exception(); //
        }
        md.update(plainText.getBytes(Charset.defaultCharset()));
        byte[] mdbytes = md.digest();
        // convert the byte to hex format method 1
        StringBuffer checksum = new StringBuffer();
        for (int i = 0; i < mdbytes.length; i++)
        {
            checksum.append(Integer.toString((mdbytes[i] & 0xff) +
                    0x100, 16).substring(1));
        }
        return checksum.toString();
    }



//
//    public static String getSha256Hash(String json, String key) {
//        try {
//            MessageDigest digest = null;
//            try {
//                digest = MessageDigest.getInstance("SHA-256");
//            } catch (NoSuchAlgorithmException e1) {
//                e1.printStackTrace();
//            }
//            digest.reset();
//            return bin2hex(digest.digest(json.concat(key).getBytes()));
//        } catch (Exception ignored) {
//            return null;
//        }
//    }



    @Override
    public void refresh() {
        myWebView.reload();
    }

    private class ChromeClinet extends WebChromeClient {

        public void onProgressChanged(WebView webView, int progress) {
            frameLayout.setVisibility(View.VISIBLE);
            progressBar.setProgress(progress);

            if (progress == 100) {
                frameLayout.setVisibility(View.GONE);
                lottieAnimationView.setVisibility(View.GONE);
            }
            super.onProgressChanged(webView, progress);
        }


        private View mCustomView;
        private CustomViewCallback mCustomViewCallback;
        protected FrameLayout mFullscreenContainer;
        private int mOriginalOrientation;
        private int mOriginalSystemUiVisibility;

        ChromeClinet() {}

        public Bitmap getDefaultVideoPoster()
        {
            if (mCustomView == null) {
                return null;
            }
            return BitmapFactory.decodeResource(getResources(), 2130837573);
        }

        public void onHideCustomView()
        {
            Window window =  mainActivity.getWindow();
            ((FrameLayout)window.getDecorView()).removeView(this.mCustomView);
            this.mCustomView = null;
            mainActivity.getWindow().getDecorView().setSystemUiVisibility(this.mOriginalSystemUiVisibility);
            mainActivity.setRequestedOrientation(this.mOriginalOrientation);

            this.mCustomViewCallback.onCustomViewHidden();
            this.mCustomViewCallback = null;
        }

        public void onShowCustomView(View paramView, CustomViewCallback paramCustomViewCallback)
        {
            if (this.mCustomView != null)
            {
                onHideCustomView();
                return;
            }
            this.mCustomView = paramView;
            this.mOriginalSystemUiVisibility = mainActivity.getWindow().getDecorView().getSystemUiVisibility();
            this.mOriginalOrientation = mainActivity.getRequestedOrientation();
            this.mCustomViewCallback = paramCustomViewCallback;
            Window window = mainActivity.getWindow();
            ((FrameLayout)window.getDecorView()).addView(this.mCustomView, new FrameLayout.LayoutParams(-1, -1));
            window.getDecorView().setSystemUiVisibility(3846 | View.SYSTEM_UI_FLAG_LAYOUT_STABLE);
        }



    }






    public boolean isNetworkAvailable(Context context) {

        ConnectivityManager connectivityManager = ((ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE));

        return connectivityManager.getActiveNetworkInfo() != null && connectivityManager.getActiveNetworkInfo().isConnected();
    }


    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        ((MainActivity)context).initializeRefresh(this);
    }
}


class PaymentInterface{
    @JavascriptInterface
    public void success(String data){
        Log.d("WAAHVIJAY",data);
    }

    @JavascriptInterface
    public void error(String data){
        Log.d("WAAHVIJAY",data);
    }

}