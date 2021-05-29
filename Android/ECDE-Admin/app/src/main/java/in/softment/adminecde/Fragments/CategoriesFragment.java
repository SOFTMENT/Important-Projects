package in.softment.adminecde.Fragments;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.MetadataChanges;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;

import in.softment.adminecde.Adapters.EditCategoriesAdapter;
import in.softment.adminecde.AddCateogryScreen;
import in.softment.adminecde.MainActivity;
import in.softment.adminecde.Models.CategoryModel;
import in.softment.adminecde.R;
import in.softment.adminecde.Utils.Services;

public class CategoriesFragment extends Fragment {


    private Context context;
    private RecyclerView recyclerView;
    private EditCategoriesAdapter editCategoriesAdapter;
    public CategoriesFragment(Context context) {
        this.context = context;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View view =  inflater.inflate(R.layout.fragment_category, container, false);

        //Add Category
        view.findViewById(R.id.addCategory).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(context, AddCateogryScreen.class));
            }
        });

        recyclerView = view.findViewById(R.id.categories_recyclerview);
        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new LinearLayoutManager(context));
        editCategoriesAdapter = new EditCategoriesAdapter(context,CategoryModel.categoryModels);
        recyclerView.setAdapter(editCategoriesAdapter);


        return view;

    }

    public void notifyAdapter() {
        editCategoriesAdapter.notifyDataSetChanged();
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        ((MainActivity)context).initializeCategoryFragment(this);
    }
}