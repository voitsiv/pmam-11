public class AtbashCipher {

    private static final String EN_UPPER = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; // Англійські великі літери
    private static final String EN_LOWER = EN_UPPER.toLowerCase();       // Англійські малі літери
    private static final String UA_UPPER = "АБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ"; // Українські великі літери
    private static final String UA_LOWER = UA_UPPER.toLowerCase();       // Українські малі літери
    private static final String DIGITS = "0123456789";                   // Цифри

    public static String process(String text) {
        StringBuilder result = new StringBuilder(); // Місце для збереження результату

        for (char c : text.toCharArray()) { // Проходимо по кожному символу
            if (EN_UPPER.indexOf(c) >= 0) {
                // Віддзеркалення символу в англійському великому алфавіті
                result.append(EN_UPPER.charAt(EN_UPPER.length() - 1 - EN_UPPER.indexOf(c)));
            } else if (EN_LOWER.indexOf(c) >= 0) {
                // Віддзеркалення символу в англійському малому алфавіті
                result.append(EN_LOWER.charAt(EN_LOWER.length() - 1 - EN_LOWER.indexOf(c)));
            } else if (UA_UPPER.indexOf(c) >= 0) {
                // Віддзеркалення символу в українському великому алфавіті
                result.append(UA_UPPER.charAt(UA_UPPER.length() - 1 - UA_UPPER.indexOf(c)));
            } else if (UA_LOWER.indexOf(c) >= 0) {
                // Віддзеркалення символу в українському малому алфавіті
                result.append(UA_LOWER.charAt(UA_LOWER.length() - 1 - UA_LOWER.indexOf(c)));
            } else if (DIGITS.indexOf(c) >= 0) {
                // Віддзеркалення цифри (0→9, 1→8, ...)
                result.append(DIGITS.charAt(DIGITS.length() - 1 - DIGITS.indexOf(c)));
            } else {
                // Пробіли та інші символи залишаються без змін
                result.append(c);
            }
        }
        return result.toString(); // Повертаємо готовий зашифрований/розшифрований текст
    }
}