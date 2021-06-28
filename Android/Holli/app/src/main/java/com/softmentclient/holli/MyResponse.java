package com.softmentclient.holli;
public class MyResponse {

    String status;

    String txnId;

    String amount;

    String pgUsed;

    String pgUnderlier;

    String merchantTxnId;

    String checksum;

    String errorCode;

    String errorMessage;

    String metadata;

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTxnId() {
        return txnId;
    }

    public void setTxnId(String txnId) {
        this.txnId = txnId;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getPgUsed() {
        return pgUsed;
    }

    public void setPgUsed(String pgUsed) {
        this.pgUsed = pgUsed;
    }

    public String getPgUnderlier() {
        return pgUnderlier;
    }

    public void setPgUnderlier(String pgUnderlier) {
        this.pgUnderlier = pgUnderlier;
    }

    public String getMerchantTxnId() {
        return merchantTxnId;
    }

    public void setMerchantTxnId(String merchantTxnId) {
        this.merchantTxnId = merchantTxnId;
    }

    public String getChecksum() {
        return checksum;
    }

    public void setChecksum(String checksum) {
        this.checksum = checksum;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }
}