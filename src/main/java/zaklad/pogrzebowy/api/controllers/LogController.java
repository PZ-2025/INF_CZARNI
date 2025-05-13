package zaklad.pogrzebowy.api.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import zaklad.pogrzebowy.api.models.Log;
import zaklad.pogrzebowy.api.services.LogService;
import zaklad.pogrzebowy.api.dto.LogDTO;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/logs")
@CrossOrigin(origins = "*") // Upewnij się, że to jest obecne
public class LogController {

    @Autowired
    private LogService logService;

    @GetMapping
    public ResponseEntity<List<LogDTO>> getRecentLogs() {
        List<Log> logs = logService.getRecentLogs();
        List<LogDTO> logDTOs = logs.stream()
                .map(log -> new LogDTO(log))
                .collect(Collectors.toList());
        return ResponseEntity.ok(logDTOs);
    }

    @GetMapping("/entity/{entityType}")
    public ResponseEntity<List<LogDTO>> getLogsByEntityType(@PathVariable String entityType) {
        List<Log> logs = logService.getLogsByEntityType(entityType);
        List<LogDTO> logDTOs = logs.stream()
                .map(log -> new LogDTO(log))
                .collect(Collectors.toList());
        return ResponseEntity.ok(logDTOs);
    }

    @GetMapping("/entity/{entityType}/{entityId}")
    public ResponseEntity<List<LogDTO>> getLogsByEntityTypeAndId(
            @PathVariable String entityType,
            @PathVariable Long entityId) {
        List<Log> logs = logService.getLogsByEntityTypeAndId(entityType, entityId);
        List<LogDTO> logDTOs = logs.stream()
                .map(log -> new LogDTO(log))
                .collect(Collectors.toList());
        return ResponseEntity.ok(logDTOs);
    }
}