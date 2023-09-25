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
			          url: "/techtalk/autoSearchKeyword.do",
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
						   
						   //$("#keyword_record").text(keyword_String) 
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
			
		var url = "/techtalk/insertCoTechDemand.do"
		var form = $('#frm')[0];  //폼
		var data = new FormData(form);
		//console.log(data.has('biz_name'));
			$.ajax({
			       url : url,
			       type: "post",
			       processData: false,
			       contentType: false,
			       data: data,
			       dataType: "json",
			       success : function(res){
			    	   	console.log(res)			    	   	
				    	alert("등록되었습니다!")
				    	//성공했다 >> 이동 함수를 호출
				    	moveCTDL();
			       },
			       error : function(){
			    	alert('기업수요 등록에 실패했습니다.');    
			       },
			       complete : function(){
			       }
			});
		
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
			$('#bizEmail2').val("");
		} else {
			$('#bizEmail2').val(selValue);
		}
	}

	
	function moveCTDL() {
		location.href = "/techtalk/moveCoTechDemandList.do";
	}

	//
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
	
	//<select> 대-중-소 분류 
	var RNDs = false;

	function update_selected() {
	  $("#category_small").val(0);
	  $("#category_small").find("option[value!=0]").detach();

	  $("#category_small").append(RNDs.filter(".RND" + $(this).val())); // this.val 값이 
	  
	}

	$(function() {
	  RNDs = $("#category_small").find("option[value!=0]");
	 
	  RNDs.detach();

	  $("#category_medi").change(update_selected);
	  $("#category_medi").trigger("change");

	});
	
	
</script>
<!-- compaVcContent s:  -->
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
			<!-- page_title s: 기업수요 정보 / 소속(회사 이름)  -->
			<div class="area_tit">
				
			</div>
			<!-- page_content s: 기업 기술수요 등록 폼  -->
			<form id="frm">
				<div class="area_cont ">
				<!--  
					<div class="subject_corp">
						<h4>기업 수요 정보 </h4>
					</div>
				-->	
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
										<!-- 기술명 -->
										<select id="medi_category" name="medi_category">
										   <option value="0" selected="selected">기술분류1 선택</option>  <!-- 순서: 1번 -->
										   <option value="01" id="1">전기자동차</option> <!-- 500ml선택, 트라움샾&위메프 선택 -->
										   <option value="02" id="2">자율주행자동차</option>
										   <option value="03" id="3">수소연로전지자동차</option>
										   <option value="04" id="4">자동차 일반/기타</option>
										   <option value="05" id="5">드론/UAM</option>
										   <option value="06" id="6">로봇</option>
										   <option value="07" id="7">선박</option>
										</select>
										<!-- 전기자동차 -->
										<select id="small_category" name="small_category">
										   <option value="0">기술분류2 선택</option>
										   <option value="11" class="RND1" id="11">구동/동력</option>
										   <option value="12" class="RND1" id="12">배터리(양극화물질)</option>
										   <option value="13" class="RND1" id="13">기타</option>						
										   <option value="14" class="RND1" id="14">배터리 냉각/리튬 회수</option>
										   <option value="15" class="RND1" id="15">배터리(에너지 관리)</option>		
										   <option value="16" class="RND1" id="16">배터리(인버터/컨버터)</option>
										   <option value="17" class="RND1" id="17">배터리(2차전지)</option>
										   <!-- 자율주행자동차 -->
										   <option value="21" class="RND2" id="21">객체인식/판단/학습</option>
										   <option value="22" class="RND2" id="22">보안</option>
										   <option value="23" class="RND2" id="23">기타</option>
										   <option value="24" class="RND2" id="24">운전자 편의</option>
										   <option value="25" class="RND2" id="25">데이터 통신</option>
										   <!-- 수소연료전지자동차 -->
										   <option value="31" class="RND3" id="31">기타</option>
										   <option value="32" class="RND3" id="32">배터리 냉각</option>
										   <option value="33" class="RND3" id="33">데이터 통신/제어</option>
										   <option value="34" class="RND3" id="34">연료전지/배터리</option>
										   <!-- 자동차 일반/기타 -->
										   <option value="41" class="RND4" id="41">교통/도로/안전</option>
										   <option value="42" class="RND4" id="42">영상/촬영/학습</option>
										   <option value="43" class="RND4" id="43">기타</option>
										   <option value="44" class="RND4" id="44">제동/조향/구동</option>
										   <option value="45" class="RND4" id="45">데이터 통신/배터리</option>
										   <option value="46" class="RND4" id="46">촉매/소재</option>
										   <option value="47" class="RND4" id="47">열차</option>
										   <!-- 드론/UAM -->
										   <option value="51" class="RND5" id="51">동력</option>
										   <option value="52" class="RND5"  id="52">전지</option>
										   <option value="53" class="RND5"  id="53">안테나/통신</option>
										   <option value="54" class="RND5"  id="54">촬영/감시/측량</option>
										   <option value="55" class="RND5"  id="55">암호화/보안</option>
										   <option value="56" class="RND5"  id="56">학습/탐지/인식</option>
										   <!-- 로봇 -->
										   <option value="61" class="RND6" id="61">구동/동력</option>
										   <option value="62" class="RND6" id="62">영상/탐지/인식</option>
										   <option value="63" class="RND6" id="63">데이터 통신</option>
										   <option value="64" class="RND6" id="64">자율주행/경로학습</option>
										   <option value="65" class="RND6" id="65">배터리</option>
										   <!-- 선박 -->
										   <option value="71" class="RND7" id="71">기관/재생</option>
										   <option value="72" class="RND7" id="72">소재</option>
										   <option value="73" class="RND7" id="73">데이터 통신</option>
										   <option value="74" class="RND7" id="74">자율주행</option>
										   <option value="75" class="RND7" id="75">물류/보안/기타</option>
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
												id="keyword" name="keyword" maxlength="50"
												title="검색">
										</div>
										
									</td>
									
								</tr>
								<tr>
									<th scope="col">키워드 검색내용</th>
									<td><textarea id="keyword_record" name = "keyword_record" class="form-control"></textarea></td>
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