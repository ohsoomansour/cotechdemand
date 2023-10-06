package com.ttmsoft.lms.front.corporate;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

@Controller
@RequestMapping("/techtalk")
public class TLOMypageAction extends BaseAct {

	@Autowired
	private TLOMypageService tloMypageService; 
	/**
	 *
	 * @Author : OSM
	 * @Date : 2023. 9. 25.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(TLO)
	 * @Explain : 기술수요 기업 관리
	 *
	 */
	
	@RequestMapping(value = "/tloMyPage.do")
	public ModelAndView doGetTLOMyPage(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/TLOMyPage.front");
		try {		
			String id = (String) session.getAttribute("id");
			String member_type = (String) session.getAttribute("member_type");
			paraMap.put("member_type", member_type); 
			// 문제점: 이동은 정상적으로 되었다 그런데 데이터가 안들어온다 
			if(id.equals("")){
				mav.setViewName("redirect:/techtalk/login.do");
				return mav;

			}//'로그인'의 경우
			else if(!id.equals("")){
				// 로그인 후 멤버 타입 확인
				
				if(member_type.equals("TLO") || member_type.equals("ADMIN")) {
					System.out.println("member_type:" + member_type); // TLO 또는 ADMIN이 들어왔나 확인 
					DataMap navi = new DataMap();
					navi.put("one", "마이페이지");
					navi.put("two", "기업 기술수요 목록");
					mav.addObject("navi", navi);
					
					//기술분류 리스트
					paraMap.put("depth", '1');
					mav.addObject("codeList1", this.tloMypageService.doGetCodeListInfo(paraMap)); 
					paraMap.put("depth", '2');
					mav.addObject("codeList2", this.tloMypageService.doGetCodeListInfo(paraMap));
					paraMap.put("depth", '3');
					mav.addObject("codeList3", this.tloMypageService.doGetCodeListInfo(paraMap));	
					//소속
					paraMap.put("id", request.getSession().getAttribute("id"));
					paraMap.put("biz_name", request.getSession().getAttribute("biz_name"));
					paraMap.put("member_seqno", request.getSession().getAttribute("member_seqno")); //3
					// --------------------------- 페이징 start----------------------------------------
					//총 기업목록 수
					int totalCount = this.tloMypageService.doCountCorporates(paraMap);
					mav.addObject("totalCount", totalCount);

					paraMap.put("count", totalCount);
					//현재페이지: 없으면 기본 1페이지
					String page = StringUtil.nchk((String)(paraMap.get("page")),"1");
					//페이지에 포함되는 레코드 수: 없으면 기본 rows 5개 
					String rows = StringUtil.nchk((String)(paraMap.get("rows")),"5");
					//게시물 정렬 위치
					String sidx = StringUtil.nchk((String)(paraMap.get("sidx")),"1");
					//게시물 정렬차순
					String sord = StringUtil.nchk((String)(paraMap.get("sord")),"asc");
					//페이지 그룹 수:  1 ~ 5페이징 
					int pageGroups = 5;
					
					//리스트 유형: 전체 all을 받아옴 
					String list = paraMap.get("list").toString();
						
					paraMap.put("page", page);
					paraMap.put("rows", rows);
					paraMap.put("sidx", sidx);
					paraMap.put("sord", sord);
					paraMap.put("list", list);
					System.out.println("list:" + list);	
					mav.addObject("sPageInfo",  new PageInfo().makeIndex(
							Integer.parseInt(page), totalCount, Integer.parseInt(rows), pageGroups, "fncList" 
					));
					mav.addObject("paraMap", paraMap);
					// --------------------------- 페이징 end ----------------------------------------
					List<DataMap> corporateList = tloMypageService.doGetCoTechDemandInfo(paraMap); 
					System.out.println("10.06 corporateList 확인중:" + corporateList);
					mav.addObject("corporateList", corporateList);
					
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
	
	/**
	 *
	 * @Author : osooman
	 * @Date : 2023. 9. 25.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지 TLO 기업 목록관리 
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/doSaveList1X.do")
	public ModelAndView doSaveList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {

			this.tloMypageService.doUpdateViewYn(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 * @Author : osooman
	 * @Date : 2023. 9. 22.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자) 상세보기 기술분류목록
	 * @Explain :
	 */
	@RequestMapping(value = "/doGetCodeList1X.do")
	public ModelAndView deGetCodeList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response,  HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		String member_seqno = String.valueOf(session.getAttribute("member_seqno"));
		//String member_seqno = (String)session.getAttribute("member_seqno");
		paraMap.put("tlo_seqno", member_seqno);
		
		try {
			if(paraMap.get("gubun").equals("mid")) {
				paraMap.put("depth", '2');
			} else if(paraMap.get("gubun").equals("sub")) {
				paraMap.put("depth", '3');
			}	
			List<DataMap> code = tloMypageService.doGetCodeListInfo(paraMap);
			if(paraMap.get("gubun").equals("mid")) {
				mav.addObject("codeList", code);
			} else if(paraMap.get("gubun").equals("sub")) {
				mav.addObject("codeList", code);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 * @Author : osooman 
	 * @Date : 2023.9.19.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(TLO) 업데이트 
	 * @Explain : TLO(관리자)가 '수요기업의 관리항목'을 수정
	 */
	@RequestMapping(value = "/doUpdateCorporateX.do")
	public ModelAndView deUpdateCoTechDemandInfo(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response,  HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		
		String member_seqno = (String) session.getAttribute("member_seqno");
		paraMap.put("corporate_seqno", member_seqno);
		
		try {
				this.tloMypageService.doUpdateCorporate(paraMap);
				//담당자 정보: this.tloMypageService.doUpdateManager(paraMap);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
}
