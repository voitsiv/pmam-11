import java.io.*;
import java.util.*;

public class Main {
    static String file = "tasks.txt";
    static List<String> tasks = new ArrayList<>();

    public static void main(String[] args) throws Exception {
        load();
        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.println("\n1) show\n2) add\n3) done\n4) delete\n5) exit");
            System.out.print("choice: ");
            String c = sc.nextLine();

            if (c.equals("1")) show();
            else if (c.equals("2")) {
                System.out.print("task: ");
                tasks.add(sc.nextLine());
                save();
            } else if (c.equals("3")) {
                System.out.print("number: ");
                int i = Integer.parseInt(sc.nextLine());
                if (i > 0 && i <= tasks.size()) {
                    tasks.set(i-1, tasks.get(i-1) + " [done]");
                    save();
                }
            } else if (c.equals("4")) {
                System.out.print("number: ");
                int i = Integer.parseInt(sc.nextLine());
                if (i > 0 && i <= tasks.size()) {
                    tasks.remove(i-1);
                    save();
                }
            } else if (c.equals("5")) break;
        }
    }

    static void show() {
        if (tasks.isEmpty()) System.out.println("empty");
        for (int i = 0; i < tasks.size(); i++)
            System.out.println((i+1) + ") " + tasks.get(i));
    }

    static void load() throws Exception {
        File f = new File(file);
        if (!f.exists()) return;
        BufferedReader br = new BufferedReader(new FileReader(f));
        String line;
        while ((line = br.readLine()) != null) tasks.add(line);
        br.close();
    }

    static void save() throws Exception {
        PrintWriter pw = new PrintWriter(new FileWriter(file));
        for (String t : tasks) pw.println(t);
        pw.close();
    }
}
