<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
	var mode = '${mode}';		//폼 모드 아이디 찾기/비밀번호 찾기
	$(document).ready(function(){
		if(mode == 'ID') {
			$('#tap1').css('display', 'block');
			$('#tap2').css('display', 'none');
		}
		else{
			$('#tap1').css('display', 'none');
			$('#tap2').css('display', 'block');
		}
		
		
		$('#btnFindId').click(function() {
			fncFindId();
		});
		$('#btnGetPw').click(function() {
			fncFindPw();
		})
		// 다이얼로그 창 닫기 
		$('button[name=btnCancel]').click(function() {
			parent.$('#dialog').dialog('close');
		});
		$('#btnGetId').click(function() {
			fncGetEmailToId()();
		});
		$('#btnEmailCheck').click(function() {
			fncCheckEmail();
		})
	});
	
	//[아이디 찾기] - 아이디 찾기 -> 2021/04/19 - 추정완
	function fncFindId() {
		var bizNo_ID = $('#bizNo_ID').val();
		var email_ID = $('#email_ID').val();
		if(!isBlank('사업자등록번호', '#bizNo_ID'))
		if(!isBlank('이메일', '#email_ID')){
			$.ajax({
				type : 'POST',
				url : '/techtalk/findId.do',
				data : {
					biz_regno : bizNo_ID,
					user_email : email_ID
				},
				dataType : 'json',
				success : function(data) {
					var result_check = data.result_check;
					if(result_check == '0') {
						alert_popup('사업자등록번호 및 담당자 이메일을 다시 확인해주세요.');
						return false;
					}
					else{
						var userInfo = data.userInfo;
						
						$('#tap1_1').css('display', 'none');
						$('#tap1_2').css('display', 'block');
						
						var memberId = userInfo.id;		//memberid 셋팅필요
						
						$('#saveId').val(memberId);
						$('#saveEmail').val(email_ID);
						
						var idLength = memberId.length;
						memberId = memberId.substr(0, 2) + Array(idLength - 1).join("*");
						$('#findId').append(memberId);
					}
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			})
		}
	}
	//[아이디 찾기] - 이메일로 완전한 아이디 받기
	function fncGetEmailToId() {
		var saveId = $('#saveId').val();
		var saveEmail = $('#saveEmail').val();	
		
		$.ajax({
			type : 'POST',
			url : '/techtalk/getEmailToId.do',
			data : {
				saveId : saveId,
				saveEmail : saveEmail
			},
			dataType : 'json',
			beforeSend: function() {
				$('.wrap-loading').removeClass('display-none');
			},
			success : function() {
				alert_popup('해당 이메일로 전송 완료 되었습니다.');
			},
			error : function() {
				
			},
			complete : function() {
				$('.wrap-loading').addClass('display-none');
			}
		})
	}
	//[비밀번호 찾기] - 비밀번호 찾기 -> 2021/04/21 - 추정완
	function fncFindPw() {
		var bizNo_PW = $('#bizNo_PW').val();
		var id = $('#id').val();
		var email_PW = $('#email_PW').val();
		if(!isBlank('사업자등록번호', '#bizNo_PW'))
		if(!isBlank('아이디', '#id'))
		if(!isBlank('이메일', '#email_PW')) {
			$.ajax({
				type : 'POST',
				url : '/techtalk/getEmailToPw.do',
				data : {
					biz_regno : bizNo_PW,
					id : id,
					user_email : email_PW
				},
				dataType : 'json',
				beforeSend: function() {
					$('.wrap-loading').removeClass('display-none');
				},
				success : function(data) {
					var result_check =  data.result_check;
					if(result_check == 0) {
						alert_popup('정보를 다시 확인해주세요.');
						return false;
					}
					else{
						$('.wrap-loading').addClass('display-none');
						$('#emailUrl').val(email_PW);
						$('#tap2_1').css('display', 'none');
						$('#tap2_2').css('display', 'block');
					}
				},
				error : function() {
					
				}
			})
		}
	}
	//[비밀번호 찾기] - 이메일 확인 이동 -> 2021/04/21 추정완
	function fncCheckEmail() {
		var email = $('#emailUrl').val();
		var emailUrl = email.split('@')[1];
		window.open('https://www.' + emailUrl);
	}
</script>
<div class="modal_pop_cont">
	<input type="hidden" id="saveId">
	<input type="hidden" id="saveEmail">
	<div id="tap1" style="display: block">
		<div class="line form-inline alignCenter">
			<label>기업회원 아이디 찾기</label>
		</div>
		<div id="tap1_1" style="display: block">
			<div class="table2 mTop5">
				<table>
					<caption class="caption_hide">기업회원 아이디 찾기</caption>
					<colgroup>
						<col style="width:30%"/>
						<col style="width:70%"/>
					</colgroup>
					<tbody class="line">
						<tr>
							<th>사업자등록번호</th>
							<td class="left form-inline">
								<input type="text" id="bizNo_ID" class="form-control" title="사업자등록번호" />
							</td>
						</tr>
						<tr>
							<th>담당자 이메일</th>
							<td class="left form-inline">
								<input type="text" id="email_ID" class="form-control" title="담당자 이메일" />
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btnList alignCenter mTop60">
					<button type="button" id="btnFindId" class="btn btn-primary btn-sm" title="확인">확인</button>
					<button type="button" name="btnCancel" class="btn btn-primary btn-sm" title="닫기">닫기</button>
				</div>
			</div>
		</div>
		<div id="tap1_2" style="display: none">
			<div class="line form-inline alignCenter">
				<div style="margin-top: 30px">
					<label>가입하신 아이디는</label>
					<label id="findId"></label>
					<label>입니다.</label>
				</div>
				<label style="color: red">완전한 아이디 정보는 이메일로 요청 시 확인가능합니다.</label>
			</div>
			<div class="btnList alignCenter mTop60">
				<button type="button" id="btnGetId" class="btn btn-primary btn-sm" title="이메일로 완전한 아이디 받기">이메일로 완전한 아이디 받기</button>
				<button type="button" name="btnCancel" class="btn btn-primary btn-sm" title="확인">확인</button>
			</div>
		</div>
	</div>
	<div id="tap2" style="display: none">
		<div class="line form-inline alignCenter">
			<label>기업회원 비밀번호 찾기</label>
		</div>
		<div id="tap2_1" style="display: block">
			<div class="table2 mTop5">
				<table>
					<caption class="caption_hide">기업회원 비밀번호 찾기</caption>
					<colgroup>
						<col style="width:30%"/>
						<col style="width:70%"/>
					</colgroup>
					<tbody class="line">
						<tr>
							<th>사업자등록번호</th>
							<td class="left form-inline">
								<input type="text" id="bizNo_PW" class="form-control" title="사업자등록번호" />
							</td>
						</tr>
						<tr>
							<th>아이디</th>
							<td class="left form-inline">
								<input type="text" id="id" class="form-control" title="아이디" />
							</td>
						</tr>
						<tr>
							<th>담당자 이메일</th>
							<td class="left form-inline">
								<input type="text" id="email_PW" class="form-control" title="담당자 이메일" />
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btnList alignCenter mTop60">
					<button type="button" id="btnGetPw" class="btn btn-primary btn-sm" title="확인">확인</button>
					<button type="button" name="btnCancel" class="btn btn-primary btn-sm" title="닫기">닫기</button>
				</div>
			</div>
		</div>
		<div id="tap2_2" style="display: none">
			<input type="hidden" id="emailUrl">
			<div class="line form-inline alignCenter">
				<div style="margin-top: 30px">
					<label>가입하신 이메일로 임시비밀번호를 발급했습니다.</label>
				</div>
			</div>
			<div class="btnList alignCenter mTop60">
				<button type="button" id="btnEmailCheck" class="btn btn-primary btn-sm" title="이메일로 이동">이메일로 이동</button>
				<button type="button" name="btnCancel" class="btn btn-primary btn-sm" title="확인">확인</button>
			</div>
		</div>
	</div>
</div>
<div class="wrap-loading display-none">
    <div><img src="/images/loading.gif"/></div>
</div>