
package com.originaldevelopment.NewsRoomWordpress;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class WoocommerceMeta {

    @SerializedName("activity_panel_inbox_last_read")
    @Expose
    private String activityPanelInboxLastRead;
    @SerializedName("activity_panel_reviews_last_read")
    @Expose
    private String activityPanelReviewsLastRead;
    @SerializedName("categories_report_columns")
    @Expose
    private String categoriesReportColumns;
    @SerializedName("coupons_report_columns")
    @Expose
    private String couponsReportColumns;
    @SerializedName("customers_report_columns")
    @Expose
    private String customersReportColumns;
    @SerializedName("orders_report_columns")
    @Expose
    private String ordersReportColumns;
    @SerializedName("products_report_columns")
    @Expose
    private String productsReportColumns;
    @SerializedName("revenue_report_columns")
    @Expose
    private String revenueReportColumns;
    @SerializedName("taxes_report_columns")
    @Expose
    private String taxesReportColumns;
    @SerializedName("variations_report_columns")
    @Expose
    private String variationsReportColumns;
    @SerializedName("dashboard_sections")
    @Expose
    private String dashboardSections;
    @SerializedName("dashboard_chart_type")
    @Expose
    private String dashboardChartType;
    @SerializedName("dashboard_chart_interval")
    @Expose
    private String dashboardChartInterval;
    @SerializedName("dashboard_leaderboard_rows")
    @Expose
    private String dashboardLeaderboardRows;

    public String getActivityPanelInboxLastRead() {
        return activityPanelInboxLastRead;
    }

    public void setActivityPanelInboxLastRead(String activityPanelInboxLastRead) {
        this.activityPanelInboxLastRead = activityPanelInboxLastRead;
    }

    public String getActivityPanelReviewsLastRead() {
        return activityPanelReviewsLastRead;
    }

    public void setActivityPanelReviewsLastRead(String activityPanelReviewsLastRead) {
        this.activityPanelReviewsLastRead = activityPanelReviewsLastRead;
    }

    public String getCategoriesReportColumns() {
        return categoriesReportColumns;
    }

    public void setCategoriesReportColumns(String categoriesReportColumns) {
        this.categoriesReportColumns = categoriesReportColumns;
    }

    public String getCouponsReportColumns() {
        return couponsReportColumns;
    }

    public void setCouponsReportColumns(String couponsReportColumns) {
        this.couponsReportColumns = couponsReportColumns;
    }

    public String getCustomersReportColumns() {
        return customersReportColumns;
    }

    public void setCustomersReportColumns(String customersReportColumns) {
        this.customersReportColumns = customersReportColumns;
    }

    public String getOrdersReportColumns() {
        return ordersReportColumns;
    }

    public void setOrdersReportColumns(String ordersReportColumns) {
        this.ordersReportColumns = ordersReportColumns;
    }

    public String getProductsReportColumns() {
        return productsReportColumns;
    }

    public void setProductsReportColumns(String productsReportColumns) {
        this.productsReportColumns = productsReportColumns;
    }

    public String getRevenueReportColumns() {
        return revenueReportColumns;
    }

    public void setRevenueReportColumns(String revenueReportColumns) {
        this.revenueReportColumns = revenueReportColumns;
    }

    public String getTaxesReportColumns() {
        return taxesReportColumns;
    }

    public void setTaxesReportColumns(String taxesReportColumns) {
        this.taxesReportColumns = taxesReportColumns;
    }

    public String getVariationsReportColumns() {
        return variationsReportColumns;
    }

    public void setVariationsReportColumns(String variationsReportColumns) {
        this.variationsReportColumns = variationsReportColumns;
    }

    public String getDashboardSections() {
        return dashboardSections;
    }

    public void setDashboardSections(String dashboardSections) {
        this.dashboardSections = dashboardSections;
    }

    public String getDashboardChartType() {
        return dashboardChartType;
    }

    public void setDashboardChartType(String dashboardChartType) {
        this.dashboardChartType = dashboardChartType;
    }

    public String getDashboardChartInterval() {
        return dashboardChartInterval;
    }

    public void setDashboardChartInterval(String dashboardChartInterval) {
        this.dashboardChartInterval = dashboardChartInterval;
    }

    public String getDashboardLeaderboardRows() {
        return dashboardLeaderboardRows;
    }

    public void setDashboardLeaderboardRows(String dashboardLeaderboardRows) {
        this.dashboardLeaderboardRows = dashboardLeaderboardRows;
    }

}
