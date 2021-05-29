package com.originaldevelopment.API;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.originaldevelopment.NewsRoomWordpress.NewsRoomWordpress;

import java.util.List;
import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.http.GET;
import retrofit2.http.Url;


public class Api {
    private static RetrofitArray retrofitArray = null;
    private static final String URL= "http://rapidcollect.co.za/";

    public static RetrofitArray getApi() {

        if(retrofitArray == null ) {
            Gson gson = new GsonBuilder()
                    .setLenient()
                    .create();

            OkHttpClient okHttpClient = new OkHttpClient().newBuilder()
                    .connectTimeout(400, TimeUnit.SECONDS)
                    .readTimeout(600, TimeUnit.SECONDS)
                    .writeTimeout(600, TimeUnit.SECONDS)
                    .build();

            Retrofit retrofit =  new Retrofit.Builder().client(okHttpClient).baseUrl(URL).addConverterFactory(GsonConverterFactory.create(gson)).build();

            retrofitArray = retrofit.create(RetrofitArray.class);
        }
        return retrofitArray;

    }

    public interface RetrofitArray {


        @GET
        Call<List<NewsRoomWordpress>> getPost(@Url String url);





    }
}
