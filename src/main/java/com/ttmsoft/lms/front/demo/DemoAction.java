package com.ttmsoft.lms.front.demo;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.util.ExcelUtil;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping ("/demo")
@Slf4j
@RequiredArgsConstructor
public class DemoAction {
	
	private final ExcelUtil excelUtil;

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
	
}
