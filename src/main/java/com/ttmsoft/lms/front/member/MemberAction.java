package com.ttmsoft.lms.front.member;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
 
@Controller
@RequestMapping(value="/admin")
public class MemberAction extends BaseAct{

	@Autowired
	private MemberService memberService;

	@Autowired
	private CodeService codeService;

	@Value ("${siteid}")
	private String			siteid;
	/**
	 *
	 * @Author   : osooman
	 * @Date	 : 2023. 8. 31
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 
	 * @Explain  : 일반회원 관리
	 *
	 */

	@RequestMapping(value = "/member.do")
	public ModelAndView doMemberManagement (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/admin/member/member/adminMember.front");
		paraMap.put("siteid", siteid);   // {siteid=ttmsoft}
		
		try {
			String member_type = (String) session.getAttribute("member_type");
			String  id = (String) session.getAttribute("id");
			//'비로그인'의 경우 
			if(Objects.isNull(id)){

				mav.setViewName("redirect:/techtalk/login.do");
				return mav;

			}//'로그인'의 경우
			else if(!Objects.isNull(id)){
				if(member_type.equals("ADMIN")) {
					//----------------- 가이드 등록 여부 확인 Y/N 옵션 -------------------
					List<String> guideList = new ArrayList<String>(Arrays.asList("Y", "N")); //
					mav.addObject("guideList", guideList);
					return mav;
				} else {
					mav.setViewName("redirect:/");
					return mav;
				}
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	

	private boolean isNull() {
		// TODO Auto-generated method stub
		return false;
	}



	/**
	 *
	 * @Author   : osooman
	 * @Date	 : 2023. 8. 31
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listMemberX.do")   
	public ModelAndView doListMember (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {		
			// 총 데이터 갯수
			int totalCount = memberService.doCountVMember(paraMap);	
			System.out.println("totalCount:" + totalCount);
			// 총 페이지 갯수
			int totalPage  = (totalCount -1)/Integer.parseInt((String)paraMap.get("rows")) + 1;	
			System.out.println("totalPage:" + totalPage);
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",   totalPage);
			// 현재 페이지
			mav.addObject("page",    paraMap.get("page"));
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			System.out.println("검색:" + memberService.doGetMemberInfoData(paraMap));
			//여기서 부터 디버깅 시작! 
			mav.addObject("rows",   memberService.doGetMemberInfoData(paraMap));
			
			// --------------------------------------------------------------------------
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}

	/**
	 * @Author   : osooman
	 * @Date	 : 2023. 8. 31
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 멤버폼
	 * @Explain  : 
	 *
	 */
	
	@RequestMapping(value="/agreeMemberAuthX.do")
	public ModelAndView doMovePopMemberAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/techtalk/admin/member/member/adminMemberForm.front_popup");
		HttpSession session = request.getSession(); //1. 요청 세션을 얻고
		String sessionId = (String)session.getAttribute("id"); //2. id에 대한 세션값을 얻고
		String memberType = (String)session.getAttribute("member_type");
		System.out.println("sessionID:" + sessionId);
		System.out.println("member_type:" + memberType);
		
		paraMap.put("sessionid", sessionId); // 3. 확인사항: ADMIN만 승인완료하면 DB에 membertype을 확인 ? Y/N
		paraMap.put("member_type", memberType);
		mav.addObject("mode", paraMap.get("mode"));  
		mav.addObject("seqno", paraMap.get("seqno"));
		System.out.println("agreeMemberAuth" + mav); // agreeMemberAuth 넘어오는 값{mode=Y, seqno=4}
		try {
			//1.가입 승인 'Y' => 승인 로직
			if(paraMap.get("mode").equals("Y")) {		 
				mav.addObject("authLookUpList", memberService.doUpdateAgreement(paraMap));
				
			}
			else if(paraMap.get("mode").equals("N")) {		// 권한 수정 시 데이터	셋팅
				mav.addObject("authKindsList", memberService.doListAuthKinds(paraMap));				
			}
	
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}

	@RequestMapping(value="/joinAgreementConfirmX.do")
	public ModelAndView confirmJoinApproved(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		mav.addObject("seqno", paraMap.get("seqno"));
		
		try {
			//2. DB에서 agree_flag 'Y'값인지 확인해서 
			if(memberService.getJoinApprovedFlag(paraMap).get("agree_flag").equals("Y")) {
				mav.addObject("joinApprovedConfirm", memberService.getJoinApprovedFlag(paraMap));  
				return mav;
			} else if(memberService.getJoinApprovedFlag(paraMap).get("agree_flag").equals("N")) {
				System.out.println("가입승인: 'N'상태입니다. ");
				mav.addObject("joinApprovedConfirm", memberService.getJoinApprovedFlag(paraMap));
				return mav;
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
	 * @Date	 : 2020. 3. 27
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 멤버권한정보가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listMemberAuthX.do")
	public ModelAndView doListMemberAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		
		try {
			mav.addObject("memberAuthList", memberService.doListMemberAuth(paraMap));		//수정 버튼 클릭 한 사용자 정보 가져오기
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 16
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 멤버권한수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/updateMemberAuthX.do")
	public ModelAndView doUpdateMemberAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("seq_tblnm", "TU_USER_ROLE");
		paraMap.put("reguid", request.getSession().getAttribute("userid"));
		paraMap.put("moduid", request.getSession().getAttribute("userid"));
		paraMap.put("siteid", siteid);
		
		try {
			//사용자 선택 권한 리스트			
			String[] strAuths = request.getParameterValues("authCode");	
			List<String> list = new ArrayList<String>();
			
			for(int i = 0; i < strAuths.length; i++) {
				list.add(strAuths[i]);
			}
			
			paraMap.put("list", list);
			memberService.doUpdateMemberAuth(paraMap);			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
}
