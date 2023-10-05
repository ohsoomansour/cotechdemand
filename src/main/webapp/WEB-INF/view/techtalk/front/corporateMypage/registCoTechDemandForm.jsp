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
	
	$(document).on('ready', function() {
		setTimeout(function() {
			$('#member_type').focus();
		}, 500);
		

	});

// 키워드 자동 검색: 2023.09.18 오수만
var searchList = [];
var keyword_String =" ";
$(document).ready(	
		
	function() {
		
		// input필드에 자동완성 기능을 걸어준다
		$("#keyword").autocomplete({
			//하단에 뜨는 자동완성리스트(필수값)
			  source: function (request, response) {
				  console.log("request:" + JSON.stringify(request))
				  
				  var data = $('#keyword').val();
			      $.ajax({
			          url: "/techtalk/autoSearchKeywordX.do",
			          type: "POST",
			          dataType: "json",
			          data: { code_name: request.term },
			          success: function (data) {
			              response(
			                  $.map(data.result, function (item) {
				                  console.log("검색 코드 이름들 던져 주니까 어째나옴?" + JSON.stringify(item));
			                      return {
			                          label: item.code_name,
			                      }
			                  })
			              )
			          }
			      })
			  },
			  focus: function (event, ui) {
			      return false;
			  },
			  select: function (event, item) {
				  
				   console.log(item.item.value)  //item변수는 > {item: {…}}   
				   console.log(searchList)
		
				   if(searchList.length >= 5) { 
					   alert("키워드 5개를 모두 입력였습니다!")
						return searchList; 
				   } else if(searchList.length < 5){
					   alert("키워드 5개를 입력하세요!") //알림:키워드 5개 입력하라고 
					   searchList.push(item.item.value) // 5개까지 카운트, 그 이상 반환! 
					   keyword_String += ('#' + item.item.value + ",") ; 
					   $("#keyword_record").text(keyword_String) 
					   if(searchList.length == 5){
						   alert("키워드 5개를 모두 입력였습니다!")
						   //5가 되면 keyword의 값을 db에 넘겨줌 
						   return searchList;
					   }
				   } 
				
			   
			  },
			  delay: 500,
			  autoFocus: true
		});
	});	

	//기업 기술수요 등록  -> 2023/09/15 
	function funcCTDInsert(){
		
		//개인정보 유효성 검사
		if(!isBlank('키워드', '#keyword')) // 9.20 #keyword의 값에서 >> #keyword_record값을 받아서 db에 넣음  
		if(!isBlank('필요 기술', '#tech_needs'))
		if(!isBlank('에로사항', '#erro'))
		if(!isBlank('보유 연구 인프라', '#rndInfra'))
		if(!isBlank('투자 의지', '#investWilling'))
		if(!isBlank('회사명', '#bizName'))
		if(!isBlank('부서명', '#userDepart'))
		if(!isBlank('직급', '#userRank'))
		if(!isBlank('업무용 이메일', '#bizEmail1'))
		if(!isBlank('업무용 이메일 도메인', '#bizEmail2'))
		if(!isBlank('휴대전화번호', '#userMobileNo'))	
		
		$('#frm').submit();
		alert("등록되었습니다!");
		setTimeout(function() {
			moveCTDL();
		}, 5000);
		
		
		/*
		//var form = $('#frm')[0];  //폼
		var url = "/techtalk/insertCoTechDemandX.do"
		//var data = new FormData(form);
		var selStdClassCd1 = $('#selStdClassCd1').val;
		var selStdClassCd2 = $('#selStdClassCd2').val;
		var selStdClassCd3 = $('#selStdClassCd3').val;
		
			$.ajax({
			       url : url,
			       type: "post",
			       processData: false,
			       contentType: false,
			       data:{  
			    	   selStdClassCd1: $('#selStdClassCd1').val,
			    	   selStdClassCd2: $('#selStdClassCd2').val,
			    	   selStdClassCd3: $('#selStdClassCd2').val,
			       },
			       dataType: "json",
			       success : function(res){
			    	   	console.log(res)			    	   	
				    	alert("등록되었습니다!")
				    	//성공했다 >> 이동 함수를 호출
				    	//moveCTDL();
			       },
			       error : function(){
			    	alert('기업수요 등록에 실패했습니다.');    
			       },
			       complete : function(){
			       }
			});
		*/
		
	
		}

	function moveCTDL() {
		location.href = "/techtalk/moveCoTechDemandList.do";
	}

	function fncChangeEmail(obj) {
		var selValue = obj.value;
		if (selValue == "직접입력" || selValue == "") {
			$('#bizEmail2').val("");
		} else {
			$('#bizEmail2').val(selValue);
		}
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
	
	
	/*var RNDs = false;  //<select> 대-중-소 분류 
		function update_selected() {
		  $("#selStdClassCd2").val(0);
		  $("#selStdClassCd2").find("option[value!=0]").detach();
	
		  $("#selStdClassCd2").append(RNDs.filter(".RND" + $(this).val())); // this.val 값이 
		  
		}
		
		$(function() {
		  RNDs = $("#selStdClassCd3").find("option[value!=0]");
		 
		  RNDs.detach();
	
		  $("#selStdClassCd3").change(update_selected);
		  $("#selStdClassCd3").trigger("change");

	});*/
	function fncChangeStd(obj, gubun){
		var selValue = obj.value;
		if(selValue == "" || selValue == "선택"){
			if(gubun == "mid"){
				$('#selStdClassCd2').empty();
				$('#selStdClassCd3').empty();
				$('#selStdClassCd2').append("<option title='기술분류2' value=''>선택</option>");
				if(selValue == "") {
					$('#selStdClassCd2').attr('disabled', 'disabled');
				}
				$('#selStdClassCd3').append("<option title='기술분류3' value=''>선택</option>");
				$('#selStdClassCd3').attr('disabled', 'disabled');
			} else if(gubun == "sub" || gubun == "end") {
				$('#selStdClassCd3').empty();
				$('#selStdClassCd3').append("<option title='기술분류3' value=''>선택</option>");
				$('#selStdClassCd3').attr('disabled', 'disabled');
			} 
		}else{
			$.ajax({
				type : 'POST',
				url : '/techtalk/doGetCodeList2X.do',
				data : {
					parent_code_key : selValue,
					gubun : gubun
				},
				dataType : 'json',
				success : function(res) {
					console.log(res)
					var codeData = "";
					var aHtml = "";
					if(gubun == "mid"){
						codeData = res.codeList;
						aHtml += "<option title='기술분류2' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						
						$('#selStdClassCd2').empty();
						$('#selStdClassCd2').append(aHtml);
						$('#selStdClassCd2').removeAttr("disabled");	
					} else if(gubun == "sub") {
						codeData = res.codeList;
						aHtml += "<option title='기술분류3' value=''>선택</option>";
						$.each(codeData, function(key, val){
							aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
						});
						
						$('#selStdClassCd3').empty();
						$('#selStdClassCd3').append(aHtml);
						$('#selStdClassCd3').removeAttr("disabled");	
					} 
				},
				error : function() {
					
				},
				complete : function() {
					
				}
			});
		}
	}
	
</script>
<!-- compaVcContent s:  -->

<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s: 기업수요 정보 / 소속(회사 이름)  
			<div class="area_tit">
				
			</div>-->
			<!-- page_content s: 기업 기술수요 등록 폼  -->
			<form id="frm" action="#" method="post" >
				<div class="area_cont ">
					<div class="tbl_view tbl_public">
						<table class="tbl">
							<caption>기업수요 정보 입력폼</caption>
							<colgroup>
								<col style="width: 15%">
								<col>
							</colgroup>
							<thead></thead>
							<tbody class="view">
								<tr>
									<th scope="col">기술명 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">	
											<select id="selStdClassCd1" name="selStdClassCd1" onChange="fncChangeStd(this, 'mid');" title="기술분류1" style="width:32%;">
													<option title="기술분류1" value="">선택</option>
												<c:forEach var="code1" items="${codeList1}" varStatus="status">
												 	<option title="${code1.code_name}" value="${code1.code_key}">${code1.code_name}</option>
												</c:forEach>
											</select> 
											<select id="selStdClassCd2" name="selStdClassCd2"  onChange="fncChangeStd(this, 'sub');" title="기술분류2" style="width:32%;">
												<c:forEach var="code2" items="${codeList2}" varStatus="status">
													<option title="기술분류2" value="${code2.code_key}">${code2.code_name}</option>
												</c:forEach>
											</select> 
											<select id="selStdClassCd3" name="selStdClassCd3" title="기술분류3" style="width:32%;">
													<option title="기술분류3" value="">선택</option>
												<c:forEach var="code3" items="${codeList3}" varStatus="status">
													<option title="${code3.code_name3}" value="${code3.code_key}">${code3.code_name}</option>
												</c:forEach>
											</select>
										</div>
									</td>
								</tr>
								
								<!-- 키워드 검색 -->
								<tr>
									<th scope="col">키워드 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_dept"
												   id="keyword" name="keyword" maxlength="50" title="검색">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">키워드 검색내용</th>
									<td><textarea id="keyword_record" name="keyword_record" class="form-control"></textarea></td>
								</tr>
								<tr>
									<th scope="col">필요 기술<span class="red">*</span></th>
									<td class="ta_left">
										<textarea id="tech_needs" name="tech_needs" class="form-control" style="height: 100px"></textarea>
									</td>
								</tr>
								
								<!-- 기업 에로사항, 보유 연구 인프라, 투자 의지(사업 투자 여력) -->
								<tr>
									<th scope="col">기업 에로사항 <span class="red">*</span></th>
									<td class="ta_left">
										<textarea id="erro" name="erro" class="form-control" style="height: 100px"></textarea>
									</td>
								</tr>
								<tr>
									<th scope="col">보유 연구 인프라 <span class="red">*</span></th>
									<td class="ta_left">
										<textarea id="rndInfra" name="rndInfra" class="form-control" style="height: 100px"></textarea>
									</td>
								</tr>
								<tr>
									<th scope="col">투자 의지(사업 투자 여력) <span class="red">*</span></th>
									<td class="ta_left">
										<textarea id="investWilling" name="investWilling" class="form-control" style="height: 100px"></textarea>
									</td>
								</tr>
	
							</tbody>
							<tfoot></tfoot>
						</table>
					</div>
				</div>
				
				
				<div class="area_cont area_cont2">
					<div class="subject_corp w_top">
						<h4>담당자 정보</h4>
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
									<th scope="col">회사이름 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" 
												id="bizName" name="bizName" title="회사명">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">부서 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_dept"
												id="dept" name="dept" maxlength="50"
												title="담당자 부서">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">직급 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_spot"
												id="managerPosition" name="managerPosition" maxlength="20" title="담당자 직위">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">이름 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_spot"
												id="managerName" name="managerName" maxlength="20" title="담당자 이름">
										</div>
									</td>
								</tr>
								<tr>
									<th scope="col">업무용 이메일 <span class="red">*</span></th>
									<td class="ta_left">
										<div class="form-inline">
											<input type="text" class="form-control form_email1"
												id="bizEmail1" name="bizEmail1"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일아이디">@ <input
												type="text" class="form-control form_email2" id="bizEmail2"
												name="bizEmail2"
												onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
												maxlength="30" title="담당자 이메일 도메인 직접입력"> <select
												class="form-control form_email3" id="bizEmail3"
												name="bizEmail3" onChange="fncChangeEmail(this);"
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
												name="userMobileNo" title="휴대전화">
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
				<a href="javascript:funcCTDInsert();" class="btn_confirm"title="등록">등록 </a>
				<a href="javascript:history.back();" class="btn_close" title="닫기">닫기</a> 
			</div> 
			<!-- //page_content e:  -->
		</div>
	</div>
</div>