import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;


class Student {
    private String name;
    private String id;
    private List<Integer> grades;

    public Student(String name, String id) {
        this.name = name;
        this.id = id;
        this.grades = new ArrayList<>();
    }

    public void addGrade(int grade) {
        if (grade >= 0 && grade <= 100) {
            grades.add(grade);
            System.out.println("Оцінка " + grade + " додана для " + name);
        } else {
            System.out.println("Помилка: Оцінка має бути від 0 до 100.");
        }
    }

    public double getAverageGrade() {
        if (grades.isEmpty()) return 0.0;
        return grades.stream().mapToInt(Integer::intValue).average().orElse(0.0);
    }

    public String getId() { return id; }
    public String getName() { return name; }

    @Override
    public String toString() {
        return String.format("ID: %-5s | Студент: %-15s | Середній бал: %.2f | Оцінки: %s",
                id, name, getAverageGrade(), grades.toString());
    }
}


public class GradeSystem {
    private static List<Student> students = new ArrayList<>();
    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        System.out.println("--- СИСТЕМА УПРАВЛІННЯ ОЦІНКАМИ (JAVA) ---");

        while (true) {
            printMenu();
            String choice = scanner.nextLine();

            switch (choice) {
                case "1":
                    addNewStudent();
                    break;
                case "2":
                    addGradeToStudent();
                    break;
                case "3":
                    showAllStudents();
                    break;
                case "4":
                    System.out.println("Вихід з програми...");
                    return;
                default:
                    System.out.println("Невідома команда, спробуйте ще раз.");
            }
        }
    }

    private static void printMenu() {
        System.out.println("\n1. Додати студента");
        System.out.println("2. Додати оцінку студенту");
        System.out.println("3. Показати рейтинг групи");
        System.out.println("4. Вихід");
        System.out.print("Ваш вибір: ");
    }

    private static void addNewStudent() {
        System.out.print("Введіть ім'я студента: ");
        String name = scanner.nextLine();
        System.out.print("Введіть ID (номер заліковки): ");
        String id = scanner.nextLine();

        boolean exists = students.stream().anyMatch(s -> s.getId().equals(id));
        if (exists) {
            System.out.println("Помилка: Студент з таким ID вже існує!");
            return;
        }

        students.add(new Student(name, id));
        System.out.println("Студента успішно додано.");
    }

    private static void addGradeToStudent() {
        if (students.isEmpty()) {
            System.out.println("Список студентів порожній.");
            return;
        }

        System.out.print("Введіть ID студента: ");
        String id = scanner.nextLine();

        Student student = students.stream()
                .filter(s -> s.getId().equals(id))
                .findFirst()
                .orElse(null);

        if (student == null) {
            System.out.println("Студента з таким ID не знайдено.");
            return;
        }

        System.out.print("Введіть оцінку (0-100): ");
        try {
            int grade = Integer.parseInt(scanner.nextLine());
            student.addGrade(grade);
        } catch (NumberFormatException e) {
            System.out.println("Помилка: Введіть ціле число!");
        }
    }

    private static void showAllStudents() {
        if (students.isEmpty()) {
            System.out.println("Список порожній.");
            return;
        }
        
        System.out.println("\n--- РЕЙТИНГ ГРУПИ ---");
        students.stream()
                .sorted((s1, s2) -> Double.compare(s2.getAverageGrade(), s1.getAverageGrade()))
                .forEach(System.out::println);
    }
}
