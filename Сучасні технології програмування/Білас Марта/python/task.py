# task.py
class Task:
    def __init__(self, title, description="", done=False):
        self.title = title
        self.description = description
        self.done = done

    def mark_done(self):
        self.done = True

    def mark_undone(self):
        self.done = False

    def __str__(self):
        status = "✔" if self.done else "✘"
        return f"{status} {self.title}"
