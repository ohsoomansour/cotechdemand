package com.ttmsoft.lms.front.main;

import java.util.List;
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

import com.ttmsoft.lms.admin.site.BannerService;
import com.ttmsoft.lms.admin.site.PopupService;
import com.ttmsoft.lms.front.boarditem.BoardItemFrontService;
import com.ttmsoft.lms.front.notice.NoticeFrontService;
import com.ttmsoft.lms.front.projectapply.ProjectFrontService;
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
	private BannerService bannerService;
	
	@Autowired
	private PopupService popupService;
		
	@Autowired
	private BoardItemFrontService boardService;
	
	@Autowired
	private ProjectFrontService applyFrontService;
	
	@Autowired
	private BoardItemFrontService boardItemFrontService;
	
	@Autowired
	private NoticeFrontService noticeFrontService;
	
	@Autowired
	private TechTalkMainService techTalkMainService;


//	@RequestMapping ("/")
//	public ModelAndView doMain (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) {
//		ModelAndView mv = new ModelAndView("redirect:/front/mainView.do");
//		return mv;
//	}
	
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
	
	@RequestMapping ("/tttttest.do")
	public ModelAndView tttttest (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");	
		mav.addObject(paraMap);
		System.out.println("나오냐"+paraMap);
		return mav;
	}
	
	
	@RequestMapping ("/tttt.do")
	public ModelAndView doTttt (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/main/main2.front");
		return mav;
	}
	@RequestMapping ("/check.do")
	public ModelAndView idCheck (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");	
		List<DataMap> result = techTalkMainService.doCheck(paraMap);
		
		mav.addObject(result);
		System.out.println("나오냐"+result);
		return mav;
	}
}
