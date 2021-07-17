package in.softment.kidsit.Models;

import java.util.Date;

public class ParentModel {

    public String uid = "";
    public String fullName = "";
    public String emailAddress = "";
    public String phone = "";
    public String nos = "";
    public String address = "";
    public String city = "";
    public Date registrationDate = new Date();

    public static ParentModel data  = new ParentModel();

    public ParentModel() {
        data = this;
    }
}
