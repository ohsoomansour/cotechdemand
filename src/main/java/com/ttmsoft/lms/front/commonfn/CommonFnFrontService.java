package com.ttmsoft.lms.front.commonfn;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class CommonFnFrontService extends BaseSvc<DataMap> {

	public int countAccountBookList(DataMap paraMap) {
		return dao.countQuery("CommonfnFrontSQL.countAccountBook",paraMap);
	}
	//정산관리 리스트
	public List<DataMap> doListAccountBook(DataMap paraMap) {
		int count = paraMap.getint("count");
		if(count<10) {
			paraMap.put("offset", 0);
		}
		System.out.println("확인용"+paraMap);
		List<DataMap> result = this.dao.dolistQuery("CommonfnFrontSQL.selectAccountBookList", paraMap);
		for(int i=0; i<result.size();i++) {
			DataMap data = new DataMap();
			String subject_seqno = result.get(i).getstr("subject_seqno");
			data.put("subject_seqno", subject_seqno);
			int sum_cost = this.dao.countQuery("CommonfnFrontSQL.selectAccountBookSumCost", data);
			result.get(i).put("sum_cost", sum_cost); 
		}
		return result; 
	}
	//정산관리 디테일
	public DataMap doDetailAccountBook(DataMap paraMap) {
		DataMap result = this.dao.selectQuery("SubjectFrontSQL.selectSubjectDetailSC", paraMap);
		DataMap dcData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberDC",paraMap);
		result.put("dcData", dcData);
		DataMap scData = this.dao.selectQuery("SubjectFrontSQL.selectSubjectMemberSC",paraMap);
		result.put("scData", scData);
		DataMap apply = this.dao.selectQuery("SubjectFrontSQL.selectSubjectApply",paraMap);
		result.put("apply", apply);
		List<DataMap> accountBookData = this.dao.dolistQuery("CommonfnFrontSQL.selectAccountBookDetail",paraMap);
		result.put("accountBookData", accountBookData);
		DataMap total = new DataMap();
		int cost = 0;
		int use_cost = 0;
		int remaining = 0;
		for(int i=0; i<accountBookData.size();i++) {
			cost += Integer.parseInt(accountBookData.get(i).getstr("cost"));
			use_cost += Integer.parseInt(accountBookData.get(i).getstr("use_cost"));
		}
		remaining = cost - use_cost;
		double use_rate = (double)use_cost/cost;
		total.put("cost", cost);
		total.put("use_cost", use_cost);
		total.put("remaining", remaining);
		total.put("use_rate", use_rate);
		result.put("total", total);
		System.out.println("result에요"+result);
		return result;
	}
	//정산관리 승인
	public int doAccountBookSubmit(DataMap paraMap) {
		int result = this.dao.updateQuery("SubjectFrontSQL.updateCalc",paraMap);
		return result;
	}
	public List<DataMap> doAccountBookHist(DataMap paraMap) {
		return this.dao.dolistQuery("CommonfnFrontSQL.selectAccountBookHist", paraMap);
	}
	public int accountBookSubmit(DataMap paraMap) {
		int result =0;
		if( paraMap.getstr("seqno").equals("")){
			int seqno = this.dao.countQuery("CommonfnFrontSQL.maxHistSeqno", paraMap);
			seqno = seqno+1;
			paraMap.put("seqno", seqno);
			result = this.dao.insertQuery("CommonfnFrontSQL.insertSettleHist", paraMap);
		}else {
			result = this.dao.updateQuery("CommonfnFrontSQL.updateSettleHist", paraMap);
		}
		
		DataMap settleDetail = this.dao.selectQuery("CommonfnFrontSQL.selectSettleDetail", paraMap);
		int cost = Integer.parseInt(settleDetail.getstr("cost"));
		int use_cost = Integer.parseInt(settleDetail.getstr("use_cost"));
		double use_rate = Double.parseDouble(settleDetail.getstr("use_rate"));
		
		use_cost += Integer.parseInt(paraMap.getstr("cost"));
		use_rate = (double)cost/use_cost;
		DataMap paraMap2 = new DataMap();
		paraMap2.put("subject_seqno", paraMap.getstr("subject_seqno"));
		paraMap2.put("settle_seqno", paraMap.getstr("settle_seqno"));
		paraMap2.put("settle_type", "A10");
		paraMap2.put("use_rate", use_rate);
		paraMap2.put("use_cost", use_cost);
		result += this.dao.updateQuery("CommonfnFrontSQL.updateSettleDetail",paraMap2);
		 
		return result;
	}
	
}

