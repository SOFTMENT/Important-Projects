package com.originaldevelopment.wallpaper.Custom;

import android.content.Context;
import android.util.AttributeSet;


public class TransTextView extends androidx.appcompat.widget.AppCompatTextView {

    public TransTextView(Context context) {
        super(context);
        setTypeface(TransportFont.getInstance(context).getTypeFace());
    }

    public TransTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        setTypeface(TransportFont.getInstance(context).getTypeFace());
    }

    public TransTextView(Context context, AttributeSet attrs,
                                  int defStyle) {
        super(context, attrs, defStyle);
        setTypeface(TransportFont.getInstance(context).getTypeFace());
    }

}