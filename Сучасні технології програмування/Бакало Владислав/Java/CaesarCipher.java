public class CaesarCipher {

    private static final String ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ0123456789";
    // Алфавіт: англійські великі, українські великі літери та цифри

    public static String process(String text, String keyStr, boolean encrypt) {
        int key;
        try { 
            key = Integer.parseInt(keyStr); // Конвертація ключа у число
        } catch(NumberFormatException e) { 
            key = 3; // Якщо введено неправильне значення - використовуємо ключ 3 за замовчуванням
        }

        StringBuilder sb = new StringBuilder(); // Результат
        for(char c : text.toUpperCase().toCharArray()) { // Перебір кожного символу, перетворення у верхній регістр
            int idx = ALPHABET.indexOf(c); // Пошук символу в алфавіті
            if(idx == -1) { 
                sb.append(c); // Якщо символ не знайдено (пробіл, знак)додаємо без змін
                continue;
            }
            int shift = encrypt ? key : -key; // Додаємо або віднімаємо ключ залежно від режиму
            int newIdx = (idx + shift + ALPHABET.length()) % ALPHABET.length();
            // Обчислення нового індексу з циклічним обертанням
            sb.append(ALPHABET.charAt(newIdx)); // Додаємо новий символ до результату
        }
        return sb.toString(); // Повертаємо результат
    }
}