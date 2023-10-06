package com.ttmsoft.lms.front.corporate;

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
public class TLOMypageService extends BaseSvc<DataMap>{
	

	/* 마이페이지 기업 기술분류 목록 - 2023/09/18 */
	public List<DataMap> doGetCodeListInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("TLOPageSQL.doGetCodeListInfo", paraMap);
		return result;
	}
	
	/* 마이페이지 기업 기술수요 목록 - 2023/09/24 */
	public List<DataMap> doGetCoTechDemandInfo(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("TLOPageSQL.doGetCoTechDemandInfo", paraMap);
		return result;
	}
	/* 마이페이지 기업 수요자 수정 - 2023/09/19 */
	public void doUpdateCorporate(DataMap paraMap) { 
		String keyword1 = paraMap.get("keyword1").toString().trim();
		String keyword2 = paraMap.get("keyword2").toString().trim(); 
		String keyword3 = paraMap.get("keyword3").toString().trim(); 
		String keyword4 = paraMap.get("keyword4").toString().trim(); 
		String keyword5 = paraMap.get("keyword5").toString().trim();
		
		if(!keyword1.isEmpty()) keyword1 = ""   + keyword1;
		if(!keyword2.isEmpty()) keyword2 = ", " + keyword2;
		if(!keyword3.isEmpty()) keyword3 = ", " + keyword3;
		if(!keyword4.isEmpty()) keyword4 = ", " + keyword4;
		if(!keyword5.isEmpty()) keyword5 = ", " + keyword5;
		
		paraMap.put("keyword1", keyword1);
		paraMap.put("keyword2", keyword2);
		paraMap.put("keyword3", keyword3);
		paraMap.put("keyword4", keyword4);
		paraMap.put("keyword5", keyword5);
		System.out.println("paraMap: "+paraMap);
		this.dao.insertQuery("TLOPageSQL.doUpdateCorporate", paraMap);
		this.dao.insertQuery("TLOPageSQL.doUpdateCorporateUser", paraMap);
	}
	
	/* 마이페이지 기업 카운트 - 2023/09/24*/
	public int doCountCorporates(DataMap paraMap) {
		int result = this.dao.countQuery("TLOPageSQL.doCountCorporates", paraMap);
		return result;
	}

	// 09.25 수정중.. 기업은 seqno가 동일하므로 co_td_no로 종류별 view_yn을 설정하는게 적절 
	public void doUpdateViewYn(DataMap paraMap) {
		String[] co_td_no_arr =(String[]) paraMap.get("co_td_no_arr");
		String[] view_yn_arr = (String[]) paraMap.get("view_yn_arr");
		
		for(int i=0; i< co_td_no_arr.length; i++) {
			paraMap.put("co_td_no", co_td_no_arr[i]);
			paraMap.put("view_yn", view_yn_arr[i]);
			this.dao.insertQuery("TLOPageSQL.doUpdateViewYn", paraMap);
		}
			
	}

	/* 마이페이지 기업 담당자 수정중.. - 2023/09/20 */
	public void doUpdateManager(DataMap paraMap) {
		String tel = paraMap.get("manager_tel1").toString() ;
				//+ "-" + paraMap.get("manager_tel2").toString() 
				//+ "-" + paraMap.get("manager_tel3").toString();
		
		String mail = paraMap.get("manager_mail1").toString() 
				+ "@" + paraMap.get("manager_mail2").toString();

		paraMap.put("tel", tel);
		paraMap.put("mail", mail);
		
		this.dao.insertQuery("TLOPageSQL.doUpdateManager", paraMap);
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
			
			this.dao.insertQuery("TLOPageSQL.doUpdateInvent", paraMap);
		}
	}
	
	/* 마이페이지 담당자정보 - 2023/09/11 */
	public List<DataMap> doGetManager(DataMap paraMap) {
		List<DataMap> result = this.dao.dolistQuery("TLOPageSQL.doGetManager", paraMap);
		return result;
	}

	public DataMap deTechPopupView (DataMap paraMap) {
		return this.dao.selectQuery("TLOPageSQL.deTechPopupView", paraMap);
	}
}
