// Оголошення класу товару
class Product {
  constructor(public id: number, public name: string, public price: number) {}
}

// Масив з доступними товарами
const availableProducts: Product[] = [
  new Product(1, 'Футболка', 20),
  new Product(2, 'Штани', 30),
  new Product(3, 'Кросівки', 50),
];

// Отримання корзини покупок з локального сховища браузера
let cart: { product: Product; quantity: number }[] = JSON.parse(localStorage.getItem('cart') || '[]');

// Функція для відображення товарів на сторінці
function displayProducts(products: Product[]): void {
  const productsDiv = document.getElementById('products');
  productsDiv.innerHTML = '';

  products.forEach((product) => {
    const productDiv = document.createElement('div');
    productDiv.innerHTML = `<p>${product.name} - ${product.price}$ <button onclick="addToCart(${product.id})">Додати до корзини</button></p>`;
    productsDiv.appendChild(productDiv);
  });
}

// Функція для додавання товару до корзини
function addToCart(productId: number): void {
  const cartItem = findCartItemById(productId);
  if (cartItem) {
    cartItem.quantity++;
  } else {
    const productToAdd = findProductById(productId);
    if (productToAdd) {
      cart.push({ product: productToAdd, quantity: 1 });
    }
  }
  saveCart();
  displayCart();
}

// Функція для пошуку товару за його ідентифікатором
function findProductById(id: number): Product | undefined {
  for (const product of availableProducts) {
    if (product.id === id) {
      return product;
    }
  }
  return undefined;
}

// Функція для пошуку товару в корзині за його ідентифікатором
function findCartItemById(id: number): { product: Product; quantity: number } | undefined {
  for (const cartItem of cart) {
    if (cartItem.product.id === id) {
      return cartItem;
    }
  }
  return undefined;
}

// Функція для збереження корзини в локальне сховище браузера
function saveCart(): void {
  localStorage.setItem('cart', JSON.stringify(cart));
}

// Функція для відображення корзини покупок
function displayCart(): void {
  const cartList = document.getElementById('cart');
  cartList.innerHTML = '';

  cart.forEach((cartItem) => {
    const { product, quantity } = cartItem;
    const cartItemElement = document.createElement('li');
    cartItemElement.innerHTML = `
      <span>${product.name} - ${product.price}$ (Кількість: ${quantity})</span>
      <button onclick="removeFromCart(${product.id})">Видалити</button>
      <button onclick="decreaseQuantity(${product.id})">-</button>
      <button onclick="increaseQuantity(${product.id})">+</button>
    `;
    cartList.appendChild(cartItemElement);
  });
}

// Функція для видалення товару з корзини
function removeFromCart(productId: number): void {
  cart = cart.filter((item) => item.product.id !== productId);
  saveCart();
  displayCart();
}

// Функція для зменшення кількості товару
function decreaseQuantity(productId: number): void {
  const cartItem = findCartItemById(productId);
  if (cartItem && cartItem.quantity > 1) {
    cartItem.quantity--;
    saveCart();
    displayCart();
  }
}

// Функція для збільшення кількості товару
function increaseQuantity(productId: number): void {
  const cartItem = findCartItemById(productId);
  if (cartItem) {
    cartItem.quantity++;
    saveCart();
    displayCart();
  }
}

// Відображення товарів при завантаженні сторінки
displayProducts(availableProducts);
displayCart(); // Відобразити корзину покупок при завантаженні сторінки
