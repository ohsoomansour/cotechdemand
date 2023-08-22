package com.ttmsoft.lms.cmm.login;

import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import com.ttmsoft.lms.cmm.intercept.SessionCheckService;
import com.ttmsoft.lms.front.boarditem.BoardItemFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.AES256Util;
import com.ttmsoft.toaf.util.CommonUtil;

/**
 * 
 * @Package	 : com.ttmsoft.lms.cmm.login
 * @File	 : LoginAction.java
 * 
 * @Author   : choi
 * @Date	 : 2020. 3. 18.
 * @Explain  : 로그인/로그아웃 처리
 *
 */
@Controller
@RequestMapping ("/login")
public class LoginAction extends BaseAct {
	
	@Autowired
	private JavaMailSender javaMailSender;

	@Autowired
	private LoginService		loginService;
	
	@Autowired
	private SessionCheckService	sessionCheckService;
	
	@Value ("${siteid}")
	private String			siteid;

	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그인 ID/PW 입력폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/login.do")
	public ModelAndView doFormLogin (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		String sessionKey = request.getSession().getId();
		paraMap.put("sesskey", sessionKey);
		ModelAndView mav = new ModelAndView("/lms/front/cmm/login/login.single");
		mav.addObject("siteid", siteid);
		return mav;
	}
	
	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그인 ID/PW 입력폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/test.do")
	public ModelAndView doFormLoginTest (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		String sessionKey = request.getSession().getId();
		paraMap.put("sesskey", sessionKey);
		ModelAndView mav = new ModelAndView("/lms/front/cmm/login/login_backup.single");
		mav.addObject("siteid", siteid);
		return mav;
	}

	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그인
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/loginx.do", method = RequestMethod.POST)
	public ModelAndView doLogin (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		// 예외상황에 대한 기본 오류 정보 선언
		String error_code = "1";
		String error_mesg = "로그인 실패 했습니다.";
				
		try {
			
			HttpSession session = request.getSession();
					
			if (logger.isDebugEnabled()) {
				logger.debug("로그인 ==> " + paraMap.get("userid") + "|" + paraMap.get("userpw"));
			}
			
			if (this.loginService.countUserInfo(paraMap) == 0) {
				error_code = "2"; 
				error_mesg = "아이디와 비밀번호를 다시 한번 확인해주세요."; throw new Exception();
			}
			
			
			
			DataMap userMap = this.loginService.getoneUserInfo(paraMap);

			if (logger.isDebugEnabled()) {
				logger.debug("로그인 결과==> " + userMap.toString());
			}

			String [] rolelist = userMap.get("roles").toString().split(",");		
			userMap.put("rolelist"		, rolelist);
			
			int count = this.loginService.doCountAdminMenuAuth(userMap);

			if(count > 0) {
				userMap.put("roleyn", "Y");
			}else {
				userMap.put("roleyn", "N");
			}
			
			if(count > 0) {
				// 사용자정보 및 기본권한을 세션에 담는다.
				this.addSessionLoginInfo(session, userMap);
				// 권한 리스트를 세션 정보에 담는다.
				paraMap.put("userno", String.valueOf(userMap.get("userno")));
				paraMap.put("siteid", String.valueOf(userMap.get("siteid")));
				this.appendConnectInfo(paraMap, request);	// 접속 로그 기록
				this.appendSessionInfo(paraMap, request);	// 유저 세션 정보 기록
				DataMap results = new DataMap();
				results.put("item", userMap);
				mav.addObject("result_code", "0");
				mav.addObject("results", results);
			}
			else {
				mav.addObject("result_code", "1");
				mav.addObject("result_mesg", "해당 아이디는 관리자 권한이 없습니다.");
			}
			
		}
		catch (Exception e) {

			mav.addObject("result_code", error_code);
			mav.addObject("result_mesg", this.messageSource.getMessage(error_mesg, null, CommonUtil.getLocale(request)));
		}

		return mav;
	}
	
	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : SSO로그인 
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/loginssox.do", method = RequestMethod.POST)
	public ModelAndView doSSOLogin (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("redirect:/index.do");
//		// 예외상황에 대한 기본 오류 정보 선언
//		String error_code = "1";
//		String error_mesg = "error.common.list";
//		try {
//			HttpSession session = request.getSession();
//
//			final String API_KEY = "368B184727E89AB69FAF";
//			SSO context = new SSO(API_KEY);
//			String ssoToken = CookieUtil.getCookieByName(request, "SSOTOKEN");
//
//			if (ssoToken == null || ssoToken.length() < 1 ||
//				context.verifyToken(ssoToken, CommonUtil.getRemoteAddress(request)) < 0) {
//				error_code = "2"; error_mesg = "lms.common.text122";
//				throw new Exception();
//			}
//
//			paraMap.put("userid", context.getValueUserID());
//			if (!context.getValueUserID().equals(String.valueOf(request.getSession().getAttribute("userno")))) {
//				paraMap.put("autologin", "Y");
//				DataMap userMap = this.loginService.getoneUserInfo(paraMap);
//				// 사용자정보 및 기본권한을 세션에 담는다.
//				this.addSessionLoginInfo(session, userMap);
//				// 권한 리스트를 세션 정보에 담는다.
//				paraMap.put("userno", String.valueOf(userMap.get("userno")));
//				paraMap.put("siteid", String.valueOf(userMap.get("siteid")));
//
//				this.appendConnectInfo(paraMap, request);	// 접속 로그 기록
//				this.appendSessionInfo(paraMap, request);	// 유저 세션 정보 기록
//			}
//		}
//		catch (Exception e) {
//			if (logger.isDebugEnabled()) e.printStackTrace();
//			mav.addObject("result_code", error_code);
//			mav.addObject("result_mesg", this.messageSource.getMessage(error_mesg, null, CommonUtil.getLocale(request)));
//		}
		return mav;
	}

	
	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : void
	 * @Function : 세션에 회원정보 담기
	 * @Explain  : 
	 *
	 */
	private void addSessionLoginInfo (HttpSession session, DataMap userMap) {
		
		session.setAttribute("userno", userMap.get("userno").toString()); 	// 회원 번호
		session.setAttribute("userid", userMap.get("userid").toString());	// 회원 아이디
		session.setAttribute("usernm", userMap.get("usernm").toString());	// 회원 이름
		//session.setAttribute("role_pcd", userMap.get("role_pcd").toString());	// 권한 코드
		session.setAttribute("rolenm", userMap.get("rolenm").toString());	// 권한 이름
		session.setAttribute("roles", userMap.get("roles").toString());		// 권한리스트
		session.setAttribute("orgno", userMap.get("orgno").toString());		// 조직 번호
		session.setAttribute("orgnm", userMap.get("orgnm").toString());		// 조직 이름
		session.setAttribute("email", userMap.get("email").toString());		// 메일주소
		session.setAttribute("photo", userMap.get("photo").toString());		// 프로필 이미지
		session.setAttribute("roleyn", userMap.get("roleyn").toString());	// 권연 여부
		session.setAttribute("siteid", userMap.get("siteid").toString());	// SITEID
	}
	
	

	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그아웃 처리
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/logoutx.do")
	public ModelAndView doLogout (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");

		// 예외상황에 대한 기본 오류 정보 선언
		String error_code = "1";
		String error_mesg = "error.common.process";
		
		try {
			HttpSession session = request.getSession();
			/* 세션 유지 정보 삭제 */
			DataMap paramMap = new DataMap();
			paramMap.put("sesskey", request.getSession().getId());
			paramMap.put("userno", request.getSession().getAttribute("userno"));

			this.sessionCheckService.removeSessionInfo(paramMap);
			session.invalidate();
			
			mav.addObject("result_code", "0");
			mav.addObject("result_mesg", this.messageSource.getMessage("result.success", null, CommonUtil.getLocale(request)));
		}
		catch (Exception e) {
			if (logger.isDebugEnabled()) e.printStackTrace();
			mav.addObject("result_code", error_code);
			mav.addObject("result_mesg", this.messageSource.getMessage(error_mesg, null, CommonUtil.getLocale(request)));
		}

		return mav;
	}
	
	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : Ajax Session 종료
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/sessionExpired.do")
	public ModelAndView doSessionExpried (HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		mav.addObject("SESSION", "EXPIRED_SESSION");

		return mav;
	}
	
	
	
	
	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : void
	 * @Function : 유저 세션 정보 기록
	 * @Explain  : 
	 *
	 */
	private void appendSessionInfo (DataMap paraMap, HttpServletRequest request) {
		if (!(String.valueOf(request.getSession().getAttribute("roles"))).equals("")) {
			paraMap.put("sesskey", request.getSession().getId());
			paraMap.put("note", request.getHeader("User-Agent"));
			this.sessionCheckService.appendUserSession(paraMap);
		}
	}

	/**
	 *
	 * @Author   : choi
	 * @Date	 : 2020. 3. 18.
	 * @Parm	 : DataMap
	 * @Return   : void
	 * @Function : 접속로그 정보 기록
	 * @Explain  : 
	 *
	 */
	private void appendConnectInfo (DataMap paraMap, HttpServletRequest request) {
		// 접속로그 정보 기록
		paraMap.put("conn_ip", CommonUtil.getRemoteAddress(request));
		paraMap.put("conn_sesskey", request.getSession().getId());
		paraMap.put("conn_agent", request.getHeader("User-Agent"));

		paraMap.put("conn_pcd", "CONN_P002");
		paraMap.put("conn_tcd", "CONN_T001");
		paraMap.put("conn_scd", "CONN_S002");
		paraMap.put("note", "");

		this.loginService.appendLogConnect(paraMap);
		this.loginService.modifyLogin(paraMap);
	}
}
