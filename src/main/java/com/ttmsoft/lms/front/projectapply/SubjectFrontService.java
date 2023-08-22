package com.ttmsoft.lms.front.projectapply;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.mail.MailSendException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sun.mail.smtp.SMTPSenderFailedException;
import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.lms.front.api.SignOkApi;
import com.ttmsoft.lms.front.notice.NoticeFrontService;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class SubjectFrontService extends BaseSvc<DataMap> {
	@Autowired
	private SeqService seqService;
	
	@Autowired
	private NoticeFrontService noticeService;

	@Autowired
	private SignOkApi signokApi;
	// 사업신청 카운트
	public int countApplyList(DataMap paraMap) {
		return dao.countQuery("SubjectFrontSQL.countApplyList", paraMap);
	}

	// 사업신청 리스트
	public List<DataMap> doListApply(DataMap paraMap) {
		int count = paraMap.getint("count");
		if (count < 10) {
			paraMap.put("offset", 0);
		}
		return this.dao.dolistQuery("SubjectFrontSQL.selectApplySignList", paraMap);
	}

	// 사업신청 작성
	public DataMap doDetailApply(HttpServletRequest request, DataMap paraMap) {
		// project 정보
		DataMap result = dao.selectQuery("ProjectFrontSQL.selectApplyDetail", paraMap);
		try {
			// 사업신청 작성 여부 확인
			int check = dao.countQuery("SubjectFrontSQL.countSubject", paraMap);
			if (check > 0) {
				// member데이터 가져오기
				DataMap subject = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
				result.put("subject", subject);
				paraMap.put("subject_seqno", subject.getstr("subject_seqno"));
				DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
				result.put("dcData", dcData);
				DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
				result.put("scData", scData);
				List<DataMap> cost = this.dao.dolistQuery("SubjectFrontSQL.selectSubjectCost", paraMap);
				result.put("cost", cost);
				DataMap apply = this.dao.selectQuery("SubjectFrontSQL.selectSubjectApply", paraMap);
				if(apply.getstr("fmst_seqno").equals("")||apply.getstr("fmst_seqno").equals(null)||apply.getstr("fmst_seqno").equals("null")) {
					apply.put("fmst_seqno", 0);
				}
				result.put("apply", apply);
			} else {
				result.remove("fmst_seq");
				result.put("fmst_seq", 0);
			}
			result.put("check", check);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result.put("check", 0);
			return result;
		}
	}

	// 사업자번호검색
	public List<DataMap> searchBiz(DataMap paraMap) {
		return this.dao.dolistQuery("SubjectFrontSQL.searchBizRegno", paraMap);
	}

	// 사업신청 
	public int doApplySubmit(DataMap paraMap, HttpServletRequest request) throws MailSendException,SMTPSenderFailedException {
		String subject_seqno = paraMap.get("subject_seqno").toString().trim();
		int fin = 0;
		paraMap.put("seq_tblnm", "TBLSUBJECT");
		paraMap.put("subject_proc_step", "110");
		paraMap.put("ip", request.getRemoteAddr());
		paraMap.put("applier_type", "SC");

		// cost 배열에 집어넣기
		List<Map<String, String>> list = new ArrayList<>();
		String[] costList = { "BS10", "BS20", "BS30", "BS40","BS50", "TS10", "TS20", "TS30" };
		for (int i = 0; i < costList.length; i++) {
			Map<String, String> data = new HashMap<String, String>();
			data.put("id", costList[i]);
			data.put("value", paraMap.getstr(costList[i].toLowerCase()));
			list.add(data);
		}
		System.out.println("list어케나옴"+list);
		paraMap.put("list", list);
		if (subject_seqno.equals("")) {
			// insert
			paraMap.put("subject_seqno", seqService.doAddAndGetSeq(paraMap));
			DataMap result = this.dao.selectQuery("SubjectFrontSQL.doInsertSubject", paraMap);
			paraMap.put("subject_seqno", result.getstr("subject_seqno"));
			// 공급기업,수요기업 insert
			fin += this.dao.insertQuery("SubjectFrontSQL.insertSubjectMember", paraMap);
			fin += this.dao.insertQuery("SubjectFrontSQL.insertSubjectCost", paraMap);
			fin += this.dao.insertQuery("SubjectFrontSQL.insertSubjectApply", paraMap);
			fin += this.dao.insertQuery("SubjectFrontSQL.insertSubjectApplyDetail", paraMap);
			paraMap.put("notice_gubun","adm");
			fin += noticeService.noticeStepSubmit(paraMap);
			System.out.println("fin의값은" + fin);
		} else {
			// update
			fin += this.dao.updateQuery("SubjectFrontSQL.doUpdateSubject", paraMap);
			fin += this.dao.updateQuery("SubjectFrontSQL.updateSubjectMemberDC", paraMap);
			fin += this.dao.updateQuery("SubjectFrontSQL.updateSubjectMemberSC", paraMap);
			fin += this.dao.insertQuery("SubjectFrontSQL.updateSubjectCost", paraMap);
			fin += this.dao.insertQuery("SubjectFrontSQL.updateSubjectApply", paraMap);
			//fin += this.dao.insertQuery("SubjectFrontSQL.updateSubjectApplyDetail", paraMap);
			paraMap.put("notice_gubun","adm");
			fin += noticeService.noticeStepSubmit(paraMap);
		}
		return fin;
	}
	

	// 사업신청서 제출 
	public int doApplyDocumentSubmit(DataMap paraMap, HttpServletRequest request) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		result += this.dao.updateQuery("SubjectFrontSQL.updateSubjectDocument",paraMap);
		
		return result;
		
	}

	// 사업신청 게시물 확인
	public int countList(DataMap paraMap) {
		return dao.countQuery("SubjectFrontSQL.countJoinSubjectList", paraMap);
	}

	// 게시판조회
	public List<DataMap> doListBoard(DataMap paraMap) {
		int count = paraMap.getint("count");
		if (count < 10) {
			paraMap.put("offset", 0);
		}
		return this.dao.dolistQuery("SubjectFrontSQL.selectSubjectJoinListAll", paraMap);
	}

	// 사업수행상세
	public DataMap doDeatilContract(DataMap paraMap) throws JSONException {
		//signok서명정보업데이트
		String[] ary = {"DC","SC","adm"};
		DataMap contract = this.dao.selectQuery("SubjectFrontSQL.selectSubjectContractDetail", paraMap);
		String documentid = contract.getstr("documentid");
		paraMap.put("documentid", documentid);
		try {
			DataMap getSign = signokApi.getSign(paraMap);
			if(!getSign.isEmpty()) {
				JSONArray signList =  (JSONArray) getSign.get("document_history");
				if(!signList.isNull(0)) {
					for(int i=0;i<signList.length();i++) {
						JSONObject signData = signList.getJSONObject(i);
						paraMap.put("sign_date", signData.get("history_datetime"));
						paraMap.put("user_gubun", ary[i]);
						this.dao.updateQuery("SubjectFrontSQL.updateContractDetail",paraMap);
					}
				}
				
			}
		}catch(Exception e) {
			
		}
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		if(contract.getstr("fmst_seqno").equals("")) {
			contract.put("fmst_seqno", 0);
		}
		result.put("contract", contract);
		DataMap contractDetailDC = this.dao.selectQuery("SubjectFrontSQL.selectContractDetailDC", paraMap);
		result.put("contractDetailDC", contractDetailDC);
		DataMap contractDetailSC = this.dao.selectQuery("SubjectFrontSQL.selectContractDetailSC", paraMap);
		result.put("contractDetailSC", contractDetailSC);
		DataMap contractDetailAdmin = this.dao.selectQuery("SubjectFrontSQL.selectContractDetailAdmin", paraMap);
		contractDetailAdmin.remove("userpwd");
		result.put("contractDetailAdmin", contractDetailAdmin);
		System.out.println("result에요" + result);
		return result;
	}

	public int setPerformData(DataMap paraMap) {
		List<DataMap> searchData = dao.dolistQuery("SubjectFrontSQL.selectSubjectList", paraMap);

		System.out.println("얘는 데이터가 어케나와요" + searchData);
		for (int i = 0; i < searchData.size(); i++) {
			String list_status = searchData.get(i).getstr("list_status").toString();
			if (list_status.equals("0")) {
				paraMap.put("list_status", "0");
				this.dao.updateQuery("SubjectFrontSQL.updateSubjectList", paraMap);
			}
		}

		return 0;
	}

	// 협약체결 카운트
	public int countContractList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countContract", paraMap);
		return result;
	}

	// 협약체결 리스트
	public List<DataMap> doListContract(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectContractList", paraMap);
		return result;
	}

	// 협약체결 승인
	public int contractSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		result = this.dao.updateQuery("SubjectFrontSQL.updateContract", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}

	// 권한부여 카운트
	public int countPermitList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countPermit", paraMap);
		return result;
	}

	// 권한부여 리스트
	public List<DataMap> doListPermit(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectPermitList", paraMap);
		return result;
	}

	// 권한부여 디테일
	public DataMap doDeatilPermit(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap permitData = this.dao.selectQuery("SubjectFrontSQL.selectPermitDetail",paraMap);
		if(permitData.getstr("fmst_seqno").equals("")) {
			permitData.put("fmst_seqno", 0);
		}
		result.put("permitData", permitData);
		System.out.println("result에요" + result);
		return result;
	}

	// 권한부여 신청
	public int doPermitSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		// permit상태값변경 20->50
		result += this.dao.updateQuery("SubjectFrontSQL.updatePermit", paraMap);
		int countSettle = this.dao.countQuery("SubjectFrontSQL.countSettle",paraMap);
		System.out.println("어케나와"+countSettle);
		if(countSettle==0) {
 			DataMap check = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
			LocalDate subject_sdate = LocalDate.parse(check.get("subject_sdate").toString());
			LocalDate subject_edate = LocalDate.parse(check.get("subject_edate").toString());

			boolean checkMonth = true;
			ArrayList<Integer> list = new ArrayList<>();
			int countss = 0;
			LocalDate temp = subject_sdate.plusMonths(1);
			while (checkMonth) {
				String check_date = temp.getYear() + "" + getMonth(temp.getMonthValue());
				list.add(Integer.parseInt(check_date));
				if (subject_edate.getYear() == temp.getYear()) {
					if (subject_edate.getMonthValue() == temp.getMonthValue()) {
						checkMonth = false;
					}else if(subject_edate.getMonthValue() < temp.getMonthValue()) {
						break;
					}
				}
				temp = temp.plusMonths(1);
			}
			
			System.out.println("어케나와요" + list);
			paraMap.put("list", list);
			paraMap.put("settle_type", "A10");
			paraMap.put("notice_gubun","sc");
			result += noticeService.noticeStepSubmit(paraMap);
			// 선금신청 insert
			result += this.dao.insertQuery("SubjectFrontSQL.insertSettle", paraMap);
			// 진도점검 insert
			result += this.dao.insertQuery("SubjectFrontSQL.insertCheck", paraMap);
			// 설문조사 insert
			//result += this.dao.insertQuery("SubjectFrontSQL.insertSurvey", paraMap);
			// 최종평가 insert
			result += this.dao.insertQuery("SubjectFrontSQL.insertEval", paraMap);
			// 추적조사 insert
			LocalDate tempDate = subject_edate.plusYears(1);
			String trace_date = tempDate.getYear()+"";
			paraMap.put("trace_date", trace_date);
			result += this.dao.insertQuery("SubjectFrontSQL.insertTrace", paraMap);
			paraMap.put("subject_proc_step","141");
			result += this.dao.updateQuery("SubjectFrontSQL.updateSubjectStatus",paraMap);

		}
		else {
			result = 0;
		}
		return result;
	}

	// 사업비신청 카운트
	public int countSettleList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countSettle", paraMap);
		return result;
	}

	// 사업비신청 리스트
	public List<DataMap> doListSettle(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectSettleList", paraMap);
		return result;
	}

	// 사업비신청 디테일
	public DataMap doDeatilSettle(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetailSC", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap settleData = this.dao.selectQuery("SubjectFrontSQL.selectSettleDetail", paraMap);
		if(settleData.getstr("fmst_seqno").equals("")) {
			settleData.put("fmst_seqno", 0);
		}
		result.put("settleData", settleData);
		List<DataMap> listSettleData = this.dao.dolistQuery("SubjectFrontSQL.selectSettleDetailList", paraMap);
		result.put("listSettleData", listSettleData);
		System.out.println("result에요" + result);
		return result;
	}

	// 사업비신청 신청
	public int doSettleSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;

		List<Map<String, Object>> list = new ArrayList<>();
		if (paraMap.get("cost").getClass().isArray()) {
			for (int i = 0; i < ((String[]) paraMap.get("cost")).length; i++) {
				Map data = new HashMap<>();
				data.put("cost", ((String[]) paraMap.get("cost"))[i]);
				data.put("desc", ((String[]) paraMap.get("desc"))[i]);
				data.put("item", ((String[]) paraMap.get("item"))[i]);
				list.add(data);
			}
		} else {
			Map data = new HashMap<>();
			data.put("cost", paraMap.get("cost"));
			data.put("desc", paraMap.get("desc"));
			data.put("item", paraMap.get("item"));
			list.add(data);
		}
		paraMap.put("list", list);
		System.out.println("어케나올꺄" + list);
		result += this.dao.updateQuery("SubjectFrontSQL.updateSettle", paraMap);
		result += this.dao.insertQuery("SubjectFrontSQL.insertSettleDetail", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}
	
	//진도점검카운트
	public int countCheckList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countCheck", paraMap);
		return result;
	}
	//진도점검리스트
	public List<DataMap> doListCheck(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectCheckList", paraMap);
		return result;
	}

	// 진도점검 디테일
	public DataMap doDeatilCheck(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetailSC", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap checkData = this.dao.selectQuery("SubjectFrontSQL.selectCheckDetail", paraMap);
		if (checkData.getstr("fmst_seqno").equals("")) {
			checkData.put("fmst_seqno", 0);
		}
		result.put("checkData", checkData);
		System.out.println("result에요" + result);
		return result;
	}

	// 진도점검 승인
	public int doCheckSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		result = this.dao.updateQuery("SubjectFrontSQL.updateCheck", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}

	// 현장실태조사 카운트
	public int countAddCheckList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countAddCheck", paraMap);
		return result;
	}

	// 현장실태조사 리스트
	public List<DataMap> doListAddCheck(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectAddCheckList", paraMap);
		return result;
	}

	// 현장실태조사 디테일
	public DataMap doDeatilAddCheck(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetailSC", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap checkData = this.dao.selectQuery("SubjectFrontSQL.selectAddCheckDetail", paraMap);
		if (checkData.getstr("fmst_seqno").equals("")) {
			checkData.put("fmst_seqno", 0);
		}
		result.put("checkData", checkData);
		System.out.println("result에요" + result);
		return result;
	}

	// 현장실태조사 작성
	public int doAddCheckSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		result = this.dao.updateQuery("SubjectFrontSQL.updateAddCheck", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}
	// 설문조사 카운트
	public int countSurveyList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countSurvey", paraMap);
		return result;
	}

	// 설문조사 리스트
	public List<DataMap> doListSurvey(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectSurveyList", paraMap);
		return result;
	}

	// 설문조사 디테일
	public DataMap doDeatilSurvey(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap surveyData = this.dao.selectQuery("SubjectFrontSQL.selectSurveyDetail", paraMap);
		result.put("surveyData", surveyData);
		List<DataMap> queResult = this.dao.dolistQuery("SubjectFrontSQL.doListQueResult", surveyData);
		result.put("queResult", queResult);
		if(surveyData.getstr("subject_proc_status").equals("50")) {
			
		}
		result.put("ppr_seq",surveyData.getstr("ppr_seq"));
		System.out.println("result에요" + result);
		return result;
	}

	// 설문조사 신청
	public int doSurveySubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = this.dao.updateQuery("SubjectFrontSQL.updateSurvey", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		paraMap.put("subject_proc_step", 170);
		result += this.dao.updateQuery("SubjectFrontSQL.updateSubjectStatus", paraMap);
		paraMap.remove("notice_gubun");
		paraMap.put("notice_gubun","dc");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}
	// 최종평가 카운트
	public int countEvalList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countEval", paraMap);
		return result;
	}

	// 최종평가 리스트
	public List<DataMap> doListEval(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectEvalList", paraMap);
		return result;
	}

	// 최종평가 디테일
	public DataMap doDeatilEval(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap evalData = this.dao.selectQuery("SubjectFrontSQL.selectEvalDetail", paraMap);
		if (evalData.getstr("fmst_seqno").equals("")) {
			evalData.put("fmst_seqno", 0);
		}
		result.put("evalData", evalData);
		System.out.println("result에요" + result);
		return result;
	}

	// 최종평가 승인
	public int doEvalSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		result = this.dao.updateQuery("SubjectFrontSQL.updateEval", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}

	// 추적조사 카운트
	public int countTraceList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countTrace", paraMap);
		return result;
	}

	// 추적조사 리스트
	public List<DataMap> doListTrace(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectTraceList", paraMap);
		return result;
	}

	// 추적조사 디테일
	public DataMap doDeatilTrace(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetail", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap traceData = this.dao.selectQuery("SubjectFrontSQL.selectTraceDetail", paraMap);
		if (traceData.getstr("fmst_seqno").equals("")) {
			traceData.put("fmst_seqno", 0);
		}
		result.put("traceData", traceData);
		System.out.println("result에요" + result);
		return result;
	}
	//정산관리 카운트
	public int countCalcList(DataMap paraMap) {
		int result = this.dao.countQuery("SubjectFrontSQL.countCalc", paraMap);
		return result;
	}
	
	// 정산관리 리스트
	public List<DataMap> doListCalc(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("SubjectFrontSQL.selectCalcList", paraMap);
		return result;
	}

	// 정산관리 디테일
	public DataMap doDeatilCalc(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetailSC", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC", paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC", paraMap);
		result.put("scData", scData);
		DataMap calcData = this.dao.selectQuery("SubjectFrontSQL.selectCalcDetail", paraMap);
		if (calcData.getstr("fmst_seqno").equals("")) {
			calcData.put("fmst_seqno", 0);
		}
		result.put("calcData", calcData);
		System.out.println("result에요" + result);
		return result;
	}

	// 추적조사 승인 없는기능인듯?
	
	  public int doTraceSubmit(DataMap paraMap) { 
		  int result = 0; result = this.dao.updateQuery("SubjectFrontSQL.updateTrace", paraMap); 
		  return result;
	 }
	 
	// 달 구하기
	public String getMonth(int data) {
		String date = String.valueOf(data);
		if (date.length() == 1) {
			date = "0" + date;
		}
		return date;
	}
	//설문지 목록조회 
	public List<DataMap> doListFrontSurveyPaper(DataMap paraMap) {
		return this.dao.dolistQuery("SubjectFrontSQL.doListFrontSurveyPaper", paraMap);
	}
		
	//설문 기간 조회 
	public List<DataMap> doListApplyDate(DataMap paraMap) {
		return this.dao.dolistQuery("SubjectFrontSQL.doListApplyDate", paraMap);
	}
	
	// 출제된 문제의 객관식 항목 목록 조회
	public List<DataMap> doListMultipleChoice(DataMap paraMap) {
		return this.dao.dolistQuery("SubjectFrontSQL.doListMultipleChoice", paraMap);
	}

	// 출제된 문제의 객관식 항목 목록 조회
	public List<DataMap> doListMultipleJu(DataMap paraMap) {
		return this.dao.dolistQuery("SubjectFrontSQL.doListMultipleJu", paraMap);
	}
	
	public int doCalcSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result = 0;
		result = this.dao.updateQuery("SubjectFrontSQL.updateCalc", paraMap);
		paraMap.put("subject_proc_step", 180);
		result += this.dao.updateQuery("SubjectFrontSQL.updateSubjectStatus", paraMap);
		paraMap.put("notice_gubun","adm");
		result += noticeService.noticeStepSubmit(paraMap);
		return result;
	}
	
	//출제된 문제의 객관식 항목 목록 조회 (2020.05 조예찬)
	public List<DataMap> doListMultipleChoiceList (DataMap paraMap){
		return this.dao.dolistQuery("SubjectFrontSQL.doListMultipleChoiceList", paraMap);
	}
	
	//출제된 문제의 객관식(점수) 항목 목록 조회 
	public List<DataMap> doListMultipleChoiceScore (DataMap paraMap){
		return this.dao.dolistQuery("SubjectFrontSQL.doListMultipleChoiceScore", paraMap);
	}
	
	//출제된 문제의 주관식 항목 목록 조회 (2020.05 조예찬)
	public List<DataMap> doListSubjective (DataMap paraMap){
		return this.dao.dolistQuery("SubjectFrontSQL.doListSubjective", paraMap);
	}
	
	public DataMap doSubjectDetail(DataMap paraMap) {
		return this.dao.selectQuery("SubjectFrontSQL.selectSubjectApply", paraMap);
	}
		
	
}
