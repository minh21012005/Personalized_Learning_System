package swp.se1941jv.pls.controller.client.cart;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import swp.se1941jv.pls.entity.Cart;
import swp.se1941jv.pls.entity.CartPackage;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.service.CartService;
import swp.se1941jv.pls.service.UserService;

@Controller
public class CartController {

    private final CartService cartService;
    private final UserService userService;

    public CartController(CartService cartService, UserService userService) {
        this.cartService = cartService;
        this.userService = userService;
    }

    @GetMapping("/parent/cart")
    public String getCartPage(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession();
        long userId = (long) session.getAttribute("id");
        User user = this.userService.getUserById(userId);
        List<User> students = user.getChildren();
        Cart cart = this.cartService.getCartByUser(user);
        List<CartPackage> cartPackages = cart == null ? new ArrayList<>() : cart.getCartPackages();
        double totalPrice = 0;
        for (CartPackage cartPackage : cartPackages) {
            totalPrice += cartPackage.getPkg().getPrice();
        }
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("cartPackages", cartPackages);
        model.addAttribute("students", students);
        return "client/cart/show";
    }

    @PostMapping("/parent/cart")
    public String addToCart(RedirectAttributes redirectAttributes, @RequestParam("packageId") long packageId,
            HttpServletRequest request) {
        HttpSession session = request.getSession();
        long userId = (long) session.getAttribute("id");
        boolean isSuccess = this.cartService.handleAddToCart(userId, packageId, session);
        if (!isSuccess) {
            redirectAttributes.addFlashAttribute("fail", "Bạn đã có khóa học này trong giỏ hàng rồi!");
        } else {
            redirectAttributes.addFlashAttribute("success", "Khóa học đã được thêm vào giỏ hàng!");
        }
        return "redirect:/parent/course";
    }

    @PostMapping("/parent/cart/delete/{id}")
    public String deletePackageInCart(RedirectAttributes redirectAttributes, HttpServletRequest request,
            @PathVariable("id") long id) {
        HttpSession session = request.getSession();
        this.cartService.handleDeletePackageInCart(id, session);
        redirectAttributes.addFlashAttribute("success", "Khóa học đã được xóa khỏi giỏ hàng!");
        return "redirect:/parent/cart";
    }
}
