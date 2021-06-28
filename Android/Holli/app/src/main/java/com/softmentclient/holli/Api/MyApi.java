package com.softmentclient.holli.Api;


import com.softmentclient.holli.Const;
import com.softmentclient.holli.MyResponse;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Query;

public class MyApi {


    Retrofit myHtmlCall = new Retrofit.Builder().baseUrl("https://checkout.freecharge.in/").build();

    public Retrofit getMyHtmlCall() {
        return myHtmlCall;
    }
}









