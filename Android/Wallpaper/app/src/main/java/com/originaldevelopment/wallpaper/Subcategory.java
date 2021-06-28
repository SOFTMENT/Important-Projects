
package com.originaldevelopment.wallpaper;

import java.io.Serializable;
import java.util.List;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Subcategory implements Serializable {

    @SerializedName("sname")
    @Expose
    private String sname;
    @SerializedName("url")
    @Expose
    private List<Url> url = null;

    public String getSname() {
        return sname;
    }

    public void setSname(String sname) {
        this.sname = sname;
    }

    public List<Url> getUrl() {
        return url;
    }

    public void setUrl(List<Url> url) {
        this.url = url;
    }

}
