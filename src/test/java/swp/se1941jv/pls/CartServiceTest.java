package swp.se1941jv.pls;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.Optional;

import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import swp.se1941jv.pls.entity.Cart;
import swp.se1941jv.pls.entity.CartPackage;
import swp.se1941jv.pls.entity.Package;
import swp.se1941jv.pls.entity.User;
import swp.se1941jv.pls.repository.CartPackageRepository;
import swp.se1941jv.pls.repository.CartRepository;
import swp.se1941jv.pls.service.CartService;
import swp.se1941jv.pls.service.PackageService;
import swp.se1941jv.pls.service.UserService;

@ExtendWith(MockitoExtension.class)
public class CartServiceTest {

    @Mock
    private CartRepository cartRepository;

    @Mock
    private UserService userService;

    @Mock
    private PackageService packageService;

    @Mock
    private CartPackageRepository cartPackageRepository;

    @Mock
    private HttpSession session;

    @InjectMocks
    private CartService cartService;

    private User user;
    private Cart cart;
    private Package pkg;
    private CartPackage cartPackage;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUserId(1L);
        cart = new Cart();
        cart.setUser(user);
        cart.setQuantity(1);
        pkg = new Package();
        pkg.setPackageId(1L);
        pkg.setPrice(100.0);
        cartPackage = new CartPackage();
        cartPackage.setCart(cart);
        cartPackage.setPkg(pkg);
        cartPackage.setPrice(100.0);
    }

    // Tests for handleAddToCart
    @Test
    void testHandleAddToCart_UserNotFound() {
        // Arrange
        when(userService.getUserById(1L)).thenReturn(null);

        // Act
        boolean result = cartService.handleAddToCart(1L, 1L, session);

        // Assert
        assertTrue(result);
        verify(userService).getUserById(1L);
        verifyNoInteractions(cartRepository, packageService, cartPackageRepository, session);
    }

    @Test
    void testHandleAddToCart_NewCart() {
        // Arrange
        when(userService.getUserById(1L)).thenReturn(user);
        when(cartRepository.findByUser(user)).thenReturn(null);
        when(cartRepository.save(any(Cart.class))).thenAnswer(invocation -> {
            Cart savedCart = invocation.getArgument(0);
            if (savedCart.getQuantity() == 0) {
                // Simulate first save: new cart
                savedCart.setQuantity(0);
            }
            // Simulate second save: return as is (quantity already updated)
            return savedCart;
        });
        when(packageService.findById(1L)).thenReturn(Optional.of(pkg));
        when(cartPackageRepository.findByCartAndPkg(any(Cart.class), eq(pkg))).thenReturn(null);
        when(cartPackageRepository.save(any(CartPackage.class))).thenReturn(cartPackage);

        // Act
        boolean result = cartService.handleAddToCart(1L, 1L, session);

        // Assert
        assertTrue(result);
        verify(userService).getUserById(1L);
        verify(cartRepository).findByUser(user);
        verify(cartRepository, times(2)).save(any(Cart.class));
        verify(packageService).findById(1L);
        verify(cartPackageRepository).findByCartAndPkg(any(Cart.class), eq(pkg));
        verify(cartPackageRepository).save(any(CartPackage.class));
        verify(session).setAttribute("sum", 1);
    }

    @Test
    void testHandleAddToCart_ExistingCart_PackageExists() {
        // Arrange
        when(userService.getUserById(1L)).thenReturn(user);
        when(cartRepository.findByUser(user)).thenReturn(cart);
        when(packageService.findById(1L)).thenReturn(Optional.of(pkg));
        when(cartPackageRepository.findByCartAndPkg(cart, pkg)).thenReturn(cartPackage);

        // Act
        boolean result = cartService.handleAddToCart(1L, 1L, session);

        // Assert
        assertFalse(result);
        verify(userService).getUserById(1L);
        verify(cartRepository).findByUser(user);
        verify(packageService).findById(1L);
        verify(cartPackageRepository).findByCartAndPkg(cart, pkg);
        verifyNoMoreInteractions(cartPackageRepository, cartRepository, session);
    }

    @Test
    void testHandleAddToCart_ExistingCart_NewPackage() {
        // Arrange
        when(userService.getUserById(1L)).thenReturn(user);
        when(cartRepository.findByUser(user)).thenReturn(cart);
        when(packageService.findById(1L)).thenReturn(Optional.of(pkg));
        when(cartPackageRepository.findByCartAndPkg(cart, pkg)).thenReturn(null);
        when(cartPackageRepository.save(any(CartPackage.class))).thenReturn(cartPackage);
        when(cartRepository.save(any(Cart.class))).thenAnswer(invocation -> invocation.getArgument(0));

        // Act
        boolean result = cartService.handleAddToCart(1L, 1L, session);

        // Assert
        assertTrue(result);
        verify(userService).getUserById(1L);
        verify(cartRepository).findByUser(user);
        verify(packageService).findById(1L);
        verify(cartPackageRepository).findByCartAndPkg(cart, pkg);
        verify(cartPackageRepository).save(any(CartPackage.class));
        verify(cartRepository).save(cart);
        verify(session).setAttribute("sum", 2);
    }

    // Tests for handleDeletePackageInCart
    @Test
    void testHandleDeletePackageInCart_QuantityGreaterThanOne() {
        // Arrange
        cart.setQuantity(2);
        cartPackage.setId(1L);
        when(cartPackageRepository.findById(1L)).thenReturn(Optional.of(cartPackage));
        when(cartRepository.save(cart)).thenReturn(cart);

        // Act
        cartService.handleDeletePackageInCart(1L, session);

        // Assert
        verify(cartPackageRepository).findById(1L);
        verify(cartPackageRepository).delete(cartPackage);
        verify(cartRepository).save(cart);
        verify(session).setAttribute("sum", 1);
        assertEquals(1, cart.getQuantity());
        verifyNoMoreInteractions(cartRepository, userService, packageService);
    }

    @Test
    void testHandleDeletePackageInCart_QuantityOne() {
        // Arrange
        cart.setQuantity(1);
        cartPackage.setId(1L);
        when(cartPackageRepository.findById(1L)).thenReturn(Optional.of(cartPackage));

        // Act
        cartService.handleDeletePackageInCart(1L, session);

        // Assert
        verify(cartPackageRepository).findById(1L);
        verify(cartPackageRepository).delete(cartPackage);
        verify(cartRepository).delete(cart);
        verify(session).setAttribute("sum", 0);
        verify(cartRepository, times(0)).save(any(Cart.class));
        verifyNoMoreInteractions(userService, packageService);
        assertNull(cart.getUser().getCart());
    }

    @Test
    void testGetCartByUser() {
        // Arrange
        when(cartRepository.findByUser(user)).thenReturn(cart);

        // Act
        Cart result = cartService.getCartByUser(user);

        // Assert
        assertEquals(cart, result);
        verify(cartRepository).findByUser(user);
        verifyNoMoreInteractions(cartRepository, userService, packageService, cartPackageRepository, session);
    }

    @Test
    void testDeleteCart() {
        // Act
        cartService.deleteCart(cart);

        // Assert
        verify(cartRepository).delete(cart);
        verifyNoMoreInteractions(cartRepository, userService, packageService, cartPackageRepository, session);
    }
}