package com.devops.task_flow.Service;

import com.devops.task_flow.Model.Task;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class TaskService {

    private final ConcurrentHashMap<Long, Task> store = new ConcurrentHashMap<>(); // in-memory
    private long seq = 0;

    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>(store.values());
        tasks.sort(Comparator.comparing(Task::getId));
        return tasks;
    }

    public Optional<Task> getTask(Long id) {
        return Optional.ofNullable(store.get(id));
    }

    public Task createTask(String title) {
        long id = ++seq;
        Task task = new Task(id, title, false);
        store.put(id, task);
        return task;
    }

    public Optional<Task> updateTask(Long id, String title, Boolean completed) {
        Task task = store.get(id);
        if (task == null) return Optional.empty();

        if (title != null) task.setTitle(title);
        if (completed != null) task.setCompleted(completed);

        store.put(id, task);
        return Optional.of(task);
    }

    public boolean delete(Long id) {
        return store.remove(id) != null;
    }
}
