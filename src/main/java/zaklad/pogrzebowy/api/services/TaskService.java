package zaklad.pogrzebowy.api.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import zaklad.pogrzebowy.api.models.Task;
import zaklad.pogrzebowy.api.models.Order;
import zaklad.pogrzebowy.api.models.User;
import zaklad.pogrzebowy.api.models.TaskAssignment;
import zaklad.pogrzebowy.api.repositories.TaskRepository;
import zaklad.pogrzebowy.api.repositories.OrderRepository;
import zaklad.pogrzebowy.api.repositories.UserRepository;
import zaklad.pogrzebowy.api.repositories.TaskAssignmentRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;


@Service
public class TaskService implements ITaskService {

    @Autowired
    private TaskRepository taskRepository;
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private TaskAssignmentRepository taskAssignmentRepository;

    @Autowired
    private LogService logService;

    @Override
    public List<Task> findAll() {
        return taskRepository.findAll();
    }

    @Override
    public Optional<Task> findById(Long id) {
        return taskRepository.findById(id);
    }

    @Override
    public List<Task> findByStatus(Task.Status status) {
        return taskRepository.findByStatus(status);
    }

    @Override
    public Task create(Task task) {
        try {
            // Create a new Task entity
            Task newTask = new Task();
            newTask.setTaskName(task.getTaskName());
            newTask.setDescription(task.getDescription());
            newTask.setDueDate(task.getDueDate());
            newTask.setPriority(task.getPriority());
            newTask.setStatus(task.getStatus());
    
            // Handle order association
            if (task.getOrder() != null && task.getOrder().getId() != null) {
                Order order = orderRepository.findById(task.getOrder().getId())
                    .orElseThrow(() -> new RuntimeException("Order not found with id: " + task.getOrder().getId()));
                newTask.setOrder(order);
                System.out.println("Setting order: " + order.getId());
            }
    
            // Handle user assignment
            if (task.getAssignedUser() != null && task.getAssignedUser().getId() != null) {
                User user = userRepository.findById(task.getAssignedUser().getId())
                    .orElseThrow(() -> new RuntimeException("User not found with id: " + task.getAssignedUser().getId()));
                newTask.setAssignedUser(user);
                System.out.println("Setting user: " + user.getId());
            }
    
            // Save the task only once after setting all relationships
            Task savedTask = taskRepository.save(newTask);

            //log
            try {
                StringBuilder details = new StringBuilder();
                details.append("Created task: ").append(savedTask.getTaskName());
                details.append(", Priority: ").append(savedTask.getPriority());
                details.append(", Status: ").append(savedTask.getStatus());

                if (savedTask.getOrder() != null) {
                    details.append(", Order ID: ").append(savedTask.getOrder().getId());
                }

                if (savedTask.getAssignedUser() != null) {
                    details.append(", Assigned to: ")
                            .append(savedTask.getAssignedUser().getFirstName())
                            .append(" ")
                            .append(savedTask.getAssignedUser().getLastName());
                }

                logService.createLog("CREATE", "Task", savedTask.getId(), details.toString());
                System.out.println("Log created for task: " + savedTask.getId());
            } catch (Exception logError) {
                System.out.println("Error creating log: " + logError.getMessage());
                logError.printStackTrace();
            }

            System.out.println("Saved task ID: " + savedTask.getId());
            System.out.println("Saved task order ID: " + (savedTask.getOrder() != null ? savedTask.getOrder().getId() : "null"));
            System.out.println("Saved task user ID: " + (savedTask.getAssignedUser() != null ? savedTask.getAssignedUser().getId() : "null"));
    
            // Create task assignment if user is assigned
            if (savedTask.getAssignedUser() != null) {
                TaskAssignment assignment = new TaskAssignment();
                assignment.setTask(savedTask);
                assignment.setUser(savedTask.getAssignedUser());
                assignment.setAssignedAt(LocalDateTime.now());
                
                TaskAssignment savedAssignment = taskAssignmentRepository.save(assignment);
                System.out.println("Saved task assignment ID: " + savedAssignment.getId());
            }
    
            return savedTask; // Return the task without saving it again
        } catch (Exception e) {
            System.out.println("Error creating task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Error creating task: " + e.getMessage(), e);
        }

    }

    @Override
    public Task update(Long id, Task task) {
        return taskRepository.findById(id)
            .map(existingTask -> {
                existingTask.setTaskName(task.getTaskName());
                existingTask.setDescription(task.getDescription());
                existingTask.setDueDate(task.getDueDate());
                existingTask.setPriority(task.getPriority());
                existingTask.setStatus(task.getStatus());

                // Handle order update
                if (task.getOrder() != null && task.getOrder().getId() != null) {
                    Order order = orderRepository.findById(task.getOrder().getId())
                        .orElseThrow(() -> new RuntimeException("Order not found"));
                    existingTask.setOrder(order);
                } else {
                    existingTask.setOrder(null);
                }

                // Handle user assignment update
                if (task.getAssignedUser() != null && task.getAssignedUser().getId() != null) {
                    User user = userRepository.findById(task.getAssignedUser().getId())
                        .orElseThrow(() -> new RuntimeException("User not found"));
                    
                    existingTask.setAssignedUser(user);
                    
                    // Update task assignment
                    taskAssignmentRepository.deleteAllByTaskId(existingTask.getId());
                    TaskAssignment assignment = new TaskAssignment();
                    assignment.setTask(existingTask);
                    assignment.setUser(user);
                    assignment.setAssignedAt(LocalDateTime.now());
                    taskAssignmentRepository.save(assignment);
                } else {
                    existingTask.setAssignedUser(null);
                    taskAssignmentRepository.deleteAllByTaskId(existingTask.getId());
                }

                return taskRepository.save(existingTask);
            })
            .orElseThrow(() -> new RuntimeException("Task not found"));
    }

    @Override
    public void delete(Long id) {
        Task task = taskRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Task not found"));

        // Clear the assigned user reference
        if (task.getAssignedUser() != null) {
            task.setAssignedUser(null);
            taskRepository.save(task);
        }

        // Clear the order reference if exists
        if (task.getOrder() != null) {
            task.setOrder(null);
            taskRepository.save(task);
        }

        taskRepository.deleteById(id);
    }
}