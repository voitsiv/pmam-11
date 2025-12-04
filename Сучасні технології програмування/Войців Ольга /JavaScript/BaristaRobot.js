
const wait = (ms) => new Promise(resolve => setTimeout(resolve, ms));

const MENU = {
    espresso: { time: 2000, water: 30, beans: 18 },
    latte:    { time: 3500, water: 50, beans: 18, milk: 150 },
    cappuccino: { time: 3000, water: 50, beans: 18, milk: 100 }
};

class SmartBarista {
    constructor(name) {
        this.name = name;
        this.resources = {
            water: 500, 
            beans: 100, 
            milk: 300  
        };
    }

    async makeDrink(orderType) {
        const recipe = MENU[orderType];

        console.log(`\n${this.name}: Отримав замовлення на ${orderType.toUpperCase()}.`);

        try {
            await this.checkResources(recipe);

            await this.grindBeans(recipe.beans);
            await this.boilWater(recipe.water);
            
            if (recipe.milk) {
                await this.frothMilk(recipe.milk);
            }

            console.log(`Наливаю ${orderType} у чашку...`);
            await wait(1000); 

            console.log(`${this.name}: Ваш ${orderType} готовий! Смачного!`);
            this.printStats();

        } catch (error) {
            console.error(`${this.name}: ПОМИЛКА! ${error.message}`);
        }
    }


    async checkResources(recipe) {
        console.log("Перевіряю системи...");
        await wait(500); 

        if (this.resources.water < recipe.water) throw new Error("Не вистачає води! Поповніть бак.");
        if (this.resources.beans < recipe.beans) throw new Error("Закінчилась кава! Засипте зерна.");
        if (recipe.milk && this.resources.milk < recipe.milk) throw new Error("Немає молока!");


        this.resources.water -= recipe.water;
        this.resources.beans -= recipe.beans;
        if (recipe.milk) this.resources.milk -= recipe.milk;
    }

    async grindBeans(amount) {
        console.log(`Мелю зерна (${amount}г)... [zzzzzz]`);
        await wait(1500);
    }

    async boilWater(amount) {
        console.log(`Нагріваю воду (${amount}мл)... [shhhhh]`);
        await wait(1500);
    }

    async frothMilk(amount) {
        console.log(`Збиваю молоко (${amount}мл)... [whoosh]`);
        await wait(2000); 
    }

    printStats() {
        console.log(` [Система] Залишок: ${this.resources.water}ml | ${this.resources.beans}g | ${this.resources.milk}ml`);
    }
}


(async () => {
    console.log("--- JAVASCRIPT ASYNC COFFEE SHOP ---");
    
    const robot = new SmartBarista("Bender-2000");
    await robot.makeDrink("espresso");
    
    console.log("\n... (Заходить новий клієнт) ...");
    await wait(2000);
    await robot.makeDrink("latte");

})();
