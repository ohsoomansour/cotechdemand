<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
	$(document).ready(function() {

	});

	//[비밀번호변경] - 2023/09/14 - 박성민
	function changePwd(){
		if(!isBlank('현재 비밀번호', '#pw'))
		if(!isBlank('새 비밀번호', '#newPwd'))
		if(!isBlank('새 비밀번호 확인', '#newPwdChk'))
		if($('#newPwd').val() != $('#newPwdChk').val()){
			alert_popup_focus('새 비밀번호와 새비밀번호 확인이 일치하지 않습니다.', '#newPwdChk');
			return false;
			}
		var url = '/techtalk/updatePwX.do';
		var form = $('#frm')[0];
		var data = new FormData(form);
		$.ajax({
			url : url,
	       type: "post",
	       processData: false,
	       contentType: false,
	       data: data,
	       dataType: "json",
	       success : function(res){
		       if(res.result==0){
		    	   alert_popup_focus('현재 비밀번호가 일치하지 않습니다 비밀번호를 확인해 주세요.', '#pwd');
			       }else if(res.result==1){
				       alert("비밀번호가 변경되었습니다. 다시 로그인 해주세요.");
				       doLogout();
				       }
	    	   
	       },
	       error : function(){
	    		alert('실패했습니다.');    
	       },
	       async:false,
	       complete : function(){

	       }
		});
	}
</script>
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">비밀번호 변경</h3>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<form id="frm">
				<input type="hidden" id="id" name="id" value="${id }"/>
				<input type="hidden" id="member_seqno" name="member_seqno" value="${member_seqno }"/>
				<div class="area_cont ">
					<div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>비밀번호 변경 폼</caption>
							<colgroup>
								<col style="width: 15%">
								<col>
							</colgroup>
							<thead></thead>
							<tbody class="view">
								<tr>
									<th scope="col">현재 비밀번호 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="password" class="form-control form_id" id="pwd"name="pwd" title="현재 비밀번호"> 
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">새 비밀번호 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="password" class="form-control form_man_name"
												id="newPwd" name="new_pwd" maxlength="20" title="새 비밀번호" >
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">새 비밀번호 확인<span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="password" class="form-control form_man_name"
												id="newPwdChk" name="new_pwd_chk" maxlength="20" title="새 비밀번호확인" />
										</div>
									</td>
								</tr>
							</tbody>
							<tfoot></tfoot>
						</table>
					</div>
				</div>
			</form>
			<div class="wrap_btn _center">
				<a href="javascript:history.back();" class="btn_cancel" title="취소">취소</a>
				<a href="javascript:changePwd();" class="btn_confirm"title="비밀번호 변경하기">비밀번호 변경하기 </a> 
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>