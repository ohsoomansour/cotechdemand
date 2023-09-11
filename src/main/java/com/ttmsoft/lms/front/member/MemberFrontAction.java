package com.ttmsoft.lms.front.member;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.login.LoginFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.AES256Util;
import com.ttmsoft.toaf.util.CommonUtil;

/**
 * 
 * @Package	 : com.ttmsoft.lms.front.member
 * @File	 : MemberJoinFrontAction.java
 * 
 * @Author   : jwchoo
 * @Date	 : 2021. 4. 16.
 * @Explain  : 수업기업/공급기업 회원가입
 *
 */
@Controller
@RequestMapping ("/techtalk")
public class MemberFrontAction extends BaseAct {
	
	@Autowired
	private JavaMailSender javaMailSender;
	
	@Autowired
	private SeqService	seqService;
	
	@Autowired
	private MemberFrontService memberFrontService;
	
	@Autowired
	private LoginFrontService loginFrontService;
	
	@Autowired
	private CommonUtil CommonUtil;
	
	/**
	 *
	 * @Author   : hsLee
	 * @Date	 : 2021. 6. 30. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자 회원가입 동의화면
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberJoinAgreePage.do",  method = RequestMethod.POST)
	public ModelAndView doMemberJoinAgreePage(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberJoinAgree.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "회원가입");
		mav.addObject("navi",navi);
		try {

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : hsLee
	 * @Date	 : 2021. 6. 30. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자 회원가입 정보 입력 화면
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberJoinFormPage.do",  method = RequestMethod.GET)
	public ModelAndView doMemberJoinFormPage(HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberJoinForm.front");
		
		try {
			DataMap paraMap = new DataMap();
			paraMap.put("depth", '1');
			List<DataMap> stdCode = memberFrontService.doGetStdMainCodeInfo(paraMap);
			mav.addObject("stdMainCode", stdCode);
			DataMap navi = new DataMap();
			navi.put("one", "메인");
			navi.put("two", "회원가입");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : hsLee
	 * @Date	 : 2021. 6. 30. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자 회원가입 완료 화면
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberJoinCompletePage.do")
	public ModelAndView doMemberJoinCompletePage(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberJoinComplete.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "회원가입");
		mav.addObject("navi",navi);
		try {

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 16. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자 회원가입 화면
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberJoinPage.do")
	public ModelAndView doMemberJoinPage(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberJoin.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "회원가입");
		mav.addObject("navi",navi);
		try {

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
	 * @Function : 아이디 및 사업자등록번호 중복검사
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberDoubleCheck.do")
	public ModelAndView doMemberDoubleCheck(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("paraMap : " + paraMap.toString());
		try {
			//DB 셋팅 후 사용자 아이디 중복확인 코드 적용 필요
			if(paraMap.get("gubun").equals("ID")) {
				int memberCount = memberFrontService.doCountMemberId(paraMap);
				System.out.println("memberCount : " + memberCount);
				mav.addObject("memberCount", memberCount);
			}
			else {
				int bizRegnoCount = memberFrontService.doCountBizRegno(paraMap);
				System.out.println("bizRegnoCount : " + bizRegnoCount);
				mav.addObject("bizRegnoCount", bizRegnoCount);
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
	 * @Date	 : 2023. 9. 19. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 회원가입
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberJoin.do")
	public ModelAndView doMemberJoin(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("paraMap : " + paraMap);
		
		try {
			LocalDate now = LocalDate.now();
			int month = now.getMonthValue();
			int day = now.getDayOfMonth();

			String pw = paraMap.get("pw").toString();
			paraMap.put("pw", AES256Util.strEncode(pw));
			String text = "귀하께서는 "+month+"월"+day+"일 </br>TECHTALK  회원으로 가입되셨습니다.<br/><br/><br/> ";
					text +="아이디 : "+ paraMap.getstr("id");
			paraMap.put("subject", "[TECHTALK] 회원가입을 환영합니다.");
			paraMap.put("text", text);
			String user_email = paraMap.getstr("user_email1")+"@"+paraMap.getstr("user_email2");
			paraMap.put("user_email", user_email);
			paraMap.put("pw", AES256Util.strEncode(pw));
			//CommonUtil.doMailSender(paraMap);
			
			/*
			String pw = CommonUtil.randomString();
			System.out.println("pw : " + pw);
			
			SimpleMailMessage message = new SimpleMailMessage();
			message.setTo(paraMap.get("user_email").toString());
			message.setSubject("임시비밀번호 발급");
			message.setText("임시비밀번호는 " + pw + "입니다. 임시비밀번호로 로그인 해주세요.");
			javaMailSender.send(message);
			
			System.out.println(AES256Util.strEncode(pw));
			
			
			*/
			
			//DB 셋팅 후 회원 INSERT 관련 코드 입력필요
			this.memberFrontService.doInsertMember(paraMap);
			/*
			 * String notice_title = "바우처사업관리시스템에  회원으로 가입되셨습니다.";
			 * paraMap.put("notice_title", notice_title);
			 */
			//this.memberFrontService.doSMSMember(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 8. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 회원정보관리
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberUpdatePage.do")
	public ModelAndView doMemberUpdatePage(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberUpdateForm.front");
		try {
			paraMap.put("member_seqno", session.getAttribute("member_seqno"));
			mav.addObject("userInfo", memberFrontService.doGetMemberInfo(paraMap));
			paraMap.put("depth","1");
			DataMap navi = new DataMap();
			navi.put("one", "메인");
			navi.put("two", "회원정보관리");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	
	
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 수요기업/공급기업 회원정보관리
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberPrivacyPage.do")
	public ModelAndView doMemberPrivacyPage(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberPrivacy.front");
		try {
			paraMap.put("member_seqno", session.getAttribute("member_seqno"));
			mav.addObject("userInfo", memberFrontService.doGetMemberInfo(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "메인");
			navi.put("two", "회원정보관리");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 수요기업/공급기업  회원정보관리 - 비밀번호 변경폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updatePwForm.do")
	public ModelAndView doUpdatePwForm(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/memberPrivacyForm.frontPopup");
		try {
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 4. 22. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 수요기업/공급기업  회원정보관리 - 비밀번호 변경 확인
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updatePw.do")
	public ModelAndView doUpdatePw(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			System.out.println("paraMap : " + paraMap.toString());
			System.out.println("암호화 : " + AES256Util.strEncode(paraMap.get("pw").toString()));
			paraMap.put("pw", AES256Util.strEncode(paraMap.get("pw").toString()));
			if(loginFrontService.doCountUserInfo(paraMap) == 0) {
				mav.addObject("result_code", "0");
			}
			else {
				mav.addObject("result_code", "1");
				paraMap.put("pw", AES256Util.strEncode(paraMap.get("pw_n").toString()));
				memberFrontService.doUpdatePw(paraMap);
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
	 * @Date	 : 2023. 9. 08. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 마이페이지 정보 변경
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateMember.do")
	public ModelAndView doUpdateMember(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("member_seqno", session.getAttribute("member_seqno"));
			System.out.println("paraMap : " + paraMap.toString());
			int result = memberFrontService.doUpdateMember(paraMap);
			mav.addObject("result", result);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : hsLee
	 * @Date	 : 2021. 7. 5. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 표준산업분류값 가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/doGetStdCodeInfo.do")
	public ModelAndView doGetStdCodeInfo(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("paraMap : " + paraMap.toString());
		try {
			//DB 셋팅 후 사용자 아이디 중복확인 코드 적용 필요
			if(paraMap.get("gubun").equals("mid")) {
				paraMap.put("depth", '2');
			}else if(paraMap.get("gubun").equals("sub")) {
				paraMap.put("depth", '3');
			}else if(paraMap.get("gubun").equals("bot")) {
				paraMap.put("depth", '4');
			}else if(paraMap.get("gubun").equals("sub_bot")) {
				paraMap.put("depth", '5');
			}
			List<DataMap> code = memberFrontService.doGetStdMiddleCodeInfo(paraMap);
			if(paraMap.get("gubun").equals("mid")) {
				mav.addObject("stdCode", code);
			}else if(paraMap.get("gubun").equals("sub")) {
				mav.addObject("stdCode", code);
			}else if(paraMap.get("gubun").equals("bot")) {
				mav.addObject("stdCode", code);
			}else if(paraMap.get("gubun").equals("sub_bot")) {
				mav.addObject("stdCode", code);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : smpark
	 * @Date	 : 2021. 8. 05. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 연구개발서비스협회 등록번호 검색
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/doGetRndBizno.do")
	public ModelAndView doGetRndBizno(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			System.out.println("paraMap : " + paraMap.toString());
			mav.addObject("result", memberFrontService.doGetRndBizno(paraMap));
			
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2021. 11. 08. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사업자등록번호 자동입력
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/memberBizInsert.do")
	public ModelAndView doMemberBizInsert(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("paraMap : " + paraMap);
		try {
			mav.addObject("memberBizInsert", memberFrontService.doMemberBiz(paraMap));
			/*memberFrontService.doMemberBiz(paraMap);
			mav.addObject("paraMap", paraMap);*/
			System.out.println("paraMap2 : " + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 6. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 회사 자동검색
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/autoSearchBusiness.do")
	public ModelAndView doAutoSearchBusiness(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("check paraMap"+paraMap);
		List<DataMap> result = memberFrontService.doAutoSearchBusiness(paraMap);
		mav.addObject("result", result);
		return mav;
	}
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 8. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 임시페이지
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/tempPage1.do")
	public ModelAndView doTempPage1(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/tempPage1.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "임시페이지");
		mav.addObject("navi",navi);
		try {

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 8. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 임시페이지2
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/tempPage2.do")
	public ModelAndView doTempPage2(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/tempPage2.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "임시페이지2");
		mav.addObject("navi",navi);
		try {

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 9. 8. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 임시페이지3
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/tempPage3.do")
	public ModelAndView doTempPage3(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/front/member/tempPage3.front");
		DataMap navi = new DataMap();
		navi.put("one", "메인");
		navi.put("two", "임시페이지2");
		mav.addObject("navi",navi);
		try {

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
	
		return mav;
	}
}
