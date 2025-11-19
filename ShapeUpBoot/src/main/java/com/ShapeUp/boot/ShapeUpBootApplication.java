package com.ShapeUp.boot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
public class ShapeUpBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(ShapeUpBootApplication.class, args);
	}

}
