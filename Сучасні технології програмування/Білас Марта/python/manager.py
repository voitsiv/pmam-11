# manager.py
from task import Task

class TaskManager:
    def __init__(self):
        self.tasks = []

    def add_task(self, task: Task):
        self.tasks.append(task)

    def remove_task(self, index: int):
        if 0 <= index < len(self.tasks):
            del self.tasks[index]

    def get_all_tasks(self):
        return self.tasks

    def get_done_tasks(self):
        return [t for t in self.tasks if t.done]

    def get_pending_tasks(self):
        return [t for t in self.tasks if not t.done]
