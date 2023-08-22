<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
	var idCheck = false;			//아이디 중복검사 체크
	var bizRegnoCheck = false;		//사업자등록번호 중복검사 체크
	$(document).ready(function(){
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
	
	//[약관동의] - 약관동의 체크박스 제어 -> 2021/04/16 - 추정완
	function fncTermsAllCheckBox(input) {
		console.log(input);
		var checkAll = input;
		var checkList = $("input[name='termsCheckbox']");
		if(checkAll.checked == true) {
			for(var i = 0; i < checkList.length; i++) {
				checkList[i].checked = true;
			}
		}
		else{
			for(var i = 0; i < checkList.length; i++) {
				checkList[i].checked = false;
			}
		}
	}
	
	//[약관동의] - 약관동의 확인 -> 2021/04/16 - 추정완
	function fncTermsCheck() {
		var check = true;
		var checkList = $("input[name='termsCheckbox']");
		for(var i = 0; i < checkList.length; i++) {
			if(checkList[i].checked == false) {
				check = false;
			}
		}
		
		if(check == false) {
			alert_popup('모든 약관동의를 해주세요.');
		}
		else{
			$('#memberJoinTab1').css('display', 'none');
			$('#memberJoinTab2').css('display', 'block');
		}
	}
	
	//[회원가입] - 아이디 및 사업자등록번호 중복확인 -> 2021/04/16 - 추정완
	function fncDoubleCheck(gubun) {
		if(gubun == 'ID') {
			var id = $('#memberId').val();
			console.log('id : ' + id);
			if(id == '') {
				alert_popup('아이디를 입력 후 중복확인 버튼을 클릭해주세요.');
				return false;
			}
			$.ajax({
				type : 'POST',
				url : '/front/memberDoubleCheck.do',
				data : {
					gubun : gubun,
					id : id
				},
				dataType : 'json',
				success : function(transport) {
					var memberCount = transport.memberCount;
					if(memberCount == '1') {
						alert_popup('중복된 아이디가 있습니다. 다른 아이디를 사용해주세요.');
						idCheck = false;
					}
					else{
						alert_popup('사용가능한 아이디 입니다.');
						idCheck = true;
					}					
					
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			});
		}
		else{
			var bizRegno = $('#bizRegno').val();
			console.log('bizRegno : ' + bizRegno);
			if(bizRegno == '') {
				alert_popup('사업자등록번호를 입력 후 중복여부 버튼을 클릭해주세요.');
				return false;
			}
			$.ajax({
				type : 'POST',
				url : '/front/memberDoubleCheck.do',
				data : {
					gubun : gubun,
					biz_regno : bizRegno
				},
				dataType : 'json',
				success : function(transport) {
					var bizRegnoCount = transport.bizRegnoCount;
					if(bizRegnoCount == '1') {
						alert_popup('중복된 사업자등록번호 입니다. 다시 확인해주세요.');
						bizRegnoCheck = false;
					}
					else{
						alert_popup('사용 가능한 사업자등록번호 입니다.');
						bizRegnoCheck = true;
					}
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			});
		}
	}
	
	//[회원가입] - 사업장 주소 -> 2021/04/19 - 추정완
	function fncMemberAddress() {
        new daum.Postcode({
            oncomplete: function(data) {
            	var addr = ''; 		// 주소 변수
            	var zipcode = '';	// 우편번호 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }
            	
            	zipcode = data.zonecode;
            	
            	console.log('addr : ' + addr);
            	console.log('zipcode : ' + zipcode);
            	
            	$('#zipcode').val(zipcode);
            	$('#address1').val(addr);
            	setTimeout(function(){
            		$('#detailAddress').focus();
            	}, 500);
            }
        }).open();
    }
	
	//[회원가입] - 회원가입 -> 2021/04/19 - 추정완
	function fncMemberJoin() {
		if(!isBlank('아이디', '#memberId'))
		if(!isBlank('사업자등록번호', '#bizRegno'))
		if(!isBlank('기업명', '#bizName'))
		if(!isBlank('대표자명', '#owner'))
		if(!isBlank('일반전화번호', '#tel_no'))
		if(!isBlank('우편번호', '#zipcode'))
		if(!isBlank('주소', '#address1'))
		if(!isBlank('상세주소', '#detailAddress'))
		if(!isBlank('이름', '#userName'))
		if(!isBlank('휴대전화번호', '#userMobileNo'))
		if(!isBlank('이메일주소', '#userEmail'))
		if(!isBlank('부서', '#userDepart'))
		if(!isBlank('직위', '#userRank')){
			if(idCheck == true && bizRegnoCheck == true) {
				$.ajax({
					type : 'POST',
					url : '/front/memberJoin.do',
					data : $('#frm').serialize(),
					dataType : 'json',
					beforeSend: function() {
						$('.wrap-loading').removeClass('display-none');
					},
					success : function() {
						alert_popup('회원가입 성공!');
					},
					error : function() {
						
					},
					complete : function() {
						$('.wrap-loading').addClass('display-none');
	 					$('#memberJoinTab2').css('display', 'none');
						$('#memberJoinTab3').css('display', 'block');
						$('#emailUrl').val($('#userEmail').val());
					}
				})
			}
			else if(idCheck == false) {
				alert_popup('아이디 중복검사를 해주세요.');
				setTimeout(function(){
					$('#btnIdCheck').focus();
				}, 500);
				
				return false;
			}
			else if(bizRegnoCheck == false) {
				alert_popup('사업자등록번호 중복여부를 확인해주세요.');
				setTimeout(function(){
					$('#btnBizRegnoCheck').focus();
				}, 500);
				return false;
			}
		}
	}
	//[회원가입] - 이메일 확인 이동 -> 2021/04/19 추정완
	function fncCheckEmail() {
		var userEmail = $('#emailUrl').val();
		var emailUrl = userEmail.split('@')[1];
		window.open('https://www.' + emailUrl);
	}
	//[회원가입] - 로그인 화면 이동 -> 2021/04/26 추정완
	function fncLoginPage() {
		location.href="/front/login.do";
	}
</script>
<div class="sub_area">
	<div class="sub_contents_area">
		<div class="sub_list" style="width : 80%">
			<div>
				<h1 class="page-header">회원가입</h1>
				<!-- pathIndicator -->
				<p class="pathIndicator">
					<span class="home"><span class="glyphicon glyphicon-home"></span></span>
					<span class="separator">&gt;</span>
					<span class="category">Home</span>
					<span class="separator">&gt;</span>
					<span class="current category">회원가입</span>
				</p>
			</div>
			<div id="memberJoinTab1" style="text-align: center; display: block">
				<div style="text-align: center">
					<div><b>약관동의</b> > 회원정보입력 > 가입완료</label></div>
					<div><h3>약관동의</h3></div>
				</div>
				<div style="margin: 0 auto; width : 600px;">
					<div style="border: 1px solid black; width : 600px; height: 150px; margin-bottom: 30px;">
						<div style="float : left; width : 290px; padding : 10px; height: 50px">
							<button class="btn btn-primary btn-sm" title="이용약관동의 버튼">이용약관동의</button>
						</div>
						<div style="float : right; width : 290px; padding : 10px; height: 50px">
							<span>
								<input type="checkbox" id="agree1" name="termsCheckbox" title="이용약관동의">
								<label for="agree1">동의</label>
							</span>
						</div>
						<div style="clear: both; width : 600px">이용약관동의 내용~~</div>
					</div>
					<div style="border: 1px solid black; width : 600px; height: 150px; margin-bottom: 30px;">
						<div style="float : left; width : 290px; padding : 10px; height: 50px">
							<button class="btn btn-primary btn-sm" title="개인정보취급방침 버튼">개인정보취급방침</button>
						</div>
						<div style="float : right; width : 290px; padding : 10px; height: 50px">
							<span>
								<input type="checkbox" id="agree2" name="termsCheckbox" title="개인정보취급방침동의">
								<label for="agree2">동의</label>
							</span>
						</div>
						<div style="clear: both; width : 600px">개인정보취급방침 내용~~</div>
					</div>
					<div style="border: 1px solid black; width : 600px; height: 150px; margin-bottom: 30px;">
						<div style="float : left; width : 290px; padding : 10px; height: 50px">
							<button class="btn btn-primary btn-sm" title="제3자정보제공동의 버튼">제3자정보제공동의</button>
						</div>
						<div style="float : right; width : 290px; padding : 10px; height: 50px">
							<span onclick="fncTermsCheckbox(2)">
								<input type="checkbox" id="agree3" name="termsCheckbox" title="개인정보취급방침동의">
								<label for="agree3">동의</label>
							</span>
						</div>
						<div style="clear: both; width : 600px">제3자정보제공동의 내용~~</div>
					</div>
					<div>
						<input type="checkbox" id="allAgree" onclick="fncTermsAllCheckBox(this)" title="제3자정보제공동의"><label for="allAgree">전체동의</label>
					</div>
					<div>
						<button class="btn btn-default btn-sm" title="취소 버튼">취소</button>
						<button class="btn btn-default btn-sm" onclick="fncTermsCheck()" title="제3자정보제공동의 확인버튼">확인</button>
					</div>
				</div>
			</div>
			<div id="memberJoinTab2" style="display: none;">
				<div style="text-align: center">
					<div>약관동의 > <b>회원정보입력</b> > 가입완료</label></div>
					<div><h3>회원정보입력</h3></div>
				</div>
				<div class="table_box">
					<form id="frm">
						<div style="margin-bottom: 10px;">
							<div><label>▶ 기본정보</label></div>
					  		<div class="table2" style="border-top: solid #e4e4e4 1px">
					  			<table>
					  				<caption>기본정보</caption>
					  				<colgroup>
										<col style="width:20%" />
										<col />
									</colgroup>
									<tr>
										<th>아이디</th>
										<td class="form-inline left">
											<input type="text" id="memberId" name="id" class="form-control" title="아이디">
											<button type="button" id="btnIdCheck" class="btn btn-default btn-sm" title="중복확인 버튼">중복확인</button>
										</td>
									</tr>
									<tr>
										<th>비밀번호</th>
										<td class="left"><label>가입시 담당자 이메일로 임시비밀번호가 발급됩니다.</label></td>
									</tr>
					  			</table>
					  		</div>
				  		</div>
				  		<div style="margin-bottom: 10px">
							<div><label>▶ 기업정보</label></div>
					  		<div class="table2" style="border-top: solid #e4e4e4 1px">
					  			<table>
					  				<caption>사업자 기본정보</caption>
					  				<colgroup>
										<col style="width:20%" />
										<col />
									</colgroup>
									<tr>
										<th>사업자등록번호</th>
										<td class="form-inline left">
											<input type="text" id="bizRegno" name="biz_regno" class="form-control" title="사업자등록번호">
											<button type="button" id="btnBizRegnoCheck" class="btn btn-default btn-sm">중복여부</button>
											<button type="button" class="btn btn-default btn-sm">기업인증</button>
										</td>
									</tr>
									<tr>
										<th>기업명</th>
										<td class="form-inline left">
											<input type="text" id="bizName" name="biz_name" class="form-control" size="30" title="기업명">
										</td>
									</tr>
									<tr>
										<th>대표자명</th>
										<td class="form-inline left">
											<input type="text" id="owner" name="owner" class="form-control" size="30" title="대표자명">
										</td>
									</tr>
									<tr>
										<th>일반전화번호</th>
										<td class="form-inline left">
											<input type="text" id="telNo" name="tel_no" class="form-control" size="30" title="일반전화번호">
										</td>
									</tr>
									<tr>
										<th>사업장 주소</th>
										<td class="form-inline left">
											<input type="text" id="zipcode" name="zipcode" class="form-control" size="10" placeholder="우편번호" title="우편번호">
											<button type="button" class="btn btn-default btn-sm" onclick="fncMemberAddress()">주소 찾기</button>
											<br>
											<input type="text" id="address1" name="address1" class="form-control" size="50" placeholder="주소" title="주소">
											<br>
											<input type="text" id="address2" name="address2" class="form-control" size="50" placeholder="상세주소" title="상세주소">
										</td>
									</tr>
					  			</table>
					  		</div>
				  		</div>
				  		
				  		<div style="margin-bottom: 10px">
							<div><label>▶ 담당자정보</label></div>
					  		<div class="table2" style="border-top: solid #e4e4e4 1px">
					  			<table>
					  				<caption>담당자 기본정보</caption>
					  				<colgroup>
										<col style="width:20%" />
										<col />
									</colgroup>
									<tr>
										<th>이름</th>
										<td class="form-inline left">
											<input type="text" id="userName" name="user_name" class="form-control" title="담당자 이름">
										</td>
									</tr>
									<tr>
										<th>휴대전화번호</th>
										<td class="form-inline left">
											<input type="text" id="userMobileNo" name="user_mobile_no" class="form-control" size="30" title="휴대전화번호">
										</td>
									</tr>
									<tr>
										<th>이메일주소</th>
										<td class="form-inline left">
											<input type="text" id="userEmail" name="user_email" class="form-control" size="30" title="이메일주소">
										</td>
									</tr>
									<tr>
										<th>부서</th>
										<td class="form-inline left">
											<input type="text" id="userDepart" name="user_depart" class="form-control" title="부서">
										</td>
									</tr>
									<tr>
										<th>직위</th>
										<td class="form-inline left">
											<input type="text" id="userRank" name="user_rank" class="form-control" title="직위">
										</td>
									</tr>
					  			</table>
					  		</div>
				  		</div>
			  		</form>
		  		</div>
		  		
		  		<div class="btnList alignCenter mTop30">
		  			<button type="button" class="btn btn-primary btn-sm" onclick="fncLoginPage()">로그인 화면으로 이동</button>
		  			<button type="button" id="btnSubmit" class="btn btn-primary btn-sm">회원가입</button>
		  		</div>
			</div>
			
			<div id="memberJoinTab3" style="display: none;">
				<input type="hidden" id="emailUrl">
				<div style="text-align: center">
					<div>약관동의 > 회원정보입력 > <b>가입완료</b></label></div>
					<div><h3>가입완료</h3></div>
				</div>
				<div style="text-align: center; margin-top: 30px">
					<label>회원가입을 축하드립니다.<br><br>가입하신 이메일로 임시비밀번호가 발송되었습니다.<br>처음 로그인 시 비밀번호를 변경하시기 바랍니다.</label>
				</div>
				<div class="btnList alignCenter mTop30">
		  			<button type="button" id="btnEmailCheck" class="btn btn-primary btn-sm">이메일 확인 이동</button>
		  			<button type="button" class="btn btn-primary btn-sm" onclick="fncLoginPage()">로그인화면으로 이동</button>
		  		</div>
			</div>
		</div>
	</div>
</div>
<div class="wrap-loading display-none">
    <div><img src="/images/loading.gif"/></div>
</div>