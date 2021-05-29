package com.originaldevelopment.Model;

public class RapidTVModel {

    private String title, desc, videoUrl;
    private int image;

    public RapidTVModel(String title, String desc, String videoUrl, int image) {
        this.title = title;
        this.desc = desc;
        this.videoUrl = videoUrl;
        this.image = image;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public int getImage() {
        return image;
    }

    public void setImage(int image) {
        this.image = image;
    }
}
