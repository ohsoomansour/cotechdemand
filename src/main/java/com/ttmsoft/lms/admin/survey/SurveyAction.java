package com.ttmsoft.lms.admin.survey;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseAct;
import com.ttmsoft.toaf.object.DataMap;

/**
 * 
 * @Package	 : com.ttmsoft.lms.cmm.site
 * @File	 : BoardAction.java
 * 
 * @Author   : ycjo
 * @Date	 : 2020. 5. 28.
 * @Explain  : 설문조사
 *
 */
@Controller
@RequestMapping ("/admin")
public class SurveyAction extends BaseAct {

	@Autowired
	private SurveyService surveyService;
	
	@Autowired
	private SeqService	seqService;

	@Value ("${siteid}")
	private String			siteid;	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사문제 관리 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/surveyQue.do", method = RequestMethod.GET)
	public ModelAndView dolistSurveyQueForm (@ModelAttribute ("paraMap") DataMap paraMap) {	
		ModelAndView mav = new ModelAndView("/lms/admin/survey/listSurveyQue.admin");
		mav.addObject("paraMap", paraMap);			
	 	
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사문제 관리
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/surveyQue.do", method = RequestMethod.POST)
	public ModelAndView dolistSurveyQue (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");		
		mav.addObject("siteid", siteid);
		mav.addObject("paraMap", paraMap);		
			
		try {
	
		 	int totalCount = this.surveyService.doCountSurveyQue(paraMap);
			int totalPage  = (totalCount -1)/(10) + 1;	
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",  totalPage);
			// 현재 페이지
			mav.addObject("page",   1);
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",   this.surveyService.dolistSurveyQue(paraMap));
			// --------------------------------------------------------------------------		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 28.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사문제 등록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addSurveyQue.do", method = RequestMethod.GET)
	public ModelAndView doAddSurveyQueForm (@ModelAttribute ("paraMap") DataMap paraMap) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/addSurveyQue.adminPopup");
		
		mav.addObject("paraMap", paraMap);	
		paraMap.put("seq_tblnm", "TE_EVAL_QUE");		
	 	
		return mav;
	}	

	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 28
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사문제 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/addSurveyQue.do", method = RequestMethod.POST)
	public ModelAndView doAddSurveyQue(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		String que_seq =  String.valueOf(seqService.doAddAndGetSeq(paraMap));
		String userId = (String) request.getSession().getAttribute("userid");
		
		ModelAndView mav = new ModelAndView("jsonView");
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", userId);
		paraMap.put("que_seq", que_seq);
		
		try {
			
			if(request.getParameterValues("item_title") != null) {
			paraMap.put("seq_tblnm", "TE_EVAL_QUEITEM");	
			ArrayList<DataMap> list = new ArrayList<DataMap>();
			
			String[] item_title = request.getParameterValues("item_title");
			String[] item_idx = request.getParameterValues("item_idx");	
			
			int length = item_title.length;
			
			for(int i = 0; i < length; ++i) {				
				
				DataMap data = new DataMap();
				
				if(item_idx == null) {
					data.put("item_seq", seqService.doAddAndGetSeq(paraMap));
					data.put("item_title", item_title[i]);
					data.put("item_idx", i+1);
					data.put("que_seq", que_seq);		
					data.put("userId", userId);	
				}else {
					data.put("item_seq", seqService.doAddAndGetSeq(paraMap));
					data.put("item_title", item_title[i]);
					data.put("item_idx", item_idx[i]);
					data.put("que_seq", que_seq);		
					data.put("userId", userId);	
				}
				list.add(data);
				
			}
			paraMap.put("list", list);
			
			this.surveyService.doAddSurveyQue(paraMap); //문제 등록
			this.surveyService.doAddSurveyQueItem(paraMap); //객관식 문항 등록
			}else{
				this.surveyService.doAddSurveyQue(paraMap); //문제 등록	
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사문제 수정 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateSurveyQue.do", method = RequestMethod.GET)
	public ModelAndView doUpdateSurveyQueForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/updateSurveyQue.adminPopup");
		mav.addObject("paraMap", paraMap);	
		
		mav.addObject("data", this.surveyService.doGetSurveyQue(paraMap)); 
		mav.addObject("queitem", this.surveyService.doListSurveyQueItem(paraMap)); //객관식 항목
		mav.addObject("maxidx", this.surveyService.doGetMaxQueItemIdx(paraMap));
	 	
		return mav;
	}		
	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사문제 수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/updateSurveyQue.do", method = RequestMethod.POST)
	public ModelAndView doUpdateSurveyQue(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {
			if(request.getParameterValues("item_seqs") != null || request.getParameterValues("item_titles") != null) { //수정
				ArrayList<DataMap> lists = new ArrayList<DataMap>();
				String[] item_seqs = request.getParameterValues("item_seqs");
				String[] item_titles = request.getParameterValues("item_titles");
				String[] item_idxs = request.getParameterValues("item_idxs");
				
				System.out.println(item_seqs);
				System.out.println(item_titles);
			
				int lengths = item_seqs.length;
				
				for(int i = 0; i < lengths; ++i) {				
					
					DataMap datas = new DataMap();
					
					datas.put("item_seqs", item_seqs[i]);
					datas.put("item_titles", item_titles[i]);
					datas.put("item_idxs", item_idxs[i]);			
					
					lists.add(datas);
				}
				paraMap.put("lists", lists);	
				this.surveyService.doUpdateSurveyQueItem(paraMap); //객관식 문제 수정
			}
			if(request.getParameterValues("item_title") != null) { //등록
				ArrayList<DataMap> list = new ArrayList<DataMap>();
					paraMap.put("seq_tblnm", "TE_EVAL_QUEITEM");	
					
					String[] item_title = request.getParameterValues("item_title");
					String[] item_idx = request.getParameterValues("item_idx");	
				
					int length = item_title.length;
					
					for(int i = 0; i < length; ++i) {				
						
						DataMap data = new DataMap();

						data.put("item_seq", seqService.doAddAndGetSeq(paraMap));
						data.put("item_title", item_title[i]);
						data.put("item_idx", item_idx[i]);
						data.put("que_seq", paraMap.get("que_seq"));		
						
						list.add(data);
						
					}
					paraMap.put("list", list);
					
					this.surveyService.doAddSurveyQueItem(paraMap); //객관식 문항 등록
			}
				this.surveyService.doUpdateSurveyQue(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}		
	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 문제 삭제
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/deleteSurveyQue.do", method = RequestMethod.GET)
	public ModelAndView doDeleteSurveyQue(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		
		ArrayList<DataMap> list = new ArrayList<DataMap>();	
		String[] que_seq = (String[]) paraMap.get("que_seq");
		
		int length = que_seq.length;
		
		for(int i = 0; i < length; ++i) {
			
			DataMap data = new DataMap();	
			data.put("que_seq", que_seq[i]);		
			list.add(data);		
		}
		paraMap.put("list", list);
		
		try {
			this.surveyService.doDeleteSurveyQue(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 16. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 객관식 문항 조회
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/listQueItem.do", method = RequestMethod.POST)
	public ModelAndView doListQueItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			mav.addObject("result", this.surveyService.doListSurveyQueItem(paraMap));
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 객관식 문항 삭제
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/deleteSurveyQueItem.do", method = RequestMethod.GET)
	public ModelAndView doDeleteSurveyQueItem(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			this.surveyService.doDeleteSurveyQueItem(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문지 관리 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/surveyPaper.do", method = RequestMethod.GET)
	public ModelAndView dolistSurveyPaerForm (@ModelAttribute ("paraMap") DataMap paraMap) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/listSurveyPaper.admin");
		mav.addObject("paraMap", paraMap);			
	 	
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문지 관리 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/surveyPaper.do", method = RequestMethod.POST)
	public ModelAndView dolistSurveyPaer (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");		
		mav.addObject("siteid", siteid);
		mav.addObject("paraMap", paraMap);		
		
		try {
		 	int totalCount = this.surveyService.doCountSurveyPaper(paraMap);
			int totalPage  = (totalCount -1)/(10) + 1;	
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",  totalPage);
			// 현재 페이지
			mav.addObject("page",   1);
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",   this.surveyService.doListSurveyPaper(paraMap));
			// --------------------------------------------------------------------------		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사설문지 등록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addSurveyPaper.do", method = RequestMethod.GET)
	public ModelAndView doAddSurveyPaperForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/addSurveyPaper.adminPopup");
		mav.addObject("paraMap", paraMap);	
		paraMap.put("seq_tblnm", "TE_EVAL_PAPER");		
	 	
		return mav;
	}	

	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사설문지 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/addSurveyPaper.do", method = RequestMethod.POST)
	public ModelAndView doAddSurveyPaper(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		String ppr_seq =  String.valueOf(seqService.doAddAndGetSeq(paraMap));
		
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		paraMap.put("ppr_seq", ppr_seq);
		paraMap.put("cmptn_pcd", "-");
		
		try {
		
			this.surveyService.doAddSurveyPaper(paraMap); //설문지 등록
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사설문지 수정 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateSurveyPaper.do", method = RequestMethod.GET)
	public ModelAndView doUpdateSurveyPaperForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/updateSurveyPaper.adminPopup");
		mav.addObject("paraMap", paraMap);	
		mav.addObject("data", this.surveyService.doGetSurveyPaper(paraMap)); //설문지 데이터
	 	
		return mav;
	}	

	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사설문지 수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/updateSurveyPaper.do", method = RequestMethod.POST)
	public ModelAndView doUpdateSurveyPaper(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));

		try {
			
			this.surveyService.doUpdateSurveyPaper(paraMap); //설문지 수정
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 5. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문지 삭제
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/deleteSurveyPaper.do", method = RequestMethod.GET)
	public ModelAndView doDeleteSurveyPaper(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		
		try {
			this.surveyService.doDeleteSurveyPaper(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}
	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 설문지 문제 출제 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listSurveySet.do", method = RequestMethod.GET)
	public ModelAndView doAddSurveyPaperQueForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/addSurveySet.adminPopup");
		mav.addObject("paraMap", paraMap);	
		mav.addObject("data", this.surveyService.doGetSurveySet(paraMap));
		mav.addObject("paper", this.surveyService.doGetSurveyPaper(paraMap));
		
		paraMap.put("ppr_seq", paraMap.get("ppr_seq"));
		paraMap.put("seq_tblnm", "TE_EVAL_SET");	
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 설문지 문제 출제 목록
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listSurveySet.do", method = RequestMethod.POST)
	public ModelAndView doAddSurveyPaperQue (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");		
		mav.addObject("siteid", siteid);
		mav.addObject("paraMap", paraMap);	
			
		try {
		 	int totalCount = this.surveyService.doCountSetSurveyQue(paraMap);
			int totalPage  = (totalCount -1)/(10) + 1;	
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",  totalPage);
			// 현재 페이지
			mav.addObject("page",   1);
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",   this.surveyService.dolistSetSurveyQue(paraMap));
			// 문제 출제 등록
			// --------------------------------------------------------------------------		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		
		return mav;
	}			
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 29,
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 문항 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/addSurveySet.do", method = RequestMethod.POST)
	public ModelAndView doAddSurveySet(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {	
			ArrayList<DataMap> list = new ArrayList<DataMap>();

			if(paraMap.get("que_seqs") != "") {
				String queSeq = (String) paraMap.get("que_seqs");
				
				String queSeqs[] = queSeq.split(",");
				
				for(int i = 0; i < queSeqs.length; i++) {				
					
					DataMap data = new DataMap();
					data.put("eset_seqs", seqService.doAddAndGetSeq(paraMap));
					data.put("que_seqs", queSeqs[i]);	
					
					list.add(data);					
				}
				paraMap.put("lists", list);
				
				this.surveyService.doAddSurveySet(paraMap);			
			}		

		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 설문지 문제 출제 수정 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateSurveySet.do", method = RequestMethod.GET)
	public ModelAndView doUpdateSurveySetForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/updateSurveySet.adminPopup");
		mav.addObject("paraMap", paraMap);	
		mav.addObject("data", this.surveyService.doGetSurveySet(paraMap));
		mav.addObject("paper", this.surveyService.doGetSurveyPaper(paraMap));
		
		paraMap.put("ppr_seq", paraMap.get("ppr_seq"));
		
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 설문지 문제 출제 수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateSurveySet.do", method = RequestMethod.POST)
	public ModelAndView doUpdateSurveySet(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		String userId = (String) request.getSession().getAttribute("userid");
		paraMap.put("siteid", siteid);	
		paraMap.put("userid", userId);
		try {		
			ArrayList<DataMap> list = new ArrayList<DataMap>();
			
			String[] eset_seq = (String[])paraMap.get("eset_seq");
			String[] que_score = (String[])paraMap.get("que_score");
			String[] useyn = (String[])paraMap.get("useyn");		
		
			int length = que_score.length;
			
			for(int i = 0; i < length; ++i) {				
				
				DataMap data = new DataMap();
				
				data.put("eset_seq", eset_seq[i]);
				data.put("que_score", que_score[i]);
				data.put("useyn", useyn[i]);			
				
				list.add(data);
				
			}
			paraMap.put("list", list);
			
			this.surveyService.doUpdateSurveySet(paraMap);
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 설문지 문제 출제 삭제
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/deleteSurveySet.do", method = RequestMethod.POST)
	public ModelAndView doDeleteSurveySet(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();		
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {		
			ArrayList<DataMap> list = new ArrayList<DataMap>();

			if(paraMap.get("delete_seqs") != "") {
				String queSeq = (String) paraMap.get("delete_seqs");
				
				String queSeqs[] = queSeq.split(",");
				
				for(int i = 0; i < queSeqs.length; i++) {				
					
					DataMap data = new DataMap();
					data.put("que_seq", queSeqs[i]);	
					
					list.add(data);					
				}
				paraMap.put("list", list);
				
				this.surveyService.doDeleteSurveySet(paraMap);		
			}					
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가 계획 목록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/surveyMng.do", method = RequestMethod.GET)
	public ModelAndView dolistSurveyMngForm (@ModelAttribute ("paraMap") DataMap paraMap) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/listSurveyMng.admin");
		mav.addObject("paraMap", paraMap);			
	 	
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가 계획 목록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/surveyMng.do", method = RequestMethod.POST)
	public ModelAndView dolistSurveyMngForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("jsonView");		
		mav.addObject("siteid", siteid);
		mav.addObject("paraMap", paraMap);		
		
		try {
		 	int totalCount = this.surveyService.doCountSurveyMng(paraMap);
			int totalPage  = (totalCount -1)/(10) + 1;	
			
			// GRID로 전달하는 데이터
			// --------------------------------------------------------------------------
			// 총 페이지 갯수
			mav.addObject("total",  totalPage);
			// 현재 페이지
			mav.addObject("page",   1);
			// 총 데이터 갯수
			mav.addObject("records", totalCount);
			// 그리드 데이터
			mav.addObject("rows",   this.surveyService.dolistSurveyMng(paraMap));
			// --------------------------------------------------------------------------		
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}	
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가계획 등록 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/addSurveyMng.do", method = RequestMethod.GET)
	public ModelAndView doAddSurveyMngForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/addSurveyMng.adminPopup");
		mav.addObject("paraMap", paraMap);	
		paraMap.put("seq_tblnm", "TE_EVAL_MNG");		
	 	
		return mav;
	}	

	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 5. 30
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가계획 등록
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/addSurveyMng.do", method = RequestMethod.POST)
	public ModelAndView doAddSurveyMng (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		String eval_seq =  String.valueOf(seqService.doAddAndGetSeq(paraMap));
		
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));
		paraMap.put("eval_seq", eval_seq);
		
		try {
		
			this.surveyService.doAddSurveyMng(paraMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 1.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가계획 수정 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/updateSurveyMng.do", method = RequestMethod.GET)
	public ModelAndView doUpdateSurveyMngForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/updateSurveyMng.adminPopup");
		mav.addObject("paraMap", paraMap);	
		mav.addObject("data", this.surveyService.doGetSurveyMng(paraMap));
	 	
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 1
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가계획 수정
	 * @Explain  : 
	 *
	 */
	@RequestMapping(value = "/updateSurveyMng.do", method = RequestMethod.POST)
	public ModelAndView doUpdateSurveyMng(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();
		
		paraMap.put("siteid", siteid);
		paraMap.put("userid", session.getAttribute("userid"));

		try {
			
			this.surveyService.doUpdateSurveyMng(paraMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}
		return mav;
	}		
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 1. 
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 평가계획 삭제
	 * @Explain  : 
	 *
	 */	
	@RequestMapping (value = "/deleteSurveyMng.do", method = RequestMethod.GET)
	public ModelAndView deleteSurveyMng(@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {	
		ModelAndView mav = new ModelAndView("jsonView");
		HttpSession session = request.getSession();		
		paraMap.put("userid", session.getAttribute("userid"));
		
		try {
			this.surveyService.doDeleteSurveyMng(paraMap);
			
		} catch (Exception e) {
			e.printStackTrace();
			return new ModelAndView("error");
		}			
		return mav;
	}	
	
	/**
	 *
	 * @Author   : ycjo
	 * @Date	 : 2020. 6. 1.
	 * @Parm	 : DataMap
	 * @Return   : ModelAndView
	 * @Function : 설문조사 결과 폼
	 * @Explain  : 
	 *
	 */
	@RequestMapping (value = "/listSurveyResult.do", method = RequestMethod.GET)
	public ModelAndView doListSurveyResultForm (@ModelAttribute ("paraMap") DataMap paraMap, HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("/lms/admin/survey/listSurveyResult.admin");
		mav.addObject("paraMap", paraMap);	
		mav.addObject("mng", this.surveyService.doGetSurveyPaper(paraMap)); //설문지 조회
	 	mav.addObject("subjective", this.surveyService.doListSubjective(paraMap)); //출제된 문제의 주관식 항목
	 	mav.addObject("choice", this.surveyService.doListMultipleChoice(paraMap)); //출제된 문제의 객관식 항목
	 	mav.addObject("queO", this.surveyService.doListSurveySetQueO(paraMap)); //객관식 문제  제목
	 	mav.addObject("queS", this.surveyService.doListSurveySetQueS(paraMap)); //주관식 문제  제목

		return mav;
	}		
		
		//jqtree 스트링 변환
		private String stringChange(List<DataMap> list) {
			StringBuilder sb = new StringBuilder();
			sb.append("<ul>");
			for(int i = 0; i < list.size(); i++) {
				if(list.get(i).get("ctgr_lvl").toString().equals("1")) {
					sb.append("<li id='" + list.get(i).get("ctgr_seq") + "' value='" + list.get(i).get("ctgr_lvl") + "'><a href='#'>" + list.get(i).get("ctgrnm") + "</a>");
					sb.append("<ul>");
					for(int j = i + 1; j < list.size(); j++) {				
						if(list.get(j).get("ctgr_lvl").toString().equals("2") && list.get(i).get("ctgr_seq").equals(list.get(j).get("up_seq"))) {
							sb.append("<li id='" + list.get(j).get("ctgr_seq") + "' value='" + list.get(j).get("ctgr_lvl") + "'><a href='#'>" + list.get(j).get("ctgrnm") + "</a>");
							sb.append("<ul>");
							for(int h = j + 1; h < list.size(); h++) {
								if(list.get(h).get("ctgr_lvl").toString().equals("3") && list.get(j).get("ctgr_seq").equals(list.get(h).get("up_seq"))) {
									sb.append("<li id='" + list.get(h).get("ctgr_seq") + "' value='" + list.get(h).get("ctgr_lvl") + "'><a href='#'>" + list.get(h).get("ctgrnm") + "</a>");
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
	
	//mcdropdown 스트링 변환
	private String changeMcdropdown(List<DataMap> list) {
		StringBuilder sb = new StringBuilder();
		int size = list.size();
		
		for(int i = 0; i < size; i++) {
			
			DataMap data = list.get(i);
			
			if(("1").equals(data.get("ctgr_lvl"))){
				
				sb.append("<li id='"+data.get("ctgr_seq")+"'>"+data.get("ctgrnm"));					
					
				int secondCheck = i+1;
					
				for(int j = i+1; j < size; j++){
					
					DataMap secondData = list.get(j);
					
					// 2depth일 경우
					if(("2").equals(secondData.get("ctgr_lvl"))){
						
						if(j == i+1){
							sb.append("<ul>");
						}
						
						sb.append("<li id='"+secondData.get("ctgr_seq")+"'>"+secondData.get("ctgrnm"));	
							
							int thirdCheck = j+1;
						
							for(int k = j+1; k < size; k++){
								
								DataMap thirdData = list.get(k);
								
								// 3depth일 경우
								if(("3").equals(thirdData.get("ctgr_lvl"))){
									
									if(k == j+1){
										sb.append("<ul>");
									}
									
									sb.append("<li id='"+thirdData.get("ctgr_seq")+"'>"+thirdData.get("ctgrnm"));
								}else{
									j = k-1;
									
									if(thirdCheck != k){
										sb.append("</ul>");
									}
									break;
								}
							}
							sb.append("</li>");
					}else{
						i = j-1;
						
						if(secondCheck != j){
							sb.append("</ul>");
						}
						break;
					}
				}
				sb.append("</li>");
			}
		}
		return sb.toString();
	}

}


