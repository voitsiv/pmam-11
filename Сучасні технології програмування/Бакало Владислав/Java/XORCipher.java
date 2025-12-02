public class XORCipher {
    // Метод виконує XOR-шифрування або розшифрування (процес однаковий)
    public static String process(String text, String key, boolean encrypt){
        // Якщо ключ не задано - використати стандартний
        if(key==null || key.isEmpty()) key="KEY";
        // Перетворення ключа в масив символів
        char[] k = key.toCharArray();
        // Текст також переводимо у масив символів
        char[] t = text.toCharArray();
        // Масив для результату
        char[] res = new char[t.length];
        // Проходимо по кожному символу тексту
        for(int i=0;i<t.length;i++){
            // XOR між символом тексту і символом ключа (циклічним)
            res[i] = (char)(t[i] ^ k[i % k.length]);
        }
        // Повертаємо результат у вигляді рядка
        return new String(res);
    }
}