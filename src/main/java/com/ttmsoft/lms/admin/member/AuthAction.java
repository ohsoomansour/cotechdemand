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
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

@Controller
@RequestMapping(value="/admin")
public class AuthAction extends BaseAct{
	
	@Autowired
	private AuthService authService;
	
	@Autowired
	private SeqService	seqService;
	
	@Value ("${siteid}")
	private String siteid;
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 3. 23
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 권한관리페이지이동
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/auth.do")
	public ModelAndView doAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		
		ModelAndView mav = new ModelAndView("/lms/admin/member/auth/adminAuth.admin");
		paraMap.put("siteid", siteid);
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 3. 23
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 권한리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listAuth.do")
	public ModelAndView doListAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("locale", RequestContextUtils.getLocale(request).toString());
		try {
			// 총 데이터 갯수
			int totalCount = authService.doCountAuth(paraMap);
			logger.info("권한종류 리스트 : " + totalCount);
			
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
			mav.addObject("rows",    authService.doListAuth(paraMap));
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
	 * @Date	 : 2020. 4. 21
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 권한 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/movePopAuth.do")
	public ModelAndView doMovePopAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		
		ModelAndView mav = new ModelAndView("/lms/admin/member/auth/adminAuthForm.adminPopup");
		paraMap.put("siteid", siteid);
		mav.addObject("mode", paraMap.get("mode"));
		try {
			if(paraMap.get("mode").equals("U")) {
				mav.addObject("authInfo", authService.doGetAuthInfo(paraMap));
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
	 * @Date	 : 2020. 4. 21
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 코드 중복체크
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/codeCheck.do")
	public ModelAndView doCodeCheck(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		
		try {
			int check = authService.doCheckCodeOverlap(paraMap);
			logger.info("실시간 코드 체크 : " + check);
			mav.addObject("check", check);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 21
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 권한 등록 및 수정 및 삭제
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/authOption.do")
	public ModelAndView doAuthOption(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		paraMap.put("seq_tblnm", "TA_MENU_AUTH");
		try {
			logger.info("코드관련 데이터들 : " + paraMap.toString());
			
			if(paraMap.get("mode").equals("I")) {
				List<DataMap> list = new ArrayList<DataMap>();
				List<DataMap> menuAllList = authService.doListMenuAllData(paraMap);
				
				for(int i = 0; i < menuAllList.size(); i++) {					
					DataMap data = new DataMap();		
					data.put("menuauth_seq", seqService.doAddAndGetSeq(paraMap));
					data.put("menucd", menuAllList.get(i).get("menucd"));
					list.add(data);
				}
				
				paraMap.put("list", list);
				authService.doInsertAuth(paraMap);
				
			}else if(paraMap.get("mode").equals("U")) {				
				authService.doUpdateAuth(paraMap);
				
			}else if(paraMap.get("mode").equals("D")) {	
				int memberAuthCnt = authService.doCountAuthOfMemberAuth(paraMap);
				
				if(memberAuthCnt == 0) {
					authService.doDeleteAuth(paraMap);
				}
				
				mav.addObject("memberAuthCnt", memberAuthCnt);				
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
	 * @Date	 : 2020. 3. 25
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 메뉴트리리스트조회
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="/listTreeAuth.do")
	public ModelAndView doListTreeAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("locale", RequestContextUtils.getLocale(request).toString());
		try {
			//관리자 메뉴 불러오기
			paraMap.put("menu_tcd", "MENU_T004");
			List<DataMap> adminMenuList_A = authService.doListAuthTree(paraMap);	
			String strMenuTree_A = stringChange(adminMenuList_A);
			mav.addObject("strMenuTree_A", strMenuTree_A);
			
			//홈페이지 메뉴 불러오기			
			paraMap.put("menu_tcd", "MENU_T001");
			List<DataMap> adminMenuList_H = authService.doListAuthTree(paraMap);	
			String strMenuTree_H = stringChange(adminMenuList_H);
			mav.addObject("strMenuTree_H", strMenuTree_H);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 5. 7
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 각 메뉴 데이터 가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="menuGet.do")
	public ModelAndView doMenuGet(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		try {
			System.out.println("menucd : " + paraMap.get("menucd"));
			mav.addObject("menuInfo", authService.doGetMenu(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 22
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 권한에 따른 메뉴 데이터 가져오기
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="menuDataAuth.do")
	public ModelAndView doMenuDataAuth(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);

		try {
			mav.addObject("authMenuList", authService.doListMenuAuth(paraMap));
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author   : jwchoo
	 * @Date	 : 2020. 4. 22
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 권한 메뉴 저장
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value="saveMenu.do")
	public ModelAndView doSaveMenu(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));

		try {
			//USEYN이 Y인 메뉴선택데이터
			String[] menuCodeNum = request.getParameterValues("authMenuSeq");
			String[] menuUseAuth = request.getParameterValues("useAuth");
			String[] menuStateAuth = request.getParameterValues("authMenuState");

			if(menuCodeNum != null && menuUseAuth != null) {			
				List<DataMap> chkedMenuList = new ArrayList<DataMap>();			
				int length = menuCodeNum.length;
				
				for(int i = 0; i < length; i++) {
					
					logger.info("menuCodeNum : " + menuCodeNum[i]);
					
					DataMap data = new DataMap();
					data.put("useyn", "Y");
					data.put("menucd", menuCodeNum[i]);
					data.put("useauth", menuUseAuth[i]);
					data.put("stateauth", menuStateAuth[i]);
					chkedMenuList.add(data);
				}
				paraMap.put("list", chkedMenuList);
			}
			
			authService.doUpdateMenu(paraMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	private String stringChange(List<DataMap> list) {
		StringBuilder sb = new StringBuilder();
		sb.append("<ul>");
		for(int i = 0; i < list.size(); i++) {
			if(list.get(i).get("menu_lvl").toString().equals("1")) {
				sb.append("<li id='" + list.get(i).get("menucd") + "' value='" + list.get(i).get("menu_lvl") + "'><a href='#'>" + list.get(i).get("menunm") + "</a><span id='" + list.get(i).get("menucd") + "' style='display : none' class='tr_text'><input type='checkbox' name='" + list.get(i).get("menucd") +"' value='1'><label>등록</label>&nbsp;&nbsp;<input type='checkbox' name='" +list.get(i).get("menucd") + "' value='2'><label>수정</label>&nbsp;&nbsp;<input type='checkbox' name='" +list.get(i).get("menucd") + "' value='4'><label>삭제</label>&nbsp;&nbsp;</span>");
				sb.append("<ul>");
					for(int j = i + 1; j < list.size(); j++) {
						if(list.get(j).get("menu_lvl").toString().equals("2") && list.get(i).get("menucd").equals(list.get(j).get("up_cd"))) {
							sb.append("<li id='" + list.get(j).get("menucd") + "' value='" + list.get(j).get("menu_lvl") + "'><a href='#'>" + list.get(j).get("menunm") + "</a><span id='" + list.get(j).get("menucd") + "' style='display : none' class='tr_text'><input type='checkbox' name='" + list.get(j).get("menucd") +"' value='1'><label>등록</label>&nbsp;&nbsp;<input type='checkbox' name='" +list.get(j).get("menucd") + "' value='2'><label>수정</label>&nbsp;&nbsp;<input type='checkbox' name='" +list.get(j).get("menucd") + "' value='4'><label>삭제</label>&nbsp;&nbsp;</span>");
							sb.append("<ul>");
							for(int h = j + 1; h < list.size(); h++) {
								if(list.get(h).get("menu_lvl").toString().equals("3") && list.get(j).get("menucd").equals(list.get(h).get("up_cd"))) {
									sb.append("<li id='" + list.get(h).get("menucd") + "' value='" + list.get(h).get("menu_lvl") + "'><a href='#'>" + list.get(h).get("menunm") + "</a><span id='" + list.get(h).get("menucd") + "' style='display : none' class='tr_text'><input type='checkbox' name='" + list.get(h).get("menucd") +"' value='1'><label>등록</label>&nbsp;&nbsp;<input type='checkbox' name='" +list.get(h).get("menucd") + "' value='2'><label>수정</label>&nbsp;&nbsp;<input type='checkbox' name='" +list.get(h).get("menucd") + "' value='4'><label>삭제</label>&nbsp;&nbsp;</span></li>");

								}
							}
							sb.append("</ul>");
						}
					}
					sb.append("</li>");
					sb.append("</ul>");
			}
			sb.append("</li>");
		}
		sb.append("</ul>");
		return sb.toString();
	}
}
