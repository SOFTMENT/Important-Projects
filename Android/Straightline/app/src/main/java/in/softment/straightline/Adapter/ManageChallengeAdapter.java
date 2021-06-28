package in.softment.straightline.Adapter;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.AppCompatButton;
import androidx.recyclerview.widget.RecyclerView;

import com.bumptech.glide.Glide;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.firestore.DocumentReference;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestore;

import org.jetbrains.annotations.NotNull;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import de.hdodenhof.circleimageview.CircleImageView;
import in.softment.straightline.ChatScreenActivity;
import in.softment.straightline.ManageChallengeActivity;
import in.softment.straightline.Model.ChallnageModel;
import in.softment.straightline.Model.UserModel;
import in.softment.straightline.R;
import in.softment.straightline.ToastType;
import in.softment.straightline.Utils.ProgressHud;
import in.softment.straightline.Utils.Services;


public class ManageChallengeAdapter  extends RecyclerView.Adapter<ManageChallengeAdapter.ViewHolder> {

    private Context context;
    private ArrayList<ChallnageModel> challnageModels;




    public ManageChallengeAdapter(Context context,ArrayList<ChallnageModel> challnageModels) {

        this.context = context;
        this.challnageModels = challnageModels;



    }

    @NonNull
    @NotNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull @NotNull ViewGroup parent, int viewType) {
        return new ViewHolder(LayoutInflater.from(parent.getContext()).inflate(R.layout.manage_challenge_view,parent,false));
    }

    @Override
    public void onBindViewHolder(@NonNull @NotNull ManageChallengeAdapter.ViewHolder holder, int position) {
        holder.setIsRecyclable(false);


        ChallnageModel challnageModel = challnageModels.get(position);


        holder.place.setText(challnageModel.location);
        holder.title.setText(challnageModel.title);
        holder.time.setText(Services.convertDateToTimeString(challnageModel.time));
        holder.message.setText(challnageModel.message);

        holder.addVideo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                ((ManageChallengeActivity)context).pickVideo(challnageModel);

            }
        });

        holder.delete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder builder = new AlertDialog.Builder(context,R.style.MyTimePickerDialogTheme);
                builder.setTitle("Delete");
                builder.setMessage("Are you sure you want to delete challenge?");
                builder.setPositiveButton("Yes", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        ProgressHud.show(context,"Deleting...");
                        FirebaseFirestore.getInstance().collection("Challenges").document(challnageModel.getCid()).delete().addOnCompleteListener(new OnCompleteListener<Void>() {
                            @Override
                            public void onComplete(@NonNull @NotNull Task<Void> task) {
                                ProgressHud.dialog.dismiss();
                                if (task.isSuccessful()) {
                                    Services.showCenterToast(context,ToastType.SUCCESS,"Deleted");
                                }
                            }
                        });

                        dialog.dismiss();
                    }
                });

                builder.setNegativeButton("No", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                             dialog.dismiss();
                    }
                });

                builder.show();
            }
        });



    }



    @Override
    public int getItemCount() {
        return challnageModels.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {


        TextView  place, title, time, message;
        AppCompatButton delete, addVideo;
        public ViewHolder(@NonNull @NotNull View view) {
            super(view);

            place = view.findViewById(R.id.place);
            title = view.findViewById(R.id.title);
            time = view.findViewById(R.id.time);
            message = view.findViewById(R.id.message);
            delete = view.findViewById(R.id.delete);
            addVideo = view.findViewById(R.id.addVideo);
        }
    }
}
