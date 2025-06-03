package zaklad.pogrzebowy.api.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfig implements WebMvcConfigurer {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Forward all non-API routes to index.html for React Router
        registry.addViewController("/").setViewName("forward:/index.html");
        registry.addViewController("/log").setViewName("forward:/index.html");
        registry.addViewController("/admin").setViewName("forward:/index.html");
        registry.addViewController("/profile").setViewName("forward:/index.html");
        registry.addViewController("/tasks").setViewName("forward:/index.html");
        registry.addViewController("/raports").setViewName("forward:/index.html");
        registry.addViewController("/recepcionist").setViewName("forward:/index.html");
    }
}