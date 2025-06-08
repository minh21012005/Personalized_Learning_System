package swp.se1941jv.pls.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import jakarta.servlet.http.HttpSession;
import swp.se1941jv.pls.entity.Cart;
import swp.se1941jv.pls.entity.CartPackage;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.CartPackageRepository;
import swp.se1941jv.pls.repository.CartRepository;

@Service
public class CartService {
    private final CartRepository cartRepository;
    private final UserService userService;
    private final PackageService packageService;
    private final CartPackageRepository cartPackageRepository;

    public CartService(CartRepository cartRepository, UserService userService, PackageService packageService,
            CartPackageRepository cartPackageRepository) {
        this.cartRepository = cartRepository;
        this.userService = userService;
        this.packageService = packageService;
        this.cartPackageRepository = cartPackageRepository;
    }

    public Cart getCartByUser(User user) {
        return this.cartRepository.findByUser(user);
    }

    public boolean handleAddToCart(long userId, long packageId, HttpSession session) {
        User user = this.userService.getUserById(userId);
        if (user != null) {
            Cart cart = this.cartRepository.findByUser(user);
            if (cart == null) {
                Cart newCart = new Cart();
                newCart.setUser(user);
                newCart.setQuantity(0);
                cart = this.cartRepository.save(newCart);
            }
            Optional<Package> pkgOptional = this.packageService.findById(packageId);
            Package pkg = pkgOptional.get();
            CartPackage oldCartPackage = this.cartPackageRepository.findByCartAndPkg(cart, pkg);
            if (oldCartPackage != null) {
                return false;
            } else {
                CartPackage cartPackage = new CartPackage();
                cartPackage.setCart(cart);
                cartPackage.setPkg(pkg);
                cartPackage.setPrice(pkg.getPrice());
                this.cartPackageRepository.save(cartPackage);

                int s = cart.getQuantity() + 1;
                cart.setQuantity(s);
                this.cartRepository.save(cart);
                session.setAttribute("sum", s);
            }

        }
        return true;
    }
}
