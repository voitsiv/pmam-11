<?php
declare(strict_types=1); 

interface Sellable {
    public function getName(): string;
    public function getPrice(): float;
}

class Product implements Sellable {
    private string $name;
    private float $price;

    public function __construct(string $name, float $price) {
        $this->name = $name;
        $this->price = $price;
    }

    public function getName(): string {
        return $this->name;
    }

    public function getPrice(): float {
        return $this->price;
    }
}


class Cart {
    private array $items = [];
    private float $taxRate = 0.20; 

    public function add(Sellable $product, int $quantity = 1): void {
        for ($i = 0; $i < $quantity; $i++) {
            $this->items[] = $product;
        }
        echo "   [+] Додано: {$product->getName()} ({$this->formatMoney($product->getPrice())})\n";
    }

    public function getTotal(): float {
        $sum = 0.0;
        foreach ($this->items as $item) {
            $sum += $item->getPrice();
        }
        return $sum;
    }

    private function formatMoney(float $amount): string {
        return '$' . number_format($amount, 2);
    }

    public function printReceipt(): void {
        echo "\n----------------------------------\n";
        echo "       ВАШ ЧЕК (RECEIPT)       \n";
        echo "----------------------------------\n";

        if (empty($this->items)) {
            echo "Кошик порожній.\n";
            return;
        }

        $counts = [];
        foreach ($this->items as $item) {
            $name = $item->getName();
            if (!isset($counts[$name])) {
                $counts[$name] = ['obj' => $item, 'count' => 0];
            }
            $counts[$name]['count']++;
        }

        foreach ($counts as $data) {
            $item = $data['obj'];
            $qty = $data['count'];
            $totalItemPrice = $item->getPrice() * $qty;

            printf("%-20s x%d ... %s\n", 
                $item->getName(), 
                $qty, 
                $this->formatMoney($totalItemPrice)
            );
        }

        $subtotal = $this->getTotal();
        $tax = $subtotal * $this->taxRate;
        $finalTotal = $subtotal + $tax;

        echo "----------------------------------\n";
        printf("%-25s %s\n", "Сума:", $this->formatMoney($subtotal));
        printf("%-25s %s\n", "ПДВ (20%):", $this->formatMoney($tax));
        echo "==================================\n";
        printf("%-25s %s\n", "РАЗОМ ДО СПЛАТИ:", $this->formatMoney($finalTotal));
        echo "==================================\n";
        echo "      Дякуємо за покупку!       \n";
    }
}



echo "--- PHP E-COMMERCE SYSTEM (CLI) ---\n\n";

$laptop = new Product("MacBook Air M2", 1199.99);
$mouse = new Product("Logitech MX Master", 99.50);
$keyboard = new Product("Keychron K2", 85.00);

$myCart = new Cart();

$myCart->add($laptop);
$myCart->add($mouse);
$myCart->add($keyboard, 2);


$myCart->printReceipt();
