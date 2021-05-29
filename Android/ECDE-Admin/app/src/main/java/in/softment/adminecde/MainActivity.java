package in.softment.adminecde;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.fragment.app.FragmentPagerAdapter;
import androidx.viewpager.widget.ViewPager;

import android.os.Bundle;

import com.etebarian.meowbottomnavigation.MeowBottomNavigation;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.EventListener;
import com.google.firebase.firestore.FirebaseFirestore;
import com.google.firebase.firestore.FirebaseFirestoreException;
import com.google.firebase.firestore.MetadataChanges;
import com.google.firebase.firestore.Query;
import com.google.firebase.firestore.QuerySnapshot;

import java.util.ArrayList;
import java.util.List;

import in.softment.adminecde.Fragments.AccountFragment;
import in.softment.adminecde.Fragments.CategoriesFragment;
import in.softment.adminecde.Fragments.HomeFragment;
import in.softment.adminecde.Models.CategoryModel;
import in.softment.adminecde.Utils.Services;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;


public class MainActivity extends AppCompatActivity implements Function1<MeowBottomNavigation.Model, Unit> {

   MeowBottomNavigation meowBottomNavigation;
   private CategoriesFragment categoriesFragment;
   private HomeFragment homeFragment;

   ViewPager viewPager;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);




        //ViewPager
        viewPager = findViewById(R.id.viewpager);
        setupViewPager(viewPager);
        viewPager.setOffscreenPageLimit(3);

        meowBottomNavigation = findViewById(R.id.bottomnavigation1);
        meowBottomNavigation.add(new MeowBottomNavigation.Model(0, R.drawable.ic_baseline_storefront_24));
        meowBottomNavigation.add(new MeowBottomNavigation.Model(1, R.drawable.ic_baseline_menu_24));
        meowBottomNavigation.add(new MeowBottomNavigation.Model(2, R.drawable.ic_baseline_person_outline_24));
        meowBottomNavigation.show(1,true);
        meowBottomNavigation.setOnShowListener(this);

        viewPager.setCurrentItem(1);



        getCategotyData();


    }

    public void getCategotyData() {
        FirebaseFirestore.getInstance().collection("Categories").orderBy("title", Query.Direction.ASCENDING).addSnapshotListener(MetadataChanges.INCLUDE,new EventListener<QuerySnapshot>() {
            @Override
            public void onEvent(@Nullable QuerySnapshot value, @Nullable FirebaseFirestoreException error) {
                if (error == null) {
                    if (value != null && !value.isEmpty()) {
                        CategoryModel.categoryModels.clear();
                        for (DocumentSnapshot documentSnapshot : value.getDocuments()) {
                            CategoryModel categoryModel = documentSnapshot.toObject(CategoryModel.class);
                            CategoryModel.categoryModels.add(categoryModel);
                        }

                    }
                    categoriesFragment.notifyAdapter();
                    homeFragment.notifyAdapter();
                }
                else {
                    Services.showDialog(MainActivity.this,"ERROR",error.getLocalizedMessage());
                }
            }
        });
    }

    private void setupViewPager(ViewPager viewPager) {
        ViewPagerAdapter adapter = new ViewPagerAdapter(getSupportFragmentManager());
        adapter.addFrag(new HomeFragment(this));
        adapter.addFrag(new CategoriesFragment(this));
        adapter.addFrag(new AccountFragment(this));
        viewPager.setAdapter(adapter);
    }



    @Override
    public Unit invoke(MeowBottomNavigation.Model model) {
        viewPager.setCurrentItem(model.getId());
        return null;
    }
    static class ViewPagerAdapter extends FragmentPagerAdapter {
        private final List<Fragment> mFragmentList = new ArrayList<>();

        public ViewPagerAdapter(FragmentManager manager) {
            super(manager);
        }

        @Override
        public Fragment getItem(int position) {

            return mFragmentList.get(position);
        }

        @Override
        public int getCount() {

            return mFragmentList.size();
        }

        public void addFrag(Fragment fragment) {
            mFragmentList.add(fragment);

        }


    }

    public void initializeCategoryFragment(CategoriesFragment categoriesFragment) {
        this.categoriesFragment = categoriesFragment;
    }

    public void initializeHomeFragment(HomeFragment homeFragment){
        this.homeFragment = homeFragment;
    }
}


