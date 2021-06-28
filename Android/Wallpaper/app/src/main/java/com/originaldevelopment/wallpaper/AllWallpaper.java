
package com.originaldevelopment.wallpaper;

import java.io.Serializable;
import java.util.List;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class AllWallpaper implements Serializable {

    @SerializedName("cname")
    @Expose
    private String cname;
    @SerializedName("subcategory")
    @Expose
    private List<Subcategory> subcategory = null;
    @SerializedName("size")
    @Expose
    private Integer size;
    @SerializedName("clogo")
    @Expose
    private String clogo;
    @SerializedName("status")
    @Expose
    private String status;

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public List<Subcategory> getSubcategory() {
        return subcategory;
    }

    public void setSubcategory(List<Subcategory> subcategory) {
        this.subcategory = subcategory;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public String getClogo() {
        return clogo;
    }

    public void setClogo(String clogo) {
        this.clogo = clogo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
