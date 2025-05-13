package zaklad.pogrzebowy.api.dto;

import zaklad.pogrzebowy.api.models.Log;
import java.time.LocalDateTime;

public class LogDTO {
    private Long id;
    private String action;
    private String entityType;
    private Long entityId;
    private String details;
    private LocalDateTime timestamp;
    private UserDTO user;

    public LogDTO() {}

    public LogDTO(Log log) {
        this.id = log.getId();
        this.action = log.getAction();
        this.entityType = log.getEntityType();
        this.entityId = log.getEntityId();
        this.details = log.getDetails();
        this.timestamp = log.getTimestamp();
        if (log.getUser() != null) {
            this.user = new UserDTO(log.getUser());
        }
    }

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public Long getEntityId() {
        return entityId;
    }

    public void setEntityId(Long entityId) {
        this.entityId = entityId;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public UserDTO getUser() {
        return user;
    }

    public void setUser(UserDTO user) {
        this.user = user;
    }
}