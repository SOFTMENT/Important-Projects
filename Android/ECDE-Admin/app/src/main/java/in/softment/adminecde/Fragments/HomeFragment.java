package in.softment.adminecde.Fragments;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.recyclerview.widget.StaggeredGridLayoutManager;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import java.util.ArrayList;

import in.softment.adminecde.Adapters.CategoriesAdaper;
import in.softment.adminecde.Adapters.ProductAdapter;
import in.softment.adminecde.MainActivity;
import in.softment.adminecde.Models.CategoryModel;
import in.softment.adminecde.R;


public class HomeFragment extends Fragment {

    private EditText searchET;
    private RecyclerView categories_recyclerview;
    private RecyclerView products_recyclerview;
    private Context context;
    private CategoriesAdaper categoriesAdaper;
    private ProductAdapter productAdapter;
    public HomeFragment(Context context) {
       this.context = context;
    }




    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View view = inflater.inflate(R.layout.fragment_home, container, false);
        searchET = view.findViewById(R.id.searchEditText);

        categories_recyclerview = view.findViewById(R.id.cat_recyclerview);
        categories_recyclerview.setHasFixedSize(true);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(context,LinearLayoutManager.HORIZONTAL,false);
        categories_recyclerview.setLayoutManager(linearLayoutManager);

        ArrayList<Drawable> categories_back_view = new ArrayList<>();
        categories_back_view.add(ContextCompat.getDrawable(context,R.drawable.categories_back_view3));
        categories_back_view.add(ContextCompat.getDrawable(context,R.drawable.categories_back_view2));
        categories_back_view.add(ContextCompat.getDrawable(context,R.drawable.categories_back_view));
        categories_back_view.add(ContextCompat.getDrawable(context,R.drawable.categories_back_view6));
        categories_back_view.add(ContextCompat.getDrawable(context,R.drawable.categories_back_view4));
        categories_back_view.add(ContextCompat.getDrawable(context,R.drawable.categories_back_view5));
        categoriesAdaper = new CategoriesAdaper(context,categories_back_view, CategoryModel.categoryModels);
        categories_recyclerview.setAdapter(categoriesAdaper);


        products_recyclerview = view.findViewById(R.id.product_recyclerview);
        products_recyclerview.setHasFixedSize(true);
        products_recyclerview.setLayoutManager(new StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL));

        ArrayList<Drawable> products = new ArrayList<>();
        products.add(ContextCompat.getDrawable(context,R.drawable.one));
        products.add(ContextCompat.getDrawable(context,R.drawable.two));
        products.add(ContextCompat.getDrawable(context,R.drawable.three));
        products.add(ContextCompat.getDrawable(context,R.drawable.four));
        products.add(ContextCompat.getDrawable(context,R.drawable.five));
        products.add(ContextCompat.getDrawable(context,R.drawable.six));
        products.add(ContextCompat.getDrawable(context,R.drawable.seven));

        productAdapter = new ProductAdapter(context,products);
        products_recyclerview.setAdapter(productAdapter);
        return view;
    }

    public void notifyAdapter(){
        categoriesAdaper.notifyDataSetChanged();
    }

    @Override
    public void onAttach(@NonNull Context context) {
        super.onAttach(context);
        ((MainActivity)context).initializeHomeFragment(this);
    }
}