package com.ttmsoft.lms.front.corporate;

import java.util.Arrays;
import java.util.List;

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
import com.ttmsoft.toaf.util.ExcelUtil;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

@Controller
@RequestMapping("/techtalk")
public class TLOMypageAction extends BaseAct {
private final ExcelUtil excelUtil = new ExcelUtil();
	
	@Autowired
	private TLOMypageService tloMypageService; 
	/**
	 *
	 * @Author : OSM
	 * @Date : 2023. 9. 05.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(TLO)
	 * @Explain :
	 *
	 */
	
	@RequestMapping(value = "/tloMyPage.do")
	public ModelAndView doGetTLOMyPage(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response) {
		
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/TLOMyPage.front");
		// ----------- 9.18 (월) 확인중.. -----------
		try {
			
			DataMap navi = new DataMap();
			navi.put("one", "마이페이지");
			navi.put("two", "기업 기술수요 목록");
			mav.addObject("navi", navi);
			
			//기술분류 리스트: 'TBTECH_CODE 테이블'의 'code_depth'에 따라 'name_path'길이 추정가능 & 수정시 필요 
			paraMap.put("depth", '1');
			mav.addObject("codeList1", this.tloMypageService.doGetCodeListInfo(paraMap)); 
			paraMap.put("depth", '2');
			mav.addObject("codeList2", this.tloMypageService.doGetCodeListInfo(paraMap));
			paraMap.put("depth", '3');
			mav.addObject("codeList3", this.tloMypageService.doGetCodeListInfo(paraMap));	
			//기업 정보  >> TLOMyPage.jsp로 보낸다!
			
			//소속
			paraMap.put("id", request.getSession().getAttribute("id"));
			paraMap.put("biz_name", request.getSession().getAttribute("biz_name"));
			paraMap.put("member_seqno", request.getSession().getAttribute("member_seqno")); //3
			//총 기업목록 수
			int totalCount = this.tloMypageService.doCountCorporates(paraMap);
			mav.addObject("totalCount", totalCount);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
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
			//class = "paging_comm" 참조 / param을 전달 > PageInfo 유틸을 통해서 페이지 정보를 반환! 
			mav.addObject("sPageInfo",  new PageInfo().makeIndex(
					Integer.parseInt(page), totalCount, Integer.parseInt(rows), pageGroups, "fncList" //페이징 함수
			));
			
			System.out.println("frm2:" + paraMap);
			
			List<DataMap> corporateList = tloMypageService.doGetCoTechDemandInfo(paraMap);  // CODE_NAME1, 2를 가져옴
			System.out.println("9.24 corporateList 확인중:" + corporateList);
			mav.addObject("corporateList", corporateList);
			
			//TLO 연구자 목록
			//mav.addObject("data", this.tloMypageService.doGetTLOCorporateList(paraMap));
			
			/*
			if(mav.getModel().get("data") != null) {
				
				String keyword = this.tloMypageService.doGetCoTechDemandInfo(paraMap);
				String researcher_seqno = this.tloMypageService.doGetCoTechDemandInfo(paraMap);
				String[] keyword_split = keyword.split(",");
				paraMap.put("researcher_seqno", researcher_seqno);
				
				for(int i=0; i < keyword_split.length; i++) {
					paraMap.put("keyword_split"+(i+1), keyword_split[i]);
				}
			}
			*/
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
		/*
		List<DataMap> corporateList = tloMypageService.doGetCoTechDemandInfo(paraMap);  // CODE_NAME1, 2를 가져옴
		String[] co_td_no_arr;
		for(DataMap co :corporateList) {
			co_td_no_arr.add(co.get("co_td_no"));
		}
		
		paraMap.put("co_td_no", "");
		*/
		// TLOMypage.jsp 'doSave ajax' 에서 co_td_no, view_yn가져와서 처리
		
		try {
			 // {co_td_no_arr=[Ljava.lang.String;@306b0942, view_yn=[Ljava.lang.String;@3eace13f}
			/*
			String[] co_td_no =(String[]) paraMap.get("co_td_no_arr");
			String[] view_yn = (String[]) paraMap.get("view_yn_arr");
			
			for(int i=0; i<view_yn.length; i++) {
				System.out.println("view_yn : "  + view_yn[i]);
			}
			*/
			
			this.tloMypageService.doUpdateViewYn(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	
	/**
	 *
	 * @Author : JHSeo
	 * @Date : 2023. 9. 07.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(연구자) 상세보기 기술분류목록
	 * @Explain : 필요 확인중..
	 *
	 */
	@RequestMapping(value = "/doGetCodeList1X.do")
	public ModelAndView deGetCodeList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response,  HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		String member_seqno = String.valueOf(session.getAttribute("member_seqno"));
		//String member_seqno = (String)session.getAttribute("member_seqno");
		paraMap.put("tlo_seqno", member_seqno);
		
		try {
			//DB 셋팅 후 사용자 아이디 중복확인 코드 적용 필요
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
	 *
	 * @Author : osooman 
	 * @Date : 2023.9.19.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 마이페이지(기업 수요자) 수정
	 * @Explain : 
	 *
	 */
	@RequestMapping(value = "/doUpdateCorporateX.do")
	public ModelAndView deUpdateCoTechDemandInfo(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response,  HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		//String co_td_no = request.getParameter("co_td_no");
		//System.out.println("co_td_no 파라미터 값: " + co_td_no );
		
		String member_seqno = (String) session.getAttribute("member_seqno");
		paraMap.put("corporate_seqno", member_seqno);
		
		try {
			//9.22 기업 수요자 정보 수정중.. 
			this.tloMypageService.doUpdateCorporate(paraMap);
			//담당자 정보
			//this.tloMypageService.doUpdateManager(paraMap);
			
		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
	
		return mav;
	}
	
		
}
