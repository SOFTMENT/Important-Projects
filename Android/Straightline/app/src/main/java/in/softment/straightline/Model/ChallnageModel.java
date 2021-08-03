package in.softment.straightline.Model;

import android.util.Log;

import java.util.ArrayList;
import java.util.Date;

public class ChallnageModel {

    public String title = "";
    public Date time = new Date();
    public String location = "";
    public String message = "";
    public String name = "";
    public String profileImage = "";
    public String uid = "";
    public String cid = "";
    public String token = "";
    public String email = "";
    public String vehicleImage = "";
    public double latitude = -1;
    public double longitude = -1;





    public static ArrayList<ChallnageModel> challnageModels = new ArrayList<>();

    public String getVehicleImage() {
        return vehicleImage;
    }

    public void setVehicleImage(String vehicleImage) {
        this.vehicleImage = vehicleImage;
    }

    public static ArrayList<ChallnageModel> getChallnageModels() {
        return challnageModels;
    }

    public static void setChallnageModels(ArrayList<ChallnageModel> challnageModels) {
        ChallnageModel.challnageModels = challnageModels;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }



    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public static ArrayList<ChallnageModel> filterChallengesBasedOnMiles(int miles){
        ArrayList<ChallnageModel> filterChallengesModel = new ArrayList<>();
        if (miles == -1) {
            return challnageModels;
        }

        for (ChallnageModel challnageModel : challnageModels) {
            if (checkDistance(challnageModel.latitude,challnageModel.longitude,UserModel.data.latitude, UserModel.data.longitude, miles)) {
                filterChallengesModel.add(challnageModel);
            }
        }
        return filterChallengesModel;
    }
    private static boolean checkDistance(double lat1, double lng1, double lat2, double lng2, int miles) {
        double earthRadius = 3958.75; // in miles, change to 6371 for kilometer output
        double dLat = Math.toRadians(lat2-lat1);
        double dLng = Math.toRadians(lng2-lng1);
        double sindLat = Math.sin(dLat / 2);
        double sindLng = Math.sin(dLng / 2);
        double a = Math.pow(sindLat, 2) + Math.pow(sindLng, 2)
                * Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2));

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

        double dist = earthRadius * c;
        Log.d("DISTANCE",lat1+" "+lat2+ " "+lng1+" "+lng2);
        Log.d("DISTANCE",dist+" WOW");
        return dist <= miles;
    }
}
