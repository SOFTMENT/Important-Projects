package in.softment.straightline.Adapter;


import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;

import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;
import in.softment.straightline.Model.AllMessagesModel;
import in.softment.straightline.R;
import in.softment.straightline.Utils.Services;

public class LiveChatAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private int LEFT_MESSAGE = 0;
    private int RIGHT_MESSAGE = 1;
    private List<AllMessagesModel> chatModels;
    private Context context;
    private String uid = "";

    public LiveChatAdapter(Context  context, List<AllMessagesModel> chatModels, String uid) {
        this.context = context;
        this.chatModels = chatModels;
        this.uid = uid;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == LEFT_MESSAGE) {
            return new MyHolderLeft(LayoutInflater.from(context).inflate(R.layout.left_message, parent, false));
        }
        else {
            return new MyHolder(LayoutInflater.from(context).inflate(R.layout.right_message, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, final int position) {
        holder.setIsRecyclable(false);

        if (holder.getItemViewType() == LEFT_MESSAGE) {
            MyHolderLeft myHolderLeft  = (MyHolderLeft)holder;
            myHolderLeft.name.setText(chatModels.get(position).getSenderName());
            Glide.with(context).load(chatModels.get(position).getSenderImage()).diskCacheStrategy(DiskCacheStrategy.DATA).placeholder(R.drawable.placeholder).into(myHolderLeft.imageView);

            if (chatModels.get(position).getDate() != null) {
                myHolderLeft.dateandtime.setText(Services.getTimeAgo(chatModels.get(position).date.getTime()));
            }
            else {
                myHolderLeft.dateandtime.setText("TIME NOT AVAILABLE");
            }


            myHolderLeft.message.setText(chatModels.get(position).getMessage());


        }
        else {
            MyHolder myHolder = (MyHolder)holder;
            if (chatModels.get(position).getDate() != null) {
                    myHolder.datenadtime.setText(Services.getTimeAgo(chatModels.get(position).date.getTime()));
            }
            else {
                myHolder.datenadtime.setText("TIME NOT AVAILABLE");
            }

                myHolder.message.setVisibility(View.VISIBLE);
                myHolder.message.setText(chatModels.get(position).getMessage());




        }


    }




    @Override
    public int getItemCount() {
        return chatModels.size();
    }

    static class MyHolder extends RecyclerView.ViewHolder {
        private TextView message;
        private View view;
        private TextView datenadtime;
        MyHolder(@NonNull View itemView) {
            super(itemView);
            view = itemView;
            message = itemView.findViewById(R.id.message);
            datenadtime = itemView.findViewById(R.id.dateandtime);
        }
    }

    static class MyHolderLeft extends RecyclerView.ViewHolder {
        private TextView message;
        private CircleImageView imageView;
        private TextView name;
        private View view;
        private TextView dateandtime;

        MyHolderLeft(@NonNull View itemView) {
            super(itemView);
            view = itemView;
            message = itemView.findViewById(R.id.message);
            imageView = itemView.findViewById(R.id.profile_image);
            name = itemView.findViewById(R.id.name);
            dateandtime = itemView.findViewById(R.id.dateandtime);
        }
    }

    @Override
    public int getItemViewType(int position) {
        if (chatModels.get(position).getSenderUid().equals(uid)) {
            return RIGHT_MESSAGE;
        }
        else {
            return LEFT_MESSAGE;
        }
    }
}
