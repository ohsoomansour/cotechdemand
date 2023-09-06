package com.ttmsoft.lms.front.techsearch;

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
public class TechSearchAction extends BaseAct {

	@Value ("${siteid}")
	private String			siteid;
	
	@Autowired
	private TechSearchService techSearchServicec;
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 8. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 연구자 검색 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/searchResearcher.do")
	public ModelAndView doSearchResearcherView (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/techsearch/searchResearcher.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "연구자 검색");
		mav.addObject("navi",navi);
		return mav;
	}
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 8. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업수요 검색 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/searchBusiness.do")
	public ModelAndView doSearchBusinessView (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/techsearch/searchBusiness.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "기업수요 검색");
		mav.addObject("navi",navi);
		return mav;
	}
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 6.
	 * @Parm	 : DataMap
0	 * @Return   : ModelAndView
	 * @Function : 매칭된 기업수요 목록 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/matchBusinessList.do")
	public ModelAndView doMatchBusinessList (@ModelAttribute("paraMap")DataMap paraMap,HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/techsearch/matchBusinessList.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "매칭된 기업수요 목록 페이지");
		mav.addObject("navi",navi);
		return mav;
	}
}
