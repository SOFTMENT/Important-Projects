package com.originaldevelopment.rapidcollect;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.originaldevelopment.NewsRoomWordpress.Title;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ShowNewsRoomContent extends AppCompatActivity {
    private WebView webView;
    private TextView title, date;
    private ImageView imageView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_show_news_room_content);

        final String sTitle = getIntent().getStringExtra("title");
        String sContent = getIntent().getStringExtra("content");
        final String sDate = getIntent().getStringExtra("date");
        final String sImage = getIntent().getStringExtra("image");
        ImageView back = findViewById(R.id.back);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        webView = findViewById(R.id.webview);
        title = findViewById(R.id.contenttitle);
        date = findViewById(R.id.contentdate);
        imageView = findViewById(R.id.contentimage);
        Glide.with(this).load(sImage).into(imageView);




        // sContent = sContent.replace("<script async defer src=\"//www.instagram.com/embed.js\"></script>","<script async defer src=\"https://platform.instagram.com/en_US/embeds.js\">");
        title.setText(sTitle);
        date.setText(sDate);
        webView.getSettings().setJavaScriptEnabled(true);
//        webView.getSettings().setLoadWithOverviewMode(true);
//        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setPluginState(WebSettings.PluginState.ON);
//        // webView.loadData("<iframe src=\"https://www.facebook.com/plugins/video.php?href=https%3A%2F%2Fwww.facebook.com%2FdeveloperPvj%2Flive%2F&show_text=false&width=735&appId=537027176709773&height=413\" width=\"735\" height=\"413\" style=\"border:none;overflow:hidden\" scrolling=\"no\" frameborder=\"0\" allowTransparency=\"true\" allow=\"encrypted-media\" allowFullScreen=\"true\"></iframe>","text/htmk","utf-8");
//        String webContent = "<iframe src=\"https://www.facebook.com/plugins/video.php?href=https%3A%2F%2Fwww.facebook.com%2FdeveloperPvj%2Flive%2F&show_text=false&width=735&appId=537027176709773&width=\"735\"style=\"border:none;overflow:hidden\" scrolling=\"no\" frameborder=\"0\" allowTransparency=\"true\" allow=\"encrypted-media\" allowFullScreen=\"true\"></iframe>";
//
//        webView.loadDataWithBaseURL("", "<style>iframe { display: block;max-width:100%;max-height : 96%; height : 1600;margin-top:10px; margin-bottom:10px; width : 1600;}</style>"+webContent , "text/html",  "UTF-8", "");



        //
      if(sContent.contains("www.instagram.com/embed.js"))
            webView.loadDataWithBaseURL("http://rapidcollect.co.za/", "<style>img{display : block;height: auto;max-width: 100% ; width : 1600;}  iframe { display: block;max-width:100%;margin-top:10px; margin-bottom:10px; width : 1600;} body {font-size : 13px;font-family: \"Times New Roman\", Times, serif;}</style>"+sContent, "text/html", "utf-8", "");
        else
            webView.loadDataWithBaseURL("http://rapidcollect.co.za/", "<style>img{display : block;height: auto;max-width: 100% ;width : 1600;}  iframe { display: block;max-width:100%;height:190;margin-top:10px; margin-bottom:10px;width : 1600;} body {font-size : 13px;font-family: \"Times New Roman\", Times, serif;}</style>"+sContent, "text/html", "utf-8", "");


    }


}
