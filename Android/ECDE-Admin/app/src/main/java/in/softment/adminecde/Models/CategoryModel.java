package in.softment.adminecde.Models;

import java.util.ArrayList;

public class CategoryModel {

    public String id = "";
    public String title = "";
    public String image = "";

    public static ArrayList<CategoryModel> categoryModels = new ArrayList<>();

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
