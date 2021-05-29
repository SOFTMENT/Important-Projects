
package com.originaldevelopment.NewsRoomWordpress;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Sizes {

    @SerializedName("thumbnail")
    @Expose
    private Thumbnail thumbnail;
    @SerializedName("medium")
    @Expose
    private Medium medium;
    @SerializedName("medium_large")
    @Expose
    private MediumLarge mediumLarge;
    @SerializedName("post-thumbnail")
    @Expose
    private PostThumbnail postThumbnail;
    @SerializedName("pofo-related-post-thumb")
    @Expose
    private PofoRelatedPostThumb pofoRelatedPostThumb;
    @SerializedName("pofo-popular-posts-thumb")
    @Expose
    private PofoPopularPostsThumb pofoPopularPostsThumb;
    @SerializedName("woocommerce_thumbnail")
    @Expose
    private WoocommerceThumbnail woocommerceThumbnail;
    @SerializedName("woocommerce_single")
    @Expose
    private WoocommerceSingle woocommerceSingle;
    @SerializedName("woocommerce_gallery_thumbnail")
    @Expose
    private WoocommerceGalleryThumbnail woocommerceGalleryThumbnail;
    @SerializedName("shop_catalog")
    @Expose
    private ShopCatalog shopCatalog;
    @SerializedName("shop_single")
    @Expose
    private ShopSingle shopSingle;
    @SerializedName("shop_thumbnail")
    @Expose
    private ShopThumbnail shopThumbnail;
    @SerializedName("full")
    @Expose
    private Full full;

    public Thumbnail getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(Thumbnail thumbnail) {
        this.thumbnail = thumbnail;
    }

    public Medium getMedium() {
        return medium;
    }

    public void setMedium(Medium medium) {
        this.medium = medium;
    }

    public MediumLarge getMediumLarge() {
        return mediumLarge;
    }

    public void setMediumLarge(MediumLarge mediumLarge) {
        this.mediumLarge = mediumLarge;
    }

    public PostThumbnail getPostThumbnail() {
        return postThumbnail;
    }

    public void setPostThumbnail(PostThumbnail postThumbnail) {
        this.postThumbnail = postThumbnail;
    }

    public PofoRelatedPostThumb getPofoRelatedPostThumb() {
        return pofoRelatedPostThumb;
    }

    public void setPofoRelatedPostThumb(PofoRelatedPostThumb pofoRelatedPostThumb) {
        this.pofoRelatedPostThumb = pofoRelatedPostThumb;
    }

    public PofoPopularPostsThumb getPofoPopularPostsThumb() {
        return pofoPopularPostsThumb;
    }

    public void setPofoPopularPostsThumb(PofoPopularPostsThumb pofoPopularPostsThumb) {
        this.pofoPopularPostsThumb = pofoPopularPostsThumb;
    }

    public WoocommerceThumbnail getWoocommerceThumbnail() {
        return woocommerceThumbnail;
    }

    public void setWoocommerceThumbnail(WoocommerceThumbnail woocommerceThumbnail) {
        this.woocommerceThumbnail = woocommerceThumbnail;
    }

    public WoocommerceSingle getWoocommerceSingle() {
        return woocommerceSingle;
    }

    public void setWoocommerceSingle(WoocommerceSingle woocommerceSingle) {
        this.woocommerceSingle = woocommerceSingle;
    }

    public WoocommerceGalleryThumbnail getWoocommerceGalleryThumbnail() {
        return woocommerceGalleryThumbnail;
    }

    public void setWoocommerceGalleryThumbnail(WoocommerceGalleryThumbnail woocommerceGalleryThumbnail) {
        this.woocommerceGalleryThumbnail = woocommerceGalleryThumbnail;
    }

    public ShopCatalog getShopCatalog() {
        return shopCatalog;
    }

    public void setShopCatalog(ShopCatalog shopCatalog) {
        this.shopCatalog = shopCatalog;
    }

    public ShopSingle getShopSingle() {
        return shopSingle;
    }

    public void setShopSingle(ShopSingle shopSingle) {
        this.shopSingle = shopSingle;
    }

    public ShopThumbnail getShopThumbnail() {
        return shopThumbnail;
    }

    public void setShopThumbnail(ShopThumbnail shopThumbnail) {
        this.shopThumbnail = shopThumbnail;
    }

    public Full getFull() {
        return full;
    }

    public void setFull(Full full) {
        this.full = full;
    }

}
