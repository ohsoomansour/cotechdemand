package com.ttmsoft.lms.project;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;


@SpringBootApplication
@EnableAutoConfiguration
@ComponentScan(basePackages = "com.ttmsoft")
public class LmsTtmApplication {

	public static void main(String[] args) {
		SpringApplication.run(LmsTtmApplication.class, args);
	}
}
