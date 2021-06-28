package in.softment.straightline.Model;

import java.util.Date;

public class VideoModel {

    public String cid = "";
    public String title = "";
    public String uid = "";
    public String url = "";
    public Date time = new Date();
    public String location = "";
    public Date uplaodVideoTime = new Date();


    public Date getUplaodVideoTime() {
        return uplaodVideoTime;
    }

    public void setUplaodVideoTime(Date uplaodVideoTime) {
        this.uplaodVideoTime = uplaodVideoTime;
    }

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
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
}
