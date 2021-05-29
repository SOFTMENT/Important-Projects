package com.svenska.digginz.Fragment;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.ProgressBar;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.github.ybq.android.spinkit.SpinKitView;
import com.github.ybq.android.spinkit.sprite.Sprite;
import com.github.ybq.android.spinkit.style.Wave;
import com.svenska.digginz.Interface.RefreshCall;
import com.svenska.digginz.MainActivity;
import com.svenska.digginz.R;


public class HomeFragment extends Fragment implements RefreshCall {

    private WebView myWebView;
    private FrameLayout frameLayout;
    private ProgressBar progressBar;
    private MainActivity mainActivity;
    private boolean flag = false;
    private SpinKitView lottieAnimationView;
    public HomeFragment(Context context) {
        mainActivity = (MainActivity)context;

    }


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



        myWebView.setWebViewClient(new WebViewClient() {
            public boolean shouldOverrideUrlLoading(WebView webView, String url) {
                webView.loadUrl(url);
                frameLayout.setVisibility(View.VISIBLE);
                return true;
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
        myWebView.getSettings().setAllowFileAccess(true);
        myWebView.getSettings().setCacheMode( WebSettings.LOAD_DEFAULT);

        if ( !isNetworkAvailable(getContext()) ) {
            myWebView.getSettings().setCacheMode( WebSettings.LOAD_CACHE_ELSE_NETWORK );
        }

        myWebView.getSettings().setAllowContentAccess(true);
        myWebView.setScrollbarFadingEnabled(false);

        myWebView.loadUrl("https://digginz.com");

        myWebView.setScrollbarFadingEnabled(false);

        progressBar.setMax(100);
        progressBar.setProgress(0);



        return view;
    }

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
