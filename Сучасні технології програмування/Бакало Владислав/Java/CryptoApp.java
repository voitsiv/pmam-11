import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.io.File;
import java.io.IOException;

public class CryptoApp extends JFrame {

    // Основні UI елементи
    private JTextArea textArea;        // Поле для введення/виведення тексту
    private JTextField keyField;       // Поле для ключа
    private final JComboBox<String> cipherBox;   // Вибір шифру
    private final JLabel hintLabel;              // Підказка для ключа
    private final JLabel cipherInfoLabel;        // Коротка інформація про шифр
    private final JLabel infoLabel;              // Верхній опис додатку

    // Конструктор додатку (створення інтерфейсу)
    public CryptoApp() {

        // Основні параметри вікна
        setTitle("CryptoApp - Шифрування та дешифрування тексту");
        setSize(850, 700);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        // Головна панель для всіх компонентів
        JPanel mainPanel = new JPanel(new BorderLayout(10, 10));
        mainPanel.setBorder(new EmptyBorder(15, 15, 15, 15));
        mainPanel.setBackground(new Color(245, 245, 250));

        // Верхня панель з інформацією про програму
        JPanel topPanel = new JPanel(new BorderLayout(5, 5));
        topPanel.setBackground(new Color(245, 245, 250));

        // Опис програми (HTML текст)
        infoLabel = new JLabel("<html><center><b>CryptoApp</b> - додаток для шифрування та дешифрування тексту.<br>" +
                "Виберіть алгоритм шифрування, введіть ключ, якщо потрібно, та текст для обробки (у вікні або з файлу).<br>" +
                "Підтримуються українські й англійські літери, цифри та пробіли.</center></html>",
                SwingConstants.CENTER);
        infoLabel.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        infoLabel.setForeground(Color.DARK_GRAY);
        infoLabel.setBorder(new EmptyBorder(10, 5, 10, 5));
        topPanel.add(infoLabel, BorderLayout.NORTH);

        // Панель вибору шифру та введення ключа (2 рядки)
        JPanel selectionPanel = new JPanel(new GridBagLayout());
        selectionPanel.setBackground(new Color(245, 245, 250));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 10, 5, 10);
        gbc.anchor = GridBagConstraints.WEST;

        // Рядок 1: напис "Виберіть шифр"
        gbc.gridx = 0; gbc.gridy = 0;
        selectionPanel.add(new JLabel("Виберіть шифр:"), gbc);

        // Випадаючий список із шифрами
        gbc.gridx = 1;
        cipherBox = new JComboBox<>(new String[]{
                "Шифр Цезаря", "XOR", "Шифр Віженера",
                "Шифр підстановки", "Шифр Плейфера", "S-DES", "Атбаш"
        });

        // Оновлюємо підказку для ключа та інформацію про шифр при зміні вибору
        cipherBox.addActionListener(e -> {
            updateKeyHint();
            updateCipherInfo();
        });
        selectionPanel.add(cipherBox, gbc);

        // Напис "Ключ:"
        gbc.gridx = 2;
        selectionPanel.add(new JLabel("Ключ:"), gbc);

        // Поле введення ключа
        gbc.gridx = 3;
        keyField = new JTextField(15);
        selectionPanel.add(keyField, gbc);

        // Підказка щодо типу ключа
        gbc.gridx = 3; gbc.gridy = 1;
        gbc.anchor = GridBagConstraints.NORTHWEST;
        hintLabel = new JLabel(" ");
        hintLabel.setForeground(new Color(0, 102, 204));
        hintLabel.setFont(hintLabel.getFont().deriveFont(Font.ITALIC, 12f));
        selectionPanel.add(hintLabel, gbc);

        // Коротка інформація про шифр
        gbc.gridx = 1; gbc.gridy = 1;
        cipherInfoLabel = new JLabel(" ");
        cipherInfoLabel.setForeground(new Color(0, 102, 204));
        cipherInfoLabel.setFont(cipherInfoLabel.getFont().deriveFont(Font.ITALIC, 12f));
        selectionPanel.add(cipherInfoLabel, gbc);
        topPanel.add(selectionPanel, BorderLayout.CENTER);

        // Оновлення полів при старті
        updateKeyHint();
        updateCipherInfo();
        mainPanel.add(topPanel, BorderLayout.NORTH);

        // Центральна текстова зона для вводу/виводу тексту
        textArea = new JTextArea();
        textArea.setLineWrap(true);
        textArea.setWrapStyleWord(true);
        mainPanel.add(new JScrollPane(textArea), BorderLayout.CENTER);

        // Нижня панель з кнопками
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 15, 10));
        buttonPanel.setBackground(new Color(245, 245, 250));

        // Створення градієнтних кнопок
        JButton encryptBtn = createGradientButton("Зашифрувати",
                new Color(70, 130, 255), new Color(85, 145, 255),
                this::encryptText);

        JButton decryptBtn = createGradientButton("Розшифрувати",
                new Color(50, 160, 70), new Color(65, 180, 90),
                this::decryptText);

        JButton loadBtn = createGradientButton("Завантажити файл",
                new Color(255, 165, 0), new Color(255, 180, 30),
                e -> loadFile());

        JButton saveBtn = createGradientButton("Зберегти у файл",
                new Color(128, 0, 255), new Color(160, 0, 255),
                e -> saveFile());

        JButton clearBtn = createGradientButton("Очистити",
                new Color(220, 53, 69), new Color(235, 70, 90),
                e -> { textArea.setText(""); keyField.setText(""); });

        // Додавання кнопок у панель
        buttonPanel.add(encryptBtn);
        buttonPanel.add(decryptBtn);
        buttonPanel.add(loadBtn);
        buttonPanel.add(saveBtn);
        buttonPanel.add(clearBtn);
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);

        // Додавання основної панелі у вікно
        add(mainPanel);
    }

    // Оновлюємо підказку про ключ при виборі іншого шифру
    private void updateKeyHint() {
        String cipher = (String) cipherBox.getSelectedItem();
        String hint = switch (cipher) {
            case "Шифр Цезаря" -> "Введіть ціле число";
            case "XOR" -> "Введіть текстовий ключ";
            case "Шифр Віженера" -> "Введіть слово";
            case "Шифр підстановки" -> "Ключ не потрібен";
            case "Шифр Плейфера" -> "Введіть слово";
            case "Атбаш" -> "Ключ не потрібен";
            case "S-DES" -> "Введіть 10 біт (наприклад 1010000010)";
            default -> "";
        };
        hintLabel.setText(hint);
    }

    // Показуємо коротку інформацію про вибраний шифр
    private void updateCipherInfo() {
        String cipher = (String) cipherBox.getSelectedItem();
        String info = switch (cipher) {
            case "Шифр Цезаря" -> "Зсуває кожну літеру на певну кількість.";
            case "XOR" -> "Використовує побітову операцію XOR.";
            case "Шифр Віженера" -> "Працює з повторюваним текстовим ключем.";
            case "Шифр підстановки" -> "Замінює літери за фіксованою таблицею.";
            case "Шифр Плейфера" -> "Шифрує текст парами літер.";
            case "Атбаш" -> "Віддзеркалює алфавіт.";
            case "S-DES" -> "Спрощений варіант DES із 10-бітним ключем.";
            default -> "";
        };
        cipherInfoLabel.setText(info);
    }

    // Обробка кнопок шифрування
    private void encryptText(ActionEvent e) { process(true); }

    // Обробка кнопок дешифрування
    private void decryptText(ActionEvent e) { process(false); }

    // Основна функція шифрування/дешифрування
    private void process(boolean encrypt) {
        String text = textArea.getText().trim();
        String key = keyField.getText().trim();
        String cipher = (String) cipherBox.getSelectedItem();
        try {
            // Перевірки ключа для кожного шифру
            switch (cipher) {
                case "Шифр Цезаря" -> {
                    if (!key.matches("\\d+")) {
                        JOptionPane.showMessageDialog(this, "Ключ повинен бути числом.");
                        return;
                    }
                }
                case "XOR", "Шифр Віженера", "Шифр Плейфера" -> {
                    if (key.isEmpty()) {
                        JOptionPane.showMessageDialog(this, "Ключ не може бути порожнім.");
                        return;
                    }
                }
                case "S-DES" -> {
                    if (!key.matches("[01]{10}")) {
                        JOptionPane.showMessageDialog(this, "Ключ S-DES повинен бути 10-бітним.");
                        return;
                    }
                }
                case "Шифр підстановки", "Атбаш" -> key = "";
            }

            // Виконання вибраного шифру
            String result = switch (cipher) {
                case "Шифр Цезаря" -> CaesarCipher.process(text, key, encrypt);
                case "XOR" -> XORCipher.process(text, key, encrypt);
                case "Шифр Віженера" -> VigenereCipher.process(text, key, encrypt);
                case "Шифр підстановки" -> SubstitutionCipher.process(text, key, encrypt);
                case "Шифр Плейфера" -> PlayfairCipher.process(text, key, encrypt);
                case "Атбаш" -> AtbashCipher.process(text);
                case "S-DES" -> {
                    SDesCipher sdes = new SDesCipher(key);
                    yield encrypt ? sdes.encrypt(text) : sdes.decrypt(text);
                }
                default -> text;
            };

            // Виводимо результат у текстову зону
            textArea.setText(result);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Помилка: " + ex.getMessage());
        }
    }

    // Завантаження тексту з файлу
    private void loadFile() {
        JFileChooser chooser = new JFileChooser();
        if (chooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            File f = chooser.getSelectedFile();
            try {
                textArea.setText(new String(java.nio.file.Files.readAllBytes(f.toPath())));
            } catch (IOException ex) {
                JOptionPane.showMessageDialog(this, "Не вдалося завантажити: " + ex.getMessage());
            }
        }
    }

    // Збереження тексту у файл
    private void saveFile() {
        JFileChooser chooser = new JFileChooser();
        if (chooser.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
            File file = chooser.getSelectedFile();
            if (!file.getName().toLowerCase().endsWith(".txt")) {
                file = new File(file.getAbsolutePath() + ".txt");
            }
            try {
                java.nio.file.Files.write(file.toPath(), textArea.getText().getBytes());
                JOptionPane.showMessageDialog(this, "Файл збережено:\n" + file.getName());
            } catch (IOException ex) {
                JOptionPane.showMessageDialog(this, "Помилка збереження: " + ex.getMessage());
            }
        }
    }

    // Створення градієнтних кнопок з кастомним малюванням
    private JButton createGradientButton(String text, Color start, Color end, java.awt.event.ActionListener action) {
        JButton btn = new JButton(text) {
            @Override
            protected void paintComponent(Graphics g) {

                Graphics2D g2 = (Graphics2D) g.create();
                g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

                // Градієнт фону кнопки
                GradientPaint gp = new GradientPaint(0, 0, start, 0, getHeight(), end);
                g2.setPaint(gp);
                g2.fillRoundRect(0, 0, getWidth(), getHeight(), 20, 20);

                // Налаштування тексту
                Font font = new Font("Segoe UI Semibold", Font.BOLD, 14);
                g2.setFont(font);
                FontMetrics fm = g2.getFontMetrics();
                int x = (getWidth() - fm.stringWidth(getText())) / 2;
                int y = (getHeight() + fm.getAscent() - fm.getDescent()) / 2;

                g2.setColor(Color.WHITE);
                g2.drawString(getText(), x, y);
                g2.dispose();
            }
        };

        btn.setContentAreaFilled(false);
        btn.setFocusPainted(false);
        btn.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        btn.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 20));
        btn.addActionListener(action);
        return btn;
    }

      // Точка входу - запуск програми
       public static void main(String[] args) {

        // Підключення стилю FlatLaf
        try {
            UIManager.setLookAndFeel(new com.formdev.flatlaf.FlatIntelliJLaf());
            UIManager.put("Button.arc", 12);
            UIManager.put("Component.arc", 12);
            UIManager.put("TextComponent.arc", 12);
        } catch (UnsupportedLookAndFeelException ignored) {}
        SwingUtilities.invokeLater(() -> new CryptoApp().setVisible(true));
    }
}