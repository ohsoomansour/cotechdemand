package com.ttmsoft.lms.front.projectapply;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.front.api.OpenApiService;
import com.ttmsoft.lms.front.member.MemberFrontService;
import com.ttmsoft.lms.front.survey.SurveyFrontService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;
import com.ttmsoft.toaf.util.PageInfo;
import com.ttmsoft.toaf.util.StringUtil;

/**
 * 
 * @Package : com.ttmsoft.lms.cmm.site
 * @File : BoardAction.java
 * 
 * @Author : psm
 * @Date : 2021. 4. 05.
 * @Explain : 사업공고
 *
 */
@Controller
@RequestMapping("/subject")
public class SubjectFrontAction extends BaseAct {

//	@Autowired
//	private SeqService seqService;

	@Autowired
	private MemberFrontService memberService;

	@Autowired
	private SubjectFrontService subjectService;
	
	@Autowired
	private SurveyFrontService surveyFrontService;
	
	@Autowired
	private FileService fileService;

	@Autowired
	private OpenApiService openApiService;
	
	@Value("${siteid}")
	private String siteid;

	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 4. 26.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 사업신청 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/applyList.do", method = RequestMethod.GET)
	public ModelAndView doApplyList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		paraMap.put("insert_user", session.getAttribute("member_seqno"));
		ModelAndView mav = new ModelAndView("/lms/front/subject/applyList.front");

		mav.addObject("paraMap", paraMap);

		try {
//			paraMap.put("title", request.getParameter("title").toString());
//			paraMap.put("year", request.getParameter("year").toString());
//			paraMap.put("status", request.getParameter("status").toString());

			// 게시글 개수
			int totalCount = this.subjectService.countApplyList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListApply(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "신청 현황");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}

	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 4. 05.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 사업공고 신청,수정페이지
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/apply.do", method = RequestMethod.POST)
	public ModelAndView doApply(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = null;
		System.out.println("초기데이터어케드러와요" + paraMap);
		try {
			String member_seqno = request.getSession().getAttribute("member_seqno").toString();
			paraMap.put("insert_user", member_seqno);
			paraMap.put("member_seqno", member_seqno);
			DataMap result = subjectService.doDetailApply(request, paraMap);
			System.out.println("apply.do>>>>>>>>>>>>>>>>>" + result);
			String check = result.getstr("check");
			System.out.println("check?? "+check);
			if (!check.equals("0")) {
				mav = new ModelAndView("/lms/front/subject/subjectApplyUpd.front");
			} else {
				mav = new ModelAndView("/lms/front/subject/subjectApply.front");
				DataMap user = this.memberService.doGetMemberInfo(paraMap);
				user.remove("pw");
				mav.addObject("user", user);
			}
			mav.addObject("paraMap", result);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "신청");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "110");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
			System.out.println("paraMap " + result);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 5. 26
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 사업신청서 승인
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/applySubmit.do", method = RequestMethod.POST)
	public ModelAndView applySubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String member_seqno = session.getAttribute("member_seqno").toString();
		paraMap.put("member_seqno", member_seqno);
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("초기데이터확인" + paraMap);
		try {
			int result = this.subjectService.doApplySubmit(paraMap, request);
			mav.addObject("paraMap", result);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 12. 30
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 사업신청서 제출
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/applyDocumentSubmit.do", method = RequestMethod.POST)
	public ModelAndView applyDocumentSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String member_seqno = session.getAttribute("member_seqno").toString();
		paraMap.put("member_seqno", member_seqno);
		ModelAndView mav = new ModelAndView("jsonView");
		System.out.println("초기데이터확인" + paraMap);
		try {
			int result = this.subjectService.doApplyDocumentSubmit(paraMap, request);
			mav.addObject("paraMap", result);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}

	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 4. 05.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 사업공고 등록,수정 완료
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/applyFin.do", method = RequestMethod.GET)
	public ModelAndView doApplyFin(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("/lms/front/subject/applyFin.front");

		mav.addObject("paraMap", paraMap);
		DataMap navi = new DataMap();
		navi.put("one", "사업");
		navi.put("two", "신청완료");
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
	 * @Author : psm
	 * @Date : 2021. 4. 29.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 사업자번호 검색(사업신청록페이지)
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/searchBiz", method = RequestMethod.GET)
	public ModelAndView doSearchBiz(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("jsonView");

		try {
			System.out.println("어케들어오나요" + paraMap);
			List<DataMap> result = subjectService.searchBiz(paraMap);
			List<DataMap> removePwResult = new ArrayList<>();
			for (int i = 0; i < result.size(); i++) {
				result.get(i).remove("pw");
				removePwResult.add(result.get(i));
			}
			int size = result.size();
			mav.addObject("biz", removePwResult);
			mav.addObject("biz_size", size);

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}


	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 28.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 협약체결 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/contractList.do", method = RequestMethod.GET)
	public ModelAndView doContractList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/contractList.front");

		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countContractList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListContract(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "협약체결");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 5. 25.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 협약체결 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/contractDetail.do", method = RequestMethod.POST)
	public ModelAndView doContractDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/contractDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilContract(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "협약체결 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "120");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 29.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 서명하기 만들다맘
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/doPaying", method = RequestMethod.GET)
	public ModelAndView doPaying(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {

		ModelAndView mav = new ModelAndView("jsonView");

		try {
			paraMap.put("user_id", request.getSession().getAttribute("member_seqno"));
			System.out.println("어케들어오나요" + paraMap);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 29.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 협약체결 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/contractSubmit.do", method = RequestMethod.POST)
	public ModelAndView contractSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("insert_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.contractSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 권한부여 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/permitList.do", method = RequestMethod.GET)
	public ModelAndView doPermitList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/permitList.front");

		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countPermitList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListPermit(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "권한부여");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 권한부여 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/permitDetail.do", method = RequestMethod.POST)
	public ModelAndView doPermitDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/permitDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		paraMap.put("member_seqno", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilPermit(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "권한부여 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "130");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 협약체결 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/permitSubmit.do", method = RequestMethod.POST)
	public ModelAndView permitSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("member_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doPermitSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/settleList.do", method = RequestMethod.GET)
	public ModelAndView doSittleList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/settleList.front");
		LocalDate date = LocalDate.now();
		String strDate = date.getYear()+""+getMonth(date.getMonthValue());
		paraMap.put("check_date",Integer.parseInt(strDate));
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		paraMap.put("insert_user", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countSettleList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListSettle(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "사업비신청");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/settleDetail.do", method = RequestMethod.POST)
	public ModelAndView doSettleDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/settleDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		//mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilSettle(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "사업비신청 상세");
			mav.addObject("navi",navi);
			if(paraMap.getstr("settle_type").equals("A10")) {
				paraMap.put("subject_proc_code", "141");
			}else if(paraMap.getstr("settle_type").equals("B10")) {
				paraMap.put("subject_proc_code", "142");
			}else if(paraMap.getstr("settle_type").equals("B20")) {
				paraMap.put("subject_proc_code", "143");
			}
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/settleSubmit.do", method = RequestMethod.POST)
	public ModelAndView settleSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doSettleSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 진도점검 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/checkList.do", method = RequestMethod.GET)
	public ModelAndView doCheckList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/checkList.front");
		LocalDate date = LocalDate.now();
		String strDate = date.getYear()+""+getMonth(date.getMonthValue());
		paraMap.put("check_date",Integer.parseInt(strDate));
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countCheckList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListCheck(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "진도점검");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 진도점검 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/checkDetail.do", method = RequestMethod.POST)
	public ModelAndView doCheckDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/checkDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilCheck(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "진도점검 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "151");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 진도점검 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/checkSubmit.do", method = RequestMethod.POST)
	public ModelAndView checkSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doCheckSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 현장실태조사 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/addcheckList.do", method = RequestMethod.GET)
	public ModelAndView doAddCheckList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/addcheckList.front");
		LocalDate date = LocalDate.now();
		String strDate = date.getYear()+""+getMonth(date.getMonthValue());
		paraMap.put("check_date",Integer.parseInt(strDate));
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countAddCheckList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListAddCheck(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "현장실태조사");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 현장실태조사 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/addcheckDetail.do", method = RequestMethod.POST)
	public ModelAndView doAddCheckDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/addcheckDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilAddCheck(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "현장실태조사 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "152");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 현장실태조사 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/addcheckSubmit.do", method = RequestMethod.POST)
	public ModelAndView addcheckSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doAddCheckSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 설문조사 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/surveyList.do", method = RequestMethod.GET)
	public ModelAndView doSurveyList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		ModelAndView mav = new ModelAndView("/lms/front/subject/surveyList.front");

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countSurveyList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("data", subjectService.doListSurvey(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "서비스 만족도 조사");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 설문조사 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/surveyDetail.do", method = RequestMethod.POST)
	public ModelAndView doSurveyDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/surveyDetail.front");
		
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		HttpSession session = request.getSession();	
		paraMap.put("userno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		System.out.println("데이터확이느"+paraMap);
		try {
			DataMap result = this.subjectService.doDeatilSurvey(paraMap);
			paraMap.put("ppr_seq",result.getstr("ppr_seq"));
			//paraMap.put("project_seqno",result.getstr("project_seqno"));
			System.out.println("paraMpa"+ paraMap);
			// 카테고리
			mav.addObject("paraMap", result);
			//mav.addObject("paraMap", this.subjectService.doDeatilSurvey(paraMap));
			mav.addObject("que", surveyFrontService.doListSurveySet(paraMap)); //출제된 문제 데이터
		 	mav.addObject("queitem", subjectService.doListMultipleChoice(paraMap)); //객관식 항목
		 	mav.addObject("queJu", subjectService.doListMultipleJu(paraMap)); //주관식 항목
		 	//mav.addObject("queResult", subjectService.doDeatilSurvey(paraMap)); //설문 결과
		 	mav.addObject("choice", this.subjectService.doListMultipleChoiceList(paraMap)); //출제된 문제의 객관식 항목
			mav.addObject("choiceScore", this.subjectService.doListMultipleChoiceScore(paraMap)); //출제된 문제의 객관식(점수) 항목
		 	mav.addObject("subjective", this.subjectService.doListSubjective(paraMap)); //출제된 문제의 주관식 항목
		 	
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "서비스 만족도 조사 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "110");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 설문조사 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/surveySubmit.do", method = RequestMethod.POST)
	public ModelAndView surveySubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();	
		mav.addObject("paraMap", paraMap);	
		
		paraMap.put("siteid", siteid);
		paraMap.put("userno", session.getAttribute("member_seqno"));
		paraMap.put("userid", session.getAttribute("userid"));
		try {
			
			ArrayList<DataMap> list = new ArrayList<DataMap>();
			
			String[] que_seq = request.getParameterValues("que_seq");
			String[] que_pcd = request.getParameterValues("que_pcd");
							
			int length = que_seq.length;
						
			List<String> apl_ans = new ArrayList<String>();
	
			for(int j = 0; j < length; j++) {
				
				apl_ans.add(paraMap.getstr("apl_ans_" + j));
			}
							
			for(int i = 0; i < length; ++i) {				
				
				DataMap data = new DataMap();
				data.put("que_seq", que_seq[i]);
				data.put("que_pcd", que_pcd[i]);
				data.put("apl_ans", apl_ans.get(i));

				list.add(data);
			}
			paraMap.put("list", list);
			System.out.println("어케들22222어오나요" + paraMap);
			this.surveyFrontService.doAddSurveyApply(paraMap); //설문조사 등록
			this.surveyFrontService.doAddSurveyApplog(paraMap); //설문조사 참여 내역 등록
			
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("insert_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doSurveySubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 최종평가 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/evalList.do", method = RequestMethod.GET)
	public ModelAndView doEvalList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/evalList.front");
		LocalDate date = LocalDate.now();
		String strDate = date.getYear()+""+getMonth(date.getMonthValue());
		paraMap.put("check_date",Integer.parseInt(strDate));
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countEvalList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListEval(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "최종평가");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 최종평가 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/evalDetail.do", method = RequestMethod.POST)
	public ModelAndView doEvalDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/evalDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilEval(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "최종평가 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "110");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 최종평가 신청하기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/evalSubmit.do", method = RequestMethod.POST)
	public ModelAndView evalSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doEvalSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 추적조사 현황 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/traceList.do", method = RequestMethod.GET)
	public ModelAndView doTraceList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/traceList.front");
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countTraceList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListTrace(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "추적조사");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 추적조사 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/traceDetail.do", method = RequestMethod.POST)
	public ModelAndView doTraceDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/traceDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			DataMap result = this.subjectService.doDeatilTrace(paraMap);
			mav.addObject("paraMap", result);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "추적조사 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "110");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
			System.out.println("data어케나와"+result);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}

	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 8. 03.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 리스트
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/calcList.do", method = RequestMethod.GET)
	public ModelAndView doCalcList(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		HttpSession session = request.getSession();
		System.out.println(">>>>>>>>>>>>>>" + session.getAttribute("member_seqno"));
		System.out.println(">>>>>>>>>>>>>>" + session);
		ModelAndView mav = new ModelAndView("/lms/front/subject/calcList.front");
		paraMap.put("member_seqno", session.getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);

		try {
			// 게시글 개수
			int totalCount = this.subjectService.countCalcList(paraMap);

			paraMap.put("count", totalCount);
			// --------------------------------------------------------------------------
			// 현재페이지
			String page = StringUtil.nchk((String) (paraMap.get("page")), "1");
			// 페이지에 포함되는 레코드 수
			String rows = StringUtil.nchk((String) (paraMap.get("rows")), "10");
			// 게시물 정렬 위치
			String sidx = StringUtil.nchk((String) (paraMap.get("sidx")), "1");
			// 게시물 정렬차순
			String sord = StringUtil.nchk((String) (paraMap.get("sord")), "asc");
			// 페이지 그룹 수

			int pageGroups = 5;

			paraMap.put("page", page);
			paraMap.put("rows", rows);
			paraMap.put("sidx", sidx);
			paraMap.put("sord", sord);

			mav.addObject("sPageInfo", new PageInfo().makeIndex(Integer.parseInt(page), totalCount,
					Integer.parseInt(rows), pageGroups, "fncList"));
			mav.addObject("result", this.subjectService.doListCalc(paraMap));
			mav.addObject("paraMap", paraMap);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "사업비 정산");
			mav.addObject("navi",navi);
			System.out.println("데이터에요오오" + paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 8. 03.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 상세보기
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/calcDetail.do", method = RequestMethod.POST)
	public ModelAndView doCalcDetail(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/calcDetail.front");
		System.out.println("데이터확이느"+paraMap);
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		mav.addObject("paraMap", paraMap);
		try {
			// 카테고리
			mav.addObject("paraMap", this.subjectService.doDeatilCalc(paraMap));
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "사업비 정산 상세");
			mav.addObject("navi",navi);
			paraMap.put("subject_proc_code", "110");
			List<DataMap> codeList = fileService.getFileCode(paraMap);
			if(codeList.size()!=0) {
				codeList.get(0).put("size", codeList.size());
			}
			mav.addObject("code",codeList);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 8. 06.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 정산관리 자료제출
	 * @Explain :
	 *
	 */
	
	@RequestMapping(value = "/calcSubmit.do", method = RequestMethod.POST)
	public ModelAndView calcSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("insert_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doCalcSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 6. 30.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : 추적조사 신청하기 없는기능인듯함?
	 * @Explain :
	 *
	 */
	
	@RequestMapping(value = "/traceSubmit.do", method = RequestMethod.POST)
	public ModelAndView traceSubmit(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
			paraMap.put("user_seqno", request.getSession().getAttribute("member_seqno"));
			paraMap.put("insert_ip", request.getRemoteAddr());
			System.out.println("어케들어오나요" + paraMap);
			int result = subjectService.doTraceSubmit(paraMap);
			mav.addObject("result", result);
		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}

	

	public String  getMonth(int data) {
		String date = String.valueOf(data);
		if(date.length()==1) {
			date = "0"+date;
		}
		return date;
	}
	
	/**
	 *
	 * @Author : psm
	 * @Date : 2021. 4. 26.
	 * @Parm : DataMap
	 * @Return : ModelAndView
	 * @Function : API 호출
	 * @Explain :
	 *
	 */
	@RequestMapping(value = "/documentCheck.do", method = RequestMethod.POST)
	public ModelAndView doDocumentCheck(@ModelAttribute("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("/lms/front/subject/documentCheck.front");
		paraMap.put("insert_user", request.getSession().getAttribute("member_seqno"));
		
		System.out.println("paraMap"+paraMap);

		try {
			DataMap apply = subjectService.doSubjectDetail(paraMap);
			mav.addObject("apply", apply);
			System.out.println("어케나완"+apply);
			
			paraMap.put("id", request.getSession().getAttribute("id"));
			List<DataMap> result = this.openApiService.doFrontBusiness(paraMap);
			String biz_regno = result.get(0).getstr("biz_regno");
			int total = 0;
			int ser1 = openApiService.bizApiCheck(biz_regno);
			int ser2 = openApiService.bizBusibbCnt(biz_regno);
			List<DataMap> listdatamap = new ArrayList<>();
			JSONArray taxList = openApiService.taxCertificationList(biz_regno);
			mav.addObject("ser1", ser1);
			mav.addObject("ser2", ser2);
			for(int i=0; i<taxList.length();i++) {
				JSONObject checkStatus = taxList.getJSONObject(i);
				if(checkStatus.get("txvsacqsdatstsnm").equals("검증완료")) {
					total ++;
				}
				DataMap tempdata = new DataMap();
				tempdata.put("bizno", checkStatus.get("bizno"));
				tempdata.put("cfw_req_end_yymm", checkStatus.get("cfw_req_end_yymm"));
				tempdata.put("cfw_req_st_yymm", checkStatus.get("cfw_req_st_yymm"));
				tempdata.put("entrnm", checkStatus.get("entrnm"));
				tempdata.put("inunm", checkStatus.get("inunm"));
				tempdata.put("pdf_file_pth", checkStatus.get("pdf_file_pth"));
				tempdata.put("regcono", checkStatus.get("regcono"));
				tempdata.put("repr", checkStatus.get("repr"));
				tempdata.put("rgs_dtm", checkStatus.get("rgs_dtm"));
				tempdata.put("smt_ofcrnm", checkStatus.get("smt_ofcrnm"));
				tempdata.put("txvsacqsdatstsnm", checkStatus.get("txvsacqsdatstsnm"));
				tempdata.put("txvscfwdivcd", checkStatus.get("txvscfwdivcd"));
				tempdata.put("txvscfwissno", checkStatus.get("txvscfwissno"));
				tempdata.put("txvscfwnm", checkStatus.get("txvscfwnm"));
				tempdata.put("txvssndpcsstsnm", checkStatus.get("txvssndpcsstsnm"));
				listdatamap.add(tempdata);
			}
			mav.addObject("taxList", listdatamap);
			total += ser1 + ser2 ;
			mav.addObject("total", total);
			DataMap navi = new DataMap();
			navi.put("one", "사업");
			navi.put("two", "신청 현황");
			mav.addObject("navi",navi);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}

		return mav;
	}
	
}
