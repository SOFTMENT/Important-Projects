package in.softment.straightline.Model;

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
}
