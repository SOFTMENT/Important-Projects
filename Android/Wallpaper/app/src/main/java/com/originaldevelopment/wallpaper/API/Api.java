package com.originaldevelopment.wallpaper.API;



import com.originaldevelopment.wallpaper.AllWallpaper;

import java.util.List;

import okhttp3.Response;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Url;

public interface Api {

    String BASE_URL = "http://thepixtures.in/";
    @GET("fetch1.php")
    Call<List<AllWallpaper>> getData();

    @GET
    Call<ResponseBody> downloadFileWithDynamicUrlSync(@Url String fileUrl);

}
