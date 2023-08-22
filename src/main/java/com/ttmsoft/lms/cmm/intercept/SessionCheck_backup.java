//package com.ttmsoft.lms.cmm.intercept;
//
//import java.io.IOException;
//import java.io.UnsupportedEncodingException;
//import java.net.URLEncoder;
//import java.util.Locale;
//
//import javax.annotation.Resource;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import org.apache.commons.lang.StringUtils;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.MessageSource;
//import org.springframework.stereotype.Component;
//import org.springframework.web.multipart.MultipartHttpServletRequest;
//import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
//
//import com.ttmsoft.lms.cmm.login.LoginService;
//import com.ttmsoft.toaf.object.DataMap;
//import com.ttmsoft.toaf.util.CookieUtil;
//import com.ttmsoft.toaf.util.StringUtil;
//
//@Component
//@SuppressWarnings ({ "unused" })
//public class SessionCheck_backup extends HandlerInterceptorAdapter {
//
//	private Logger				logger	= LoggerFactory.getLogger(this.getClass());
//	private String				message	= "";
//
//	@Autowired
//	private SessionCheckService	sessionCheckService;
//
//	@Autowired
//	private LoginService		loginService;
//	
//	@Autowired
//	private DefaultCheckService	DefaultCheckService;
//
//	protected MessageSource		messageSource;
//
//	@Resource (name = "messageSource")
//	public void setMessageSource (MessageSource messageSource) {
//		this.messageSource = messageSource;
//	}
//
//	public boolean preHandle (HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
//
//		boolean result = false;
//
//		try {	
//			logger.info("share session check !!!!" + getSessionValue(request, "userno"));
//			if ("".equals(getSessionValue(request, "userno"))) {
//				logger.debug("share session check !!");
//				this.makeUserInfoSession(request);
//			}
//
//			// 비로그인 가능 요청인 경우
//			if (this.isNoSessionRequest(request)) {
//				logger.debug("비로그인 가능 요청입니다.");
//				return true;
//			}
//
//			if (logger.isDebugEnabled()) {
//				logger.debug("Session Check Interceptor !!!!");
//				logger.debug("REQUEST HEADER : " + request.getHeader("X-Requested-With"));
//				logger.debug(request.getServerName());
//				logger.debug(request.getRequestURI());
//				logger.debug("sesskey : " + request.getSession().getId());
//				logger.debug("userid : " + getSessionValue(request, "userid"));
//				logger.debug("userno : " + getSessionValue(request, "userno"));
//				logger.debug("usernm : " + getSessionValue(request, "usernm"));
//				logger.debug("orgno : " + getSessionValue(request, "orgno"));
//			}
//			result = this.isAvailableSession(request, response);
//		}
//		catch (Exception e) {
//			if (logger.isDebugEnabled()) {
//				e.printStackTrace();
//				logger.debug(" Exception - preHandle : " + e.toString());
//			}
//		}
//
//		// 로그인 설정 요청 반환
//		return result;
//	}
//
//	private void makeUserInfoSession (HttpServletRequest request) {
//		
//		try {
//			
//			HttpSession session = request.getSession();
//
//			DataMap dataMap = new DataMap();
//			dataMap.put("sesskey", session.getId());
//			DataMap sessMap = this.sessionCheckService.getoneSessionByKey(dataMap);
//			
//			if (sessMap != null) {
//				sessMap.put("siteid", request.getAttribute("siteid"));
//				sessMap.put("autologin", "Y"); // 비밀번호 체크 안함
//
//				DataMap userMap = loginService.getoneUserInfo(sessMap);
//				
//				String [] rolelist = userMap.get("roles").toString().split(",");
//				
//				userMap.put("rolelist"		, rolelist);
//				
//				int count = DefaultCheckService.doCountAdminMenuAuth(userMap);
//				
//				if(count > 0) {
//					userMap.put("roleyn", "Y");
//				}else {
//					userMap.put("roleyn", "N");
//				}
//						
//				this.addSessionLoginInfo(session, userMap);
//			}
//		}
//		catch (Exception e) {
//			if (logger.isDebugEnabled()) {
//				logger.debug(" Exception - makeUserInfoSession : " + e.toString());
//			}
//		}
//	}
//
//	private void addSessionLoginInfo (HttpSession session, DataMap userMap) {
//		
//		session.setAttribute("userno", userMap.get("userno").toString()); 	// 회원 번호
//		session.setAttribute("userid", userMap.get("userid").toString());	// 회원 아이디
//		session.setAttribute("usernm", userMap.get("usernm").toString());	// 회원 이름
//		session.setAttribute("posnm", userMap.get("posnm").toString());		// 신분명
//		session.setAttribute("roles", userMap.get("roles").toString());		// 권한리스트
//		session.setAttribute("orgno", userMap.get("orgno").toString());		// 조직 번호
//		session.setAttribute("orgnm", userMap.get("orgnm").toString());		// 조직 이름
//		session.setAttribute("email", userMap.get("email").toString());		// 메일주소
//		session.setAttribute("photo", userMap.get("photo").toString());		// 프로필 이미지
//		session.setAttribute("roleyn", userMap.get("roleyn").toString());	// 권연 여부
//		session.setAttribute("siteid", userMap.get("siteid").toString());	// SITEID
//	}
//
//	/**
//	 * SessionInterceptor 에서 로그인 필요 요청에 관련된 리턴 유형 설정
//	 *
//	 * @param request
//	 * @param response
//	 * @return false : 오류 메세지 출력과 함께 요청 종료, true : 요청 진행
//	 * @throws IOException
//	 */
//	private boolean isAvailableSession (HttpServletRequest request, HttpServletResponse response) throws IOException {
//
//		if (this.isNologin(request) || this.hasNoAdminRole(request)) {
//			if (logger.isDebugEnabled()) {
//				logger.debug(this.message);
//			}
//			return this.returnErrorMessage(request, response);
//		}
//		/* 중복로그인 체크 개발기간동안은 편의성을 위해  주석처리함..
//		if(this.isDupleLogin(request)){
//			if (logger.isDebugEnabled()) {
//				logger.debug(this.message);
//			}
//			return this.returnErrorMessage(request, response);
//		}
//		*/
//		return true;
//	}
//
//	/**
//	 * 중복 로그인 체크
//	 *
//	 * @param request
//	 * @return
//	 */
//	private boolean isDupleLogin (HttpServletRequest request) {	
//		
//		this.message = "다른 PC에서 로그인 되었습니다.";	// "다른 PC 에서 로그인 되었습니다.";
//
//		DataMap paramMap = new DataMap();
//		paramMap.put("sesskey", request.getSession().getId());
//		paramMap.put("userno", getSessionValue(request, "userno"));
//
//		DataMap sessMap = this.sessionCheckService.getoneSessionInfo(paramMap);
//
//		if (sessMap != null && sessMap.get("useyn").equals("N")) {
//			request.getSession().invalidate();
//			this.sessionCheckService.removeSessionInfo(sessMap);
//			return true;
//		}
//	
//		return false;
//	}
//
//	/**
//	 * SessionInterceptor 에서 사용하는 세션값 리턴
//	 *
//	 * @param request
//	 * @param str
//	 * @return
//	 */
//	private String getSessionValue (HttpServletRequest request, String str) {
//		return StringUtil.trim(request.getSession().getAttribute(str));
//	}
//
//	/**
//	 * 비로그인 상태인 경우 메세지와 false 리턴
//	 *
//	 * @param request
//	 * @return
//	 */
//	private boolean isNologin (HttpServletRequest request) {		
//		this.message = "로그인 후 이용하실 수 있습니다.";	// "로그인 후 이용하실 수 있습니다.";
//		return getSessionValue(request, "userno").equals("");
//	}
//
//	/**
//	 * 관리자 요청 페이지지만 현재 사용자 그룹이 관리자 그룹이 아닌경우 false 리턴
//	 *
//	 * @param request
//	 * @return
//	 */
//	private boolean hasNoAdminRole (HttpServletRequest request) {
//		
//		this.message = "권한이 없습니다.";	// "권한이 없습니다.";
//
//		boolean isAdminUri = request.getRequestURI().indexOf("/admin/") != -1;	
//		//boolean isNoAdminGroup = getSessionValue(request, "orgno").toString().indexOf("TTM-00001") == -1;	
//		boolean isNoAdminRole = getSessionValue(request, "roleyn").equals("N");
//		
//		logger.info("isAdminUri : " + isAdminUri);
//		logger.info("isNoAdminRole : " + isNoAdminRole);
//		
//		return isAdminUri && isNoAdminRole;
//	}
//
//	/**
//	 * 오류 메세지를 response 객체에 출력하고 종료(false)
//	 *
//	 * @param request
//	 * @param response
//	 * @return
//	 * @throws IOException
//	 */
//	private boolean returnErrorMessage (HttpServletRequest request, HttpServletResponse response) throws IOException {
//
//		boolean isNotAjaxRequest = !StringUtils.trimToEmpty(request.getHeader("X-Requested-With")).equals("XMLHttpRequest");
//
//		if (isNotAjaxRequest) {
//
//			Locale locale = new Locale(String.valueOf(request.getSession().getAttribute("sess_lang")));
//			//String [] arrUri = request.getRequestURI().split("/");			
//			String strUrl = "login/login.do";
//			
//			StringBuilder strBuiler = new StringBuilder();
//			strBuiler.append("<SCRIPT type=text/javascript>				");
//
//			if (this.message.indexOf("common.") > -1) {	// 경고메세지 properties
//				//strBuiler.append("	alert('").append(this.messageSource.getMessage(message, null, locale)).append("');	");
//			}
//			else if (!this.message.equals("")) {	// 경고메세지 string
//				//strBuiler.append("	alert('").append(message).append("');	");
//			}
//
//			if (String.valueOf(request.getParameter("ispopup")).equals("Y")) {	// 팝업인 경우
//				strBuiler.append("	self.close();	\n");
//			}
//			else { // 팝업이 아닌경우
//				//strBuiler.append("	top.location='/").append(strUrl).append("'; ");
//				strBuiler.append("	top.location='/").append(strUrl).append("'; ");
//			}
//
//			strBuiler.append("</SCRIPT>					 				");
//
//			response.setContentType("text/html; charset=UTF-8");
//			response.getWriter().print(strBuiler.toString());
//
//			// 오류 메세지 출력 후 세션의 메뉴 아이디를 삭제해 준다.
//			request.getSession().setAttribute("menuno", "");
//		}
//		else {
//			if (logger.isDebugEnabled()) logger.debug("AJAX SESSION EXPIRED !!!");
//			response.sendRedirect("/login/sessionExpired.do");
//		}
//
//		return false;
//	}
//
//	/**
//	 * 세션 체크가 필요없는 요청에 대해 true를 리턴하여 세션 체크를 하지 않는다.
//	 *
//	 * @param request
//	 * @return
//	 */
//	private boolean isNoSessionRequest (HttpServletRequest request) {
//		
//		String url = request.getRequestURI();
//
//		boolean isMainRequest = url.indexOf("/main/") != -1;
//		boolean isUploadRequest = request instanceof MultipartHttpServletRequest;
//		boolean isLoginRequest = url.indexOf("/login/") != -1;
//		boolean isPrototypeRequest = url.indexOf("/proto/") != -1;
//		boolean isMemberJoinRequest = url.indexOf("/member/join/") != -1;
//		boolean isSiteMap = url.indexOf("/sitemap/") != -1;
//		boolean isSvc = url.indexOf("svc/") != -1;
//		// 추후 수정해야함..
//		boolean isFrontRequest = (url.indexOf("/front/") != -1 && url.indexOf("/mypage/") == -1 
//				&& url.indexOf("listFrontCmptnPaper.do") == -1 && url.indexOf("listFrontSurveyPaper.do") == -1);
//
//		return isMainRequest || isUploadRequest || isLoginRequest || isPrototypeRequest || isMemberJoinRequest || isSiteMap || isSvc || isFrontRequest;
//	}
//
//
//}
