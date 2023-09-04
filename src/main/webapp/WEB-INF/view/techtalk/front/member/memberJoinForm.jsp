<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
	$(document).on('ready', function() {
		setTimeout(function() {
			$('#member_type').focus();
		}, 500);

	});
	var idCheck = false; //아이디 중복검사 체크
	var pwCheck = false; //패스워드 중복검사 체크
	
	$(document).ready(
			function() {
				//아이디 중복체크 클릭
				$('#btnIdCheck').click(function() {
					fncDoubleCheck("ID");
				});

				//사업자등록번호 중복체크 클릭
				$('#btnBizRegnoCheck').click(function() {
					fncDoubleCheck("BR");
				});

				//회원가입
				$('#btnSubmit').click(function() {
					fncMemberJoin();
				});

				//이메일 확인 이동
				$('#btnEmailCheck').click(function() {
					fncCheckEmail();
				});

			});
	//회원가입 -> 2023/09/03 - 박성민
	function fncMemberJoin(){
		if(!idCheck){
			alert_popup_focus('id중복체크를 해주세요', '#id');
			}
		if(!pwCheck){
			alert_popup_focus('비밀번호 일치여부를 확인해주세요.', '#pw');
		}
		var url = "/techtalk/memberJoin.do"
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
				    	alert("성공") 
			       },
			       error : function(){
			    	alert('게시판 등록에 실패했습니다.');    
			       },
			       complete : function(){
			       }
			});
		
		}

	//[회원가입] - 아이디 및 사업자등록번호 중복확인 -> 2021/04/16 - 추정완
	function fncDoubleCheck(gubun) {
		if (gubun == 'ID') {
			var id = $('#id').val();
			console.log('id : ' + id);
			if (id == '' || id == null) {
				alert_popup_focus('아이디를 입력 후 중복확인 버튼을 클릭해주세요.', '#id');
				return false;
			}
			/*if(id.length < 8){
				alert_popup_focus('아이디를 8글자 이상 입력해 주세요.','#id');
				return false;
				}*/
			$.ajax({
				type : 'POST',
				url : '/techtalk/memberDoubleCheck.do',
				data : {
					gubun : gubun,
					id : id
				},
				dataType : 'json',
				success : function(transport) {
					var memberCount = transport.memberCount;
					if (memberCount == '1') {
						alert_popup_focus('중복된 아이디가 있습니다. 다른 아이디를 사용해주세요.',
								'#id');
						idCheck = false;
					} else if (id.length < 3) {
						alert_popup_focus('아이디를 3글자 이상 입력해 주세요.', '#id');
						return false;
					} else if (id.length >= 3) {
						alert("여기냐")
						changeText('사용가능한 아이디 입니다.', '#checkId');
						idCheck = true;
					}

				},
				error : function() {

				},
				complete : function() {

				}
			});
		} else {
			var bizRegno = $('#bizRegno').val();
			console.log('bizRegno : ' + bizRegno);
			if (bizRegno == '' || bizRegno == null) {
				alert_popup_focus('사업자등록번호를 입력 후 중복여부 버튼을 클릭해주세요.', '#bizRegno');
				return false;
			}
			$.ajax({
				type : 'POST',
				url : '/techtalk/memberDoubleCheck.do',
				data : {
					gubun : gubun,
					biz_regno : bizRegno
				},
				dataType : 'json',
				success : function(transport) {
					var bizRegnoCount = transport.bizRegnoCount;
					if (bizRegnoCount == '1') {
						alert_popup_focus('중복된 사업자등록번호 입니다. 다시 확인해주세요.',
								'#bizRegno');
						bizRegnoCheck = false;
						return false;
					} else {
						alert_popup_focus('사용 가능한 사업자등록번호 입니다.',
								'#btnBizRegnoCheck');
						bizRegnoCheck = true;
						fncBizInsert();
					}
				},
				error : function() {

				},
				complete : function() {

				}
			});
		}
	}

	//임시데이터만들기
	function fncSetData() {
		$('#memberType').val("R");
		$('#id').val("test");
		$('#pw').val("test");
		$('#passWordCk').val("test");
		$('#userName').val("박성민");
		$('#userEmail1').val("ghkdljtjd");
		$('#userEmail2').val("gamkil.com");
		$('#userMobileNo').val("01094778894");
		$('#bizName').val("회사명");
		$('#userDepart').val("부서");
		$('#userRank').val("직급");
		$('#bizEmail1').val("ozs876");
		$('#bizEmail2').val("naver.com");
		$('#bizTelNo').val("0200000000");
		idCheck = true;
		pwCheck = true;
	}

	function fncChangeEmail(obj) {
		var selValue = obj.value;
		if (selValue == "직접입력" || selValue == "") {
			$('#userEmail2').val("");
		} else {
			$('#userEmail2').val(selValue);
		}
	}

	//[회원가입] - 회원가입 완료 화면 이동 -> 2021/06/29 이효상
	function fncCompeletePage() {
		location.href = "/techtalk/memberJoinCompletePage.do";
	}

	
	function popup() {
		var url = "/images/techtalk/example.jpg";
		var name = "popup test";
		var option = "width = 500, height = 500, top = 100, left = 200, location = no "
		window.open(url, name, option);
	}

	function changeText(text, id){
		$(id).empty();
		$(id).html(text);
		console.log("여기는?")
		}
</script>
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">회원정보입력</h3>
				<div class="wrapper-stepper agree_box">
					<ul class="stepper">
						<li class="active">약관동의</li>
						<li class="active">회원정보입력</li>
						<li>가입완료</li>
					</ul>
				</div>
			</div>
			<!-- //page_title e:  -->
			<!-- page_content s:  -->
			<form id="frm">
				<div class="area_cont ">
					<div class="subject_corp">
						<h4>개인정보 입력</h4>
					</div>
					<div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>개인정보 입력폼</caption>
							<colgroup>
								<col style="width: 15%">
								<col>
							</colgroup>
							<thead></thead>
							<tbody class="view">
								<tr>
									<th scope="col">기업유형 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<div class="box_radioinp">
												<input type="radio" class="inp_radio" name="member_type"
													id="R" value="R" title="연구자" checked /><label for="R"
													class="lab_radio"><span class="icon ico_radio"></span>연구자</label>
											</div>
											<div class="box_radioinp">
												<input type="radio" class="inp_radio" name="member_type"
													id="B" value="B" title="기업" /><label for="B"
													class="lab_radio"><span class="icon ico_radio"></span>기업</label>
											</div>
											<div class="box_radioinp">
												<input type="radio" class="inp_radio" name="member_type"
													id="TLO" value="TLO" title="TLO" /><label for="TLO"
													class="lab_radio"><span class="icon ico_radio"></span>TLO</label>
											</div>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">아이디 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_id" id="id"
												name="id"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												title="아이디"> <a href="javascript:void;"
												class="btn_step2" title="중복확인" id="btnIdCheck">중복확인</a> <span
												style="margin-left: 10px;">8~20자 이내의 영문자(대,소) / 숫자 /
												특수문자(.,_,-,@)만 입력가능합니다. </span>
										</div>
										<div>
											<p id="idCheck" />
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">비밀번호 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="password" class="form-control form_pw" id="pw"
												name="pw" title="비밀번호"> <span
												style="margin-left: 125px;">8~20자 이내의 영문자(대,소) / 숫자 /
												특수문자만 입력가능합니다.</span>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">비밀번호 확인 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="password" class="form-control form_pw"
												id="passWordCk" name="passWordCk" title="비밀번호 확인">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">이름 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_man_name"
												id="userName" name="user_name" maxlength="20" title="이름">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">개인이메일 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_email1"
												id="userEmail1" name="user_email1"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일아이디">@ <input
												type="text" class="form-control form_email2" id="userEmail2"
												name="user_email2"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일 도메인 직접입력"> <select
												class="form-control form_email3" id="userEmail3"
												name="user_email3" onChange="fncChangeEmail(this);"
												title="담당자 이메일주소3">
												<option title="직접입력">직접입력</option>
												<option title="네이버">naver.com</option>
												<option title="G메일">gmail.com</option>
												<option title="다음">daum.net</option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">휴대전화 번호 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" 
												onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"
												class="form-control form_man_name" id="userMobileNo"
												name="user_mobile_no" title="휴대전화">
										</div>
									</td>
								</tr>

							</tbody>
							<tfoot></tfoot>
						</table>
					</div>
				</div>
				<div class="area_cont area_cont2">
					<div class="subject_corp w_top">
						<h4>기업정보</h4>
						<p class="es">* 표시는 필수 입력 사항입니다.</p>
					</div>
					<div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>회원가입 회원 기업정보</caption>
							<colgroup>
								<col style="width: 15%">
							</colgroup>
							<thead></thead>
								<col>
							<tbody class="view">
								<tr>
									<th scope="col">회사명 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_com_name"
												id="bizName" name="biz_name" title="회사명">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">부서명 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_dept"
												id="userDepart" name="user_depart" maxlength="50"
												title="담당자 부서">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">직급 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_spot"
												id="userRank" name="user_rank" maxlength="20" title="담당자 직위">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">업무용이메일 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_email1"
												id="bizEmail1" name="biz_email1"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일아이디">@ <input
												type="text" class="form-control form_email2" id="bizEmail2"
												name="biz_email2"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일 도메인 직접입력"> <select
												class="form-control form_email3" id="bizEmail3"
												name="biz_email3" onChange="fncChangeEmail(this);"
												title="담당자 이메일주소3">
												<option title="직접입력">직접입력</option>
												<option title="네이버">naver.com</option>
												<option title="G메일">gmail.com</option>
												<option title="다음">daum.net</option>
											</select>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">회사용직통전화번호 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text"
												onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"
												class="form-control form_man_name" id="bizTelNo" name="biz_tel_no"
												title="회사용직통전화번호">
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
				<a href="javascript:fncMemberJoin();" class="btn_confirm"title="회원가입">회원가입 </a> 
				<a href="javascript:fncSetData();"class="btn_confirm">데이터입력 </a>
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>