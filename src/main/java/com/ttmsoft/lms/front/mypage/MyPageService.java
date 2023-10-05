package com.ttmsoft.lms.front.mypage;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MyPageService extends BaseSvc<DataMap>{
	@Autowired
	private SeqService	seqService;

	/* 마이페이지 연구자 목록 - 2023/09/05 */
	public DataMap doGetResearcherInfo(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("MyPageSQL.doGetResearcherInfo", paraMap);
		return result;
	}
	
	
	/* 마이페이지 연구자 기술분류 목록 - 2023/09/07 */
	public List<DataMap> doGetCodeListInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetCodeListInfo", paraMap);
		return result;
	}
	
	/* 마이페이지 국가과제 - 2023/09/12 */
	public List<DataMap> doGetProject(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetProject", paraMap);
		return result;
	}
	
	/* 마이페이지 국가과제 - 2023/09/12 */
	public List<DataMap> doGetInvent(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetInvent", paraMap);
		return result;
	}
	
	/* 마이페이지 유사연구자- 2023/09/11 */
	public List<DataMap> doGetSimilar(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetSimilar", paraMap);
		return result;
	}
	
	/* 마이페이지 연구히스토리- 2023/09/12 */
	public List<DataMap> doGetHistory(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetHistory", paraMap);
		return result;
	}
	
	/* 마이페이지 엑셀정보 - 2023/09/11 */
	public List<DataMap> doGetExcel(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetExcel", paraMap);
		return result;
	}

	
	/* 마이페이지 연구자 수정 - 2023/09/13 */
	public void doUpdateResearcher(DataMap paraMap) {
		String keyword2 = paraMap.get("keyword2").toString().trim(); 
		String keyword3 = paraMap.get("keyword3").toString().trim(); 
		String keyword4 = paraMap.get("keyword4").toString().trim(); 
		String keyword5 = paraMap.get("keyword5").toString().trim();

		if(!keyword2.isEmpty()) keyword2 = ", "+keyword2;
		if(!keyword3.isEmpty()) keyword3 = ", "+keyword3;
		if(!keyword4.isEmpty()) keyword4 = ", "+keyword4;
		if(!keyword5.isEmpty()) keyword5 = ", "+keyword5;
		
		paraMap.put("keyword2", keyword2);
		paraMap.put("keyword3", keyword3);
		paraMap.put("keyword4", keyword4);
		paraMap.put("keyword5", keyword5);
		
		this.dao.insertQuery("MyPageSQL.doUpdateResearcher", paraMap);
	}
	
	/* 마이페이지 연구자 담당자 수정 - 2023/09/13 */
	public void doUpdateManager(DataMap paraMap) {
		String tel = paraMap.get("manager_tel1").toString() 
				+ "-" + paraMap.get("manager_tel2").toString() 
				+ "-" + paraMap.get("manager_tel3").toString();
		
		String mail = paraMap.get("manager_mail1").toString() 
				+ "@" + paraMap.get("manager_mail2").toString();

		paraMap.put("tel", tel);
		paraMap.put("mail", mail);
		
		this.dao.insertQuery("MyPageSQL.doUpdateManager", paraMap);
	}
	
	/* 마이페이지 연구자 특허 수정 - 2023/09/13 */
	public void doUpdateInvent(DataMap paraMap) {
	String[] invent_research_seqno =(String[]) paraMap.get("invent_research_seqno");
	String[] invent_nm =(String[]) paraMap.get("invent_nm");
	String[] applicant_no =(String[]) paraMap.get("applicant_no");
	String[] applicant_dt =(String[]) paraMap.get("applicant_dt");
	
		for(int i=0; i<invent_research_seqno.length; i++) {
			paraMap.put("research_seqno", invent_research_seqno[i]);
			paraMap.put("invent_nm", invent_nm[i]);
			paraMap.put("applicant_no", applicant_no[i]);
			paraMap.put("applicant_dt", applicant_dt[i]);
			
			this.dao.insertQuery("MyPageSQL.doUpdateInvent", paraMap);
		}
	}
	
	/* 마이페이지 연구자 엑셀 입력 - 2023/09/15 */
	public void doInsertExcel(DataMap paraMap) {
		String[] ex_assignm_no =(String[]) paraMap.get("ex_assignm_no");
		String[] ex_re_project_nm =(String[]) paraMap.get("ex_re_project_nm");
		String[] ex_re_institu_nm =(String[]) paraMap.get("ex_re_institu_nm");
		String[] ex_re_start_date =(String[]) paraMap.get("ex_re_start_date");
		String[] ex_re_end_date =(String[]) paraMap.get("ex_re_end_date");
		String[] ex_keyword =(String[]) paraMap.get("ex_keyword");

		for(int i=0; i<ex_assignm_no.length; i++) {
			paraMap.put("ex_assignm_no", ex_assignm_no[i]);
			paraMap.put("ex_re_project_nm", ex_re_project_nm[i]);
			paraMap.put("ex_re_institu_nm", ex_re_institu_nm[i]);
			paraMap.put("ex_re_start_date", ex_re_start_date[i]);
			paraMap.put("ex_re_end_date", ex_re_end_date[i]);
			paraMap.put("ex_keyword", ex_keyword[i]);
			
			this.dao.insertQuery("MyPageSQL.doInsertExcel", paraMap);
			this.dao.insertQuery("MyPageSQL.doInsertHistory", paraMap);
		}
	}
	
	/* 마이페이지 연구자 카운트 - 2023/09/15 */
	public int doCountResearcherItem(DataMap paraMap) {
		int result = this.dao.countQuery("MyPageSQL.doCountResearcherItem", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 연구자목록 - 2023/09/15 */
	public List<DataMap> doGetTloResearchList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetTloResearchList", paraMap);
		return result;
	}
	
	/* 마이페이지 연구자 특허 수정 - 2023/09/18 */
	public void doUpdateViewYn(DataMap paraMap) {
		String[] researcher_seqno =(String[]) paraMap.get("researcher_seqno");
		String[] view_yn =(String[]) paraMap.get("view_yn");
	
		for(int i=0; i<researcher_seqno.length; i++) {
			paraMap.put("researcher_seqno", researcher_seqno[i]);
			paraMap.put("view_yn", view_yn[i]);
			
			this.dao.insertQuery("MyPageSQL.doUpdateViewYn", paraMap);
		}
	}
	
	/* 마이페이지 TLO연구자 상세 - 2023/09/05 */
	public DataMap doGetTloDetail(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("MyPageSQL.doGetTloDetail", paraMap);
		return result;
	}
	
	/* 마이페이지 연구자 카운트 - 2023/09/15 */
	public int doCountAdminResearcherItem(DataMap paraMap) {
		int result = this.dao.countQuery("MyPageSQL.doCountAdminResearcherItem", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 연구자목록 - 2023/09/15 */
	public List<DataMap> doGetAdminResearchList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetAdminResearchList", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭목록 - 2023/09/21 */
	public List<DataMap> doGetTloMatchList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetTloMatchList", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭목록 카운트 - 2023/09/21 */
	public int doCountTloMatchList(DataMap paraMap) {
		int result = this.dao.countQuery("MyPageSQL.doCountTloMatchList", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭이력 - 2023/09/22 */
	public List<DataMap> doTloMatchHistoryList(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doTloMatchHistoryList", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭여부필터 Y - 2023/09/21 */
	public List<DataMap> doGetTloMatchList2(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetTloMatchList2", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭여부필터 카운트 Y - 2023/09/21 */
	public int doCountTloMatchList2(DataMap paraMap) {
		int result = this.dao.countQuery("MyPageSQL.doCountTloMatchList2", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭여부필터 N - 2023/09/21 */
	public List<DataMap> doGetTloMatchList3(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("MyPageSQL.doGetTloMatchList3", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭여부필터 카운트 N - 2023/09/21 */
	public int doCountTloMatchList3(DataMap paraMap) {
		int result = this.dao.countQuery("MyPageSQL.doCountTloMatchList3", paraMap);
		return result;
	}
	
	/* 마이페이지 TLO 매칭이력 수정 - 2023/09/18 */
	public void doSetUpdate(DataMap paraMap) {
		String[] match_date = (String[]) paraMap.get("match_date");
		String[] contents = (String[]) paraMap.get("contents");
		String[] business_nm = (String[]) paraMap.get("business_nm");
		String[] business_tel = (String[]) paraMap.get("business_tel");
		String[] business_mail = (String[]) paraMap.get("business_mail");
		String[] researcher_nm = (String[]) paraMap.get("researcher_nm");
		String[] researcher_tel = (String[]) paraMap.get("researcher_tel");
		String[] researcher_mail = (String[]) paraMap.get("researcher_mail");
	
		for(int i=0; i<researcher_nm.length; i++) {
			paraMap.put("match_date", match_date[i]);
			paraMap.put("contents", contents[i]);
			paraMap.put("business_nm", business_nm[i]);
			paraMap.put("business_tel", business_tel[i]);
			paraMap.put("business_mail", business_mail[i]);
			paraMap.put("researcher_nm", researcher_nm[i]);
			paraMap.put("researcher_tel", researcher_tel[i]);
			paraMap.put("researcher_mail", researcher_mail[i]);
			
			this.dao.insertQuery("MyPageSQL.doSetUpdate", paraMap);
		}
	}
}
