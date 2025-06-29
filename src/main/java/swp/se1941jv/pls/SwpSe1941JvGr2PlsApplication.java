package swp.se1941jv.pls;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
public class SwpSe1941JvGr2PlsApplication {

    public static void main(String[] args) {
        SpringApplication.run(SwpSe1941JvGr2PlsApplication.class, args);
    }
    @Bean
    public RestTemplate restTemplate() {    
        return new RestTemplate();
    }
}
