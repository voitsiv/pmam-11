# ui.py
import tkinter as tk
from tkinter import ttk, messagebox
from task import Task
from manager import TaskManager


class TodoUI:
    def __init__(self, root):
        self.root = root
        self.root.title("To-Do List")
        self.manager = TaskManager()
        self.setup_ui()

    def setup_ui(self):
        style = ttk.Style()
        style.theme_use('clam')
        style.configure("TNotebook.Tab", padding=[12, 8], font=("Helvetica", 12, "bold"))
        style.configure("TButton", padding=5, font=("Helvetica", 10))

        self.tab_control = ttk.Notebook(self.root)

        # Вкладки
        self.tab_all = ttk.Frame(self.tab_control)
        self.tab_pending = ttk.Frame(self.tab_control)
        self.tab_done = ttk.Frame(self.tab_control)

        self.tab_control.add(self.tab_all, text="All Tasks")
        self.tab_control.add(self.tab_pending, text="Pending")
        self.tab_control.add(self.tab_done, text="Done")
        self.tab_control.pack(expand=1, fill="both", padx=10, pady=10)

        # Списки задач з рамкою
        self.list_all = tk.Listbox(self.tab_all, font=("Helvetica", 12), activestyle='dotbox', selectmode=tk.MULTIPLE)
        self.list_pending = tk.Listbox(self.tab_pending, font=("Helvetica", 12), activestyle='dotbox', selectmode=tk.MULTIPLE)
        self.list_done = tk.Listbox(self.tab_done, font=("Helvetica", 12), activestyle='dotbox', selectmode=tk.MULTIPLE)

        for lst in [self.list_all, self.list_pending, self.list_done]:
            lst.pack(fill="both", expand=True, padx=10, pady=10)
            lst.config(bg="#f0f0f0", selectbackground="#6fa8dc", relief=tk.GROOVE, bd=2)

        # Додати задачу
        frame_add = tk.Frame(self.root)
        frame_add.pack(fill="x", padx=10, pady=5)

        self.entry_task = tk.Entry(frame_add, font=("Helvetica", 12))
        self.entry_task.pack(side=tk.LEFT, fill="x", expand=True, padx=(0, 5))

        self.btn_add = tk.Button(frame_add, text="Add Task", command=self.add_task, bg="#6fa8dc", fg="white")
        self.btn_add.pack(side=tk.RIGHT)

        # Кнопки для видалення, позначення та експорту
        frame_actions = tk.Frame(self.root)
        frame_actions.pack(fill="x", padx=10, pady=5)

        self.btn_done = tk.Button(frame_actions, text="Mark Done", command=self.mark_done, bg="#93c47d", fg="white")
        self.btn_done.pack(side=tk.LEFT, expand=True, fill="x", padx=5)

        self.btn_delete = tk.Button(frame_actions, text="Delete Task", command=self.delete_task, bg="#e06666", fg="white")
        self.btn_delete.pack(side=tk.LEFT, expand=True, fill="x", padx=5)

        self.btn_export_done = tk.Button(frame_actions, text="Export Done Tasks", command=self.export_done, bg="#f1c232", fg="white")
        self.btn_export_done.pack(side=tk.LEFT, expand=True, fill="x", padx=5)

        self.btn_export_pending = tk.Button(frame_actions, text="Export Pending Tasks", command=self.export_pending, bg="#6fa8dc", fg="white")
        self.btn_export_pending.pack(side=tk.LEFT, expand=True, fill="x", padx=5)

    def add_task(self):
        title = self.entry_task.get().strip()
        if title:
            task = Task(title)
            self.manager.add_task(task)
            self.entry_task.delete(0, tk.END)
            self.refresh_lists()
        else:
            messagebox.showwarning("Warning", "Task cannot be empty!")

    def mark_done(self):
        indices = self.list_all.curselection()
        for index in indices:
            task = self.manager.get_all_tasks()[index]
            task.mark_done()
        self.refresh_lists()

    def delete_task(self):
        indices = list(self.list_all.curselection())
        for index in reversed(indices):
            self.manager.remove_task(index)
        self.refresh_lists()

    def export_done(self):
        done_tasks = self.manager.get_done_tasks()
        if not done_tasks:
            messagebox.showinfo("Info", "No done tasks to export!")
            return
        try:
            with open("done_tasks.txt", "w", encoding="utf-8") as f:
                for task in done_tasks:
                    f.write(f"{task.title}\n")
            messagebox.showinfo("Success", f"Exported {len(done_tasks)} done tasks to done_tasks.txt")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to export tasks: {str(e)}")

    def export_pending(self):
        pending_tasks = self.manager.get_pending_tasks()
        if not pending_tasks:
            messagebox.showinfo("Info", "No pending tasks to export!")
            return
        try:
            with open("pending_tasks.txt", "w", encoding="utf-8") as f:
                for task in pending_tasks:
                    f.write(f"{task.title}\n")
            messagebox.showinfo("Success", f"Exported {len(pending_tasks)} pending tasks to pending_tasks.txt")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to export tasks: {str(e)}")

    def refresh_lists(self):
        self.list_all.delete(0, tk.END)
        self.list_pending.delete(0, tk.END)
        self.list_done.delete(0, tk.END)
        for t in self.manager.get_all_tasks():
            self.list_all.insert(tk.END, str(t))
        for t in self.manager.get_pending_tasks():
            self.list_pending.insert(tk.END, str(t))
        for t in self.manager.get_done_tasks():
            self.list_done.insert(tk.END, str(t))


if __name__ == "__main__":
    root = tk.Tk()
    app = TodoUI(root)
    root.mainloop()
