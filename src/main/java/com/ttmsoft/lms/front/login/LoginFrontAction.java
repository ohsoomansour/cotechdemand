package com.ttmsoft.lms.front.login;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.intercept.SessionCheckService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.AES256Util;
import com.ttmsoft.toaf.util.CommonUtil;

@Controller
@RequestMapping ("/techtalk")
public class LoginFrontAction extends BaseAct{
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	@Autowired
	private LoginFrontService loginFrontService;
	
	@Autowired
	private SessionCheckService sessionCheckService;
	
	@Autowired
	private CommonUtil CommonUtil;
	
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
	public ModelAndView doFormLogin (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		String sessionKey = request.getSession().getId();
		paraMap.put("sesskey", sessionKey);
		
		ModelAndView mav = new ModelAndView("/techtalk/front/login/login.login");
		
		paraMap.put("board_seq", 100);			
		
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
	public ModelAndView doFrontLogin (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request,HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		// 예외상황에 대한 기본 오류 정보 선언
		String error_code = "1";
		String error_mesg = "로그인 실패 했습니다.";
				
		try {
			
			HttpSession session = request.getSession();
					
			if (logger.isDebugEnabled()) {
				logger.debug("로그인 ==> " + paraMap.get("userid") + "|" + paraMap.get("userpw"));
			}
			System.out.println("###id"+paraMap);
			if (this.loginFrontService.doCountId(paraMap) == 0) {
				error_code = "2"; 
				error_mesg = "존재하지 않는 아이디입니다."; throw new Exception();
			}
			else {
				paraMap.put("pw", AES256Util.strEncode(paraMap.get("pw").toString()));
				
				if (this.loginFrontService.doCountUserInfo(paraMap) == 0) {
					this.loginFrontService.doUpdatePwInvalid(paraMap);
					int pwInvalidCount = this.loginFrontService.doGetPwInvalid(paraMap);
					error_code = "3"; 
					error_mesg = "비밀번호를 다시 한번 확인해주세요. [현재 비밀번호 틀린 횟수 : " + pwInvalidCount + "회]";
					throw new Exception();
				}
			
				DataMap userMap = this.loginFrontService.doGetOneUserInfo(paraMap);

				if (logger.isDebugEnabled()) {
					logger.debug("로그인 결과==> " + userMap.toString());
				}
				
				int count = this.loginFrontService.doCountUserInfo(paraMap);
				if(count > 0) {
					// 세션에 사용자정보 담기
					this.addFrontSessionLoginInfo(session, userMap);
					paraMap.put("userid", String.valueOf(userMap.get("id")));
					paraMap.put("userno", String.valueOf(userMap.get("member_seqno")));
					
					this.appendSessionInfo(paraMap, request);					// 유저 세션 정보 기록
					this.loginFrontService.doUpdateInvalidCountReset(paraMap);	// 로그인 성공 시 비밀번호 오류 횟수 초기화
					mav.addObject("result_code", "0");
					Cookie cookie = new Cookie("rememberId", String.join(",", paraMap.getstr("id")));
		            cookie.setMaxAge(30*24*60*60); // 쿠키의 유효 시간 (초)
		            response.addCookie(cookie);
				}
			}
//			String [] rolelist = userMap.get("roles").toString().split(",");		
//			userMap.put("rolelist"		, rolelist);
//			
//			int count = this.loginService.doCountAdminMenuAuth(userMap);
//
//			if(count > 0) {
//				userMap.put("roleyn", "Y");
//			}else {
//				userMap.put("roleyn", "N");
//			}
//			
//			if(count > 0) {
//				// 사용자정보 및 기본권한을 세션에 담는다.
//				this.addSessionLoginInfo(session, userMap);
//				// 권한 리스트를 세션 정보에 담는다.
//				paraMap.put("userno", String.valueOf(userMap.get("userno")));
//				paraMap.put("siteid", String.valueOf(userMap.get("siteid")));
//				this.appendConnectInfo(paraMap, request);	// 접속 로그 기록
//				this.appendSessionInfo(paraMap, request);	// 유저 세션 정보 기록
//				DataMap results = new DataMap();
//				results.put("item", userMap);
//				mav.addObject("result_code", "0");
//				mav.addObject("results", results);
//			}
//			else {
//				mav.addObject("result_code", "1");
//				mav.addObject("result_mesg", "해당 아이디는 관리자 권한이 없습니다.");
//			}
			
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
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그인 폼(아이디 찾기 / 비밀번호 찾기)
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/loginForm.do")
	public ModelAndView doLoginForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/login/loginForm.frontPopup");
		try {
			mav.addObject("mode", paraMap.get("mode"));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그인 폼(아이디 찾기)
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/findId.do")
	public ModelAndView doFindId (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			System.out.println("paraMap : " + paraMap.toString());
			System.out.println("check : " + loginFrontService.doFindId(paraMap));
			if(loginFrontService.doFindId(paraMap) != null) {
				mav.addObject("result_check", "1");
				mav.addObject("userInfo", loginFrontService.doFindId(paraMap));
			}
			else {
				mav.addObject("result_check", "0");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 이메일로 완전한 아이디 받기
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/getEmailToId.do")
	public ModelAndView doGetEmailToId (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			System.out.println("paraMap : " + paraMap.toString());
			
			/*SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(paraMap.get("saveEmail").toString());
			message.setSubject("아이디 찾기");
			message.setText("아이디는 " + paraMap.get("saveId").toString() + "입니다.");
			javaMailSender.send(message);*/
			paraMap.put("user_email", paraMap.get("user_email").toString());
			/*
			HttpSession session = request.getSession();
			String user_email = session.getAttribute("user_email").toString();
			*/
			paraMap.put("subject", "[바우처사업관리시스템] 아이디 찾기");
			String text = "아이디는 " + paraMap.get("saveId").toString() + "입니다.";
			paraMap.put("text", text);
			CommonUtil.doMailSender(paraMap);
			this.loginFrontService.doFindId(paraMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 로그인 폼(비밀번호 찾기)
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/findPw.do")
	public ModelAndView doFindPw (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			System.out.println("paraMap : " + paraMap.toString());
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 19.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 이메일로 임시비밀번호 받기
	 * @Explain  : 
	 *
	 */
	@RequestMapping ("/getEmailToPw.do")
	public ModelAndView doGetEmailToPw (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			System.out.println("paraMap : " + paraMap.toString());
			
			if(loginFrontService.doFindPw(paraMap) == null) {
				//mav.addObject("result_check", "1");
				/*String pw = CommonUtil.randomString();
								
				SimpleMailMessage message = new SimpleMailMessage();
				message.setFrom("rndvoucher@compa.re.kr");
				message.setTo(paraMap.get("user_email").toString());
				message.setSubject("임시비밀번호");
				message.setText("임시비밀번호는 " + pw + "입니다. 임시비밀번호로 로그인 해주세요.");
				javaMailSender.send(message);
				
				System.out.println(AES256Util.strEncode(pw));
				
				paraMap.put("pw", AES256Util.strEncode(pw));
				
				*/
				
				String pw = CommonUtil.randomString();
				paraMap.put("user_email", paraMap.get("user_email").toString());
				/*
				HttpSession session = request.getSession();
				String user_email = session.getAttribute("user_email").toString();
				*/
				paraMap.put("subject", "[바우처사업관리시스템] 임시 비밀번호 발송");
				paraMap.put("pw", AES256Util.strEncode(pw));
				String text = "임시비밀번호는 " + pw + "입니다. 임시비밀번호로 로그인 해주세요.";
				paraMap.put("text", text);
				CommonUtil.doMailSender(paraMap);
				this.loginFrontService.doUpdateTempPw(paraMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 4.
	 * @Parm	 : DataMap
	 * @Return   : 1 or 0
	 * @Function : 쿠키에 아이디값 저장하기
	 * @Explain  : 
	 *
	 */
	public int createCookie(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		int result = 0;
		try {
		String id = paraMap.getstr("id");
		Cookie cookie = new Cookie("id",id);
		cookie.setDomain("cookieId");
		cookie.setPath("/");
		// 1달간 저장
		cookie.setMaxAge(60*60^24*30);
		cookie.setSecure(true);
		response.addCookie(cookie);
		}catch(Exception e) {
			result=1;
		}
		return result;
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
	private void addFrontSessionLoginInfo (HttpSession session, DataMap userMap) {		
		session.setAttribute("member_seqno", userMap.get("member_seqno").toString());
		session.setAttribute("member_type", userMap.get("member_type").toString());
		session.setAttribute("id", userMap.get("id").toString());
		session.setAttribute("user_name", userMap.get("user_name").toString());
		session.setAttribute("user_email", userMap.get("user_email").toString());
		session.setAttribute("user_depart", userMap.get("user_depart").toString());
		session.setAttribute("user_rank", userMap.get("user_rank").toString());
		session.setAttribute("pw_temp_flag", userMap.get("pw_temp_flag").toString());
		session.setAttribute("pw_next_change_date", userMap.get("pw_next_change_date").toString());
		session.setAttribute("agree_flag", userMap.get("agree_flag").toString());
		session.setAttribute("delete_flag", userMap.get("delete_flag").toString());
		session.setAttribute("biz_name", userMap.get("biz_name").toString());
		
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
}
