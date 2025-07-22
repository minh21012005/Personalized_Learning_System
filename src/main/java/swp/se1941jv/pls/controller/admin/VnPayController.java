package swp.se1941jv.pls.controller.admin;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import swp.se1941jv.pls.config.PaymentConfig;
import swp.se1941jv.pls.entity.Cart;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.Transaction;
import swp.se1941jv.pls.entity.TransactionStatus;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.entity.UserPackage;
import swp.se1941jv.pls.entity.keys.KeyUserPackage;
import swp.se1941jv.pls.service.CartService;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.TransactionService;
import swp.se1941jv.pls.service.UserPackageService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class VnPayController {

    private final UserService userService;
    private final PackageService packageService;
    private final TransactionService transactionService;
    private final CartService cartService;
    private final UserPackageService userPackageService;

    public VnPayController(UserService userService, PackageService packageService,
            TransactionService transactionService, CartService cartService, UserPackageService userPackageService) {
        this.userService = userService;
        this.packageService = packageService;
        this.transactionService = transactionService;
        this.cartService = cartService;
        this.userPackageService = userPackageService;
    }

    @GetMapping("/create-payment")
    public String createPayment(HttpServletRequest request,
            @RequestParam("price") Double price,
            @RequestParam("packages") List<Long> packageIds, HttpSession session,
            @RequestParam("studentId") Long studentId,
            Model model) throws UnsupportedEncodingException {
        String txnRef = PaymentConfig.getRandomTxnRef();

        // Lưu thông tin để xử lý sau khi return
        session.setAttribute("studentId", studentId);
        session.setAttribute("packageIds", packageIds);
        session.setAttribute("price", price);
        session.setAttribute("txnRef", txnRef);

        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", "2.1.0");
        vnpParams.put("vnp_Command", "pay");
        vnpParams.put("vnp_TmnCode", PaymentConfig.VNP_TMN_CODE);
        vnpParams.put("vnp_Amount", String.valueOf(price.longValue() * 100));
        vnpParams.put("vnp_CurrCode", "VND");
        vnpParams.put("vnp_TxnRef", txnRef);
        vnpParams.put("vnp_OrderInfo", "Thanh toan khoa hoc PLS");
        vnpParams.put("vnp_OrderType", "other");
        vnpParams.put("vnp_Locale", "vn");
        vnpParams.put("vnp_ReturnUrl", PaymentConfig.VNP_RETURN_URL);
        vnpParams.put("vnp_IpAddr", PaymentConfig.getClientIp(request));
        vnpParams.put("vnp_CreateDate", PaymentConfig.getCurrentDate());

        String queryUrl = PaymentConfig.buildQueryUrl(vnpParams);
        String secureHash = PaymentConfig.hashAllFields(vnpParams);
        String redirectUrl = PaymentConfig.VNP_PAY_URL + "?" + queryUrl + "&vnp_SecureHash=" + secureHash;

        return "redirect:" + redirectUrl;
    }

    @GetMapping("/vnpay-return")
    public String vnpayReturn(HttpServletRequest request, HttpSession session, Model model)
            throws UnsupportedEncodingException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        String signValue = PaymentConfig.hashAllFields(fields);
        boolean isValidSignature = signValue.equals(vnp_SecureHash);

        String transactionStatus = request.getParameter("vnp_TransactionStatus");

        if (isValidSignature) {
            if ("00".equals(transactionStatus)) {
                Transaction transaction = new Transaction();
                Long studentId = (Long) session.getAttribute("studentId");
                Long userId = (Long) session.getAttribute("id");
                User parent = this.userService.getUserById(userId);
                User student = this.userService.getUserById(studentId);
                Double price = (Double) session.getAttribute("price");
                List<Long> packageIds = (List<Long>) session.getAttribute("packageIds");

                // Xử lý packages
                List<Package> packages = new ArrayList<>();
                for (Long pkgId : packageIds) {
                    Optional<Package> pkgOptional = this.packageService.findById(pkgId);
                    if (pkgOptional.isPresent()) {
                        packages.add(pkgOptional.get());
                    }
                }
                transaction.setPackages(packages);
                transaction.setAmount(BigDecimal.valueOf(price));
                transaction.setUser(parent);
                transaction.setStudent(student);
                transaction.setTransferCode(request.getParameter("vnp_TxnRef"));
                transaction.setAddInfo("VNPAY Payment");
                transaction.setConfirmedAt(LocalDateTime.now());
                transaction.setStatus(TransactionStatus.APPROVED);

                this.transactionService.save(transaction);
                Cart cart = this.cartService.getCartByUser(parent);
                parent.setCart(null);
                this.cartService.deleteCart(cart);
                for (Package pkg : packages) {
                    UserPackage userPackage = new UserPackage();

                    KeyUserPackage key = new KeyUserPackage();
                    key.setUserId(student.getUserId());
                    key.setPackageId(pkg.getPackageId());

                    userPackage.setId(key);
                    userPackage.setUser(student);
                    userPackage.setPkg(pkg);
                    userPackage.setStartDate(LocalDateTime.now());
                    userPackage.setEndDate(LocalDateTime.now().plusDays(pkg.getDurationDays()));
                    this.userPackageService.save(userPackage);
                }

                return "client/checkout/confirm";
            } else {
            }
        } else {
        }

        return "client/checkout/error";
    }

}
