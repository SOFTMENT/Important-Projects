package com.originaldevelopment.CurrencyConvertor;


import retrofit2.Retrofit;

public class ApiClient {
    // set your server n Api Base path here @ BASE URL

    public static Retrofit getClient() {
        return CurruncyConvrt.retrofit;
    }
}