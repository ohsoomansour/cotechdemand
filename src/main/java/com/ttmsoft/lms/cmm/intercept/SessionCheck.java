package com.ttmsoft.lms.cmm.intercept;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ttmsoft.lms.cmm.login.LoginService;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.StringUtil;

@Component
@SuppressWarnings ({ "unused" })
public class SessionCheck extends HandlerInterceptorAdapter {

	private Logger				logger	= LoggerFactory.getLogger(this.getClass());
	private String				message	= "";

	@Autowired
	private SessionCheckService	sessionCheckService;

	@Autowired
	private LoginService		loginService;
	
	@Autowired
	private DefaultCheckService	DefaultCheckService;

	protected MessageSource		messageSource;

	@Resource (name = "messageSource")
	public void setMessageSource (MessageSource messageSource) {
		this.messageSource = messageSource;
	}

	public boolean preHandle (HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		boolean result = false;

		try {	
			logger.info("share session check !!!!" + getSessionValue(request, "member_seqno"));
			
			System.out.println("세션만료되면어케되?"+getSessionValue(request, "member_seqno"));
			// 비로그인 가능 요청인 경우
			if (this.isNoSessionRequest(request)) {
				System.out.println("비로그인기능");
				logger.debug("비로그인 가능 요청입니다.");
				return true;
			}
			//메뉴권한확인
			if(checkMenuList(request)) {
				if ("".equals(getSessionValue(request, "member_seqno"))) {
					logger.debug("share session check !!");
					String requestURI = request.getRequestURI().toString();
					int check = this.makeUserInfoSession(request);
					if(!requestURI.equals("/techtalk/login.do")) {
						if(check!=1) {
							logger.debug("해당url은 비로그인기능입니다.");
							response.sendRedirect("/techtalk/login.do");
							return false;
						}	
					}
				}
				if (logger.isDebugEnabled()) {
					logger.debug("Session Check Interceptor !!!!");
					logger.debug("REQUEST HEADER : " + request.getHeader("X-Requested-With"));
					logger.debug(request.getServerName());
					logger.debug(request.getRequestURI());
					logger.debug("sesskey : " + request.getSession().getId());
					logger.debug("userid : " + getSessionValue(request, "member_seqno"));
					logger.debug("userno : " + getSessionValue(request, "member_type"));
					logger.debug("usernm : " + getSessionValue(request, "id"));
					logger.debug("orgno : " + getSessionValue(request, "user_name"));
				}
				result = this.isAvailableSession(request, response);
			}else {
				response.sendRedirect("/techtalk/login.do");
			}
		}
		catch (Exception e) {
			response.sendRedirect("/techtalk/login.do");
			
			  if (logger.isDebugEnabled()) { e.printStackTrace();
			  logger.debug(" Exception - preHandle : " + e.toString()); }
			
		}
		// 로그인 설정 요청 반환
		return true;
	}

	private int makeUserInfoSession (HttpServletRequest request) {
		int result =0;
		try {
			HttpSession session = request.getSession();

			DataMap dataMap = new DataMap();
			dataMap.put("sesskey", session.getId());
			DataMap sessMap = this.sessionCheckService.getoneSessionByKey(dataMap);
			
			if (sessMap != null) {
				result = 1;
				sessMap.put("siteid", request.getAttribute("siteid"));
				sessMap.put("autologin", "Y"); // 비밀번호 체크 안함

				DataMap userMap = loginService.getoneUserInfo(sessMap);
				
				String [] rolelist = userMap.get("roles").toString().split(",");
				
				userMap.put("rolelist"		, rolelist);
				
				int count = DefaultCheckService.doCountAdminMenuAuth(userMap);
				
				if(count > 0) {
					userMap.put("roleyn", "Y");
				}else {
					userMap.put("roleyn", "N");
				}
						
				this.addSessionLoginInfo(session, userMap);
			}else {
				
			}
		}
		catch (Exception e) {
			if (logger.isDebugEnabled()) {
				logger.debug(" Exception - makeUserInfoSession : " + e.toString());
			}
		}
		return result;
	}

	private boolean checkMenuList (HttpServletRequest request) {
		boolean result = false;
		try {
		//메뉴권한 확인
		DataMap paraMap = new DataMap();
		String memeber_type = getSessionValue(request, "member_type");
		paraMap.put("member_seqno", getSessionValue(request, "member_seqno"));
		paraMap.put("member_type", getSessionValue(request, "member_type"));
		paraMap.put("id", getSessionValue(request, "id"));
		paraMap.put("user_name", getSessionValue(request, "user_name")); 
		
		
		if(memeber_type.equals("R")) {
			paraMap.put("member_type_no", "1");
		}else if(memeber_type.equals("B")) {
			paraMap.put("member_type_no", "2");
		}else if(memeber_type.equals("TLO")) {
			paraMap.put("member_type_no", "3");
		}else if(memeber_type.equals("ADMIN")) {
			paraMap.put("member_type_no", "4");
		}else {
			paraMap.put("member_type_no", "0");
		}
		List<DataMap> data = sessionCheckService.getMenuList(paraMap);
		System.out.println("이거어케나옴"+ data );
		System.out.println("이거는? + " + request.getRequestURI());
		String url = request.getRequestURI().trim();
		
		for(int i=0; i<data.size(); i++) {
			String checkUrl = data.get(i).getstr("url").trim();
			if(checkUrl.equals(url)) {
				result = true;
				break;
			}
		}
		}catch(Exception e) {
			
		}finally {
			
		}
		return result;
	}
	private void addSessionLoginInfo (HttpSession session, DataMap userMap) {
		session.setAttribute("member_seqno", userMap.get("member_seqno").toString());
		session.setAttribute("id", userMap.get("id").toString());
		session.setAttribute("pw", userMap.get("pw").toString());
		session.setAttribute("user_name", userMap.get("user_name").toString());
		session.setAttribute("user_email", userMap.get("user_email").toString());
	}

	/**
	 * SessionInterceptor 에서 로그인 필요 요청에 관련된 리턴 유형 설정
	 *
	 * @param request
	 * @param response
	 * @return false : 오류 메세지 출력과 함께 요청 종료, true : 요청 진행
	 * @throws IOException
	 */
	private boolean isAvailableSession (HttpServletRequest request, HttpServletResponse response) throws IOException {

		if (this.isNologin(request)) {
			if (logger.isDebugEnabled()) {
				logger.debug(this.message);
			}
			return this.returnErrorMessage(request, response);
		}
		/* 중복로그인 체크 개발기간동안은 편의성을 위해  주석처리함..
		if(this.isDupleLogin(request)){
			if (logger.isDebugEnabled()) {
				logger.debug(this.message);
			}
			return this.returnErrorMessage(request, response);
		}
		*/
		return true;
	}

	/**
	 * 중복 로그인 체크
	 *
	 * @param request
	 * @return
	 */
	private boolean isDupleLogin (HttpServletRequest request) {	
		
		this.message = "다른 PC에서 로그인 되었습니다.";	// "다른 PC 에서 로그인 되었습니다.";

		DataMap paramMap = new DataMap();
		paramMap.put("sesskey", request.getSession().getId());
		paramMap.put("userno", getSessionValue(request, "userno"));

		DataMap sessMap = this.sessionCheckService.getoneSessionInfo(paramMap);

		if (sessMap != null && sessMap.get("useyn").equals("N")) {
			request.getSession().invalidate();
			this.sessionCheckService.removeSessionInfo(sessMap);
			return true;
		}
	
		return false;
	}

	/**
	 * SessionInterceptor 에서 사용하는 세션값 리턴
	 *
	 * @param request
	 * @param str
	 * @return
	 */
	private String getSessionValue (HttpServletRequest request, String str) {
		return StringUtil.trim(request.getSession().getAttribute(str));
	}

	/**
	 * 비로그인 상태인 경우 메세지와 false 리턴
	 *
	 * @param request
	 * @return
	 */
	private boolean isNologin (HttpServletRequest request) {		
		this.message = "로그인 후 이용하실 수 있습니다.";	// "로그인 후 이용하실 수 있습니다.";
		return getSessionValue(request, "member_seqno").equals("");
	}

	/**
	 * 관리자 요청 페이지지만 현재 사용자 그룹이 관리자 그룹이 아닌경우 false 리턴
	 *
	 * @param request
	 * @return
	 */
	private boolean hasNoAdminRole (HttpServletRequest request) {
		
		this.message = "권한이 없습니다.";	// "권한이 없습니다.";

		boolean isAdminUri = request.getRequestURI().indexOf("/admin/") != -1;	
		//boolean isNoAdminGroup = getSessionValue(request, "orgno").toString().indexOf("TTM-00001") == -1;	
		boolean isNoAdminRole = getSessionValue(request, "roleyn").equals("N");
		
		logger.info("isAdminUri : " + isAdminUri);
		logger.info("isNoAdminRole : " + isNoAdminRole);
		
		return isAdminUri && isNoAdminRole;
	}

	/**
	 * 오류 메세지를 response 객체에 출력하고 종료(false)
	 *
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException
	 */
	private boolean returnErrorMessage (HttpServletRequest request, HttpServletResponse response) throws IOException {

		boolean isNotAjaxRequest = !StringUtils.trimToEmpty(request.getHeader("X-Requested-With")).equals("XMLHttpRequest");

		if (isNotAjaxRequest) {

			Locale locale = new Locale(String.valueOf(request.getSession().getAttribute("sess_lang")));
			//String [] arrUri = request.getRequestURI().split("/");			
			String strUrl = "front/login.do";
			
			StringBuilder strBuiler = new StringBuilder();
			strBuiler.append("<SCRIPT type=text/javascript>				");

			if (this.message.indexOf("common.") > -1) {	// 경고메세지 properties
				//strBuiler.append("	alert('").append(this.messageSource.getMessage(message, null, locale)).append("');	");
			}
			else if (!this.message.equals("")) {	// 경고메세지 string
				//strBuiler.append("	alert('").append(message).append("');	");
			}

			if (String.valueOf(request.getParameter("ispopup")).equals("Y")) {	// 팝업인 경우
				strBuiler.append("	self.close();	\n");
			}
			else { // 팝업이 아닌경우
				//strBuiler.append("	top.location='/").append(strUrl).append("'; ");
				strBuiler.append("	top.location='/").append(strUrl).append("'; ");
			}

			strBuiler.append("</SCRIPT>					 				");

			response.setContentType("text/html; charset=UTF-8");
			response.getWriter().print(strBuiler.toString());

			// 오류 메세지 출력 후 세션의 메뉴 아이디를 삭제해 준다.
			request.getSession().setAttribute("menuno", "");
		}
		else {
			if (logger.isDebugEnabled()) logger.debug("AJAX SESSION EXPIRED !!!");
			response.sendRedirect("/login/sessionExpired.do");
		}

		return false;
	}

	/**
	 * 세션 체크가 필요없는 요청에 대해 true를 리턴하여 세션 체크를 하지 않는다.
	 *
	 * @param request
	 * @return
	 */
	private boolean isNoSessionRequest (HttpServletRequest request) {
		
		String url = request.getRequestURI();
		System.out.println(url+"어케나오는데 왜죠 ");

		boolean isListBoardItem = url.indexOf("/techtalk/mainView.do") != -1;
		boolean isAddBoardItem = url.indexOf("/techtalk/findIdPage.do") != -1;
		boolean isViewBoardItem = url.indexOf("/techtalk/findPwdPage.do") != -1;
		boolean isLoginPage = url.indexOf("/techtalk/login.do") != -1;
		boolean isLogin = url.indexOf("login") != -1;
		boolean isMemberJoinForm = url.indexOf("/techtalk/memberJoinFormPage.do") != -1;
		boolean isFile = url.indexOf("/file/") != -1;
		boolean isFindId = url.indexOf("findId") != -1;
		boolean isFindpw = url.indexOf("getEmailToPw") != -1;
		boolean isGetEmailToId = url.indexOf("getEmailToId") != -1;
		boolean isTerms = url.indexOf("/techtalk/terms.do") != -1;
		boolean isPolicy = url.indexOf("/techtalk/policy.do") != -1;
		boolean isNotAjax = url.indexOf("X.do") != -1;
		 
			

		return isListBoardItem || isAddBoardItem || isViewBoardItem || isLoginPage || isLogin || 
				isMemberJoinForm  || isFile || isFindId
				|| isFindpw || isGetEmailToId || isTerms || isPolicy || isNotAjax;
	}


}
