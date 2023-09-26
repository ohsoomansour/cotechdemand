package com.ttmsoft.lms.front.corporate;

import java.time.LocalDate;
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
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

@Controller
@RequestMapping("/techtalk")
public class CoTechDemandAction extends BaseAct {
	@Autowired
	CoTechDemandService coTechDemandService;
	/**
	 *
	 * @Author   : osm
	 * @Date	 : 2023.9. 14
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 기업 기술수요 등록  
	 * @Explain  : 
	 *
	 */
	 	
	@RequestMapping(value = "/registerCoTechDemand.do")
	public ModelAndView doRegisterCoTechDemand(@ModelAttribute("paraMap")  DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session ) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/registCoTechDemandForm.front");
		System.out.print("등록form에서 어떻게 보냄?:" + paraMap);
		
		/* secure, 기업 회원만 입장
		String member_type = (String) session.getAttribute("member_type");
		String  id = (String) session.getAttribute("id");
		
		//'비로그인'의 경우 
		if(Objects.isNull(id)){
			mav.setViewName("redirect:/techtalk/login.do");
			return mav;
		}
		//'로그인'의 경우
		else if(!Objects.isNull(id)){
			if(member_type.equals("B")) {
				return mav;
			} else {
				//팝업창에 기업 아이디가 아닙니다!
				mav.setViewName("redirect:/");
				return mav;
			 }
		}
		*/
		paraMap.put("depth", '1');
		mav.addObject("codeList1", this.coTechDemandService.doGetCodeListInfo(paraMap)); 
		paraMap.put("depth", '2');
		mav.addObject("codeList2", this.coTechDemandService.doGetCodeListInfo(paraMap));
		paraMap.put("depth", '3');
		mav.addObject("codeList3", this.coTechDemandService.doGetCodeListInfo(paraMap));
		String member_seqno = (String) session.getAttribute("member_seqno");
		String biz_name = (String) session.getAttribute("biz_name");
		String biz_email = paraMap.getstr("bizEmail1")+"@"+paraMap.getstr("bizEmail2");
		DataMap tlo_seqno = coTechDemandService.doGetTLOSeqno(paraMap);
		paraMap.put("member_seqno", member_seqno);
		paraMap.put("tlo_seqno", tlo_seqno);
		paraMap.put("biz_name", biz_name);
		paraMap.put("biz_email", biz_email);
		coTechDemandService.doInsertCoTechDemand(paraMap);
		
		return mav;
	}
	
	//삽입 
	@RequestMapping(value = "/insertCoTechDemandX.do")
	public ModelAndView doInsertCTD(@ModelAttribute("paraMap")  DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session ) {
		ModelAndView mav = new ModelAndView("jsonView");
		// ---- 문제는 지금 여기서는 못 받음, 그러면 form이 잘 못 되었다!!!!
		try {
			
			String member_seqno = (String) session.getAttribute("member_seqno");
			String biz_name = (String) session.getAttribute("biz_name");
			paraMap.put("member_seqno", member_seqno);
			paraMap.put("biz_name", biz_name);
			String biz_email = paraMap.getstr("bizEmail1")+"@"+paraMap.getstr("bizEmail2");
			paraMap.put("biz_email", biz_email);
			
			
			//지금 로그인한 기업 멤버아이디의 session 중 biz_name과 같은 tblmember.biz_name과 같은 tblmember.member_seqno를 찾아와야된다.
			DataMap tlo_seqno = coTechDemandService.doGetTLOSeqno(paraMap);
			paraMap.put("tlo_seqno", tlo_seqno);
			coTechDemandService.doInsertCoTechDemand(paraMap);	
			
			return mav;

		} catch (Exception e) {	
			
		}
		// 로직
		return mav;
	}
	
	@RequestMapping (value = "/autoSearchKeywordX.do")
	public ModelAndView doAutoSearchBusiness(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("keyword checking:" + paraMap); //예) 배터리 > 배xx
		List<DataMap> result = coTechDemandService.doAutoSearchKeyword(paraMap); // 배터리(양극화 물질), 배터리(2차전지), ... 등등을 result 변수에 담음
		mav.addObject("result", result);
		return mav;
	}
	
	@RequestMapping(value = "/doGetCodeList2X.do")
	public ModelAndView doGetCodeList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request, HttpServletResponse response,  HttpSession session) {
		ModelAndView mav = new ModelAndView("jsonView");
		String member_seqno = (String)session.getAttribute("member_seqno");
		paraMap.put("corporate_seqno", member_seqno);
		
		try {
			if(paraMap.get("gubun").equals("mid")) {
				paraMap.put("depth", '2');
			} else if(paraMap.get("gubun").equals("sub")) {
				paraMap.put("depth", '3');
			}
			
			List<DataMap> code = coTechDemandService.doGetCodeListInfo(paraMap);
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
	
	
	//기업 기술수요 목록 리스트 - 9.22 수정중..
	@RequestMapping(value = "/moveCoTechDemandList.do")
	public ModelAndView moveCorporateDemandList(@ModelAttribute("paraMap")  DataMap paraMap, HttpServletRequest request, HttpServletResponse response, HttpSession session ) {
		ModelAndView mav = new ModelAndView("/techtalk/front/corporateMypage/coTechDemandList.front");
		//***기업 회원만 입장*** 
		DataMap navi = new DataMap();
		navi.put("one", "마이페이지");
		navi.put("two", "기업 기술수요 목록");
		mav.addObject("navi", navi);
		// ---------------- 디버깅 ----------------
		//기술분류 리스트: 'TBTECH_CODE 테이블'의 'code_depth'에 따라 'name_path'길이 추정가능 & 수정시 필요 
		paraMap.put("depth", '1');
		mav.addObject("codeList1", this.coTechDemandService.doGetCodeListInfo(paraMap)); 
		paraMap.put("depth", '2');
		mav.addObject("codeList2", this.coTechDemandService.doGetCodeListInfo(paraMap));
		paraMap.put("depth", '3');
		mav.addObject("codeList3", this.coTechDemandService.doGetCodeListInfo(paraMap));
	
		paraMap.put("id", request.getSession().getAttribute("id"));
		paraMap.put("biz_name", request.getSession().getAttribute("biz_name"));

		List<DataMap> corporateList = coTechDemandService.doGetCoTechDemandInfo(paraMap); 
		System.out.println("9.26 corporateList 확인중.. -> " + corporateList); // []
		mav.addObject("corporateList", corporateList);
		
		//소속
		paraMap.put("id", request.getSession().getAttribute("id"));
		paraMap.put("biz_name", request.getSession().getAttribute("biz_name"));
		paraMap.put("member_seqno", request.getSession().getAttribute("member_seqno")); //3
		//총 기업목록 수
		int totalCount = this.coTechDemandService.doCountCorporates(paraMap);
		mav.addObject("totalCount", totalCount);

		paraMap.put("count", totalCount);
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
		return mav;
	}
		
	
}
