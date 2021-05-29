package com.originaldevelopment.rapidcollect;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.PorterDuff;
import android.os.Bundle;
import android.speech.RecognizerIntent;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.Fragment;

import com.originaldevelopment.CurrencyConvertor.ApiClient;
import com.originaldevelopment.CurrencyConvertor.ApiInterface;
import com.originaldevelopment.CurrencyConvertor.Constants;
import com.originaldevelopment.CurrencyConvertor.LatestModel;
import com.originaldevelopment.CurrencyConvertor.Rates;

import net.sourceforge.jeval.EvaluationException;
import net.sourceforge.jeval.Evaluator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;

import pl.droidsonroids.gif.GifImageView;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

import static android.app.Activity.RESULT_OK;
import static android.view.View.GONE;
import static android.view.View.VISIBLE;

public class Currency_Calc extends AppCompatActivity {


   


    GifImageView pdailog;
    TextView text_divide, text_add, text_subtract, text_ac, txtseven, txteight, textnine, text_four, text_five, text_six, text_one, text_two, text_three, text_back, text_zero, text_dot, text_multiply;
    LatestModel userResponse;
    private LinearLayout rootLayout;
    private TextView mAmount, mResult, total;
    Spinner fromSpinner, toSpinner;
    private LinearLayout btnconvert;
    String Amount = "0";
    String fromCurruncy = "USD", toCurruncy = "ZAR";
    TextView powerButton;
    private final int REQ_CODE_SPEECH_INPUT = 100;
    private int cursorPosition;
    private String[] to_currencies;
    private String[] from_currencies;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_currency__calc);
        rootLayout = (LinearLayout) findViewById(R.id.rootLayout);
        mAmount = (TextView) findViewById(R.id.amount);
        btnconvert = (LinearLayout) findViewById(R.id.btnconvert);
        mResult = (TextView) findViewById(R.id.result);
        total = findViewById(R.id.total);
        pdailog = findViewById(R.id.pdailog);

        fromSpinner = findViewById(R.id.fromSpinner);
        toSpinner = findViewById(R.id.toSpinner);

        getConvertCuruncy();

        fromSpinner.getBackground().setColorFilter(getResources().getColor(R.color.font_color), PorterDuff.Mode.SRC_ATOP);
        toSpinner.getBackground().setColorFilter(getResources().getColor(R.color.font_color), PorterDuff.Mode.SRC_ATOP);

        txtseven = findViewById(R.id.txtseven);
        txtseven.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                cursorPosition++;
                mAmount.append("7");
            }
        });

        txteight = findViewById(R.id.txteight);
        txteight.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("8");
            }
        });

        textnine = findViewById(R.id.textnine);
        textnine.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("9");
            }
        });

        text_four = findViewById(R.id.text_four);
        text_four.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("4");
            }
        });

        text_five = findViewById(R.id.text_five);
        text_five.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("5");
            }
        });

        text_six = findViewById(R.id.text_six);
        text_six.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("6");
            }
        });

        text_one = findViewById(R.id.text_one);
        text_one.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("1");
            }
        });

        text_two = findViewById(R.id.text_two);
        text_two.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("2");
            }
        });

        text_three = findViewById(R.id.text_three);
        text_three.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("3");
            }
        });

        text_back = findViewById(R.id.text_back);
        text_back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                CharSequence text = mAmount.getText();
                if (text.length() > 0) {
                    cursorPosition--;
                    mAmount.setText(text.subSequence(0, text.length() - 1));
                }
            }
        });

        text_zero = findViewById(R.id.text_zero);
        text_zero.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("0");
            }
        });

        text_dot = findViewById(R.id.text_dot);
        text_dot.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append(".");
            }
        });

        text_multiply = findViewById(R.id.text_multiply);
        text_multiply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("x");
            }
        });

        text_subtract = findViewById(R.id.text_subtract);
        text_subtract.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("-");
            }
        });

        text_add = findViewById(R.id.text_add);
        text_add.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("+");
            }
        });

        text_divide = findViewById(R.id.text_divide);
        text_divide.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                cursorPosition++;
                mAmount.append("/");
            }
        });

        text_ac = findViewById(R.id.text_ac);
        text_ac.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {




                cursorPosition = 0;
                mAmount.setText("");
                mResult.setText("");
                total.setText("");
            }
        });

        cursorPosition = 0;
        initButtons(rootLayout);

        to_currencies = getResources().getStringArray(R.array.to_currencies);
        from_currencies = getResources().getStringArray(R.array.from_currencies);

        ArrayAdapter fromadapter = new ArrayAdapter(Currency_Calc.this, R.layout.item_base, from_currencies);
        fromSpinner.setAdapter(fromadapter);

        ArrayAdapter toadapter = new ArrayAdapter(Currency_Calc.this, R.layout.item_base, to_currencies);
        toSpinner.setAdapter(toadapter);

        mAmount.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                Amount = String.valueOf(s);
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        toSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                toCurruncy = to_currencies[position];
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });


        fromSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> adapterView, View view, int i, long l) {
                fromCurruncy = from_currencies[i];
            }

            @Override
            public void onNothingSelected(AdapterView<?> adapterView) {
            }
        });

        btnconvert.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String m  = mAmount.getText().toString();
                if (m.isEmpty()) {
                    return;
                }

                Evaluator evaluator = new Evaluator();
                try {

                    String expression = mAmount.getText().toString();
                    expression = expression.replaceAll("x", "*");
                    expression = expression.replaceAll("√", "sqrt");

                    try {
                        for (int i = expression.length() - 1; i >= 0; i--) {
                            if (expression.charAt(i) == '^')
                                expression = convertPower(expression, i);


                            if (expression.charAt(i) == '!')
                                expression = calculateFactorial(expression, i);
                        }
                        String answer = evaluator.evaluate(expression);
                        total.setText(answer);
                        cursorPosition = answer.length();

                    } catch (EvaluationException e) {
                        total.setText(total.getText().toString().replaceAll("\\*", "x"));

                        Toast.makeText(Currency_Calc.this, "Invalid Expression", Toast.LENGTH_LONG).show();
                    }

                } catch (Exception e) {
                    Toast.makeText(Currency_Calc.this, " Invalid Expression", Toast.LENGTH_SHORT).show();
                }

                Amount = total.getText().toString();
                if (!toCurruncy.equals("") || !toCurruncy.isEmpty()
                        && !fromCurruncy.equals("") || !fromCurruncy.isEmpty()
                        && !Amount.equals("") || !Amount.isEmpty()) {

                    convertValue(fromCurruncy, toCurruncy,Amount);


                } else {
                    Toast.makeText(Currency_Calc.this, "Please Enter Valid Data", Toast.LENGTH_SHORT).show();
                }
            }
        });


    }

    private void convertValue(String fromCurruncy, String toCurruncy, String amount) {
        Rates rates = userResponse.getRates();
        double dfrom = 0.0;
        switch (fromCurruncy) {
            case "AED":
                dfrom = rates.getAED();
                break;

            case "AFN":
                dfrom = rates.getAFN();
                break;

            case "ALL":
                dfrom = rates.getALL();
                break;
            case "AMD":
                dfrom = rates.getAMD();
                break;

            case "ANG":
                dfrom = rates.getANG();
                break;

            case "AOA":
                dfrom = rates.getAOA();
                break;

            case "ARS":
                dfrom = rates.getARS();
                break;
            case "AUD":
                dfrom = rates.getAUD();
                break;

            case "AWG":
                dfrom = rates.getAWG();
                break;

            case "AZN":
                dfrom = rates.getAZN();
                break;
            case "BAM":
                dfrom = rates.getBAM();
                break;


            case "BBD":
                dfrom = rates.getBBD();
                break;
            case "BDT":
                dfrom = rates.getBDT();
                break;

            case "BGN":
                dfrom = rates.getBGN();
                break;

            case "BHD":
                dfrom = rates.getBHD();
                break;
            case "BIF":
                dfrom = rates.getBIF();
                break;

            case "BMD":
                dfrom = rates.getBMD();
                break;

            case "BND":
                dfrom = rates.getBND();
                break;
            case "BOB":
                dfrom = rates.getBOB();
                break;

            case "BRL":
                dfrom = rates.getBRL();
                break;

            case "BSD":
                dfrom = rates.getBSD();
                break;
            case "BTC":
                dfrom = rates.getBTC();
                break;
            case "BTN":
                dfrom = rates.getBTN();
                break;
            case "BWP":
                dfrom = rates.getBWP();
                break;

            case "BYN":
                dfrom = rates.getBYN();
                break;

            case "BYR":
                dfrom = rates.getBYR();
                break;
            case "BZD":
                dfrom = rates.getBZD();
                break;

            case "CAD":
                dfrom = rates.getCAD();
                break;
            case "CDF":
                dfrom = rates.getCDF();
                break;
            case "CHF":
                dfrom = rates.getCHF();
                break;

            case "CLF":
                dfrom = rates.getCLF();
                break;

            case "BLP":
                dfrom = rates.getCLP();
                break;
            case "CNY":
                dfrom = rates.getCNY();
                break;

            case "COP":
                dfrom = rates.getCOP();
                break;
            case "CRC":
                dfrom = rates.getCRC();
                break;


            case "CUC":
                dfrom = rates.getCUC();
                break;
            case "CUP":
                dfrom = rates.getCUP();
                break;

            case "CVE":
                dfrom = rates.getCVE();
                break;
            case "CZK":
                dfrom = rates.getCZK();
                break;


            case "DJF":
                dfrom = rates.getDJF();
                break;
            case "DKK":
                dfrom = rates.getDKK();
                break;

            case "DOP":
                dfrom = rates.getDOP();
                break;
            case "DZD":
                dfrom = rates.getDZD();
                break;


            case "EGP":
                dfrom = rates.getEGP();
                break;
            case "ERN":
                dfrom = rates.getEGP();
                break;


            case "ETB":
                dfrom = rates.getETB();
                break;
            case "EUR":
                dfrom = rates.getEUR();
                break;


            case "FJD":
                dfrom = rates.getFJD();
                break;
            case "FKP":
                dfrom = rates.getFKP();
                break;

            case "GBP":
                dfrom = rates.getGBP();
                break;
            case "GEL":
                dfrom = rates.getGEL();
                break;

            case "GGP":
                dfrom = rates.getGGP();
                break;
            case "GHS":
                dfrom = rates.getGHS();
                break;


            case "GIP":
                dfrom = rates.getGIP();
                break;
            case "GMD":
                dfrom = rates.getGMD();
                break;

            case "GNF":
                dfrom = rates.getGNF();
                break;
            case "GTQ":
                dfrom = rates.getGTQ();
                break;
            case "GYD":
                dfrom = rates.getGYD();
                break;
            case "HKD":
                dfrom = rates.getHKD();
                break;

            case "HNL":
                dfrom = rates.getHNL();
                break;
            case "HRK":
                dfrom = rates.getHRK();
                break;
            case "HTG":
                dfrom = rates.getHTG();
                break;
            case "HUF":
                dfrom = rates.getHUF();
                break;

            case "IDR":
                dfrom = rates.getIDR();
                break;
            case "ILS":
                dfrom = rates.getILS();
                break;
            case "IMP":
                dfrom = rates.getIMP();
                break;

            case "INR":
                dfrom = rates.getINR();
                break;
            case "IQD":
                dfrom = rates.getIQD();
                break;
            case "IRR":
                dfrom = rates.getIRR();
                break;
            case "ISK":
                dfrom = rates.getISK();
                break;
            case "JEP":
                dfrom = rates.getJEP();
                break;
            case "JMD":
                dfrom = rates.getJMD();
                break;
            case "JPD":
                dfrom = rates.getJOD();
                break;
            case "JPY":
                dfrom = rates.getJPY();
                break;
            case "KES":
                dfrom = rates.getKES();
                break;
            case "KGS":
                dfrom = rates.getKGS();
                break;
            case "KHR":
                dfrom = rates.getKHR();
                break;
            case "KMF":
                dfrom = rates.getKMF();
                break;
            case "KPW":
                dfrom = rates.getKPW();
                break;
            case "KRW":
                dfrom = rates.getKRW();
                break;
            case "KWD":
                dfrom = rates.getKWD();
                break;
            case "KYD":
                dfrom = rates.getKYD();
                break;
            case "KZT":
                dfrom = rates.getKZT();
                break;



            case "LAK" :
                dfrom = rates.getLAK();
                break;
            case "LBP" :
                dfrom = rates.getLBP();
                break;
            case "LKR" :
                dfrom = rates.getLKR();
                break;
            case "LRD" :
                dfrom = rates.getLRD();
                break;
            case "LSL" :
                dfrom = rates.getLSL();
                break;
            case "LTL" :
                dfrom = rates.getLTL();
                break;
            case "LVL" :
                dfrom = rates.getLVL();
                break;
            case "LYD" :
                dfrom = rates.getLYD();
                break;


            case "MAD":
                dfrom = rates.getMAD();
                break;
            case "MDL":
                dfrom = rates.getMDL();
                break;
            case "MGA":
                dfrom = rates.getMGA();
                break;

            case "MKD":
                dfrom = rates.getMKD();
                break;
            case "MMK":
                dfrom = rates.getMMK();
                break;
            case "MNT":
                dfrom = rates.getMNT();
                break;
            case "MOP":
                dfrom = rates.getMOP();
                break;

            case "MRO":
                dfrom = rates.getMRO();
                break;
            case "MUR":
                dfrom = rates.getMUR();
                break;
            case "MVR":
                dfrom = rates.getMVR();
                break;

            case "MWK":
                dfrom = rates.getMWK();
                break;
            case "MXN":
                dfrom = rates.getMXN();
                break;
            case "MYR":
                dfrom = rates.getMYR();
                break;
            case "MZN":
                dfrom = rates.getMZN();
                break;
            case "NAD":
                dfrom = rates.getNAD();
                break;
            case "NGN":
                dfrom = rates.getNGN();
                break;
            case "NIO":
                dfrom = rates.getNIO();
                break;
            case "NOK":
                dfrom = rates.getNOK();
                break;
            case "NPR":
                dfrom = rates.getNPR();
                break;
            case "NZD":
                dfrom = rates.getNZD();
                break;
            case "OMR":
                dfrom = rates.getOMR();
                break;
            case "PAB":
                dfrom = rates.getPAB();
                break;
            case "PEN":
                dfrom = rates.getPEN();
                break;
            case "PGK":
                dfrom = rates.getPGK();
                break;
            case "PHP":
                dfrom = rates.getPHP();
                break;
            case "PKR":
                dfrom = rates.getPKR();
                break;
            case "PLN":
                dfrom = rates.getPLN();
                break;
            case "PYG":
                dfrom = rates.getPYG();
                break;
            case "RON":
                dfrom = rates.getRON();
                break;

            case "RSD":
                dfrom = rates.getRSD();
                break;
            case "RUB":
                dfrom = rates.getRUB();
                break;


            case "RWF":
                dfrom = rates.getRWF();
                break;
            case "SAR":
                dfrom = rates.getSAR();
                break;

            case "SBD":
                dfrom = rates.getSBD();
                break;
            case "SCR":
                dfrom = rates.getSCR();
                break;
            case "SDG":
                dfrom = rates.getSDG();
                break;
            case "SEK":
                dfrom = rates.getSEK();
                break;

            case "SGD":
                dfrom = rates.getSGD();
                break;
            case "SHP":
                dfrom = rates.getSHP();
                break;
            case "SLL":
                dfrom = rates.getSLL();
                break;
            case "SOS":
                dfrom = rates.getSOS();
                break;

            case "SRD":
                dfrom = rates.getSRD();
                break;
            case "STD":
                dfrom = rates.getSTD();
                break;
            case "SVC":
                dfrom = rates.getSVC();
                break;

            case "SYP":
                dfrom = rates.getSYP();
                break;
            case "SZL":
                dfrom = rates.getSZL();
                break;
            case "THB":
                dfrom = rates.getTHB();
                break;
            case "TJS":
                dfrom = rates.getTJS();
                break;
            case "TMT":
                dfrom = rates.getTMT();
                break;
            case "TND":
                dfrom = rates.getTND();
                break;
            case "TOP":
                dfrom = rates.getTOP();
                break;
            case "TTD":
                dfrom = rates.getTTD();
                break;
            case "TRY":
                dfrom = rates.getTRY();
                break;
            case "TWD":
                dfrom = rates.getTWD();
                break;
            case "TZS":
                dfrom = rates.getTZS();
                break;
            case "QAR":
                dfrom = rates.getQAR();
                break;
            case "USD":
                dfrom = rates.getUSD();
                break;
            case "UAH":
                dfrom = rates.getUAH();
                break;
            case "UGX":
                dfrom = rates.getUGX();
                break;
            case "UYU":
                dfrom = rates.getUYU();
                break;
            case "UZS":
                dfrom = rates.getUZS();
                break;
            case "VEF":
                dfrom = rates.getVEF();
                break;
            case "VND":
                dfrom = rates.getVND();
                break;
            case "VUV":
                dfrom = rates.getVUV();
                break;
            case "WST":
                dfrom = rates.getWST();
                break;
            case "XAF":
                dfrom = rates.getXAF();
                break;
            case "XAG":
                dfrom = rates.getXAG();
                break;
            case "XAU":
                dfrom = rates.getXAU();
                break;
            case "XCD":
                dfrom = rates.getXCD();
                break;
            case "XDR":
                dfrom = rates.getXDR();
                break;
            case "XOF":
                dfrom = rates.getXOF();
                break;
            case "XPF":
                dfrom = rates.getXPF();
                break;
            case "YER":
                dfrom = rates.getYER();
                break;
            case "ZAR":
                dfrom = rates.getZAR();
                break;
            case "ZMK":
                dfrom = rates.getZMK();
                break;

            case "ZMW" :
                dfrom = rates.getZMW();
                break;
            case "ZWL" :
                dfrom = rates.getZWL();
                break;


        }

        double dto = 0.0;
        switch (toCurruncy) {
            case "AED":
                dto = rates.getAED();
                break;

            case "AFN":
                dto = rates.getAFN();
                break;

            case "ALL":
                dto = rates.getALL();
                break;
            case "AMD":
                dto = rates.getAMD();
                break;

            case "ANG":
                dto = rates.getANG();
                break;

            case "AOA":
                dto = rates.getAOA();
                break;

            case "ARS":
                dto = rates.getARS();
                break;
            case "AUD":
                dto = rates.getAUD();
                break;

            case "AWG":
                dto = rates.getAWG();
                break;

            case "AZN":
                dto = rates.getAZN();
                break;
            case "BAM":
                dto = rates.getBAM();
                break;


            case "BBD":
                dto = rates.getBBD();
                break;
            case "BDT":
                dto = rates.getBDT();
                break;

            case "BGN":
                dto = rates.getBGN();
                break;

            case "BHD":
                dto = rates.getBHD();
                break;
            case "BIF":
                dto = rates.getBIF();
                break;

            case "BMD":
                dto = rates.getBMD();
                break;

            case "BND":
                dto = rates.getBND();
                break;
            case "BOB":
                dto = rates.getBOB();
                break;

            case "BRL":
                dto = rates.getBRL();
                break;

            case "BSD":
                dto = rates.getBSD();
                break;
            case "BTC":
                dto = rates.getBTC();
                break;
            case "BTN":
                dto = rates.getBTN();
                break;
            case "BWP":
                dto = rates.getBWP();
                break;

            case "BYN":
                dto = rates.getBYN();
                break;

            case "BYR":
                dto = rates.getBYR();
                break;
            case "BZD":
                dto = rates.getBZD();
                break;

            case "CAD":
                dto = rates.getCAD();
                break;
            case "CDF":
                dto = rates.getCDF();
                break;
            case "CHF":
                dto = rates.getCHF();
                break;

            case "CLF":
                dto = rates.getCLF();
                break;

            case "BLP":
                dto = rates.getCLP();
                break;
            case "CNY":
                dto = rates.getCNY();
                break;

            case "COP":
                dto = rates.getCOP();
                break;
            case "CRC":
                dto = rates.getCRC();
                break;


            case "CUC":
                dto = rates.getCUC();
                break;
            case "CUP":
                dto = rates.getCUP();
                break;

            case "CVE":
                dto = rates.getCVE();
                break;
            case "CZK":
                dto = rates.getCZK();
                break;


            case "DJF":
                dto = rates.getDJF();
                break;
            case "DKK":
                dto = rates.getDKK();
                break;

            case "DOP":
                dto = rates.getDOP();
                break;
            case "DZD":
                dto = rates.getDZD();
                break;


            case "EGP":
                dto = rates.getEGP();
                break;
            case "ERN":
                dto = rates.getEGP();
                break;


            case "ETB":
                dto = rates.getETB();
                break;
            case "EUR":
                dto = rates.getEUR();
                break;


            case "FJD":
                dto = rates.getFJD();
                break;
            case "FKP":
                dto = rates.getFKP();
                break;

            case "GBP":
                dto = rates.getGBP();
                break;
            case "GEL":
                dto = rates.getGEL();
                break;

            case "GGP":
                dto = rates.getGGP();
                break;
            case "GHS":
                dto = rates.getGHS();
                break;


            case "GIP":
                dto = rates.getGIP();
                break;
            case "GMD":
                dto = rates.getGMD();
                break;

            case "GNF":
                dto = rates.getGNF();
                break;
            case "GTQ":
                dto = rates.getGTQ();
                break;
            case "GYD":
                dto = rates.getGYD();
                break;
            case "HKD":
                dto = rates.getHKD();
                break;

            case "HNL":
                dto = rates.getHNL();
                break;
            case "HRK":
                dto = rates.getHRK();
                break;
            case "HTG":
                dto = rates.getHTG();
                break;
            case "HUF":
                dto = rates.getHUF();
                break;

            case "IDR":
                dto = rates.getIDR();
                break;
            case "ILS":
                dto = rates.getILS();
                break;
            case "IMP":
                dto = rates.getIMP();
                break;

            case "INR":
                dto = rates.getINR();
                break;
            case "IQD":
                dto = rates.getIQD();
                break;
            case "IRR":
                dto = rates.getIRR();
                break;
            case "ISK":
                dto = rates.getISK();
                break;
            case "JEP":
                dto = rates.getJEP();
                break;
            case "JMD":
                dto = rates.getJMD();
                break;
            case "JPD":
                dto = rates.getJOD();
                break;
            case "JPY":
                dto = rates.getJPY();
                break;
            case "KES":
                dto = rates.getKES();
                break;
            case "KGS":
                dto = rates.getKGS();
                break;
            case "KHR":
                dto = rates.getKHR();
                break;
            case "KMF":
                dto = rates.getKMF();
                break;
            case "KPW":
                dto = rates.getKPW();
                break;
            case "KRW":
                dto = rates.getKRW();
                break;
            case "KWD":
                dto = rates.getKWD();
                break;
            case "KYD":
                dto = rates.getKYD();
                break;
            case "KZT":
                dto = rates.getKZT();
                break;



            case "LAK" :
                dto = rates.getLAK();
                break;
            case "LBP" :
                dto = rates.getLBP();
                break;
            case "LKR" :
                dto = rates.getLKR();
                break;
            case "LRD" :
                dto = rates.getLRD();
                break;
            case "LSL" :
                dto = rates.getLSL();
                break;
            case "LTL" :
                dto = rates.getLTL();
                break;
            case "LVL" :
                dto = rates.getLVL();
                break;
            case "LYD" :
                dto = rates.getLYD();
                break;


            case "MAD":
                dto = rates.getMAD();
                break;
            case "MDL":
                dto = rates.getMDL();
                break;
            case "MGA":
                dto = rates.getMGA();
                break;

            case "MKD":
                dto = rates.getMKD();
                break;
            case "MMK":
                dto = rates.getMMK();
                break;
            case "MNT":
                dto = rates.getMNT();
                break;
            case "MOP":
                dto = rates.getMOP();
                break;

            case "MRO":
                dto = rates.getMRO();
                break;
            case "MUR":
                dto = rates.getMUR();
                break;
            case "MVR":
                dto = rates.getMVR();
                break;

            case "MWK":
                dto = rates.getMWK();
                break;
            case "MXN":
                dto = rates.getMXN();
                break;
            case "MYR":
                dto = rates.getMYR();
                break;
            case "MZN":
                dto = rates.getMZN();
                break;
            case "NAD":
                dto = rates.getNAD();
                break;
            case "NGN":
                dto = rates.getNGN();
                break;
            case "NIO":
                dto = rates.getNIO();
                break;
            case "NOK":
                dto = rates.getNOK();
                break;
            case "NPR":
                dto = rates.getNPR();
                break;
            case "NZD":
                dto = rates.getNZD();
                break;
            case "OMR":
                dto = rates.getOMR();
                break;
            case "PAB":
                dto = rates.getPAB();
                break;
            case "PEN":
                dto = rates.getPEN();
                break;
            case "PGK":
                dto = rates.getPGK();
                break;
            case "PHP":
                dto = rates.getPHP();
                break;
            case "PKR":
                dto = rates.getPKR();
                break;
            case "PLN":
                dto = rates.getPLN();
                break;
            case "PYG":
                dto = rates.getPYG();
                break;

            case "QAR":
                dto = rates.getQAR();
                break;
            case "RON":
                dto = rates.getRON();
                break;

            case "RSD":
                dto = rates.getRSD();
                break;
            case "RUB":
                dto = rates.getRUB();
                break;


            case "RWF":
                dto = rates.getRWF();
                break;
            case "SAR":
                dto = rates.getSAR();
                break;

            case "SBD":
                dto = rates.getSBD();
                break;
            case "SCR":
                dto = rates.getSCR();
                break;
            case "SDG":
                dto = rates.getSDG();
                break;
            case "SEK":
                dto = rates.getSEK();
                break;

            case "SGD":
                dto = rates.getSGD();
                break;
            case "SHP":
                dto = rates.getSHP();
                break;
            case "SLL":
                dto = rates.getSLL();
                break;
            case "SOS":
                dto = rates.getSOS();
                break;

            case "SRD":
                dto = rates.getSRD();
                break;
            case "STD":
                dto = rates.getSTD();
                break;
            case "SVC":
                dto = rates.getSVC();
                break;

            case "SYP":
                dto = rates.getSYP();
                break;
            case "SZL":
                dto = rates.getSZL();
                break;
            case "THB":
                dto = rates.getTHB();
                break;
            case "TJS":
                dto = rates.getTJS();
                break;
            case "TMT":
                dto = rates.getTMT();
                break;
            case "TND":
                dto = rates.getTND();
                break;
            case "TOP":
                dto = rates.getTOP();
                break;
            case "TTD":
                dto = rates.getTTD();
                break;
            case "TRY":
                dto = rates.getTRY();
                break;
            case "TWD":
                dto = rates.getTWD();
                break;
            case "TZS":
                dto = rates.getTZS();
                break;
            
           
            case "USD":
                dto = rates.getUSD();
                break;
            case "UAH":
                dto = rates.getUAH();
                break;
            case "UGX":
                dto = rates.getUGX();
                break;
            case "UYU":
                dto = rates.getUYU();
                break;
            case "UZS":
                dto = rates.getUZS();
                break;
            case "VEF":
                dto = rates.getVEF();
                break;
            case "VND":
                dto = rates.getVND();
                break;
            case "VUV":
                dto = rates.getVUV();
                break;
            case "WST":
                dto = rates.getWST();
                break;
            case "XAF":
                dto = rates.getXAF();
                break;
            case "XAG":
                dto = rates.getXAG();
                break;
            case "XAU":
                dto = rates.getXAU();
                break;
            case "XCD":
                dto = rates.getXCD();
                break;
            case "XDR":
                dto = rates.getXDR();
                break;
            case "XOF":
                dto = rates.getXOF();
                break;
            case "XPF":
                dto = rates.getXPF();
                break;
            case "YER":
                dto = rates.getYER();
                break;
            case "ZAR":
                dto = rates.getZAR();
                break;
            case "ZMK":
                dto = rates.getZMK();
                break;

            case "ZMW" :
                dto = rates.getZMW();
                break;
            case "ZWL" :
                dto = rates.getZWL();
                break;


        }
        double amt = Double.parseDouble(amount);
        double v = (dto / dfrom) * amt;
        mResult.setText(""+v);

    }


    public void initButtons(LinearLayout layout) {
        for (int i = 0; i < layout.getChildCount(); i++) {
            View v = layout.getChildAt(i);

            if (v instanceof LinearLayout)
                initButtons((LinearLayout) v);

            if (v instanceof Button) {
                v.setSoundEffectsEnabled(false);
            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        switch (requestCode) {
            case REQ_CODE_SPEECH_INPUT: {
                if (resultCode == RESULT_OK && null != data) {

                    ArrayList<String> result = data
                            .getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
                    String res = result.get(0);
                    res = changeToOperators(res);
                    mAmount.append(res);
                }
                break;
            }
        }
    }

    private String changeToOperators(String str) {
        str = str.replaceAll("one", "1");
        str = str.replaceAll("two", "2");
        str = str.replaceAll("three", "3");
        str = str.replaceAll("four", "4");
        str = str.replaceAll("five", "5");
        str = str.replaceAll("six", "6");
        str = str.replaceAll("seven", "7");
        str = str.replaceAll("eight", "8");
        str = str.replaceAll("nine", "9");
        str = str.replaceAll("times?", "*");
        str = str.replaceAll("multipl(y|ied)", "*");
        str = str.replaceAll("plus", "+");
        str = str.replaceAll("minus|negative", "-");
        str = str.replaceAll("divid(ed)?", "/");
        str = str.replaceAll("over", "/");
        str = str.replaceAll("power", "^");
        str = str.replaceAll("open(ed)? bracket(s)?", "(");
        str = str.replaceAll("close(d)? bracket(s)?", ")");
        str = str.replaceAll("[a-z]", "");

        return str;
    }



    private static String convertPower(String expression, int operator) throws EvaluationException {

        StringTokenizer tokens = new StringTokenizer(expression, "^");
        String first = tokens.nextToken();
        String second = tokens.nextToken();
        Double n, p, r = 1d;
        n = Double.parseDouble(first);
        p = Double.parseDouble(second);
        if (n >= 0 && p == 0) {
            r = 1d;
        } else if (n == 0 && p >= 1) {
            r = 0d;
        } else {
            for (int i = 1; i <= p; i++) {
                r = r * n;
            }
        }
        String value = String.valueOf(r);

        return value;
    }

    private static String calculateFactorial(String expression, int factOp) {
        try {
            String num = "", num1 = "";
            int index = factOp;
            while (index > 0 && (expression.charAt(--index) + "").matches("[0-9]"))
                num += expression.charAt(index);
            for (int i = num.length() - 1; i >= 0; i--) {
                num1 = num1 + num.charAt(i);
            }
            double num_i = Integer.parseInt(num1);
            double fact = num_i;

            if (num_i == 0)
                fact = 1;

            while (num_i > 1) {
                num_i = num_i - 1;
                fact = fact * num_i;
            }
            expression = expression.substring(0, index) + fact + expression.substring(factOp + 1);

            return expression;

        } catch (NumberFormatException e) {
            return "Invalid";
        }
    }

    public void getConvertCuruncy() {

        pdailog.setVisibility(VISIBLE);
        Amount = mAmount.getText().toString();
        Map<String, String> params = new HashMap<String, String>();
        params.put(Constants.ACCESS_KEY, Constants.KEY);
        Call<LatestModel> call = ApiClient.getClient().create(ApiInterface.class).getConvetrCuruncy(params);
        call.enqueue(new Callback<LatestModel>() {
            @Override
            public void onResponse(Call<LatestModel> call, Response<LatestModel> response) {
                if (response.isSuccessful()) {
                    pdailog.setVisibility(GONE);

                    userResponse = response.body();



                } else {
                    pdailog.setVisibility(GONE);

                    Log.e("responsedata", "onResponse: re data " + response.message());
                }
            }

            @Override
            public void onFailure(Call<LatestModel> call, Throwable t) {
                pdailog.setVisibility(GONE);

                Toast.makeText(Currency_Calc.this, t.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
    }
}