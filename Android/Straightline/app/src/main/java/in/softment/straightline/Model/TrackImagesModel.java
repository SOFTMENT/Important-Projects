package in.softment.straightline.Model;

import java.util.ArrayList;
import java.util.List;

public class TrackImagesModel {
    public String url = "";

   public  static List<TrackImagesModel> trackImagesModels = new ArrayList<>();
    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
