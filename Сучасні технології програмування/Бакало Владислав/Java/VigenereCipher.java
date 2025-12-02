public class VigenereCipher {
    // Англійський алфавіт (верхній регістр)
    private static final String EN_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    // Український алфавіт
    private static final String UA_ALPHABET = "АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ";
    // Цифри (0–9)
    private static final String DIGITS = "0123456789";
    // Головний метод: шифрування або розшифрування весь тексту
    public static String process(String text, String key, boolean encrypt) {

        // Якщо ключ не введений - встановлюється стандартний
        if (key == null || key.isEmpty()) key = "KEY";
        StringBuilder result = new StringBuilder();
        int keyIndex = 0; // лічильник позиції у ключі

        // Проходимо по кожному символу тексту
        for (char c : text.toCharArray()) {
            // Беремо відповідний символ ключа (циклічно)
            char k = key.charAt(keyIndex % key.length());
            // Обробляємо символ згідно з шифром Віженера
            result.append(processChar(c, k, encrypt));
            // Якщо символ - літера або цифра → рухаємось по ключу далі
            if (Character.isLetter(c) || Character.isDigit(c)) {
                keyIndex++;
            }
        }
        return result.toString();
    }

    // Обробка одного символа (літера англійська, українська, цифра або інший)
    private static char processChar(char c, char k, boolean encrypt) {
        // Якщо це англійська велика літера
        if (Character.isUpperCase(c)) {
            if (EN_ALPHABET.indexOf(c) != -1) {
                // Зсув = позиція символу ключа в англійському алфавіті
                int shift = EN_ALPHABET.indexOf(Character.toUpperCase(k));
                // Розрахунок нового індексу (шифрування або дешифрування)
                return EN_ALPHABET.charAt(
                        mod((encrypt ? EN_ALPHABET.indexOf(c) + shift :
                                        EN_ALPHABET.indexOf(c) - shift),
                                EN_ALPHABET.length()));
            }
        }

        // Якщо це англійська мала літера
        else if (Character.isLowerCase(c)) {
            if (EN_ALPHABET.toLowerCase().indexOf(c) != -1) {
                // Зсув як у великих - від великої літери ключа
                int shift = EN_ALPHABET.indexOf(Character.toUpperCase(k));
                // Повертаємо шифровану малу літеру
                return Character.toLowerCase(
                        EN_ALPHABET.charAt(
                                mod((EN_ALPHABET.toLowerCase().indexOf(c) + (encrypt ? shift : -shift)),
                                    EN_ALPHABET.length())));
            }
        }

        // Якщо це українська літера
        else if (UA_ALPHABET.indexOf(Character.toUpperCase(c)) != -1) {
            boolean isUpper = Character.isUpperCase(c); // чи велика літера
            int shift = UA_ALPHABET.indexOf(Character.toUpperCase(k)); // зсув
            // Отримуємо новий символ за індексом
            char newChar = UA_ALPHABET.charAt(
                    mod((UA_ALPHABET.indexOf(Character.toUpperCase(c)) +
                            (encrypt ? shift : -shift)),
                        UA_ALPHABET.length()));
            // Повертаємо з відповідним регістром
            return isUpper ? newChar : Character.toLowerCase(newChar);
        }

        // Якщо символ цифра
        else if (Character.isDigit(c)) {
            // Зсув = остання цифра коду символу ключа
            int shift = k % 10;
            // Шифруємо/дешифруємо цифру
            return DIGITS.charAt(
                    mod((DIGITS.indexOf(c) + (encrypt ? shift : -shift)),
                        DIGITS.length()));
        }

        // Якщо не літера і не цифра - повертаємо символ без змін
        return c;
    }

    // Правильне модульне додавання (робить результат позитивним)
    private static int mod(int a, int b) {
        int res = a % b;
        return res < 0 ? res + b : res;
    }
}