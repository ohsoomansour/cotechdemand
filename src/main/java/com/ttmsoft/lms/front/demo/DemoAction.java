package com.ttmsoft.lms.front.demo;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.ObjectUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.MailSendException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.sun.mail.smtp.SMTPSenderFailedException;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.CommonUtil;
import com.ttmsoft.toaf.util.ExcelUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping ("/demo")
@Slf4j
@RequiredArgsConstructor
public class DemoAction {
	
	private final ExcelUtil excelUtil;
	private final CommonUtil commonUtil;

	@GetMapping("/excel")
	public ModelAndView excelDemo() {
		ModelAndView mav = new ModelAndView("/demo/excel");
		
		return mav;
	}
	
	
	@PostMapping("/excel")
	public ModelAndView readExcel(@RequestParam("uploadFile") MultipartFile multipartFile) {
		ModelAndView mav = new ModelAndView("/demo/excelResult");
		
		Map<String, Object> result = this.excelUtil.convertExcelToMap(multipartFile);
		
		mav.addObject("result", result);
		
		
		return mav;
	}
	
	
	@GetMapping("/mail")
	public ModelAndView mailDemo() {
		ModelAndView mav = new ModelAndView("/demo/mail");
		
		return mav;
	}
	
	@PostMapping("/mail/send")
	public ResponseEntity<Map<String,Object>> sendMail(@RequestBody DataMap params) {
		Map<String,Object> result = new HashMap<>();
		String[] requiredKey = {"user_email", "subject", "text"};
		
		/*
		 * DataMap mailParams = new DataMap();
		 * 
		 * mailParams.put("subject", params.get("subject")); mailParams.put("text",
		 * params.get("text")); mailParams.put("user_email", params.get("user_email"));
		 */
		
		// 필수 파라미터 체크
		for(String key: requiredKey) {
			
			if(!params.containsKey(key)) {
				result.put("status", "FAIL");
				result.put("message", String.format("%s is not defined.", key));
				
				return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
			}
			
			if(params.get(key).toString().trim() == "") {
				result.put("status", "FAIL");
				result.put("message", String.format("%s is not defined.", key));
				
				return new ResponseEntity<>(result, HttpStatus.INTERNAL_SERVER_ERROR);
			}
		}

		
		log.info("TEST :: {}", params);
		
		try {
			
			int sendStatus = commonUtil.doMailSender(params);
			
			switch(sendStatus) {
			case 1001: 
				result.put("status", "FAIL");
				break;
			default:
				result.put("status", "FAIL");
			}
			
		} catch (MailSendException e) {
			log.error("Error Send Mail", e);
			result.put("status", "FAIL");
		} catch (SMTPSenderFailedException e) {
			log.error("Error SMTP", e);
			result.put("status", "FAIL");
		}
		
		result.put("status", "SUCCESS");
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}
	
}
