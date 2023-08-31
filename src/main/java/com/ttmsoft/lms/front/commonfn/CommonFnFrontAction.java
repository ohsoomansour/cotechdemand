package com.ttmsoft.lms.front.commonfn;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.FileService;

@Controller
@RequestMapping ("/techtalk")

public class CommonFnFrontAction extends BaseAct{
	
	@Autowired
	private CommonFnFrontService commonfnService; 
	
	@Autowired
	private FileService fileService;
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 8. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 이용약관 페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/terms.do")
	public ModelAndView doTerms (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/commonfn/TermsOfServices.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "이용약관");
		mav.addObject("navi",navi);
		return mav;
	}
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 8. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 개인정보 처리방침
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/policy.do")
	public ModelAndView doPolicy (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/commonfn/PrivacyPolicy.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "개인정보처리방침");
		mav.addObject("navi",navi);
		return mav;
	}
}
