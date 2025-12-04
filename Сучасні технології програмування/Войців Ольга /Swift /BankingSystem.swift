import Foundation

extension Double {
    func asCurrency() -> String {
        return String(format: "$%.2f", self)
    }
}

enum BankingError: Error {
    case insufficientFunds(needed: Double, available: Double)
    case negativeAmount
    case unauthorized
}

protocol PaymentMethod {
    var name: String { get }
    func pay(amount: Double) -> Result<String, BankingError>
}


struct Transaction {
    let id: UUID
    let timestamp: Date
    let description: String
    let amount: Double
}


class BankAccount: PaymentMethod {
    let name: String
    private var balance: Double 
    private var transactionHistory: [Transaction] = []

    init(owner: String, initialBalance: Double) {
        self.name = "Bank Account (\(owner))"
        self.balance = initialBalance
    }

    func getBalance() -> String {
        return balance.asCurrency()
    }

    func pay(amount: Double) -> Result<String, BankingError> {
        guard amount > 0 else {
            return .failure(.negativeAmount)
        }
        
        guard balance >= amount else {
            return .failure(.insufficientFunds(needed: amount, available: balance))
        }

        defer {
            print("[LOG] Операція перевірки балансу завершена.")
        }

        balance -= amount
        let transaction = Transaction(id: UUID(), timestamp: Date(), description: "Payment", amount: -amount)
        transactionHistory.append(transaction)

        return .success("Оплата \(amount.asCurrency()) пройшла успішно. Залишок: \(balance.asCurrency())")
    }

    func deposit(amount: Double) {
        guard amount > 0 else {
            print("Помилка: Сума депозиту має бути додатною.")
            return
        }
        balance += amount
        transactionHistory.append(Transaction(id: UUID(), timestamp: Date(), description: "Deposit", amount: amount))
        print("Депозит \(amount.asCurrency()) зараховано.")
    }
}



print("--- SWIFT BANKING SYSTEM (JUNIOR+) ---")

let myAccount = BankAccount(owner: "Olga Voitsiv", initialBalance: 150.00)
print("Вітаємо, ваш початковий баланс: \(myAccount.getBalance())")

print("\n--- Спроба купити каву ($5.50) ---")
let coffeeResult = myAccount.pay(amount: 5.50)

switch coffeeResult {
case .success(let message):
    print("✅ \(message)")
case .failure(let error):
    print("Помилка: \(error)")
}

print("\n--- Спроба купити MacBook ($2000.00) ---")
let laptopResult = myAccount.pay(amount: 2000.00)

if case .failure(let error) = laptopResult {
    if case .insufficientFunds(let needed, let available) = error {
        print("Недостатньо коштів! Треба: \(needed.asCurrency()), а є тільки: \(available.asCurrency())")
    }
}

print("\n--- Поповнення рахунку ---")
myAccount.deposit(amount: 2500.00)
print("Новий баланс: \(myAccount.getBalance())")

print("\n--- Повторна спроба купити MacBook ---")
let secondAttempt = myAccount.pay(amount: 2000.00)

if case .success(let message) = secondAttempt {
    print("✅ \(message)")
}

print("\n--- Кінець симуляції ---")
