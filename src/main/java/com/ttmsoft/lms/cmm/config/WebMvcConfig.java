package com.ttmsoft.lms.cmm.config;

import java.util.Locale;

import org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator;
import org.springframework.aop.support.RegexpMethodPointcutAdvisor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.http.CacheControl;
import org.springframework.stereotype.Repository;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import com.ttmsoft.lms.cmm.intercept.DefaultCheck;
import com.ttmsoft.lms.cmm.intercept.SessionCheck;
import com.ttmsoft.toaf.interceptor.RequestInterceptor;

@Repository
@Configuration
public class WebMvcConfig implements WebMvcConfigurer{

	@Value("${upload.path}")
	private String rootPath;
	
	@Autowired
    private SessionCheck sessionCheckInterceptor;
	
	@Autowired
    private DefaultCheck defaultCheckInterceptor;
	
	@Autowired
	private RequestInterceptor requestInterceptor;
	 
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
    	
    	registry.addInterceptor(sessionCheckInterceptor)
    			.addPathPatterns("/**/*.do");
    	
    	
    	registry.addInterceptor(defaultCheckInterceptor)
				.addPathPatterns("/**/*.do");
    }
    
    @Bean
	public MessageSource messageSource() {
		ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
		messageSource.setBasenames("messages/message");
		messageSource.setDefaultEncoding("UTF-8");
		messageSource.setUseCodeAsDefaultMessage(true);
		return messageSource;
	}
    
    @Bean
    public SessionLocaleResolver localeResolver() {
    	SessionLocaleResolver sessionLocaleResolver = new SessionLocaleResolver();
    	sessionLocaleResolver.setDefaultLocale(Locale.KOREA);
    	return sessionLocaleResolver;
    }
    
    @Bean	
    public RegexpMethodPointcutAdvisor requestValueAdvisor() {  	
    	RegexpMethodPointcutAdvisor requestValueAdvisor = new RegexpMethodPointcutAdvisor();
    	requestValueAdvisor.setAdvice(requestInterceptor);
    	requestValueAdvisor.setPattern(".*Action.*");
    	return requestValueAdvisor;
    }

    @Bean	
    public DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator() { 	
    	DefaultAdvisorAutoProxyCreator defaultAdvisorAutoProxyCreator = new DefaultAdvisorAutoProxyCreator();
    	// if not set this, it will use JDK dynamic proxy 
        defaultAdvisorAutoProxyCreator.setProxyTargetClass(true);
    	return defaultAdvisorAutoProxyCreator;
    } 
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
    	registry.addResourceHandler("/img/**")
    	.addResourceLocations("file:///"+rootPath+"/")
    	.setCacheControl(CacheControl.noCache().cachePrivate());
    }
}
