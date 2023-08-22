package com.ttmsoft.lms.cmm.intercept;

import java.util.Locale;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.StringUtil;

@Component
public class DefaultCheck extends HandlerInterceptorAdapter {
	private Logger	logger	= LoggerFactory.getLogger(this.getClass());

	@Value ("${siteid}")
	private String			siteid;
	
	@Autowired
	private DefaultCheckService	defaultCheckService;

	@Autowired
	private LocaleResolver		localeResolver;


	public boolean preHandle (HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		HttpSession session = request.getSession();

		logger.info("DefaultCheck start!!");
		
		if (logger.isDebugEnabled() && session.getAttribute("userno") != null) {			
//			logger.debug("DefaultCheck Interceptor !!!!"+session.getAttribute("role_pcd").toString());
//			logger.debug("=====>userid : "+session.getAttribute("userid").toString());
//			logger.debug("=====>userno : "+session.getAttribute("userno").toString());
//			logger.debug("=====>siteid : "+session.getAttribute("siteid").toString());
//			logger.debug("=====>requri : "+request.getRequestURI());
		}

		this.initLanguage(request, response);

		if (isCheck(request)) {
			//logger.debug("isCheck=====>"+session.getAttribute("role_pcd").toString());

			DataMap paraMap = new DataMap();

			// 파라미터 정의
			this.initParamUserMap(request, paraMap); // request 파라미터를 DataMap 객체로 세팅
			this.initParamMenuMap(request, paraMap); // menuno 파라미터 정의

			 // 현재 메뉴 정보 조회
			 // false 결과값 : 1뎁스 메뉴로 내부에서 2뎁스 메뉴로 이동 시키고 현재 요청은 종료한다.
			try {
				if (!this.initMenuInfo(request, response, paraMap)) { 
					return false; 
				}
			}catch(Exception e){
				response.sendRedirect("/front/login.do");
				return false;
			}
			// 사용권환(등록, 수정, 삭제) 정보 조회
			if (!this.initUseAuth(request, response, paraMap)) {
				return false;
			}			

			// 메뉴 리스트 조회
			request.setAttribute("menu_list", this.defaultCheckService.getMenuListJson(request, paraMap));
			// 쪽지 정보
//			request.setAttribute("mesg_info", this.defaultCheckService.getMessageMap(paramMap));
		}

		return true;
	}

	/**
	 * 언어 세팅
	 *
	 * @param request
	 */
	private void initLanguage (HttpServletRequest request, HttpServletResponse response) {
		String sssLang	= StringUtil.nchk((String)request.getSession().getAttribute("sess_lang"));
		String reqLang	= request.getHeader("Accept-Language");

		if ("".equals(sssLang)) {
			if (reqLang != null && reqLang.length() > 1) {
				sssLang = reqLang.substring(0, 2).toLowerCase();
				localeResolver.setLocale(request, response, new Locale(sssLang));
			}
		}

		request.getSession().setAttribute("sess_lang", sssLang);
	}


	/**
	 * 메뉴 조회 필요여부 조회
	 *
	 * @param request
	 * @return
	 */
	private boolean isCheck (HttpServletRequest request) {
		String uri = request.getRequestURI().replaceAll("[0-9]", "");
		boolean isNotXreq = !StringUtil.trim(request.getHeader("X-Requested-With")).equals("XMLHttpRequest");
		boolean isNotUpload = uri.indexOf("/file/") == -1;
		boolean isNotPopup = uri.indexOf("P.do") == -1;
		boolean isNotFrame = uri.indexOf("F.do") == -1;
		boolean isNotIFrame = uri.indexOf("I.do") == -1;
		boolean isNotAjax = uri.indexOf("X.do") == -1;
		boolean isNotLogin = uri.indexOf("login.do") == -1;
		
		return isNotXreq && isNotUpload && isNotPopup && isNotFrame && isNotIFrame && isNotAjax && isNotLogin;
	}



	/**
	 * DefaultCheck 에서 사용하기 위한 파라미터 Map 설정
	 *
	 * @param request
	 * @param paramMap
	 */
	private void initParamUserMap (HttpServletRequest request, DataMap paramMap) {
		HttpSession session = request.getSession();

		if(null != session.getAttribute("userno")) {			
			
			if(session.getAttribute("roles") != null) {
				String [] rolelist = session.getAttribute("roles").toString().split(",");
				paramMap.put("rolelist"		, rolelist);
			}
			
			paramMap.put("userid"		, session.getAttribute("userid"));
			paramMap.put("userno"		, session.getAttribute("userno"));
					
		}else {		// 게스트일경우		 
			paramMap.put("guest", "ROLE_P000");
		}	

		paramMap.put("siteid",siteid);
		String parameter = "";
		if(null != request.getParameter("menuSeq")) {
			parameter = "?menuSeq=" + request.getParameter("menuSeq");
		}else if(null != request.getParameter("board_seq")) {
			parameter = "?board_seq=" + request.getParameter("board_seq");
		}
		paramMap.put("requri"		, request.getRequestURI() + parameter);
	}

	/**
	 * @param request
	 * @param dataMap
	 */
	private void initParamMenuMap (HttpServletRequest request, DataMap dataMap) {
		HttpSession session = request.getSession();

		if (!StringUtil.isEmpty(request.getParameter("menuno"))) {
			session.setAttribute("menuno", request.getParameter("menuno"));
			dataMap.put("menuno", request.getParameter("menuno"));
		}
		else {
			dataMap.put("menuno", session.getAttribute("menuno"));
		}
	}


	/**
	 * 현재 선택된 메뉴 정보를 세션에 저장
	 *
	 * @param request
	 * @param paramMap
	 */
	private boolean initMenuInfo (HttpServletRequest request, HttpServletResponse response, DataMap paramMap) {
		request.getSession().setAttribute("menu_info", this.defaultCheckService.getoneMenuInfoJson(request, paramMap));
		return true;
	}
	
	private boolean initUseAuth (HttpServletRequest request, HttpServletResponse response, DataMap paramMap) {
		request.getSession().setAttribute("use_auth", this.defaultCheckService.getUseAuthJson(request, paramMap));
		return true;
	}

}
