package zaklad.pogrzebowy.api.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import zaklad.pogrzebowy.api.models.Log;
import java.util.List;

public interface LogRepository extends JpaRepository<Log, Long> {
    List<Log> findTop50ByOrderByTimestampDesc();
    List<Log> findByEntityTypeOrderByTimestampDesc(String entityType);
    List<Log> findByEntityTypeAndEntityIdOrderByTimestampDesc(String entityType, Long entityId);
}