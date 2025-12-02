class ShoppingCart {
    constructor() {
        this.items = [];
        this.products = [];
        this.total = 0;
        this.isLoading = false;
        this.currentCategory = 'all';
        this.init();
    }

    async init() {
        await this.loadProducts();
        this.setupEventListeners();
        this.loadCartFromStorage();
        this.updateCart();
        this.showNotification('Ласкаво просимо до TechStore!', 'success');
    }

    async loadProducts() {
        this.showLoading(true);
        try {
            const response = await fetch('/api/products');
            this.products = await response.json();
            this.renderProducts();
        } catch (error) {
            console.error('Помилка завантаження товарів:', error);
            this.showNotification('Помилка завантаження товарів', 'error');
        } finally {
            this.showLoading(false);
        }
    }

    renderProducts(filterCategory = 'all') {
        this.currentCategory = filterCategory;
        const container = document.getElementById('products');
        
        if (this.isLoading) {
            container.innerHTML = `
                <div class="loading">
                    <div class="spinner"></div>
                </div>
            `;
            return;
        }

        const filteredProducts = filterCategory === 'all' 
            ? this.products 
            : this.products.filter(p => p.category === filterCategory);

        if (filteredProducts.length === 0) {
            container.innerHTML = `
                <div class="empty-cart">
                    <div class="empty-cart-icon">🔍</div>
                    <p>Товари не знайдено</p>
                </div>
            `;
            return;
        }

        container.innerHTML = filteredProducts.map(product => `
            <div class="product-card" data-category="${product.category}">
                <div class="product-image-container">
                    <img src="${product.image || '/images/placeholder.jpg'}" 
                         alt="${product.name}" 
                         class="product-image"
                         onerror="this.src='/images/placeholder.jpg'">
                    
                    ${product.discount > 0 ? `
                        <span class="product-badge product-discount">-${product.discount}%</span>
                    ` : ''}
                    
                    ${!product.inStock ? `
                        <span class="product-badge product-out">Немає в наявності</span>
                    ` : ''}
                </div>
                
                <div class="product-info">
                    <h3 class="product-title">${product.name}</h3>
                    <p class="product-description">${product.description}</p>
                    
                    <div class="product-rating">
                        <div class="stars">
                            ${'★'.repeat(Math.floor(product.rating))}${'☆'.repeat(5 - Math.floor(product.rating))}
                        </div>
                        <span class="rating-value">${product.rating}</span>
                    </div>
                    
                    <div class="product-price">
                        <span class="price-current">
                            $${(product.price * (100 - product.discount) / 100).toFixed(2)}
                        </span>
                        
                        ${product.discount > 0 ? `
                            <span class="price-old">$${product.price}</span>
                            <span class="discount-percent">-${product.discount}%</span>
                        ` : ''}
                    </div>
                    
                    <button class="add-to-cart" 
                            onclick="cart.addToCart(${product.id})"
                            ${!product.inStock ? 'disabled' : ''}>
                        <span>🛒</span>
                        ${!product.inStock ? 'Немає в наявності' : 'Додати в кошик'}
                    </button>
                </div>
            </div>
        `).join('');
    }

    searchProducts(query) {
        const filtered = this.products.filter(product => 
            product.name.toLowerCase().includes(query.toLowerCase()) ||
            product.description.toLowerCase().includes(query.toLowerCase())
        );
        
        const container = document.getElementById('products');
        if (filtered.length === 0) {
            container.innerHTML = `
                <div class="empty-cart">
                    <div class="empty-cart-icon">🔍</div>
                    <p>За запитом "${query}" нічого не знайдено</p>
                </div>
            `;
        } else {
            this.renderProducts(this.currentCategory);
        }
    }

    addToCart(productId) {
        const product = this.products.find(p => p.id === productId);
        
        if (!product.inStock) {
            this.showNotification('Товар недоступний', 'warning');
            return;
        }

        const existingItem = this.items.find(item => item.id === productId);

        if (existingItem) {
            existingItem.quantity++;
        } else {
            this.items.push({ 
                ...product, 
                quantity: 1,
                finalPrice: product.price * (100 - product.discount) / 100
            });
        }

        this.updateCart();
        this.showNotification(`${product.name} додано в кошик! 🎉`, 'success');
    }

    removeFromCart(productId) {
        this.items = this.items.filter(item => item.id !== productId);
        this.updateCart();
        this.showNotification('Товар видалено з кошика', 'warning');
    }

    updateQuantity(productId, delta) {
        const item = this.items.find(item => item.id === productId);
        if (item) {
            item.quantity += delta;
            if (item.quantity < 1) {
                this.removeFromCart(productId);
            } else {
                this.updateCart();
            }
        }
    }

    updateCart() {
        const cartElement = document.getElementById('cart');
        const totalElement = document.getElementById('total');
        const itemsCountElement = document.getElementById('cart-count');
        const orderBtn = document.getElementById('orderBtn');

        if (this.items.length === 0) {
            cartElement.innerHTML = `
                <div class="empty-cart">
                    <div class="empty-cart-icon">🛒</div>
                    <p>Ваш кошик порожній</p>
                    <p style="font-size: 0.9rem; margin-top: 10px; opacity: 0.7;">
                        Додайте товари, щоб продовжити
                    </p>
                </div>
            `;
            orderBtn.disabled = true;
            itemsCountElement.textContent = '0';
        } else {
            cartElement.innerHTML = this.items.map(item => `
                <div class="cart-item">
                    <img src="${item.image || '/images/placeholder.jpg'}" 
                         alt="${item.name}" 
                         class="cart-item-image"
                         onerror="this.src='/images/placeholder.jpg'">
                    
                    <div class="cart-item-info">
                        <div>
                            <div class="cart-item-title">${item.name}</div>
                            <div class="cart-item-price">
                                $${(item.finalPrice || item.price).toFixed(2)} x ${item.quantity}
                            </div>
                        </div>
                        
                        <div class="cart-item-quantity">
                            <button class="quantity-btn" onclick="cart.updateQuantity(${item.id}, -1)">-</button>
                            <span>${item.quantity}</span>
                            <button class="quantity-btn" onclick="cart.updateQuantity(${item.id}, 1)">+</button>
                            <button class="remove-item" onclick="cart.removeFromCart(${item.id})">🗑️</button>
                        </div>
                    </div>
                </div>
            `).join('');
            
            orderBtn.disabled = false;
            itemsCountElement.textContent = this.items.reduce((sum, item) => sum + item.quantity, 0);
        }

        // Оновлення підсумку
        const subtotal = this.items.reduce((sum, item) => 
            sum + (item.finalPrice || item.price) * item.quantity, 0);
        const discount = this.items.reduce((sum, item) => 
            sum + (item.price * item.quantity * item.discount / 100), 0);
        
        document.getElementById('subtotal').textContent = subtotal.toFixed(2);
        document.getElementById('discount').textContent = discount.toFixed(2);
        document.getElementById('total').textContent = (subtotal - discount).toFixed(2);
        
        this.total = subtotal - discount;
        this.saveCartToStorage();
    }

    setupEventListeners() {
        // Пошук
        document.getElementById('searchInput').addEventListener('input', (e) => {
            this.searchProducts(e.target.value);
        });

        // Категорії
        document.querySelectorAll('.category-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                e.target.classList.add('active');
                const category = e.target.dataset.category;
                this.renderProducts(category);
            });
        });

        // Форма замовлення
        document.getElementById('orderForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.submitOrder();
        });

        // Платіжні методи
        document.querySelectorAll('input[name="payment"]').forEach(radio => {
            radio.addEventListener('change', (e) => {
                document.querySelectorAll('.payment-method label').forEach(label => {
                    label.style.background = '';
                    label.style.color = '';
                });
                e.target.nextElementSibling.style.background = 'var(--primary-color)';
                e.target.nextElementSibling.style.color = 'white';
            });
        });
    }

    async submitOrder() {
        if (this.items.length === 0) {
            this.showNotification('Кошик порожній! Додайте товари', 'warning');
            return;
        }

        const formData = new FormData(document.getElementById('orderForm'));
        const paymentMethod = document.querySelector('input[name="payment"]:checked');

        if (!paymentMethod) {
            this.showNotification('Виберіть спосіб оплати', 'warning');
            return;
        }

        const orderData = {
            name: formData.get('name'),
            email: formData.get('email'),
            phone: formData.get('phone'),
            address: formData.get('address'),
            payment: paymentMethod.value,
            cart: this.items.map(item => ({
                id: item.id,
                name: item.name,
                price: item.finalPrice || item.price,
                quantity: item.quantity,
                discount: item.discount || 0
            }))
        };

        // Валідація
        if (!this.validateForm(orderData)) {
            return;
        }

        this.showLoading(true);

        try {
            const response = await fetch('/api/order', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(orderData)
            });

            const result = await response.json();

            if (result.success) {
                this.showNotification(`Замовлення #${result.orderId} успішно оформлено!`, 'success');
                
                // Очищення кошика
                this.items = [];
                this.updateCart();
                document.getElementById('orderForm').reset();
                
                // Перенаправлення на сторінку успіху
                setTimeout(() => {
                    window.location.href = `/success?order=${result.orderId}`;
                }, 2000);
            } else {
                this.showNotification('Помилка: ' + result.error, 'error');
            }
        } catch (error) {
            console.error('Помилка при відправці замовлення:', error);
            this.showNotification('Сталася помилка при оформленні замовлення', 'error');
        } finally {
            this.showLoading(false);
        }
    }

    validateForm(data) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const phoneRegex = /^[\+]?[0-9]{10,13}$/;

        if (!data.name.trim()) {
            this.showNotification('Введіть ім\'я', 'warning');
            return false;
        }

        if (!emailRegex.test(data.email)) {
            this.showNotification('Введіть коректний email', 'warning');
            return false;
        }

        if (!phoneRegex.test(data.phone)) {
            this.showNotification('Введіть коректний номер телефону', 'warning');
            return false;
        }

        return true;
    }

    showNotification(message, type = 'success') {
        // Видалити попередні сповіщення
        document.querySelectorAll('.notification').forEach(n => n.remove());

        const notification = document.createElement('div');
        notification.className = `notification ${type}`;
        notification.innerHTML = `
            <div class="notification-icon">
                ${type === 'success' ? '✅' : type === 'error' ? '❌' : '⚠️'}
            </div>
            <div class="notification-text">${message}</div>
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease-in forwards';
            setTimeout(() => notification.remove(), 300);
        }, 5000);
    }

    showLoading(show) {
        this.isLoading = show;
        document.getElementById('orderBtn').disabled = show;
        document.getElementById('orderBtn').innerHTML = show ? 
            '<div class="spinner" style="width: 20px; height: 20px;"></div>' : 
            'Оформити замовлення';
    }

    saveCartToStorage() {
        localStorage.setItem('cart', JSON.stringify(this.items));
    }

    loadCartFromStorage() {
        try {
            const saved = localStorage.getItem('cart');
            if (saved) {
                this.items = JSON.parse(saved);
            }
        } catch (error) {
            console.error('Помилка завантаження кошика:', error);
        }
    }
}

// Ініціалізація при завантаженні сторінки
document.addEventListener('DOMContentLoaded', () => {
    window.cart = new ShoppingCart();
    
    // Анімація завантаження
    setTimeout(() => {
        document.body.style.opacity = 1;
    }, 100);
});

// Стилі для анімації виходу сповіщення
const style = document.createElement('style');
style.textContent = `
    @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
`;
document.head.appendChild(style);