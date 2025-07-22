package swp.se1941jv.pls.config;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import jakarta.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Cấu hình tích hợp VNPAY - môi trường Sandbox
 */
public class PaymentConfig {

    public static final String VNP_PAY_URL = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String VNP_RETURN_URL = "http://localhost:5555/vnpay-return";
    public static final String VNP_TMN_CODE = "KUS522IO";
    public static final String VNP_HASH_SECRET = "RFS2QJSD9B5U1XHW86IHMMNT3P8H03R6";
    public static final String VNP_API_URL = "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";

    public static String getCurrentDate() {
        return new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
    }

    public static String getRandomTxnRef() {
        return String.valueOf(System.currentTimeMillis());
    }

    public static String getClientIp(HttpServletRequest request) {
        String ipAddress = request.getHeader("X-FORWARDED-FOR");
        if (ipAddress == null || ipAddress.isEmpty()) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }

    public static String hmacSHA512(String key, String data) {
        try {
            Mac hmac512 = Mac.getInstance("HmacSHA512");
            SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
            hmac512.init(secretKeySpec);
            byte[] bytes = hmac512.doFinal(data.getBytes(StandardCharsets.UTF_8));
            StringBuilder hash = new StringBuilder();
            for (byte b : bytes) {
                hash.append(String.format("%02x", b));
            }
            return hash.toString();
        } catch (Exception ex) {
            return "";
        }
    }

    public static String hashAllFields(Map<String, String> fields) throws UnsupportedEncodingException {
        List<String> sortedKeys = new ArrayList<>(fields.keySet());
        Collections.sort(sortedKeys);
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < sortedKeys.size(); i++) {
            String key = sortedKeys.get(i);
            String value = fields.get(key);
            if (value != null && !value.isEmpty()) {
                sb.append(URLEncoder.encode(key, StandardCharsets.US_ASCII.toString()));
                sb.append('=');
                sb.append(URLEncoder.encode(value, StandardCharsets.US_ASCII.toString()));
                if (i < sortedKeys.size() - 1) {
                    sb.append('&');
                }
            }
        }
        return hmacSHA512(VNP_HASH_SECRET, sb.toString());
    }

    public static String buildQueryUrl(Map<String, String> params) throws UnsupportedEncodingException {
        List<String> keys = new ArrayList<>(params.keySet());
        Collections.sort(keys);
        StringBuilder query = new StringBuilder();
        for (String key : keys) {
            String value = params.get(key);
            if (value != null && !value.isEmpty()) {
                query.append(java.net.URLEncoder.encode(key, "UTF-8"));
                query.append('=');
                query.append(java.net.URLEncoder.encode(value, "UTF-8"));
                query.append('&');
            }
        }
        query.setLength(query.length() - 1); // Xoá dấu & cuối
        return query.toString();
    }
}
