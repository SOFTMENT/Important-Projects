package com.originaldevelopment.CurrencyConvertor;



import java.util.Map;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.QueryMap;

public interface ApiInterface {




   // @FormUrlEncoded
    @GET("/latest")
    Call<LatestModel> getConvetrCuruncy(@QueryMap Map<String, String> apiVersionMap);
}