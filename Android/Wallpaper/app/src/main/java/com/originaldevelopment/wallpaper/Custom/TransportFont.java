package com.originaldevelopment.wallpaper.Custom;

import android.content.Context;
import android.graphics.Typeface;

import com.originaldevelopment.wallpaper.R;

public class TransportFont {

    private static TransportFont instance;
    private static Typeface typeface;

    public static TransportFont getInstance(Context context) {
        synchronized (TransportFont.class) {
            if (instance == null) {
                instance = new TransportFont();
                typeface = Typeface.createFromAsset(context.getResources().getAssets(), "fonts/trans.ttf");
            }
            return instance;
        }
    }

    public Typeface getTypeFace() {
        return typeface;
    }
}