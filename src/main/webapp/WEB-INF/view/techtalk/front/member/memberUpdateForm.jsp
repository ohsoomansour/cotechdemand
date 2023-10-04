<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
.ui-autocomplete {
  max-height: 200px;
  overflow-y: auto;
  /* prevent horizontal scrollbar */
  overflow-x: hidden;
  height: auto;
}
.ui-menu-item div.ui-state-hover,
.ui-menu-item div.ui-state-active {
  color: #ffffff;
  text-decoration: none;
  background-color: #f6B664;
  border-radius: 0px;
  -webkit-border-radius: 0px;
  -moz-border-radius: 0px;
  background-image: none;
  border:none;
}
</style>
<script>
var searchSource = ['엽기떡볶이', '신전떡볶이', '걸작떡볶이', '신당동떡볶이']; // 배열 생성
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

				//이메일 확인 이동
				$('#btnEmailCheck').click(function() {
					fncCheckEmail();
				});
				 // input필드에 자동완성 기능을 걸어준다
				$("#bizName").autocomplete({
			    source: function (request, response) {
				    var data = $('#bizName').val();
			        $.ajax({
			            url: "/techtalk/autoSearchBusinessX.do",
			            type: "POST",
			            dataType: "json",
			            data: { applicant_nm: request.term },
			            success: function (data) {
			                response(
			                    $.map(data.result, function (item) {
				                    console.log("어케나옴"+JSON.stringify(item));
			                        return {
			                            label: item.applicant_nm+'label',
			                            value: item.applicant_nm,
			                            idx: item.applicant_nm+'idx',
			                        }
			                    })
			                )
			            }
			        })
			    },
			    focus: function (event, ui) {
			        return false;
			    },
			    select: function (event, ui) {
			    	console.log(ui.item.idx)
			    },
			    delay: 500,
			    autoFocus: true
			});

			});

	
	//[회원가입] - 기업명 자동검색 -> 2023/09/06 - 박성민
	function autoComplete(){
		var data = $('#bizName').val();
		console.log("입력값");
		$.ajax({
			type : 'POST',
			url : '/techtalk/autoSearchBusinessX.do',
			data : {
				applicant_nm : data
			},
			dataType : 'json',
			success : function(data) {
				console.log("dd"+JSON.stringify(data.result));
             $.map(data.result, function(item) {
                 console.log("어케나옴:+"+JSON.stringify(item.applicant_nm))
                 return {
                     label : item.applicant_nm + 'label',
                     value : item.applicant_nm,
                     test : item.applicant_nm + 'test'
                 }
             })
					},
			select : function(event, ui) {
	            console.log(ui);
	            console.log(ui.item.label);
	            console.log(ui.item.value);
	            console.log(ui.item.test);
       },
       focus : function(event, ui) {
           return false;
       },
       minLength : 1,
       autoFocus : true,
       classes : {
           'ui-autocomplete': 'highlight'
       },
       delay : 500,
       position : { my : 'right top', at : 'right bottom' },
       close : function(event) {
           console.log(event);
       }
		});

	}
	
	//회원가입 -> 2023/09/08 - 박성민
	function fncMemberUpdate(){
		//개인정보 유효성 검사
		
		var url = "/techtalk/updateMemberX.do"
		var form = $('#frm')[0];
		var data = new FormData(form);
		console.log("이게왜 ? + " + idCheck + " pw + " + pwCheck)
		console.log("데이터확인" +JSON.stringify(data));
		
			$.ajax({
			       url : url,
			       type: "post",
			       processData: false,
			       contentType: false,
			       data: data,
			       dataType: "json",
			       success : function(res){
				       if(res.result == 1){
				    	   alert("회원정보가 변경되었습니다.");
				    	   location.reload();
					       }else{
				    	   alert('회원정보 수정에 실패하였습니다. 관리자에게 문의해주세요.');
						     }
			       },
			       error : function(res){
			    	alert('통신에 실패하였습니다. 관리자에게 문의해주세요.');    
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
				url : '/techtalk/memberDoubleCheckX.do',
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
									<th scope="col">회원종류 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<p>${userInfo.member_type }</p>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">아이디 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_id" id="id"
												name="id"
												title="아이디" value="${userInfo.id}"> 
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">이름 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_man_name"
												id="userName" name="user_name" maxlength="20" title="이름" value=${userInfo.user_name }>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">개인이메일 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_email1"
												id="userEmail" name="user_email"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일아이디" value="${userInfo.user_email }">
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
												name="user_mobile_no" title="휴대전화" value="${userInfo.user_mobile_no }">
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
											<input type="text" 
												id="bizName" name="biz_name" title="회사명" value=${userInfo.biz_name }>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">부서명 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_dept"
												id="userDepart" name="user_depart" maxlength="50"
												title="담당자 부서" value=${userInfo.user_depart }>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">직급 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_spot"
												id="userRank" name="user_rank" maxlength="20" title="담당자 직위" value=${userInfo.user_rank }>
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">업무용이메일 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_email1"
												id="bizEmail" name="biz_email"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일아이디" value=${userInfo.biz_email }>
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
												title="회사용직통전화번호" value=${userInfo.biz_tel_no }>
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
				<a href="javascript:fncMemberUpdate();" class="btn_confirm"title="회원가입">수정하기 </a> 
			</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>