package zaklad.pogrzebowy.api.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import zaklad.pogrzebowy.api.models.Log;
import zaklad.pogrzebowy.api.services.LogService;

import java.util.List;

@RestController
@RequestMapping("/logs")
@CrossOrigin(origins = "*")
public class LogController {

    @Autowired
    private LogService logService;

    @GetMapping
    public ResponseEntity<List<Log>> getRecentLogs() {
        return ResponseEntity.ok(logService.getRecentLogs());
    }

    @GetMapping("/entity/{entityType}")
    public ResponseEntity<List<Log>> getLogsByEntityType(@PathVariable String entityType) {
        return ResponseEntity.ok(logService.getLogsByEntityType(entityType));
    }

    @GetMapping("/entity/{entityType}/{entityId}")
    public ResponseEntity<List<Log>> getLogsByEntityTypeAndId(
            @PathVariable String entityType,
            @PathVariable Long entityId) {
        return ResponseEntity.ok(logService.getLogsByEntityTypeAndId(entityType, entityId));
    }
}