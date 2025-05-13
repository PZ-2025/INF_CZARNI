package zaklad.pogrzebowy.api.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import zaklad.pogrzebowy.api.models.Log;
import zaklad.pogrzebowy.api.models.User;
import zaklad.pogrzebowy.api.repositories.LogRepository;
import zaklad.pogrzebowy.api.repositories.UserRepository;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class LogService {

    @Autowired
    private LogRepository logRepository;

    @Autowired
    private UserRepository userRepository;

    public Log createLog(String action, String entityType, Long entityId, String details) {
        Log log = new Log();
        log.setAction(action);
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setDetails(details);
        log.setTimestamp(LocalDateTime.now());

        // Pobierz zalogowanego użytkownika
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getName() != null) {
            String username = authentication.getName();
            User user = userRepository.findByUsername(username).orElse(null);
            log.setUser(user);
        }

        return logRepository.save(log);
    }

    public List<Log> getRecentLogs() {
        return logRepository.findTop50ByOrderByTimestampDesc();
    }

    public List<Log> getLogsByEntityType(String entityType) {
        return logRepository.findByEntityTypeOrderByTimestampDesc(entityType);
    }

    public List<Log> getLogsByEntityTypeAndId(String entityType, Long entityId) {
        return logRepository.findByEntityTypeAndEntityIdOrderByTimestampDesc(entityType, entityId);
    }
}