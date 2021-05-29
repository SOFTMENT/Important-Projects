package com.originaldevelopment.Fragment;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;

import androidx.appcompat.app.AlertDialog;
import androidx.cardview.widget.CardView;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.text.format.DateFormat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.originaldevelopment.Adapter.ToDoAdapter;
import com.originaldevelopment.Model.ToDoModel;
import com.originaldevelopment.rapidcollect.R;
import com.originaldevelopment.rapidcollect.ToDoAddDetails;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;

import io.realm.Realm;
import io.realm.RealmResults;

/**
 * A simple {@link Fragment} subclass.
 */
public class ToDoFragment extends Fragment {

    private RecyclerView recyclerView;
    private Realm realm;
    private Context context;
    private List<ToDoModel> mytoDoModels;
    private ToDoAdapter toDoAdapter;
    private TextView edit;
    private boolean isEditable = false;

    public ToDoFragment(Context context) {
        // Required empty public constructor
        this.context = context;
        realm = Realm.getDefaultInstance();
        mytoDoModels = new ArrayList<>();

    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view  = inflater.inflate(R.layout.fragment_to_do, container, false);
        edit = view.findViewById(R.id.edit);
        edit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                    if (isEditable) {
                        isEditable = false;
                        edit.setText("Edit");
                        toDoAdapter.setDelete(false);
                    }
                    else {
                        isEditable = true;
                        edit.setText("Done");
                        toDoAdapter.setDelete(true);
                    }
            }
        });
        recyclerView = view.findViewById(R.id.todorecyclerview);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(context);
        linearLayoutManager.setStackFromEnd(true);
        linearLayoutManager.setReverseLayout(true);
        recyclerView.setLayoutManager(linearLayoutManager);
        toDoAdapter = new ToDoAdapter(context,mytoDoModels,ToDoFragment.this);
        recyclerView.setAdapter(toDoAdapter);
        ImageView addBtn = view.findViewById(R.id.add);
        addBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(context, ToDoAddDetails.class));
            }
        });
        return view;
    }

    @Override
    public void onResume() {
        super.onResume();
        readData();

    }

    @Override
    public void onPause() {
        super.onPause();
        isEditable = false;
        edit.setText("Edit");
        toDoAdapter.setDelete(false);
    }

    public void readData() {
        RealmResults<ToDoModel> toDoModels = realm.where(ToDoModel.class).findAll();
        mytoDoModels.clear();
        mytoDoModels.addAll(toDoModels);
        toDoAdapter.notifyDataSetChanged();
    }

    public void deleteData(final int position) {
        final RealmResults<ToDoModel> toDoModels = realm.where(ToDoModel.class).findAll();
        realm.executeTransaction(new Realm.Transaction() {
            @Override
            public void execute(Realm realm) {
                toDoModels.deleteFromRealm(position);
                mytoDoModels.remove(position);
                toDoAdapter.notifyDataSetChanged();
            }
        });
    }

    public void updateData(final String name) {
        final ToDoModel toDoModel = realm.where(ToDoModel.class).equalTo("name",name).findFirst();
        realm.executeTransaction(new Realm.Transaction() {
            @Override
            public void execute(Realm realm) {
                toDoModel.setComplete(true);
                toDoAdapter.notifyDataSetChanged();
            }
        });
    }

    public void showData(int position) {

        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        View view = getLayoutInflater().inflate(R.layout.todoshowview,null);
        TextView name = view.findViewById(R.id.name);
        TextView details = view.findViewById(R.id.details);
        TextView date =  view.findViewById(R.id.date);

        final AlertDialog alertDialog = builder.create();

        final ToDoModel toDoModel = mytoDoModels.get(position);

        name.setText(toDoModel.getName());
        details.setText(toDoModel.getDetails());


        final CardView completeCard = view.findViewById(R.id.completeCard);

        if (toDoModel.isComplete()) {
            completeCard.setEnabled(false);
            completeCard.setCardBackgroundColor(Color.GRAY);

        }

            completeCard.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    completeCard.setEnabled(false);
                    completeCard.setCardBackgroundColor(Color.GRAY);
                    updateData(toDoModel.getName());
                    alertDialog.dismiss();

                }
            });

        String dateformat =    DateFormat.format("yyyy-MMMM-dd, hh:mm a",toDoModel.getCompletionDate()).toString();
        date.setText(dateformat);


     alertDialog.setView(view);
     alertDialog.show();


    }
}
