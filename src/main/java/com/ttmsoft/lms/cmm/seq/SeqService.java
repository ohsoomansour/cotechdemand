package com.ttmsoft.lms.cmm.seq;


import org.springframework.stereotype.Service;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
public class SeqService extends BaseSvc<DataMap> {

	/**
	* 시퀀스가져오기
	* @param DataMap
	* @return int
	*/
	public int doAddAndGetSeq(DataMap paraMap){
		//update
		this.dao.updateQuery("SeqSQL.modifySeq", paraMap);
		//select
		return this.dao.countQuery("SeqSQL.getoneSeq", paraMap);
	}
		
	public int doGetSeq(DataMap paraMap){
		//select
		return this.dao.countQuery("SeqSQL.getoneSeq", paraMap);
	}		
}

