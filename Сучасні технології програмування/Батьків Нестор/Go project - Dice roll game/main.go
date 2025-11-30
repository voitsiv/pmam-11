package main

import (
    "fmt"
    "math/rand"
    "time"
)

func roll() int {
    return rand.Intn(6) + 1
}

func main() {
    rand.Seed(time.Now().UnixNano())

    playerScore := 0
    robotScore := 0

    for round := 1; round <= 5; round++ {
        fmt.Println("Round", round)

        p1 := roll()
        p2 := roll()
        r1 := roll()
        r2 := roll()

        playerTotal := p1 + p2
        robotTotal := r1 + r2

        fmt.Println("You rolled :", p1, "and", p2, " -> total =", playerTotal)
        fmt.Println("Robot rolled:", r1, "and", r2, " -> total =", robotTotal)

        if playerTotal > robotTotal {
            fmt.Println("You win this round!")
            playerScore++
        } else if robotTotal > playerTotal {
            fmt.Println("Robot wins this round!")
            robotScore++
        } else {
            fmt.Println("Draw this round!")
        }

        fmt.Println("Score:", playerScore, "-", robotScore)
        fmt.Println()
        time.Sleep(600 * time.Millisecond)
    }

    fmt.Println("=== FINAL RESULT ===")
    fmt.Println("You:", playerScore, "Robot:", robotScore)

    if playerScore > robotScore {
        fmt.Println("You WIN the game!")
    } else if robotScore > playerScore {
        fmt.Println("Robot WINS the game!")
    } else {
        fmt.Println("It's a DRAW!")
    }
}
