public class PlayfairCipher {

    // Таблиця ключа для шифрування та дешифрування
    private String keyTable;
    // Розмір таблиці (для квадратної матриці)
    private int tableSize;

    // Дозволені символи: англійські, українські літери та цифри
    private static final String ALLOWED = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ0123456789";

    // Конструктор: створює таблицю ключа та визначає її розмір
    public PlayfairCipher(String key) {
        keyTable = generateKeyTable(key); // генеруємо таблицю ключа
        tableSize = (int) Math.ceil(Math.sqrt(keyTable.length())); // обчислюємо розмір квадратної таблиці
    }

    // Генерує ключову таблицю Playfair без повторів символів
    private String generateKeyTable(String key) {
        StringBuilder sb = new StringBuilder();
        key = key.toUpperCase(); // перетворюємо ключ на верхній регістр
        for (char c : key.toCharArray()) {
            // додаємо символ, якщо він дозволений і ще не доданий
            if (ALLOWED.indexOf(c) != -1 && sb.indexOf(String.valueOf(c)) == -1) {
                sb.append(c);
            }
        }
        for (char c : ALLOWED.toCharArray()) {
            // додаємо усі символи з ALLOWED, яких ще немає в таблиці
            if (sb.indexOf(String.valueOf(c)) == -1) sb.append(c);
        }
        return sb.toString(); // повертаємо згенеровану таблицю
    }

    // Знаходить позицію символа у таблиці (рядок і стовпчик)
    private int[] findPosition(char c) {
        int index = keyTable.indexOf(c);
        if (index == -1) return null; // якщо символ не знайдено, повертаємо null
        return new int[]{index / tableSize, index % tableSize}; // повертаємо координати
    }

    // Повертає символ таблиці за координатами з циклічним обчисленням
    private char getCharAt(int row, int col) {
        row = (row + tableSize) % tableSize; // циклічне обчислення рядка
        col = (col + tableSize) % tableSize; // циклічне обчислення стовпчика
        int idx = row * tableSize + col;
        if (idx >= keyTable.length()) idx = keyTable.length() - 1; // захист від виходу за межі
        return keyTable.charAt(idx);
    }

    // Обробка тексту: шифрування або дешифрування
    private String processText(String text, boolean encrypt) {
        StringBuilder sb = new StringBuilder();
        text = text.toUpperCase(); // перетворюємо текст на верхній регістр
        for (int i = 0; i < text.length(); i++) {
            char c1 = text.charAt(i);
            if (ALLOWED.indexOf(c1) == -1) {
                sb.append(c1); // залишаємо пробіли та спецсимволи без змін
                continue;
            }
            char c2 = 'X'; // дефолтна друга літера у парі
            if (i + 1 < text.length()) {
                char next = text.charAt(i + 1);
                if (ALLOWED.indexOf(next) != -1) c2 = next; // беремо другу літеру, якщо дозволена
            }

            int[] pos1 = findPosition(c1); // координати першого символу
            int[] pos2 = findPosition(c2); // координати другого символу
            if (pos1 == null || pos2 == null) {
                sb.append(c1); // якщо символ не знайдено, додаємо як є
                continue;
            }

            // Алгоритм Playfair
            if (pos1[0] == pos2[0]) { // якщо символи в одному рядку
                sb.append(getCharAt(pos1[0], pos1[1] + (encrypt ? 1 : -1))); // зсуваємо по рядку
                sb.append(getCharAt(pos2[0], pos2[1] + (encrypt ? 1 : -1)));
            } else if (pos1[1] == pos2[1]) { // якщо символи в одному стовпчику
                sb.append(getCharAt(pos1[0] + (encrypt ? 1 : -1), pos1[1])); // зсуваємо по стовпчику
                sb.append(getCharAt(pos2[0] + (encrypt ? 1 : -1), pos2[1]));
            } else { // прямокутник
                sb.append(getCharAt(pos1[0], pos2[1])); // міняємо стовпці
                sb.append(getCharAt(pos2[0], pos1[1]));
            }
            i++; // переходимо до наступної пари символів
        }
        return sb.toString(); // повертаємо оброблений текст
    }

    // Шифрування тексту
    public String encrypt(String text) {
        return processText(text, true);
    }

    // Дешифрування тексту
    public String decrypt(String text) {
        return processText(text, false);
    }

    // Статичний метод для універсального виклику шифрування/дешифрування
    public static String process(String text, String key, boolean encrypt) {
        if (key == null || key.isEmpty()) key = "KEY"; // якщо ключ порожній, використовуємо дефолтний
        PlayfairCipher pf = new PlayfairCipher(key); // створюємо об’єкт шифру
        return encrypt ? pf.encrypt(text) : pf.decrypt(text); // повертаємо результат
    }
}