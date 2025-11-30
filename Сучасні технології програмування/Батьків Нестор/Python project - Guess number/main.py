import random

n = random.randint(1, 100)
print("I guessed a number 1-100. Try to guess.")

tries = 0
while True:
    x = int(input("Your guess: "))
    tries += 1

    if x < n:
        print("Bigger")
    elif x > n:
        print("Smaller")
    else:
        print("You got it! tries =", tries)
        break
