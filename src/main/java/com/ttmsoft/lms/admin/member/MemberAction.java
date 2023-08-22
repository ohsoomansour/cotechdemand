package com.ttmsoft.lms.admin.member;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.lms.admin.system.CodeService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

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
	 * @Author   : jwchoo
	 * @Date	 : 2020. 3. 19
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자관리페이지이동
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/member.do")
	public ModelAndView doMoveMember (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/admin/member/member/adminMember.admin");
		paraMap.put("siteid", siteid);
		try {			
			paraMap.put("commcd_gcd", "USER_SCD");
			mav.addObject("stateList", codeService.doListSubCodeInfo(paraMap));
			paraMap.put("commcd_gcd", "GENDER_PCD");
			mav.addObject("genderList", codeService.doListSubCodeInfo(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 3. 19
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 사용자리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listMember.do")
	public ModelAndView doListMember (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);

		try {		
			// 총 데이터 갯수
			int totalCount = memberService.doCountMember(paraMap);	
			// 총 페이지 갯수
			int totalPage  = (totalCount -1)/Integer.parseInt((String)paraMap.get("rows")) + 1;	
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",   totalPage);
			// 현재 페이지
			mav.addObject("page",    paraMap.get("page"));
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",    memberService.doListMember(paraMap));
			// --------------------------------------------------------------------------
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}

	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 3. 23
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 멤버폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/movePopMemberAuth.do")
	public ModelAndView doMovePopMemberAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		ModelAndView mav = new ModelAndView("/lms/admin/member/member/adminMemberForm.adminPopup");
		paraMap.put("siteid", siteid);
		mav.addObject("mode", paraMap.get("mode"));
		mav.addObject("userno", paraMap.get("userno"));
		mav.addObject("userInfo", memberService.doGetMemberInfo(paraMap));
		try {
			if(paraMap.get("mode").equals("L")) {		//	권한 조회 시 데이터 셋팅
				mav.addObject("authLookUpList", memberService.doListAuthLookUp(paraMap));
			}
			else if(paraMap.get("mode").equals("U")) {		// 권한 수정 시 데이터	셋팅
				mav.addObject("authKindsList", memberService.doListAuthKinds(paraMap));				
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
	@RequestMapping(value="/listMemberAuth.do")
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
	@RequestMapping(value="/updateMemberAuth.do")
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
