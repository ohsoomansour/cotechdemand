package com.ttmsoft.lms.front.projectapply;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ProjectFrontService extends BaseSvc<DataMap> {
	@Autowired
	private SeqService seqService;

	// 게시판 조회
	public List<DataMap> doListBoard(DataMap paraMap) {
		int count = paraMap.getint("count");
		if (count < 10) {
			paraMap.put("offset", 0);
		}
		return this.dao.dolistQuery("ProjectFrontSQL.selectApplyList", paraMap);
	}

	// 게시판 개수 확인
	public int countList(DataMap paraMap) {
		return dao.countQuery("ProjectFrontSQL.countApplyList", paraMap);
	}

	// 사업공고 status 값 별로 데이터 셋팅부분
	public DataMap getDetailData(HttpServletRequest request, DataMap paraMap) {
		String seqNo = paraMap.getstr("project_seqno");
		if (!("").equals(seqNo)) {
			DataMap result = this.dao.selectQuery("ProjectFrontSQL.selectApplyDetail", paraMap);
			if (("").equals(result.get("fmst_seq").toString())) {
				result.put("fmst_seq", 0);
			}
			return result;
		}
		return paraMap;
	}
	public List<DataMap> doListJoin(DataMap paraMap) {
		return this.dao.dolistQuery("SubjectFrontSQL.selectSubjectJoinList", paraMap);
	}

}
