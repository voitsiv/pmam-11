public class SDesCipher {

    // Субключі K1 та K2 по 8 біт для двох раундів шифрування
    private int[] K1, K2; 

    // Конструктор: приймає 10-бітний ключ у вигляді рядка
    public SDesCipher(String key10) {
        if (key10.length() != 10 || !key10.matches("[01]+")) {
            throw new IllegalArgumentException("Ключ має бути 10-бітним бінарним рядком");
        }
        generateKeys(key10); // Генеруємо субключі K1 та K2
    }

    // Перетворює бінарний рядок у масив int
    private int[] strToBits(String s) {
        int[] bits = new int[s.length()];
        for (int i = 0; i < s.length(); i++) {
            bits[i] = s.charAt(i) - '0';
        }
        return bits;
    }

    // Перетворює масив бітів у рядок
    private String bitsToString(int[] bits) {
        StringBuilder sb = new StringBuilder();
        for (int b : bits) sb.append(b);
        return sb.toString();
    }

    // Генерація субключів K1 та K2 з 10-бітного ключа
    private void generateKeys(String key10) {
        int[] key = strToBits(key10);

        // P10 перестановка
        int[] P10 = {2,4,1,6,3,9,0,8,7,5};
        key = permute(key, P10);

        // Розбиття на ліву та праву половини
        int[] left = new int[5];
        int[] right = new int[5];
        System.arraycopy(key, 0, left, 0, 5);
        System.arraycopy(key, 5, right, 0, 5);

        // Ліва циклічна зміщення на 1 (LS-1)
        left = shift(left, 1);
        right = shift(right, 1);

        int[] combined = new int[10];
        System.arraycopy(left, 0, combined, 0, 5);
        System.arraycopy(right, 0, combined, 5, 5);

        // P8 перестановка для отримання K1
        int[] P8 = {5,2,6,3,7,4,9,8};
        K1 = permute(combined, P8);

        // LS-2 для K2
        left = shift(left, 2);
        right = shift(right, 2);
        System.arraycopy(left, 0, combined, 0, 5);
        System.arraycopy(right, 0, combined, 5, 5);

        // P8 перестановка для отримання K2
        K2 = permute(combined, P8);
    }

    // Загальна функція перестановки
    private int[] permute(int[] input, int[] sequence) {
        int[] output = new int[sequence.length];
        for (int i = 0; i < sequence.length; i++) {
            output[i] = input[sequence[i]];
        }
        return output;
    }

    // Циклічне зміщення масиву бітів
    private int[] shift(int[] bits, int n) {
        int[] res = new int[bits.length];
        for (int i = 0; i < bits.length; i++) {
            res[i] = bits[(i + n) % bits.length];
        }
        return res;
    }

    // Основний шифрувальний раунд FK
    private int[] fk(int[] bits, int[] subkey) {
        int[] left = new int[4];
        int[] right = new int[4];
        System.arraycopy(bits, 0, left, 0, 4);
        System.arraycopy(bits, 4, right, 0, 4);

        // Expansion/permutation EP правої половини
        int[] EP = {3,0,1,2,1,2,3,0};
        int[] rightEP = permute(right, EP);

        // XOR з субключем
        for (int i = 0; i < 8; i++) rightEP[i] ^= subkey[i];

        // Розбиття на дві групи для S-блоків
        int[] left4 = {rightEP[0], rightEP[3], rightEP[4], rightEP[7]};
        int[] right4 = {rightEP[1], rightEP[2], rightEP[5], rightEP[6]};

        // S-блоки S0 і S1
        int[] S0 = sBox(left4, new int[][]{
                {1,0,3,2},
                {3,2,1,0},
                {0,2,1,3},
                {3,1,3,2}
        });

        int[] S1 = sBox(right4, new int[][]{
                {0,1,2,3},
                {2,0,1,3},
                {3,0,1,0},
                {2,1,0,3}
        });

        // Об’єднання виходів S-блоків
        int[] combined = new int[4];
        for (int i = 0; i < 2; i++) combined[i] = S0[i];
        for (int i = 2; i < 4; i++) combined[i] = S1[i-2];

        // P4 перестановка
        int[] P4 = {1,3,2,0};
        combined = permute(combined, P4);

        // XOR з лівою половиною
        for (int i = 0; i < 4; i++) left[i] ^= combined[i];

        // Об'єднання для повернення (L XOR F | R)
        int[] output = new int[8];
        System.arraycopy(left,0,output,0,4);
        System.arraycopy(right,0,output,4,4);
        return output;
    }

    // Функція S-блоку
    private int[] sBox(int[] bits, int[][] box) {
        int row = (bits[0]<<1) | bits[3]; // визначаємо рядок
        int col = (bits[1]<<1) | bits[2]; // визначаємо стовпчик
        int val = box[row][col]; // отримуємо значення з таблиці
        return new int[]{(val>>1)&1, val&1}; // перетворюємо у 2 біти
    }

    // Обмін лівої та правої половини
    private int[] switchHalves(int[] bits) {
        int[] res = new int[bits.length];
        System.arraycopy(bits,4,res,0,4);
        System.arraycopy(bits,0,res,4,4);
        return res;
    }

    // Шифрування 8-бітного блоку
    public int[] encryptBlock(int[] block) {
        int[] IP = {1,5,2,0,3,7,4,6}; // початкова перестановка
        int[] IP_inv = {3,0,2,4,6,1,7,5}; // обернена перестановка

        block = permute(block, IP);
        block = fk(block, K1); // перший раунд з K1
        block = switchHalves(block); // обмін половин
        block = fk(block, K2); // другий раунд з K2
        block = permute(block, IP_inv); // обернена перестановка
        return block;
    }

    // Дешифрування 8-бітного блоку
    public int[] decryptBlock(int[] block) {
        int[] IP = {1,5,2,0,3,7,4,6};
        int[] IP_inv = {3,0,2,4,6,1,7,5};

        block = permute(block, IP);
        block = fk(block, K2); // перший раунд з K2
        block = switchHalves(block); 
        block = fk(block, K1); // другий раунд з K1
        block = permute(block, IP_inv);
        return block;
    }

    // Перетворення символу в масив з 8 бітів
    private int[] charToBits(char c) {
        int[] bits = new int[8];
        int val = c;
        for (int i = 7; i >=0; i--) {
            bits[i] = val & 1;
            val >>=1;
        }
        return bits;
    }

    // Перетворення масиву бітів у символ
    private char bitsToChar(int[] bits) {
        int val = 0;
        for (int i = 0; i < 8; i++) {
            val = (val << 1) | bits[i];
        }
        return (char)val;
    }

    // Шифрування рядка
    public String encrypt(String plaintext) {
        StringBuilder sb = new StringBuilder();
        for (char c: plaintext.toCharArray()) {
            int[] bits = charToBits(c);
            int[] enc = encryptBlock(bits);
            sb.append(bitsToChar(enc)); // додаємо зашифрований символ
        }
        return sb.toString();
    }

    // Дешифрування рядка
    public String decrypt(String ciphertext) {
        StringBuilder sb = new StringBuilder();
        for (char c: ciphertext.toCharArray()) {
            int[] bits = charToBits(c);
            int[] dec = decryptBlock(bits);
            sb.append(bitsToChar(dec)); // додаємо розшифрований символ
        }
        return sb.toString();
    }
}