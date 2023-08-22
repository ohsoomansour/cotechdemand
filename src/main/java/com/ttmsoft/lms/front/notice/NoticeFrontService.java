package com.ttmsoft.lms.front.notice;

import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailSendException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sun.mail.smtp.SMTPSenderFailedException;
import com.ttmsoft.lms.cmm.seq.SeqService;
import com.ttmsoft.toaf.basemvc.BaseSvc;
import com.ttmsoft.toaf.object.DataMap;

@Service
@Transactional(value = "postgresqlTransactionManager", propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class NoticeFrontService extends BaseSvc<DataMap> {
	
	@Autowired
	private SeqService seqService;

	public int doCountNotice (DataMap paraMap) {
		return this.dao.countQuery("NoticeSQL.doCountNotice", paraMap);
	}
	
	
	public List<DataMap> doListNotice (DataMap paraMap){
		return this.dao.dolistQuery("NoticeSQL.doListNotice", paraMap);
	}
	
	public DataMap doGetNotice (DataMap paraMap) {
		return this.dao.selectQuery("NoticeSQL.doGetNotice", paraMap);
	}
	
	public List<DataMap> doListNoticeAttach(DataMap paraMap){
		return this.dao.dolistQuery("NoticeSQL.doListNoticeAttach", paraMap);
	}
	
	public int noticeConfirm(DataMap paraMap) {
		return this.dao.updateQuery("NoticeSQL.noticeConfirm", paraMap);
	}
	
	//각 사업단계 승인시 통지기능
	public int noticeStepSubmit(DataMap paraMap) throws MailSendException,SMTPSenderFailedException {
		int result =0;
		DataMap check = this.dao.selectQuery("NoticeSQL.NoticeUser",paraMap);
		if(check == null) {
			check = new DataMap();
			check.put("subject_seqno", paraMap.getstr("subject_seqno"));
			check.put("subject_ref", paraMap.getstr("subject_ref"));
			check.put("subject_proc_step", "사업신청");
			check.put("dc_user_id", paraMap.getstr("member_seqno"));
			check.put("sc_user_id", paraMap.getstr("sc_member_seqno"));
			check.put("adm_user_id", "1");
		}
		String notice_gubun = paraMap.getstr("notice_gubun").toString();
		String check_date = paraMap.getstr("check_date");
		if(!check_date.equals("")) {
			String subject_proc_step = check.getstr("subject_proc_step");
			subject_proc_step += check_date.substring(0,4) +"년" + check_date.substring(4)+"월";
			System.out.println("어케드러오니:"+subject_proc_step);
			check.remove("subject_proc_step");
			check.put("subject_proc_step", subject_proc_step);
		}else {
			
		}
		paraMap.put("notice_type","50");
		String title = check.getstr("subject_ref") +" " + check.getstr("subject_proc_step")+ " 신청 알림";
		paraMap.put("notice_title", title);
		
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		int day = cal.get(Calendar.DAY_OF_MONTH);
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int min = cal.get(Calendar.MINUTE); 
		String contents = title + "<br/>" 
				+year+"년도"+month+"월"+day+"일"+hour+"시"+min+"분 에 " +check.getstr("subject_proc_step") +"이(가) 신청되었습니다.";
		paraMap.put("notice_contents_data", contents);
		
		paraMap.put("confirm_required_flag", "Y");
		paraMap.put("seq_tblnm", "tblsubject_notice_send");
		paraMap.put("notice_seqno", seqService.doAddAndGetSeq(paraMap));
		paraMap.remove("subject_proc_step");
		paraMap.put("subject_proc_step", check.getstr("subject_proc_step"));
		paraMap.put("seq_tblnm", "TBLSMSMESSAGE");
		paraMap.put("fsequence", seqService.doAddAndGetSeq(paraMap));
		//전담기관
		if(notice_gubun.equals("adm")) {
			paraMap.put("send_type", "R");
			paraMap.put("member_seqno", check.getstr("adm_user_id"));
			paraMap.put("userno", check.getstr("adm_user_id"));
			paraMap.put("target", "ADM");
			DataMap checkUser = this.dao.selectQuery("MemberSQL.doGetMemberInfo",paraMap);
			paraMap.put("email", checkUser.get("email"));
			String mphone = checkUser.get("mphone").toString().replaceAll("-", "");
			paraMap.put("mphone", mphone);
			result += this.dao.insertQuery("MessageSQL.insertSmsMessage", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNotice", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeDetail", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeHist", paraMap);
		//수요기업
		}else if(notice_gubun.equals("dc")) {
			paraMap.put("send_type", "S");
			paraMap.put("member_seqno", check.getstr("dc_user_id"));
			paraMap.put("target", "DC");
			DataMap checkUser = this.dao.selectQuery("Member_v_SQL.doGetMemberInfo",paraMap);
			paraMap.put("email", checkUser.get("user_email"));
			String mphone = checkUser.get("user_mobile_no").toString().replaceAll("-", "");
			paraMap.put("mphone", mphone);
			result += this.dao.insertQuery("MessageSQL.insertSmsMessage", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNotice", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeDetail", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeHist", paraMap);
		//공급기업
		}else if(notice_gubun.equals("sc")) {
			paraMap.put("send_type", "S");
			paraMap.put("member_seqno", check.getstr("sc_user_id"));
			paraMap.put("target", "SC");
			DataMap checkUser = this.dao.selectQuery("Member_v_SQL.doGetMemberInfo",paraMap);
			paraMap.put("email", checkUser.get("user_email"));
			String mphone = checkUser.get("user_mobile_no").toString().replaceAll("-", "");
			paraMap.put("mphone", mphone);
			result += this.dao.insertQuery("MessageSQL.insertSmsMessage", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNotice", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeDetail", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeHist", paraMap);
		//수요,공급기업
		}else if(notice_gubun.equals("both")) {
			paraMap.put("send_type", "S");
			paraMap.put("member_seqno", check.getstr("dc_user_id"));
			paraMap.put("target", "DC");
			DataMap checkDCUser = this.dao.selectQuery("Member_v_SQL.doGetMemberInfo",paraMap);
			paraMap.put("email", checkDCUser.get("user_email"));
			String dcmphone = checkDCUser.get("user_mobile_no").toString().replaceAll("-", "");
			paraMap.put("mphone", dcmphone);
			result += this.dao.insertQuery("MessageSQL.insertSmsMessage", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNotice", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeDetail", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeHist", paraMap);
			paraMap.remove("member_seqno");
			paraMap.remove("target");
			paraMap.remove("notice_seqno");
			paraMap.put("notice_seqno", seqService.doAddAndGetSeq(paraMap));
			paraMap.put("member_seqno", check.getstr("sc_user_id"));
			paraMap.put("target", "SC");
			DataMap checkSCUser = this.dao.selectQuery("Member_v_SQL.doGetMemberInfo",paraMap);
			paraMap.put("email", checkSCUser.get("user_email"));
			String scmphone = checkSCUser.get("user_mobile_no").toString().replaceAll("-", "");
			paraMap.put("mphone", scmphone);
			result += this.dao.insertQuery("MessageSQL.insertSmsMessage", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNotice", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeDetail", paraMap);
			result += this.dao.insertQuery("NoticeSQL.insertNoticeHist", paraMap);
		}
		return result;
	}
	
	public List<DataMap> doPopupListNotice (DataMap paraMap){
		return this.dao.dolistQuery("NoticeSQL.doPopupListNotice", paraMap);
	}
	
	public int doConfirmNotice (DataMap paraMap){
		return this.dao.updateQuery("NoticeSQL.noticeConfirm", paraMap);
	}	

}
