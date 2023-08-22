package com.ttmsoft.lms.admin.main;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.lms.front.login.LoginFrontService;
import com.ttmsoft.lms.front.member.MemberFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

/**
 * 
 * @Package	 : com.ttmsoft.lms.admin.main
 * @File	 : AdminMainAction.java
 * 
 * @Author   : choi
 * @Date	 : 2020. 3. 18.
 * @Explain  : 관리자 메인 페이지
 *
 */
@Controller
@RequestMapping ("/admin")
public class AdminMainAction extends BaseAct{

	@Value ("${siteid}")
	private String			siteid;
	
	@Autowired
	private LoginFrontService loginFrontService;
	
	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 관리자 메인함수
	 * @Explain  : 관리자 메인페이지로 이동
	 *
	 */
	@RequestMapping (value = "/mainView.do")
	public ModelAndView doMainView (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("/lms/admin/main/adminMain.admin");
		
		paraMap.put("id", session.getAttribute("id"));
				
		mav.addObject("userInfo", loginFrontService.doGetOneUserInfo(paraMap));
		mav.addObject("siteid", siteid);
		
		LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
		Locale locale = localeResolver.resolveLocale(request);

		System.out.println("admin locale : " + locale);
		
		return mav;
	}
}
