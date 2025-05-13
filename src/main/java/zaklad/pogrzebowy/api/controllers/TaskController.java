package zaklad.pogrzebowy.api.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import zaklad.pogrzebowy.api.models.Task;
import zaklad.pogrzebowy.api.services.TaskService;
import zaklad.pogrzebowy.api.services.LogService;
import zaklad.pogrzebowy.api.dto.TaskDTO;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/tasks")
@CrossOrigin(origins = "*")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @Autowired
    private LogService logService;

    // Istniejące metody...

    @PostMapping
    public ResponseEntity<TaskDTO> createTask(@RequestBody TaskDTO taskDTO) {
        try {
            Task task = taskDTO.toEntity();
            Task savedTask = taskService.create(task);

            // Log zostanie utworzony w serwisie, ale możemy też tu dodać
            logService.createLog(
                    "CREATE",
                    "Task",
                    savedTask.getId(),
                    "Task created via API: " + savedTask.getTaskName()
            );

            return ResponseEntity
                    .status(HttpStatus.CREATED)
                    .body(new TaskDTO(savedTask));
        } catch (Exception e) {
            logService.createLog(
                    "ERROR",
                    "Task",
                    null,
                    "Error creating task: " + e.getMessage()
            );

            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .build();
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<TaskDTO> updateTask(@PathVariable Long id, @RequestBody TaskDTO taskDTO) {
        try {
            Task taskToUpdate = taskDTO.toEntity();
            taskToUpdate.setId(id);
            Task updatedTask = taskService.update(id, taskToUpdate);

            logService.createLog(
                    "UPDATE",
                    "Task",
                    updatedTask.getId(),
                    "Task updated via API: " + updatedTask.getTaskName()
            );

            return ResponseEntity.ok(new TaskDTO(updatedTask));
        } catch (Exception e) {
            logService.createLog(
                    "ERROR",
                    "Task",
                    id,
                    "Error updating task: " + e.getMessage()
            );

            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTask(@PathVariable Long id) {
        try {
            // Pobierz nazwę zadania przed usunięciem, aby dołączyć do logu
            Task task = taskService.findById(id).orElse(null);
            String taskName = task != null ? task.getTaskName() : "Unknown";

            taskService.delete(id);

            logService.createLog(
                    "DELETE",
                    "Task",
                    id,
                    "Task deleted via API: " + taskName
            );

            return ResponseEntity
                    .noContent()
                    .build();
        } catch (Exception e) {
            logService.createLog(
                    "ERROR",
                    "Task",
                    id,
                    "Error deleting task: " + e.getMessage()
            );

            return ResponseEntity
                    .notFound()
                    .build();
        }
    }
}