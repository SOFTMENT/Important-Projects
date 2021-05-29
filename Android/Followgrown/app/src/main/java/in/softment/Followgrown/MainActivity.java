package in.softment.Followgrown;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.app.DownloadManager;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.provider.MediaStore;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.DownloadListener;
import android.webkit.PermissionRequest;
import android.webkit.SslErrorHandler;
import android.webkit.URLUtil;
import android.webkit.ValueCallback;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import com.softment.Followgrown.R;

import java.io.File;
import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Date;

public class MainActivity extends AppCompatActivity {

	//Permission variables
	static boolean SngineApp_JSCRIPT    = SngineConfig.SngineApp_JSCRIPT;
	static boolean SngineApp_FUPLOAD    = SngineConfig.SngineApp_FUPLOAD;
	static boolean SngineApp_CAMUPLOAD  = SngineConfig.SngineApp_CAMUPLOAD;
	static boolean SngineApp_ONLYCAM		= SngineConfig.SngineApp_ONLYCAM;
	static boolean SngineApp_MULFILE    = SngineConfig.SngineApp_MULFILE;
	static boolean SngineApp_PULLFRESH	= SngineConfig.SngineApp_PULLFRESH;
	static boolean SngineApp_PBAR       = SngineConfig.SngineApp_PBAR;
	static boolean SngineApp_ZOOM       = SngineConfig.SngineApp_ZOOM;
	static boolean SngineApp_SFORM      = SngineConfig.SngineApp_SFORM;
	static boolean SngineApp_OFFLINE		= SngineConfig.SngineApp_OFFLINE;
	static boolean SngineApp_EXTURL		= SngineConfig.SngineApp_EXTURL;

	//Security variables
	static boolean SngineApp_CERT_VERIFICATION = SngineConfig.SngineApp_CERT_VERIFICATION;

	//Configuration variables
	private static String Sngine_URL      = SngineConfig.Sngine_URL;
	private String CURR_URL				 = Sngine_URL;
	private static String Sngine_F_TYPE   = SngineConfig.Sngine_F_TYPE;

    public static String ASWV_HOST		= aswm_host(Sngine_URL);

    //Careful with these variable names if altering
    WebView swvp_view;
    ProgressBar swvp_progress;


    private String swvp_cam_message;
    private ValueCallback<Uri> swvp_file_message;
    private ValueCallback<Uri[]> swvp_file_path;
    private final static int swvp_file_req = 1;

	private final static int loc_perm = 1;
	private final static int file_perm = 2;

    private SecureRandom random = new SecureRandom();

    private static final String TAG = MainActivity.class.getSimpleName();

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);
        if (Build.VERSION.SDK_INT >= 21) {
            getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
            getWindow().setStatusBarColor(getResources().getColor(R.color.colorPrimary));
            Uri[] results = null;
            if (resultCode == Activity.RESULT_OK) {
                if (requestCode == swvp_file_req) {
                    if (null == swvp_file_path) {
                        return;
                    }
                    if (intent == null || intent.getData() == null) {
                        if (swvp_cam_message != null) {
                            results = new Uri[]{Uri.parse(swvp_cam_message)};
                        }
                    } else {
                        String dataString = intent.getDataString();
                        if (dataString != null) {
                            results = new Uri[]{ Uri.parse(dataString) };
                        } else {
			    			if(SngineApp_MULFILE) {
                                if (intent.getClipData() != null) {
                                    final int numSelectedFiles = intent.getClipData().getItemCount();
                                    results = new Uri[numSelectedFiles];
                                    for (int i = 0; i < numSelectedFiles; i++) {
                                        results[i] = intent.getClipData().getItemAt(i).getUri();
                                    }
                                }
                            }
						}
                    }
                }
            }
            swvp_file_path.onReceiveValue(results);
            swvp_file_path = null;
        } else {
            if (requestCode == swvp_file_req) {
                if (null == swvp_file_message) return;
                Uri result = intent == null || resultCode != RESULT_OK ? null : intent.getData();
                swvp_file_message.onReceiveValue(result);
                swvp_file_message = null;
            }
        }
    }

    @SuppressLint({"SetJavaScriptEnabled", "WrongViewCast"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
		Log.w("READ_PERM = ",Manifest.permission.READ_EXTERNAL_STORAGE);
		Log.w("WRITE_PERM = ",Manifest.permission.WRITE_EXTERNAL_STORAGE);
        //Prevent the app from being started again when it is still alive in the background
        if (!isTaskRoot()) {
        	finish();
        	return;
        }

        setContentView(R.layout.activity_main);

		swvp_view = findViewById(R.id.msw_view);

		final SwipeRefreshLayout pullfresh = findViewById(R.id.pullfresh);
		if (SngineApp_PULLFRESH) {
			pullfresh.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
				@Override
				public void onRefresh() {
					pull_fresh();
					pullfresh.setRefreshing(false);
				}
			});
			swvp_view.getViewTreeObserver().addOnScrollChangedListener(new ViewTreeObserver.OnScrollChangedListener() {
				@Override
				public void onScrollChanged() {
					if (swvp_view.getScrollY() == 0) {
						pullfresh.setEnabled(true);
					} else {
						pullfresh.setEnabled(false);
					}
				}
			});
		}else{
			pullfresh.setRefreshing(false);
			pullfresh.setEnabled(false);
		}

		if (SngineApp_PBAR) {
            swvp_progress = findViewById(R.id.msw_progress);
        } else {
            findViewById(R.id.msw_progress).setVisibility(View.GONE);
        }
        Handler handler = new Handler();



        //Getting basic device information
		get_info();


        //Webview settings; defaults are customized for best performance
        WebSettings webSettings = swvp_view.getSettings();
		swvp_view.getSettings().setUserAgentString("Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/85.0.4183.121 Mobile Safari/537.36");
		swvp_view.getSettings().setMediaPlaybackRequiresUserGesture(false);


		if(!SngineApp_OFFLINE){
			webSettings.setJavaScriptEnabled(SngineApp_JSCRIPT);
		}
		webSettings.setSaveFormData(SngineApp_SFORM);
		webSettings.setSupportZoom(SngineApp_ZOOM);
		webSettings.setAllowFileAccess(true);
		webSettings.setAllowFileAccessFromFileURLs(true);
		webSettings.setAllowUniversalAccessFromFileURLs(true);
		webSettings.setUseWideViewPort(true);
		webSettings.setDomStorageEnabled(true);

		swvp_view.setOnLongClickListener(new View.OnLongClickListener() {
			@Override
			public boolean onLongClick(View v) {
				return true;
			}
		});
		swvp_view.setHapticFeedbackEnabled(false);

		swvp_view.setDownloadListener(new DownloadListener() {
			@Override
			public void onDownloadStart(String url, String userAgent, String contentDisposition, String mimeType, long contentLength) {

				if(!check_permission(2)){
					ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE}, file_perm);
				}else {
					DownloadManager.Request request = new DownloadManager.Request(Uri.parse(url));

					request.setMimeType(mimeType);
					String cookies = CookieManager.getInstance().getCookie(url);
					request.addRequestHeader("cookie", cookies);
					request.addRequestHeader("User-Agent", userAgent);
					request.setDescription(getString(R.string.dl_downloading));
					request.setTitle(URLUtil.guessFileName(url, contentDisposition, mimeType));
					request.allowScanningByMediaScanner();
					request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
					request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, URLUtil.guessFileName(url, contentDisposition, mimeType));
					DownloadManager dm = (DownloadManager) getSystemService(DOWNLOAD_SERVICE);
					assert dm != null;
					dm.enqueue(request);
					Toast.makeText(getApplicationContext(), getString(R.string.dl_downloading2), Toast.LENGTH_LONG).show();
				}
			}
		});

		getWindow().addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
		getWindow().setStatusBarColor(getResources().getColor(R.color.colorPrimaryDark));
		webSettings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
		swvp_view.setLayerType(View.LAYER_TYPE_HARDWARE, null);
        swvp_view.setVerticalScrollBarEnabled(false);
        swvp_view.setWebViewClient(new Callback());

        //Rendering the default URL
        aswm_view(Sngine_URL, false);

		//Get Cam & Mic & location permissions
		if(!check_permission(1) || !check_permission(3) || !check_permission(4)){
			//Cam & Mic & location permissions not granted so request them
			ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CAMERA, Manifest.permission.RECORD_AUDIO, Manifest.permission.ACCESS_FINE_LOCATION}, 20);
		}

        swvp_view.setWebChromeClient(new WebChromeClient() {
			public void onPermissionRequest(final PermissionRequest request) {
				request.grant(request.getResources());
			}
            
            //Handling input[type="file"]
            public boolean onShowFileChooser(WebView webView, ValueCallback<Uri[]> filePathCallback, FileChooserParams fileChooserParams){

					if (SngineApp_FUPLOAD) {
						if (swvp_file_path != null) {
							swvp_file_path.onReceiveValue(null);
						}
						swvp_file_path = filePathCallback;
						Intent takePictureIntent = null;
						if (SngineApp_CAMUPLOAD) {
							takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
							if (takePictureIntent.resolveActivity(MainActivity.this.getPackageManager()) != null) {
								File photoFile = null;
								try {
									photoFile = create_image();
									takePictureIntent.putExtra("PhotoPath", swvp_cam_message);
								} catch (IOException ex) {
									Log.e(TAG, "Image file creation failed", ex);
								}
								if (photoFile != null) {
									swvp_cam_message = "file:" + photoFile.getAbsolutePath();
									takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(photoFile));
								} else {
									takePictureIntent = null;
								}
							}
						}
						Intent contentSelectionIntent = new Intent(Intent.ACTION_GET_CONTENT);
						if (!SngineApp_ONLYCAM) {
							contentSelectionIntent.addCategory(Intent.CATEGORY_OPENABLE);
							contentSelectionIntent.setType(Sngine_F_TYPE);
							if (SngineApp_MULFILE) {
								contentSelectionIntent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, true);
							}
						}
						Intent[] intentArray;
						if (takePictureIntent != null) {
							intentArray = new Intent[]{takePictureIntent};
						} else {
							intentArray = new Intent[0];
						}

						Intent chooserIntent = new Intent(Intent.ACTION_CHOOSER);
						chooserIntent.putExtra(Intent.EXTRA_INTENT, contentSelectionIntent);
						chooserIntent.putExtra(Intent.EXTRA_TITLE, getString(R.string.fl_chooser));
						chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, intentArray);
						startActivityForResult(chooserIntent, swvp_file_req);

					return true;
				}else{
            		get_file();
            		return false;
				}
            }

            //Getting webview rendering progress
            @Override
            public void onProgressChanged(WebView view, int p) {
                if (SngineApp_PBAR) {
                    swvp_progress.setProgress(p);
                    if (p == 100) {
                        swvp_progress.setProgress(0);
                    }
                }
            }
        });
        if (getIntent().getData() != null) {
            String path     = getIntent().getDataString();
            /*
            If you want to check or use specific directories or schemes or hosts

            Uri data        = getIntent().getData();
            String scheme   = data.getScheme();
            String host     = data.getHost();
            List<String> pr = data.getPathSegments();
            String param1   = pr.get(0);
            */
            aswm_view(path, false);
        }
    }


    //Setting activity layout visibility
	private class Callback extends WebViewClient {


        public void onPageFinished(WebView view, String url) {
			CookieSyncManager.getInstance().sync();

			swvp_view.loadUrl("javascript:(function(){ " +
					"document.getElementById('android-app').style.display='none';})()");

			try {
				// Close progressDialog
				swvp_progress.setVisibility(View.GONE);
			} catch (Exception exception) {
				exception.printStackTrace();
			}

            findViewById(R.id.msw_view).setVisibility(View.VISIBLE);
        }
        //For android below API 23
		@Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            Toast.makeText(getApplicationContext(), getString(R.string.went_wrong), Toast.LENGTH_SHORT).show();
            aswm_view("file:///android_asset/error.html", false);
        }

        //Overriding webview URLs
		@Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
        	CURR_URL = url;
			return url_actions(view, url);
        }

		//Overriding webview URLs for API 23+ [suggested by github.com/JakePou]
		@TargetApi(Build.VERSION_CODES.N)
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
        	CURR_URL = request.getUrl().toString();
			return url_actions(view, request.getUrl().toString());
		}

		@Override
		public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
        	if(SngineApp_CERT_VERIFICATION) {
				super.onReceivedSslError(view, handler, error);
			} else {
        		handler.proceed(); // Ignore SSL certificate errors
			}
		}
	}

    //Random ID creation function to help get fresh cache every-time webview reloaded
    public String random_id() {
        return new BigInteger(130, random).toString(32);
    }

    //Opening URLs inside webview with request
    void aswm_view(String url, Boolean tab) {
        if (tab) {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(url));
            startActivity(intent);
        } else {
	   if(url.contains("?")){ // check to see whether the url already has query parameters and handle appropriately.
		url += "&";
	   } else {
      		url += "?";
	   }
	   url += "rid="+random_id();
	   swvp_view.loadUrl(url);
        }
    }

	//Actions based on shouldOverrideUrlLoading
	public boolean url_actions(WebView view, String url){
		boolean a = true;
		//Show toast error if not connected to the network
		 if (url.startsWith("refresh:")) {
			String ref_sch = (Uri.parse(url).toString()).replace("refresh:","");
			if(ref_sch.matches("URL")){
				CURR_URL = Sngine_URL;
			}
			pull_fresh();

			//Use this in a hyperlink to launch default phone dialer for specific number :: href="tel:+919876543210"
		} else if (url.startsWith("tel:")) {
			Intent intent = new Intent(Intent.ACTION_DIAL, Uri.parse(url));
			startActivity(intent);

			//Use this to open your apps page on google play store app :: href="rate:android"
		} else if (url.startsWith("rate:")) {
			final String app_package = getPackageName(); //requesting app package name from Context or Activity object
			try {
				startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=" + app_package)));
			} catch (ActivityNotFoundException anfe) {
				startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("https://play.google.com/store/apps/details?id=" + app_package)));
			}

			//Sharing content from your webview to external apps :: href="share:URL" and remember to place the URL you want to share after share:___
		} else if (url.startsWith("share:")) {
			Intent intent = new Intent(Intent.ACTION_SEND);
			intent.setType("text/plain");
			intent.putExtra(Intent.EXTRA_SUBJECT, view.getTitle());
			intent.putExtra(Intent.EXTRA_TEXT, view.getTitle()+"\nVisit: "+(Uri.parse(url).toString()).replace("share:",""));
			startActivity(Intent.createChooser(intent, getString(R.string.share_w_friends)));

			//Use this in a hyperlink to exit your app :: href="exit:android"
		} else if (url.startsWith("exit:")) {
			Intent intent = new Intent(Intent.ACTION_MAIN);
			intent.addCategory(Intent.CATEGORY_HOME);
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			startActivity(intent);


		} else if (SngineApp_EXTURL && !aswm_host(url).equals(ASWV_HOST)) {
			aswm_view(url,true);
		} else {
			a = false;
		}
		return a;
	}

	//Getting host name
	public static String aswm_host(String url){
		if (url == null || url.length() == 0) {
			return "";
		}
		int dslash = url.indexOf("//");
		if (dslash == -1) {
			dslash = 0;
		} else {
			dslash += 2;
		}
		int end = url.indexOf('/', dslash);
		end = end >= 0 ? end : url.length();
		int port = url.indexOf(':', dslash);
		end = (port > 0 && port < end) ? port : end;
		Log.w("URL Host: ",url.substring(dslash, end));
		return url.substring(dslash, end);
	}

	//Reloading current page
	public void pull_fresh(){
    	aswm_view((!CURR_URL.equals("")?CURR_URL:Sngine_URL),false);
	}

	//Getting device basic information
	public void get_info(){
		CookieManager cookieManager = CookieManager.getInstance();
		cookieManager.setAcceptCookie(true);
		cookieManager.setCookie(Sngine_URL, "DEVICE=android");
		cookieManager.setCookie(Sngine_URL, "DEV_API=" + Build.VERSION.SDK_INT);
	}

	//Checking permission for storage and camera for writing and uploading images
	public void get_file(){
		String[] perms = {Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA};

		//Checking for storage permission to write images for upload
		if (SngineApp_FUPLOAD && SngineApp_CAMUPLOAD && !check_permission(2) && !check_permission(3)) {
			ActivityCompat.requestPermissions(MainActivity.this, perms, file_perm);

		//Checking for WRITE_EXTERNAL_STORAGE permission
		} else if (SngineApp_FUPLOAD && !check_permission(2)) {
			ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE}, file_perm);

		//Checking for CAMERA permissions
		} else if (SngineApp_CAMUPLOAD && !check_permission(3)) {
			ActivityCompat.requestPermissions(MainActivity.this, new String[]{Manifest.permission.CAMERA}, file_perm);
		}
	}

    //Using cookies to update user locations

	//Checking if particular permission is given or not
	public boolean check_permission(int permission){
		if (permission == 2) {
			return ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
		}
		return false;
	}

	//Creating image file for upload
    private File create_image() throws IOException {
        @SuppressLint("SimpleDateFormat")
        String file_name    = new SimpleDateFormat("yyyy_mm_ss").format(new Date());
        String new_name     = "file_"+file_name+"_";
        File sd_directory   = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        return File.createTempFile(new_name, ".jpg", sd_directory);


    }


	//Checking if users allowed the requested permissions or not
	@Override
	public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults){
		if (requestCode == 1) {
			if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

			}
		}
	}

	//Action on back key tap/click
	@Override
	public boolean onKeyDown(int keyCode, @NonNull KeyEvent event) {
		if (event.getAction() == KeyEvent.ACTION_DOWN) {
			if (keyCode == KeyEvent.KEYCODE_BACK) {
				if (swvp_view.canGoBack()) {
					swvp_view.goBack();
				} else {
					finish();
				}
				return true;
			}
		}
		return super.onKeyDown(keyCode, event);
	}

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }



}
