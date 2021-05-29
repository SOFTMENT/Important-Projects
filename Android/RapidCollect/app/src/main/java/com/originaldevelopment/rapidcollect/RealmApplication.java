package com.originaldevelopment.rapidcollect;

import android.app.Application;

import com.originaldevelopment.CurrencyConvertor.CurruncyConvrt;

import io.realm.Realm;
import io.realm.RealmConfiguration;

public class RealmApplication extends CurruncyConvrt {
    @Override
    public void onCreate() {
        super.onCreate();
        Realm.init(this);
        RealmConfiguration configuration = new RealmConfiguration.Builder().build();
        Realm.setDefaultConfiguration(configuration);
    }
}
