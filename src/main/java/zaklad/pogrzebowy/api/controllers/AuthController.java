package zaklad.pogrzebowy.api.controllers;

import zaklad.pogrzebowy.api.models.User;
import zaklad.pogrzebowy.api.repositories.UserRepository;
import zaklad.pogrzebowy.api.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import java.util.Optional;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@RestController
@RequestMapping("/auth")
@CrossOrigin(origins = "*") // 🔹 Dla React
public class AuthController {
    
    private static final Logger logger = LogManager.getLogger(AuthController.class);
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private JwtUtil jwtUtil;
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody User loginUser) {
        logger.info("Próba logowania dla użytkownika: {}", loginUser.getEmail());
        
        Optional<User> user = userRepository.findByEmail(loginUser.getEmail());
        
        if (user.isPresent()) {
            logger.debug("Znaleziono użytkownika z emailem: {}", loginUser.getEmail());
            
            if (passwordEncoder.matches(loginUser.getPasswordHash(), user.get().getPasswordHash())) {
                logger.info("Logowanie pomyślne dla użytkownika: {}", loginUser.getEmail());
                
                String token = jwtUtil.generateToken(user.get().getEmail());
                logger.debug("Wygenerowano token JWT dla użytkownika: {}", loginUser.getEmail());
                
                return ResponseEntity.ok().body("{\"token\": \"" + token + "\"}");
            } else {
                logger.warn("Nieudana próba logowania - nieprawidłowe hasło dla użytkownika: {}", loginUser.getEmail());
                return ResponseEntity.status(401).body("Nieprawidłowy email lub hasło");
            }
        } else {
            logger.warn("Nieudana próba logowania - nie znaleziono użytkownika z emailem: {}", loginUser.getEmail());
            return ResponseEntity.status(401).body("Nieprawidłowy email lub hasło");
        }
    }
}