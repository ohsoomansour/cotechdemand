package com.ttmsoft.lms.front.techsearch;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class TechSearchService extends BaseSvc<DataMap> {
	
	
	/**
	 *
	 * @Author   : psm
	 * @Date	 : 2023. 8. 29.
	 * @Parm	 : DataMap
	 * @Return   : List<DataMap>
	 * @Function : 테스트용
	 * @Explain  : 
	 *
	 */
	public List<DataMap> doCheck(DataMap paraMap){
		return dao.dolistQuery("SubjectFrontSQL,selectCheck", paraMap);
	}
}

