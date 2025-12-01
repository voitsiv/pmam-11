// Оголошення класу товару
var Product = /** @class */ (function () {
    function Product(id, name, price) {
        this.id = id;
        this.name = name;
        this.price = price;
    }
    return Product;
}());
// Масив з доступними товарами
var availableProducts = [
    new Product(1, 'Футболка', 20),
    new Product(2, 'Штани', 30),
    new Product(3, 'Кросівки', 50),
];
// Отримання корзини покупок з локального сховища браузера
var cart = JSON.parse(localStorage.getItem('cart') || '[]');
// Функція для відображення товарів на сторінці
function displayProducts(products) {
    var productsDiv = document.getElementById('products');
    productsDiv.innerHTML = '';
    products.forEach(function (product) {
        var productDiv = document.createElement('div');
        productDiv.innerHTML = "<p>".concat(product.name, " - ").concat(product.price, "$ <button onclick=\"addToCart(").concat(product.id, ")\">\u0414\u043E\u0434\u0430\u0442\u0438 \u0434\u043E \u043A\u043E\u0440\u0437\u0438\u043D\u0438</button></p>");
        productsDiv.appendChild(productDiv);
    });
}
// Функція для додавання товару до корзини
function addToCart(productId) {
    var cartItem = findCartItemById(productId);
    if (cartItem) {
        cartItem.quantity++;
    }
    else {
        var productToAdd = findProductById(productId);
        if (productToAdd) {
            cart.push({ product: productToAdd, quantity: 1 });
        }
    }
    saveCart();
    displayCart();
}
// Функція для пошуку товару за його ідентифікатором
function findProductById(id) {
    for (var _i = 0, availableProducts_1 = availableProducts; _i < availableProducts_1.length; _i++) {
        var product = availableProducts_1[_i];
        if (product.id === id) {
            return product;
        }
    }
    return undefined;
}
// Функція для пошуку товару в корзині за його ідентифікатором
function findCartItemById(id) {
    for (var _i = 0, cart_1 = cart; _i < cart_1.length; _i++) {
        var cartItem = cart_1[_i];
        if (cartItem.product.id === id) {
            return cartItem;
        }
    }
    return undefined;
}
// Функція для збереження корзини в локальне сховище браузера
function saveCart() {
    localStorage.setItem('cart', JSON.stringify(cart));
}
// Функція для відображення корзини покупок
function displayCart() {
    var cartList = document.getElementById('cart');
    cartList.innerHTML = '';
    cart.forEach(function (cartItem) {
        var product = cartItem.product, quantity = cartItem.quantity;
        var cartItemElement = document.createElement('li');
        cartItemElement.innerHTML = "\n      <span>".concat(product.name, " - ").concat(product.price, "$ (\u041A\u0456\u043B\u044C\u043A\u0456\u0441\u0442\u044C: ").concat(quantity, ")</span>\n      <button onclick=\"removeFromCart(").concat(product.id, ")\">\u0412\u0438\u0434\u0430\u043B\u0438\u0442\u0438</button>\n      <button onclick=\"decreaseQuantity(").concat(product.id, ")\">-</button>\n      <button onclick=\"increaseQuantity(").concat(product.id, ")\">+</button>\n    ");
        cartList.appendChild(cartItemElement);
    });
}
// Функція для видалення товару з корзини
function removeFromCart(productId) {
    cart = cart.filter(function (item) { return item.product.id !== productId; });
    saveCart();
    displayCart();
}
// Функція для зменшення кількості товару
function decreaseQuantity(productId) {
    var cartItem = findCartItemById(productId);
    if (cartItem && cartItem.quantity > 1) {
        cartItem.quantity--;
        saveCart();
        displayCart();
    }
}
// Функція для збільшення кількості товару
function increaseQuantity(productId) {
    var cartItem = findCartItemById(productId);
    if (cartItem) {
        cartItem.quantity++;
        saveCart();
        displayCart();
    }
}
// Відображення товарів при завантаженні сторінки
displayProducts(availableProducts);
displayCart(); // Відобразити корзину покупок при завантаженні сторінки
