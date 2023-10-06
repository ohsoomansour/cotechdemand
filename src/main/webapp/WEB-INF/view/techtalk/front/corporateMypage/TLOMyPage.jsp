<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>

var proData = new Array();

$(document).ready(function() {
	//체크박스 변경 - 2023/09/18
    $(".inp_check").change(function(){
      if(this.checked){
        $(this).attr('value', 'Y');
      }else{
        $(this).attr('value', 'N');    
      }
    });
	
	
	initDatePicker([$('#strDate'), $('#endDate')]);
	
	$('#filterBtn').click(function() {
		var $href = "#filterPop";
		var cls = "filterPop";
		var op = $(this);
		//필터 팝업으로 이동
	    layer_popup($href, cls, op);
	});
	
	$('.ui-datepicker-trigger').click(function(){
		$('#date_all').prop("checked", false);
	});
	
});

//페이징 - 2023/09/18
function fncList(page) {
	$('#page').val(page);
	$('#frm').submit();
}

//검색 - 2023/09/18 
function doSearch(e) {
	$('#page').val(1);
	$('#frm').submit();
	
	
}

//목록관리 - 2023/09/18 
function doListAll(e) {
	$('#list').val('all');
	$('#page').val(1);
	$('#frm').submit();
}

//목록저장 - 2023/09/25
function doSave(e) {
	var corporate_list = $('input:checkbox[name="chk"]').length;
	console.log("corporate_list:" + corporate_list); // 현재 기업의 리스트는 2
	var co_td_no_arr = new Array(corporate_list); //***매개변수 확인 
	var view_yn_arr = new Array(corporate_list);
	for(var i=0; i < corporate_list; i++){                          
		co_td_no_arr[i] = $('input:checkbox[name="chk"]').eq(i).attr('id');
		view_yn_arr[i] = $('input:checkbox[name="chk"]').eq(i).val();
	}
	
	$.ajax({
		type : 'POST',
		url : '/techtalk/doSaveList1X.do',   //pull 이후 /techtalk/doSaveList.do으로 X변경
		data : {
			co_td_no_arr : co_td_no_arr, 
			view_yn_arr : view_yn_arr
		},
		dataType : 'json',
		success : function(res) {
			console.log("저장전:");
			alert("저장되었습니다.");
			location.href = "/techtalk/tloMyPage.do";
		},
		error : function() {
			
		},
		complete : function() {
			
		}
	});
}

//취소 - 2023/09/18 
function doCancel(e) {
	$('#list').val('');
	$('#page').val(1);
	$('#frm').submit();
}

//기업수요 상세정보 
function detail( co_td_no, compa_name, mid_category_key, small_category_key, code_name2, code_name3, keyword1,  keyword2, keyword3,  keyword4, keyword5, tech_needs, corporate_problem, hold_rnd_infra, willingness_to_invest, dept, manager_position, manager_name, mobilephone_num, biz_email, corporate_seqno)  {
 	
  	$('#NO').val(co_td_no);
  	$('#selStdClassCd1').val("A").prop("selected", true);
  	$("#selStdClassCd2").val(mid_category_key).prop("selected", true); // option 태그의 value값
    $("#selStdClassCd3").val(small_category_key).prop("selected", true); //code_name2 뿌려준 값을 받아와서 각 기업별 옵션 값 띄워줌 
  	//키워드
    $('#keyword1').empty();
	$('#keyword1').val(keyword1);
	$('#keyword2').empty();
	$('#keyword2').val(keyword2);
	$('#keyword3').empty();
	$('#keyword3').val(keyword3);
	$('#keyword4').empty();
	$('#keyword4').val(keyword4);
	$('#keyword5').empty();
	$('#keyword5').val(keyword5);
	//회사이름
	$('#compa_name').val(compa_name);
	//필요 기술
	$('#tech_needs').val(tech_needs);
	//기업 에로사항
	$('#corporate_problem').val(corporate_problem);		 	
	//보유 연구 인프라
	$('#hold_rnd_infra').val(hold_rnd_infra);	
	//투자 의지(사업 투자 여력 )
	$('#willingness_to_invest').val(willingness_to_invest);
	//담당자 정보 수정
    $('#manager_dept').val(dept);
	$('#manager_position').val(manager_position);
	$('#manager_name').val(manager_name);
	$('#manager_tel1').val(mobilephone_num);
	//이메일
	$('#manager_mail1').val(biz_email.split('@')[0]);
	$('#manager_mail2').val(biz_email.split('@')[1]);
	
	$('#compaVcContent').css("overflow", "hidden");
	layer_popup('#corporateDetailPop', 'corporateDetailPop');
    
	
}
function doUpdate() {
	//현재의 id="NO"값을 가져와서 
	$.ajax({
		type : 'POST',
		url : '/techtalk/doUpdateCorporateX.do',
		data : {
			//기업수요자 정보 수정
			//corporate_seqno : $('#corporate_seqno').val(),
			co_td_no: $('#NO').val(),
			compa_name: $('#compa_name').val(),
			mid_category: $('#selStdClassCd2').val(),
			small_category: $('#selStdClassCd3').val(),
			keyword: $('#keyword1').val() + $('#keyword2').val() + $('#keyword3').val() + $('#keyword4').val() + $('#keyword5').val(),
			
			//필요 기술
			tech_needs: $('#tech_needs').val(),
			//기업 에로사항
			corporate_problem: $('#corporate_problem').val(),		 	
			//보유 연구 인프라
			hold_rnd_infra: $('#hold_rnd_infra').val(),	
			//투자 의지(사업 투자 여력 )
			willingness_to_invest: $('#willingness_to_invest').val(),	
			//담당자 정보 수정
			dept: $('#manager_dept').val(),
			manager_position: $('#manager_position').val(),
			manager_name: $('#manager_name').val(),
			// 2023.09.22 확인 필요
			mobilephone_num: $('#manager_tel1').val(),
			biz_email: ($('#manager_mail1').val()) + '@' + ($('#manager_mail2').val())
			
			
		},
		dataType : 'json',
		success : function(res) {
			console.log(res);
			alert("기업 수요자 정보를 수정했습니다.");
			location.href = "/techtalk/tloMyPage.do";
		},
		error : function() {
			
		},
		complete : function() {
			
		}
	});
}

//상세보기 layer - 2023/09/24 detail 함수 안에서 layer_popup('#corporateDetailPop', 'corporateDetailPop') 
function layer_popup(el, cls, op){
    var $el = $(el);  //레이어의 id를 $el 변수에 저장
    var $op = $(op);    
    var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수
  
    isDim ? $("."+cls).fadeIn() : $el.fadeIn();
  	var inputId = $("."+cls).find("input").first().attr('id');  //예) .corporateDetailPop
  	 setTimeout(function(){
     	$('#'+inputId).focus();
         }, 500);
    //find(): 어떤 요소의 하위 요소 중 특정 요소를 찾을 때 사용
    //first() 메소드는 현재 위치에 해당하는 가장 첫 번째 엘리먼트를 반환
    //attr()예시 $( 'div' ).attr( 'class' );  "div 요소의 class속성의 값을 가져온다 "
    

    var $elWidth = ~~($el.outerWidth()),
        $elHeight = ~~($el.outerHeight()),
        docWidth = $(document).width(),
        docHeight = $(document).height();

    // 화면의 중앙에 레이어를 띄운다.
    if ($elHeight < docHeight || $elWidth < docWidth) {
        $el.css({
            marginTop: -$elHeight /2,
            marginLeft: -$elWidth/2
        })
    } else {
        $el.css({top: 0, left: 0});
    }
    
  	//esc키 버튼 입력시 통보 없애기
    $('#skip_navigation').find("input, a, button").attr('tabindex','-1');
    $('#compaVcHead').find("input, a, button").attr('tabindex','-1');
    $('#compaVcContent').find("input, a, button").attr('tabindex','-1');
    $('.wrap-loading').find("input, a, button").attr('tabindex','-1');
    $('.scroll-top').find("input, a, button").attr('tabindex','-1');
    $('#compaVcFoot').find("input, a, button").attr('tabindex','-1');

    $el.find('.btn_cancel, .btn-layerClose').click(function(){
        isDim ? $("."+cls).fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        /*
        $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
        $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
        $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
        $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
        $('.scroll-top').find("input, a, button").removeAttr('tabindex');
	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex'); */

        setTimeout(function(){
        	$op.focus();
           }, 500);
        return false;
    });
}

//이메일 도메인변경 - 2023/09/12
function fncChangeEmail(obj){
	var selValue = obj.value;
	if(selValue == "직접입력" || selValue == ""){
		$('#manager_mail2').val("");
	}else{
		$('#manager_mail2').val(selValue);
	}
}

//기술분류 변경 - 2023/09/07
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
			url : '/techtalk/doGetCodeList1X.do',
			data : {
				parent_code_key : selValue,
				gubun : gubun
			},
			dataType : 'json',
			success : function(res) {
				console.log("fncChangeStd 작동중..")
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


function filterChangeStd(obj, gubun){
	var selValue = obj.value;
	if(selValue == "" || selValue == "선택"){
		if(gubun == "mid"){
			$('#filterStdClassCd2').empty();
			$('#filterStdClassCd3').empty();
			$('#filterStdClassCd2').append("<option title='기술분류2' value=''>선택</option>");
			if(selValue == "") {
				$('#filterStdClassCd2').attr('disabled', 'disabled');
			}
			$('#filterStdClassCd3').append("<option title='기술분류3' value=''>선택</option>");
			$('#filterStdClassCd3').attr('disabled', 'disabled');
		} else if(gubun == "sub" || gubun == "end") {
			$('#filterStdClassCd3').empty();
			$('#filterStdClassCd3').append("<option title='기술분류3' value=''>선택</option>");
			$('#filterStdClassCd3').attr('disabled', 'disabled');
		} 
	}else{
		$.ajax({
			type : 'POST',
			url : '/techtalk/deGetCodeListX.do',
			data : {
				parent_code_key : selValue,
				gubun : gubun
			},
			dataType : 'json',
			success : function(res) {
				var codeData = "";
				var aHtml = "";
				if(gubun == "mid"){
					codeData = res.codeList;
					aHtml += "<option title='기술분류2' value=''>선택</option>";
					$.each(codeData, function(key, val){
						aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
					});
					
					$('#filterStdClassCd2').empty();
					$('#filterStdClassCd2').append(aHtml);
					$('#filterStdClassCd2').removeAttr("disabled");	
				} else if(gubun == "sub") {
					codeData = res.codeList;
					aHtml += "<option title='기술분류3' value=''>선택</option>";
					$.each(codeData, function(key, val){
						aHtml += "<option title="+this.code_name+" value="+this.code_key+">"+this.code_name+"</option>";
					});
					
					$('#filterStdClassCd3').empty();
					$('#filterStdClassCd3').append(aHtml);
					$('#filterStdClassCd3').removeAttr("disabled");	
				} 
			},
			error : function() {
				
			},
			complete : function() {
				
			}
		});
	}
}

function doSearchFilter () {
	$('#page').val(1);
	$('#frm2').submit();
}

</script>
<!-- 기술수요 목록 -->
<form action="#" id="frm" name="frm" method="post">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<input type="hidden" name="list" id="list" value="${paraMap.list}" />
<div class="area_cont area_cont2" id="researcherlist">
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<div class="area_tit">
					<h3 class="tit_corp">기술수요 목록</h3>
					<div class="belong_box">
						<dl class="belong_box_inner">
							<dt>소속</dt>
							<dd>${biz_name}</dd>
						</dl>
					</div>
				</div>
				<div class="list_panel">
					<div class="cont_list">
					<!-- 검색/필터/목록관리 -->
					<div class="list_top">
							<p>count : ${totalCount}건</p>
							<div class="list_top_util ">
								<div class="search_box_inner">
									<div class="btn_box">
										<button type="button" class="btn_default"  title="필터" id="filterBtn">
											<i class="icon_filter"></i>
											<span>필터</span>
										</button>
									</div>
									<div class="search_keyword_box">
										<input type="text" class="keyword_input" id="keyword" name="keyword" value="${paraMap.keyword}" placeholder="키워드를 입력하세요." value="" title="검색어">
									</div>
									<div class="btn_wrap">
										<button type="button" class="btn_step" onClick="javascript:doSearch();" title="검색">
											<span>검색</span>
										</button>
									</div>
									<div class="btn_box btn_box2">
										<c:choose>
											<c:when test="${paraMap.list eq 'all'}">
												<button type="button" id="save" class="btn_point" onClick="javascript:doSave();" title="저장">
													<span>저장</span>
												</button>
												<button type="button" id="cancel" class="btn_default" onClick="javascript:doCancel();" title="취소">
													<span>취소</span>
												</button>
											</c:when>
											<c:otherwise>
												<button type="button" class="btn_default" title="목록관리" onClick="javascript:doListAll();">
													<span>목록관리</span>
												</button>
											</c:otherwise>
										</c:choose>
									</div>
								</div>
							</div>
						</div>
					
							
							  <c:choose>
								<c:when test="${not empty corporateList}">
								 	 <c:forEach var="co" items="${corporateList}" > 
									<c:if test="${paraMap.list eq 'all'}">
										 <span class="box_checkinp">
											 <input type="checkbox" class="inp_check" value="${co.view_yn}" id="${co.co_td_no}" name="chk" title="표출유무"
												 <c:if test="${co.view_yn eq 'Y'}">checked</c:if>
											  >
										 </span>
						    		 </c:if> 	 
								 	  <div class="row col-box col3" onclick="detail('${co.get("co_td_no")}','${co.get("compa_name")}', '${co.get("mid_category")}', '${co.get("small_category")}',  '${co.get("code_name2")}', '${co.get("code_name3")}','${co.get("keyword1")}', '${co.get("keyword2")}', '${co.get("keyword3")}', '${co.get("keyword4")}', '${co.get("keyword5")}'
                   						 ,'${co.get("tech_needs")}', '${co.get("corporate_problem")}', '${co.get("hold_rnd_infra")}', '${co.get("willingness_to_invest")}', '${co.get("dept")}'
                   						,'${co.get("manager_position")}', '${co.get("manager_name")}', '${co.get("mobilephone_num")}', '${co.get("biz_email")}', '${co.get("corporate_seqno")}' )">
										<div class="col">
							
											<span class="row_txt_num blind">1</span> <span class="txt_left row_txt_tit">${co.hold_rnd_infra}</span>

											<ul class="tag_box">
												<li>${co.keyword}</li>
											</ul>
											<ul class="step_tech">
												<li><span class="mr txt_grey tech_nm ">미래모빌리티</span></li>
												<li><span class="mr txt_grey tech_nm ">${co.code_name2}</span></li>
												<li><span class="mr txt_grey tech_nm ">${co.code_name3}</span></li>
											</ul>
											<input id="business_seqno" name="business_seqno" type="hidden" value="${co.business_seqno}">
										</div>
									</div>	
									  </c:forEach>
									</c:when>
									<c:otherwise>
										귀하의 기업 아이디가 확인되지 않았습니다. 로그인 해주세요.
									</c:otherwise>
								  
								 </c:choose>
							
					</div>
				</div>
				<!-- paging -->
				<div class="paging_comm">${sPageInfo}</div>
			</div>
		</div>
	</div>
</div>
</form>

<div class="wrap-loading" style="display: none;">
	<div><img src="/images/loading.gif" alt="로딩" /></div>
</div>

<!-- detail -->
<div class="dim-layer corporateDetailPop">
	<div class="dimBg" ></div>  					<!-- class="pop-layer" width: 90%; height: 70%; overflow: auto; / id="pop-container" class="cont_cv" style="padding: 30px;-->
	<div id="corporateDetailPop" class="pop-layer" style="width:1260px; height:600px; overflow:auto; ">
		<div id="pop-container" >
			<div class="pop_cont">
				<div class="area_cont">
					<div class="pop-title">
						<input id="NO" type="hidden"></input>
						<h3 class="tit_corp">기술수요 기업 상세정보</h3>
						<button class="btn-layerClose" title="팝업닫기"><span class="icon ico_close">팝업닫기</span></button>
					</div>
					
					
					<!-- page_content s:  -->
				
				
						<div class="tbl_view tbl_public">
							<table class="tbl">
								<caption style="position: absolute !important; width: 1px; height: 1px; overflow: hidden; clip: rect(1px, 1px, 1px, 1px);">기업 수요 목록 상세정보</caption>
								<colgroup>
									<col style="width: 10%">
									<col>
								</colgroup>
								<thead></thead>
								<tbody class="view">
									<tr>
										<th scope="col"><label for="re_nm">기술수요 기업</label></th>
										<td class="form-control">
											<input id="compa_name" class="form-control" style="max-width: 100%; max-height: 100%" />
											
										</td>
										<th scope="" rowspan="3">필요기술</th>
										<td class="form-control" rowspan="3"><textarea id="tech_needs"
												name="tech_needs" style="width: 100%;" rows="8" cols=""></textarea>
										</td>

									</tr>
									<tr>
										<!-- 기본 셋팅 값 -->
										<th scope="col">기술분류</th>
										<td class="ta_left">
										<select id="selStdClassCd1" name="selStdClassCd1" onChange="fncChangeStd(this, 'mid');" title="기술분류1" style="width: 32%;">
											<option title="기술분류1" value="">선택</option>
											<c:forEach var="code1" items="${codeList1}" varStatus="status">
											 <option title="${code1.code_name}"
														value="${code1.code_key}">${code1.code_name}</option>
											</c:forEach>
										</select> <select id="selStdClassCd2" name="selStdClassCd2"  onChange="fncChangeStd(this, 'sub');" title="기술분류2" style="width: 32%;">
											<c:forEach var="code2" items="${codeList2}" varStatus="status">
												<option title="기술분류2" value="${code2.code_key}">${code2.code_name}</option>
											</c:forEach>
										</select> <select id="selStdClassCd3" name="selStdClassCd3" title="기술분류3" style="width: 32%;">
											<option title="기술분류3" value="">선택</option>
											<c:forEach var="code3" items="${codeList3}" varStatus="status">
											<option title="${code3.code_name3}" value="${code3.code_key}">${code3.code_name}</option>
											</c:forEach>
										</select></td>
									</tr>
									<tr>
										<th scope="col">키워드</th>
										<td class="ta_left">
											<div class="form-control"
												style="max-width: 100%; max-height: 100%">
												<input type="text" id="keyword1" name="keyword1"
													style="text-align: center; width: 18%; text-indent: 0;"
													title="키워드1" /> <input type="text" id="keyword2"
													name="keyword2"
													style="text-align: center; width: 18%; text-indent: 0;"
													title="키워드2" /> <input type="text" id="keyword3"
													name="keyword3"
													style="text-align: center; width: 18%; text-indent: 0;"
													title="키워드3" /> <input type="text" id="keyword4"
													name="keyword4"
													style="text-align: center; width: 18%; text-indent: 0;"
													title="키워드4" /> <input type="text" id="keyword5"
													name="keyword5"
													style="text-align: center; width: 18%; text-indent: 0;"
													title="키워드5" />
											</div>
										</td>
									</tr>
								</tbody>
								<tfoot></tfoot>
							</table>
						</div>
					</div>

					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>기업 에로사항</h4>
						</div>
						<div class="tbl_comm tbl_public history_tbl_wrap">
							<table class="tbl history_tbl" id="tbl_history">
								<caption class="caption_hide">기업 에로사항</caption>
								<c:choose>
									<c:when test="${not empty corporateList[0].corporate_problem}">
										<tbody>
											<tr>
												<td class="ta_left" rowspan="3"><textarea id="corporate_problem" name="corporate_problem" style="width: 100%;" rows="8" cols=""></textarea>
												</td>
											</tr>							
										</tbody>
									</c:when>
									<c:otherwise>
										등록된 에로사항이 없습니다.
									</c:otherwise>
								</c:choose>
							</table>
						</div>
					</div>
					<!-- 보유 연구 인프라 -->
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>보유 연구 인프라</h4>
						</div>
						<div class="tbl_comm tbl_public history_tbl_wrap">
							<table class="tbl history_tbl" id="tbl_history">
								<caption class="caption_hide">보유 연구 인프라</caption>
								<c:choose>
									<c:when test="${not empty corporateList[0].hold_rnd_infra}">
										<tbody>
											<tr>
												<td class="ta_left" rowspan="3"><textarea
														id="hold_rnd_infra" name="hold_rnd_infra"
														style="width: 100%;" rows="8" cols=""></textarea></td>
											</tr>
										</tbody>
									</c:when>
									<c:otherwise>
										등록된 보유 연구 인프라이 없습니다.
									</c:otherwise>
								</c:choose>

							</table>
						</div>
					</div>
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>투자 의지( 사업 투자 여력 )</h4>
						</div>
						<div class="tbl_comm tbl_public history_tbl_wrap">
							<table class="tbl history_tbl" id="tbl_history">
								<caption class="caption_hide">투자 의지( 사업 투자 여력 )</caption>
								<c:choose>
									<c:when test="${not empty corporateList[0]}">
										<tbody>
											<tr>
												<td class="ta_left" rowspan="3"><textarea
														id="willingness_to_invest" name="willingness_to_invest"
														style="width: 100%;" rows="8" cols=""></textarea></td>
											</tr>
										</tbody>
									</c:when>
									<c:otherwise>
										등록된 보유 연구 인프라이 없습니다.
									</c:otherwise>
								</c:choose>

							</table>
						</div>
					</div>
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>담당자 정보</h4>
						</div>
						<div class="tbl_view tbl_public">
							<table class="tbl">
								<caption
									style="position: absolute !important; width: 1px; height: 1px; overflow: hidden; clip: rect(1px, 1px, 1px, 1px);">담당자
									정보</caption>
								<colgroup>
									<col style="width: 10%">
									<col>
								</colgroup>
								<thead></thead>
								<tbody class="view">
									<tr>
										<th scope="col"><label for="re_belong">소속</label></th>
										<td class="ta_left">
											<div class="form-control"
												style="max-width: 100%; max-height: 100%">
												<input type="text" style="width: 50%;" id="manager_dept"
													name="manager_dept" title="담당자 소속" />
											</div>
										</td>
									</tr>
									<tr>
										<th scope="col">직책</th>
										<td class="ta_left"><input type="text"
											style="width: 50%;" id="manager_position"
											name="manager_position" title="담당자 직책" /></td>
									</tr>
									<tr>
										<th scope="col">이름</th>
										<td class="ta_left"><input type="text"
											style="width: 50%;" id="manager_name" name="manager_name"
											title="담당자 이름" /></td>
									</tr>
									<tr>
										<th scope="col">연락처</th>
										<td class="ta_left">
											<div class="form-control"
												style="max-width: 100%; max-height: 100%">
												<input 
													id="manager_tel1"
													name="manager_tel1" 
													title="담당자 번호1"
													type="text" 
													style="width: 16%" 
												     />
												<!--  
												<input type="text" style="width: 16%;" id="manager_tel2" name="manager_tel2" title="담당자 번호2"/> - 
												<input type="text" style="width: 16%;" id="manager_tel3" name="manager_tel3" title="담당자 번호3"/>
												-->
											</div>
										</td>
									</tr>
									<tr>
										<th scope="col">이메일</th>
										<td class="ta_left">
											<div class="form-control"
												style="max-width: 100%; max-height: 100%">
												<input type="text" id="manager_mail1" name="manager_mail1"
													style="width: 15%;"
													onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
													maxlength="30" title="이메일아이디"> @ <input type="text"
													id="manager_mail2" name="manager_mail2" style="width: 20%;"
													onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');"
													maxlength="30" title="이메일 도메인 직접입력"> <select
													class="form-control form_email3" id="manager_mail3"
													name="manager_mail3" onChange="fncChangeEmail(this);"
													title="이메일 도메인 선택">
													<option title="직접입력">직접입력</option>
													<option title="네이버">naver.com</option>
													<option title="G메일">gmail.com</option>
													<option title="다음">daum.net</option>
												</select>
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<!-- 수정 취소 -->
					<div class="tbl_public">
						<div style="text-align: center; margin-top: 40px;">
							<!-- doUpdate(co_td_no) 가져와서  -->

							<button id="update" type="button" onClick="doUpdate();"
								class="btn_step" title="수 정">수정</button>
							<button type="button" onClick="$('.dim-layer').fadeOut();"
								class="btn_step" title="취소">취소</button>
						</div>
					</div>

			</div>
		</div>
	</div>
</div>
<!-- 필터 부분 -->
<form action="#" id="frm2" name="frm2" method="post">
<div class="dim-layer filterPop" >
    <div class="dimBg"></div>
    <div id="filterPop" class="pop-layer" style="height:420px;width:640px">
        <div class="pop-container">
        <div class="pop-title"><h3>필터</h3><button class="btn-layerClose" title="팝업닫기"><span class="icon ico_close">팝업닫기</span></button></div>
            <div id="tap1_1" style="display: block">
				<div class="tbl_view tbl_public tr_tran" style="margin-top:0">
					<table class="tbl">
						<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);">필터</caption>
						<colgroup>
							<col style="width:150px"/><col />
						</colgroup>
						<thead></thead>
						<tbody class="line">
							<tr>
								<th scope="col">최근 업데이트 날짜</th>
								<td class="left form-inline">
									<div class="datepicker_wrap">
										<input type="text" id="strDate" name="strDate" class="form-control">
										~
										<input type="text" id="endDate" name="endDate" class="form-control">
									</div>
									
								</td>
							</tr>			 
							<tr>
								<th scope="col">기술분야</th>
								<td class="left form-inline">
									<div class="btn_chk div-inline">
										<input type="checkbox" name="tech_field"  id="tech_all" value="tech_all"> 
										<label for="tech_all" class="option_label">  
											<span class="inner"><span class="txt_checked">전체</span></span> 
										</label>
									</div>
									<select id="filterStdClassCd1" name="filterStdClassCd1" onChange="filterChangeStd(this, 'mid');" title="기술분류1" style="width: 25%;">
										<option title="기술분류1" value="">선택</option>
										<c:forEach var="code1" items="${codeList1}" varStatus="status">
											<option title="${code1.code_name}" value="${code1.code_key}">${code1.code_name}</option> 
										</c:forEach>
									</select>
									<select id="filterStdClassCd2" name="filterStdClassCd2" disabled onChange="filterChangeStd(this, 'sub');" title="기술분류2" style="width: 25%;">
										<option title="기술분류2" value="">선택</option>
										<c:forEach var="code2" items="${codeList2}" varStatus="status">
											<option title="${code2.code_name}" value="${code2.code_key}">${code2.code_name}</option> 
										</c:forEach>
									</select>
									<select id="filterStdClassCd3" name="filterStdClassCd3" disabled title="기술분류3" style="width: 25%;">
										<option title="기술분류3" value="">선택</option>
										<c:forEach var="code3" items="${codeList3}" varStatus="status">
											<option title="${code3.code_name}" value="${code3.code_key}">${code3.code_name}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<th scope="col">매칭 여부</th>
								<td class="left form-inline">
									<div class="btn_chk div-inline">
										<input type="checkbox" name="matching"  id="m_all" value="m_all"> 
										<label for="m_all" class="option_label">  
											<span class="inner"><span class="txt_checked">전체</span></span> 
										</label>
									</div>
									<div class="btn_chk div-inline">
										<input type="checkbox" name="matching"  id="mY" value="Y"> 
										<label for="mY" class="option_label">  
											<span class="inner"><span class="txt_checked">Y</span></span> 
										</label>
									</div>
									<div class="btn_chk div-inline">
										<input type="checkbox" name="matching"  id="mN" value="N"> 
										<label for="mN" class="option_label">  
											<span class="inner"><span class="txt_checked">N</span></span> 
										</label>
									</div>
								</td>
							</tr>
						</tbody>
						<tfoot></tfoot>
					</table>
					<div class="tbl_public" >
						<div style="text-align:center;margin-top:40px;">
		                	<button type="button" class="btn_step btn_point_black"  title="적용" onClick="javascript:doSearchFilter();">적용</button>
		                	<button type="button" class="btn_line btn_cancel" id="cancelId"  name="btnCancel" title="닫기">닫기</button>
	                	</div>
	                </div>
				</div>
			</div>
        </div>
   	</div>
</div>
</form>


