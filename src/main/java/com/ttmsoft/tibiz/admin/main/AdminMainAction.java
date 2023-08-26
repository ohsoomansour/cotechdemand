package com.ttmsoft.tibiz.admin.main;

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

	
}
