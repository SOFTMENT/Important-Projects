package com.originaldevelopment.Model;

import java.util.Date;

import io.realm.RealmObject;

public class ToDoModel extends RealmObject {
    private String name;
    private String details;
    private Date completionDate;
    private Date startDate;
    private boolean isComplete;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public Date getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(Date completionDate) {
        this.completionDate = completionDate;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public boolean isComplete() {
        return isComplete;
    }

    public void setComplete(boolean complete) {
        isComplete = complete;
    }

    @Override
    public String toString() {
        return "ToDoModel{" +
                "name='" + name + '\'' +
                ", details='" + details + '\'' +
                ", completionDate=" + completionDate +
                ", startDate=" + startDate +
                ", isComplete=" + isComplete +
                '}';
    }
}
