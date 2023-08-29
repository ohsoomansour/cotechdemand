package com.ttmsoft.lms.front.main;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

/**
 * 
 * 파일명	: MainAction.java
 * 패키지	: com.ttmsoft.lms.svc.main
 * 설  명	: 사용자 메인 페이지
 *
 * 2020.03.03	[sgchoi] - 최초작성
 * 
 */
@Controller
@RequestMapping("/techtalk")
public class TechTalkMainAction extends BaseAct {

	@Value ("${siteid}")
	private String			siteid;
	
	@Autowired
	private TechTalkMainService techTalkMainService;
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 8. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메인페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/mainView.do")
	public ModelAndView doMainView (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/main/main.front");
		return mav;
	}
	
	@RequestMapping ("/front/global.do")
	public ModelAndView doGlobalLangForm (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/lms/front/cmm/global/global.frontPopup");	
		return mav;
	}
	
	@RequestMapping ("/front/changeLang.do")
	public ModelAndView doChangeLang (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");	
		try {
			String lang = paraMap.getstr("lang");
			Locale locale = Locale.KOREA;
			
			if(("US").equals(lang)) {
				locale = Locale.US;
			}
			LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
			localeResolver.setLocale(request, response, locale);
			System.out.println("lang type : " + localeResolver.resolveLocale(request)); 
			
		}catch(Exception e){
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
}
