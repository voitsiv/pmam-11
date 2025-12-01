# main.py
import tkinter as tk
from ui import TodoUI

if __name__ == "__main__":
    root = tk.Tk()
    app = TodoUI(root)
    root.geometry("400x400")
    root.mainloop()
