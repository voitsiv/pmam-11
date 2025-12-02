public class SubstitutionCipher {

    // Базовий алфавіт, за яким шукаємо символи при шифруванні
    private static final String ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГҐДЕЄЖЗИІЇЙКЛМНОПРСТУФХЦЧШЩЬЮЯ0123456789";
    // Алфавіт-підстановка: на ці символи замінюються відповідні символи з ALPHABET
    private static final String SUB = "QWERTYUIOPASDFGHJKLZXCVBNMЙЦУКЕНГШЩЗХФІВАПРОЛДЯЧСМИТЬБ0123456789";

    public static String process(String text, String key, boolean encrypt){
        // Результат будемо записувати сюди
        StringBuilder sb = new StringBuilder();

        // Проходимо по кожному символу введеного тексту
        for(char c : text.toUpperCase().toCharArray()){

            // Якщо encrypt = true - беремо індекс у ALPHABET.
            // Якщо encrypt = false - в режимі дешифрування шукаємо індекс у SUB.
            int idx = encrypt ? ALPHABET.indexOf(c) : SUB.indexOf(c);

            // Якщо символ не знайдено в алфавітах (наприклад пробіл, знак, літера інша)
            // просто додаємо його без змін.
            if(idx == -1){
                sb.append(c);
                continue;
            }

            // Якщо шифруємо - беремо символ із SUB під тим самим індексом.
            // Якщо дешифруємо - беремо символ з ALPHABET.
            sb.append(encrypt ? SUB.charAt(idx) : ALPHABET.charAt(idx));
        }

        // Повертаємо зашифрований або розшифрований текст.
        return sb.toString();
    }
}