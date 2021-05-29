package com.originaldevelopment.rapidcollect;

import android.app.IntentService;
import android.content.Intent;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.os.Bundle;
import android.os.ResultReceiver;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

public class FetchAddressService extends IntentService {

    private ResultReceiver resultReceiver;
    public FetchAddressService() {
        super("FetchAddressService");
    }

    @Override
    protected void onHandleIntent(@Nullable Intent intent) {
        if (intent != null) {
           resultReceiver = intent.getParcelableExtra(Constants.RECEIVER);
            Location location = intent.getParcelableExtra(Constants.LOCATION_DATA_EXTRA);
            if (location == null) {
                return;
            }
            Geocoder geocoder = new Geocoder(this, Locale.getDefault());
            List<Address> addresses = null;
            try {
                addresses = geocoder.getFromLocation(location.getLatitude(), location.getLongitude(),1);

            }
            catch (Exception e){

            }

            if (addresses == null || addresses.isEmpty()){
                deliverResultToReceiver(Constants.FAILURE_RESULT,"FAILED");

            }
            else {
                Address address = addresses.get(0);
                String line1 = "";

                String street1 = address.getSubThoroughfare();
                    if (!(street1 == null))
                    line1 += street1 + ", ";


                String street2 = address.getThoroughfare();
                if (!(street2 == null))
                    line1 += street2;

                    String line2 = "";
                  String city = address.getSubAdminArea();
                    line2 += city + ", ";

                String state  = address.getAdminArea();
                    line2 += state + ", ";

                String postalCode = address.getPostalCode();
                    line2 += postalCode;


                String line3 = "";
                line3 = address.getCountryName();
                String fullAddress = "";


                    fullAddress = line1 + "\n"+ line2 + "\n" + line3;


                deliverResultToReceiver(Constants.SUCCESS_RESULT,
                        fullAddress.trim()
                );
            }




        }

    }

    private void deliverResultToReceiver(int resultCode, String addressMessage) {

        Bundle bundle = new Bundle();
        bundle.putString(Constants.RESULT_DATA_KEY,addressMessage);
        resultReceiver.send(resultCode,bundle);


    }
}
