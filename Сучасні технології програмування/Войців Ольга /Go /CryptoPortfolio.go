package main

import (
	"fmt"
	"math/rand"
	"sync"
	"time"
)

type Coin struct {
	Symbol string  
	Amount float64 
}


type PriceUpdate struct {
	Symbol string
	Price  float64
}


func simulateFetchPrice(symbol string) float64 {
	time.Sleep(time.Millisecond * time.Duration(rand.Intn(500)+100))
	
	basePrice := 100.0
	switch symbol {
	case "BTC":
		basePrice = 65000.0
	case "ETH":
		basePrice = 3500.0
	case "SOL":
		basePrice = 145.0
	case "DOGE":
		basePrice = 0.12
	}
	volatility := basePrice * 0.05 * (rand.Float64() - 0.5)
	return basePrice + volatility
}

func main() {
	fmt.Println("Crypto porfolio tracker:")

	myPortfolio := []Coin{
		{"BTC", 0.5},
		{"ETH", 2.0},
		{"SOL", 50.0},
		{"DOGE", 10000.0},
	}

	priceChannel := make(chan PriceUpdate, len(myPortfolio))
	
	var wg sync.WaitGroup

	for _, coin := range myPortfolio {
		wg.Add(1)
		
		go func(c Coin) {
			defer wg.Done()
			price := simulateFetchPrice(c.Symbol)
			priceChannel <- PriceUpdate{Symbol: c.Symbol, Price: price}
		}(coin)
	}

	go func() {
		wg.Wait()
		close(priceChannel)
	}()

	totalValue := 0.0
	
	fmt.Printf("%-10s | %-10s | %-12s | %-12s\n", "Coin", "Amount", "Price ($)", "Total ($)")
	fmt.Println("-------------------------------------------------------")


	portfolioMap := make(map[string]float64)
	for _, coin := range myPortfolio {
		portfolioMap[coin.Symbol] = coin.Amount
	}

	for update := range priceChannel {
		amount := portfolioMap[update.Symbol]
		value := update.Price * amount
		totalValue += value

		fmt.Printf("%-10s | %-10.4f | $%-11.2f | $%-11.2f\n", 
			update.Symbol, amount, update.Price, value)
	}

	fmt.Println("-------------------------------------------------------")
	fmt.Printf("Total portfoilio value: $%.2f\n", totalValue)
}
