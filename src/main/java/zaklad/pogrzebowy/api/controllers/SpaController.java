package zaklad.pogrzebowy.api.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SpaController {

    // Forward all non-API routes to index.html for React Router
    @RequestMapping(value = {"/", "/log", "/admin", "/profile", "/tasks", "/raports", "/recepcionist"})
    public String forward() {
        return "forward:/index.html";
    }
}