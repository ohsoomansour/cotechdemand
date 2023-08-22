package com.ttmsoft.lms.cmm.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.ttmsoft.toaf.view.ExcelView;

@Configuration
public class ViewConfig {

	@Bean
	public MappingJackson2JsonView jsonView() {
		return new MappingJackson2JsonView();	
	}
	
	@Bean
	public ExcelView excelView() {
		return new ExcelView();	
	}
}
