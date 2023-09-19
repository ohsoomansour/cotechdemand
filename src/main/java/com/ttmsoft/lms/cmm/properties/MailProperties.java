package com.ttmsoft.lms.cmm.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Configuration
@ConfigurationProperties(prefix = "spring.mail")
@Getter
@Setter
@ToString
public class MailProperties {

	private String host;
	private String port;
	private String username;
	private String password;
}
