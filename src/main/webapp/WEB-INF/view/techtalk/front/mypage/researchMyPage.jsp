<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<script>
var list = new Array();

$(document).ready(function() {
	var startIndex = 1;	// 인덱스 초기값
	
	$("#lessProButton").hide();
	$("#lessPatentButton").hide();
		
	$('#moreProButton').click(function() {
		$("#lessProButton").show();
		$("#moreProButton").hide();
		
	});

	$('#lessProButton').click(function() {
		$("#moreProButton").show();
		$("#lessProButton").hide();
	});
	
	$('#morePatentButton').click(function() {
		$("#lessPatentButton").show();
		$("#morePatentButton").hide();
		
	});

	$('#lessPatentButton').click(function() {
		$("#morePatentButton").show();
		$("#lessPatentButton").hide();
	});

});
function detail()  {
	$("#selStdClassCd3").attr("disabled","disabled");
	
	var targetVal1 = $('#selStdClassCd1 option:contains(' + '<c:out value="${data.code_name1}"  escapeXml="false"/>' + ')').val();    //text로 옵션을 찾고 해당 value를 구한다.
    $('#selStdClassCd1').val(targetVal1);
    var targetVal2 = $('#selStdClassCd2 option:contains(' + '<c:out value="${data.code_name2}"  escapeXml="false"/>' + ')').val();   
    $('#selStdClassCd2').val(targetVal2);
    var targetVal3 = $('#selStdClassCd3 option:contains(' + '<c:out value="${data.code_name3}"  escapeXml="false"/>' + ')').val();    
    $('#selStdClassCd3').val(targetVal3);

    var keyword1 = '<c:out value="${data.keyword1}"  escapeXml="false"/>';
    var keyword2 = '<c:out value="${data.keyword2}"  escapeXml="false"/>';
    var keyword3 = '<c:out value="${data.keyword3}"  escapeXml="false"/>';
    var keyword4 = '<c:out value="${data.keyword4}"  escapeXml="false"/>';
    var keyword5 = '<c:out value="${data.keyword5}"  escapeXml="false"/>';

    var re_intro_field = '<c:out value="${data.re_intro_field}"  escapeXml="false"/>';
  	//상세보기 정보
	//연구자소개
	$('#re_intro_field').empty();
	$('#re_intro_field').val(re_intro_field);
	
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
	
	layer_popup('#layer2');
}

//상세보기 layer - 2023/09/07 
function layer_popup(el){
    var $el = $(el);    //레이어의 id를 $el 변수에 저장
    var isDim = $el.prev().hasClass('dimBg'); //dimmed 레이어를 감지하기 위한 boolean 변수
	
    isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();

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
    $('#skip_navigation').find("input, a, button").attr('tabindex','-1');
    $('#compaVcHead').find("input, a, button").attr('tabindex','-1');
    $('#compaVcContent').find("input, a, button").attr('tabindex','-1');
    $('.wrap-loading').find("input, a, button").attr('tabindex','-1');
    $('.scroll-top').find("input, a, button").attr('tabindex','-1');
    $('#compaVcFoot').find("input, a, button").attr('tabindex','-1');

    $el.find('a.btn-layerClose').click(function(){
        isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
        $('#skip_navigation').find("input, a, button").removeAttr('tabindex');
        $('#compaVcHead').find("input, a, button").removeAttr('tabindex');
        $('#compaVcContent').find("input, a, button").removeAttr('tabindex');
        $('.wrap-loading').find("input, a, button").removeAttr('tabindex');
        $('.scroll-top').find("input, a, button").removeAttr('tabindex');
	    $('#compaVcFoot').find("input, a, button").removeAttr('tabindex');

        return false;
    });
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

//과제리스트
function proContens(length) {
	for(var i = 0; i < length; i++){
		var ahtml= "";
		ahtml +="<table class='tbl'>"
			ahtml +="<caption class='caption_hide'>국가 과제 수행 이력</caption>"
			ahtml +="<colgroup>"
			ahtml +="<col ' />"
			ahtml +="<col  />"
			ahtml +="<col  />"
			ahtml +="</colgroup>"
			ahtml +="<thead>"
			ahtml +="<tr>"
			ahtml +="<th>과제명</th>"
			ahtml +="<th>과제관리기관</th>"
			ahtml +="<th>연구기간</th>"
			ahtml +="<tr>"
			ahtml +="</thead>"
			ahtml +="<tbody>"
			if(list[0].re_project_nm != '' && list[0].re_project_nm != 0){
				for(var i=0; i<length;i++){
				ahtml +="<tr>"
					ahtml +=	"<td class='ta_left'>"+list[i].re_project_nm+"</td>"
					ahtml +=	"<td >"+list[i].re_institu_nm+"</td>"
					ahtml +=	"<td >"+list[i].re_start_date+" ~ "
					ahtml +=	list[i].re_end_date+"</td>"
				ahtml +="<tr>"
				}
			}else{
				ahtml +=	"<td colspan='3'>국가 과제 수행 이력이 확인되지 않았습니다.</td>"
			}
	   ahtml +="</tbody>"
		ahtml +="</table>"
		$('#tbl2').empty();
    	$('#tbl2').append(ahtml);
	}
}

//국가 과제 수행 이력 더보기 이벤트
function moreProContens(){
	list = new Array();

	if(excel.length != 0) {
		for(var i = 0; i <excel.result.data.length; i++) {
	    	var proItem ={};
			proItem.re_project_nm = excel.result.data[i].ex_re_project_nm;
			proItem.re_institu_nm = excel.result.data[i].ex_re_institu_nm;
			proItem.re_start_date = excel.result.data[i].ex_re_start_date;
			proItem.re_end_date = excel.result.data[i].ex_re_end_date;
			list.push(proItem);
	    }
	}

	<c:forEach items="${proData}" var="list">
		var proItem ={};
		proItem.re_project_nm = "${list.re_project_nm}";
		proItem.re_institu_nm = "${list.re_institu_nm}";
		proItem.re_start_date = "${list.re_start_date}";
		proItem.re_end_date = "${list.re_end_date}";
		list.push(proItem);
	</c:forEach>

	proContens(list.length);	
}

//국가 과제 수행 이력 줄이기 이벤트
function lessProContens(){
	list = new Array();

	if(excel.length != 0) {
		for(var i = 0; i <excel.result.data.length; i++) {
	    	var proItem ={};
			proItem.re_project_nm = excel.result.data[i].ex_re_project_nm;
			proItem.re_institu_nm = excel.result.data[i].ex_re_institu_nm;
			proItem.re_start_date = excel.result.data[i].ex_re_start_date;
			proItem.re_end_date = excel.result.data[i].ex_re_end_date;
			list.push(proItem);
	    }
	}

	<c:forEach items="${proData}" var="list">
		var proItem ={};
		proItem.re_project_nm = "${list.re_project_nm}";
		proItem.re_institu_nm = "${list.re_institu_nm}";
		proItem.re_start_date = "${list.re_start_date}";
		proItem.re_end_date = "${list.re_end_date}";
		list.push(proItem);
	</c:forEach>
	
	proContens(5);
}

//특허리스트
function patentContens(length) {
	for(var i = 0; i < length; i++){
		var ahtml= "";
		ahtml +="<table class='tbl'>"
			ahtml +="<caption class='caption_hide'>특허리스트</caption>"
			ahtml +="<colgroup>"
			ahtml +="<col style='width:60%'/>"
			ahtml +="<col  />"
			ahtml +="<col  />"
			ahtml +="</colgroup>"
			ahtml +="<thead>"
			ahtml +="<tr>"
			ahtml +="<th>발명의 명칭</th>"
			ahtml +="<th>출원번호</th>"
			ahtml +="<th>출원일</th>"
			ahtml +="<tr>"
			ahtml +="</thead>"
			ahtml +="<tbody>"
			if(list[0].invent_nm != '' && list[0].invent_nm != 0){
				for(var i=0; i<length;i++){
					ahtml +="<tr>"
						ahtml +=	"<td class='ta_left'><input type='hidden' id='invent_research_seqno' name='invent_research_seqno' title='발명의 명칭' value='"+list[i].research_seqno+"'/><input type='text' id='invent_nm' name='invent_nm' title='발명의 명칭' value='"+list[i].invent_nm+"'/></td>"
						ahtml +=	"<td class='ta_left'><input type='text' id='applicant_no' name='applicant_no' title='출원번호' value='"+list[i].applicant_no+"'/></td>"
						ahtml +=	"<td class='ta_left'><input type='date' id='applicant_dt' name='applicant_dt' class='form-control' title='출원일' value='"+list[i].applicant_dt+"'/></td>"
					ahtml +="<tr>"
				}
			}else{
				ahtml +=	"<td colspan='3'>특허리스트가 확인되지 않았습니다.</td>"
			}
		
	   ahtml +="</tbody>"
		ahtml +="</table>"
		$('#tbl3').empty();
    	$('#tbl3').append(ahtml);
	}
}

//특허리스트 더보기 이벤트
function morePatentContens(){
	list = new Array();
	
	<c:forEach items="${invent}" var="list">
		var item ={};
		item.research_seqno = "${list.research_seqno}";
		item.invent_nm = "${list.invent_nm}";
		item.applicant_no = "${list.application_no}";
		item.applicant_dt = "${list.applicant_date}";
		list.push(item);
	</c:forEach>

	patentContens(list.length);
	
}

//특허리스트 줄이기 이벤트
function lessPatentContens(){
	var p_count = 0;
	list = new Array();

	p_count = list.length > 5 ? 5 : list.length;

	<c:forEach items="${invent}" var="list">
		var item ={};
		item.research_seqno = "${list.research_seqno}";
		item.invent_nm = "${list.invent_nm}";
		item.applicant_no = "${list.application_no}";
		item.applicant_dt = "${list.applicant_date}";
		list.push(item);
	</c:forEach>

	
	patentContens(p_count);
}
function doUpdate() {
	// 특허리스트 수정 값
	var invent_research_seqno_ct = $("input[name=invent_research_seqno]").length;
	var invent_nm_ct = $("input[name=invent_nm]").length;
	var applicant_no_ct = $("input[name=applicant_no]").length;
	var applicant_dt_ct = $("input[name=applicant_dt]").length;

	var invent_research_seqno = new Array(invent_research_seqno_ct);
	var invent_nm = new Array(invent_nm_ct);
	var applicant_no = new Array(applicant_no_ct);
	var applicant_dt = new Array(applicant_dt_ct);

	for(var i=0; i<invent_research_seqno_ct; i++){                          
		invent_research_seqno[i] = $("input[name=invent_research_seqno]").eq(i).val();
	}
	for(var i=0; i<invent_nm_ct; i++){                          
		invent_nm[i] = $("input[name=invent_nm]").eq(i).val();
	}
	for(var i=0; i<applicant_no_ct; i++){                          
		applicant_no[i] = $("input[name=applicant_no]").eq(i).val();
	}
	for(var i=0; i<applicant_dt_ct; i++){                          
		applicant_dt[i] = $("input[name=applicant_dt]").eq(i).val();
	}
		
	$.ajax({
		type : 'POST',
		url : '/techtalk/doUpdateResearcherX.do',
		data : {
			//연구자 정보 수정
			researcher_seqno : $('#researcher_seqno').val(),
			selStdClassCd1 :  $('#selStdClassCd1').val(),
			selStdClassCd2 : $('#selStdClassCd2').val(),
			selStdClassCd3 : $('#selStdClassCd3').val(),
			keyword1 : $('#keyword1').val(),
			keyword2 : $('#keyword2').val(),
			keyword3 : $('#keyword3').val(),
			keyword4 : $('#keyword4').val(),
			keyword5 : $('#keyword5').val(),
			re_intro_field : $('#re_intro_field').val(),

			//특허리스트 수정
			invent_research_seqno : invent_research_seqno,
			invent_nm : invent_nm,
			applicant_no : applicant_no,
			applicant_dt : applicant_dt
		},
		dataType : 'json',
		success : function(res) {
			alert("연구자 정보를 수정했습니다.");
			location.href = "/techtalk/researchMyPage.do";
		},
		error : function() {
			
		},
		complete : function() {
			
		}
	});
}

</script>
<div class="area_cont area_cont2" id="researcherlist">
	<div id="compaVcContent" class="cont_cv">
		<div id="mArticle" class="assig_app">
			<h2 class="screen_out">본문영역</h2>
			<div class="wrap_cont">
				<div class="area_tit">
					<h3 class="tit_corp">연구자 목록</h3>
					<div class="belong_box">
		                <dl class="belong_box_inner">
		                    <dt>소속</dt>
		                    <dd>${data.biz_name}</dd>
		                </dl>
	            	</div>            	
				</div>
				<div class="list_panel">
                   	<div class="cont_list">
						<div class="row col-box col3" onclick="detail();">
							<c:choose>
								<c:when test="${not empty data.researcher_nm}">
									<div class="col">
					               		<span class="row_txt_num blind">1</span>
					               		<span class="txt_left row_txt_tit">${data.researcher_nm} 연구자</span>
					               		<span class="re_beloong">${data.biz_name}</span>
					               		<ul class="tag_box">
					            	   		<li>${data. keyword}</li>
					               		</ul>
					               		<ul class="step_tech">
					        	       		<li><span class="mr txt_grey tech_nm ">${data.code_name1}</span></li>
					                   		<li><span class="mr txt_grey tech_nm ">${data.code_name2}</span></li>
					                   		<li><span class="mr txt_grey tech_nm ">${data.code_name3}</span></li>
					               		</ul>
					               		<input id="researcher_seqno" name="researcher_seqno" type="hidden" value="${data.researcher_seqno}">
				            		</div>
								</c:when>
								<c:otherwise>
									연구자가 확인되지 않았습니다. 로그인 해주세요.
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>	
</div>
<div class="wrap-loading" style="display:none;">
    <div><img src="/images/loading.gif" alt="로딩"/></div>
</div>
<div class="dim-layer">
    <div class="dimBg"></div>
    <div id="layer2" class="pop-layer" style="width:1260px; height:70%; overflow: auto;">
		<div id="compaVcContent" class="cont_cv" style="padding: 30px;">
			<div id="mArticle" class="assig_app" style="padding-bottom: 30px;">
				<h2 class="screen_out">본문영역</h2>
				<div class="wrap_cont">
					<!-- page_title s:  -->
					<div class="area_tit">
						<h3 class="tit_corp">연구자 상세정보</h3>
						<a href="javascript:void(0);" class="btn-layerClose" title="연구자정보"><span class="icon ico_close" title="팝업닫기">팝업닫기</span></a>
					</div>
					<!-- //page_title e:  -->
					<!-- page_content s:  -->
					<div class="area_cont">
						<div class="tbl_view tbl_public">
							<table class="tbl">
								<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);" >연구자 상세정보</caption>
								<colgroup>
									<col style="width: 10%">
									<col>
								</colgroup>
								<thead></thead>
								<tbody class="view">
									<tr>
										<th scope="col"><label for="re_nm">연구자</label></th>
										<td class="ta_left">
											<div class="form-control" style="max-width:100%;max-height:100%"><c:out value="${data.researcher_nm}"  escapeXml="false"/></div>
										</td>
										<th scope="" rowspan="3">연구자 소재 및 주요 연구분야</th>
										<td class="ta_left" rowspan="3">
											<textarea id="re_intro_field" name="re_intro_field"style="width: 100%;" rows="8" cols=""></textarea>
										</td>
									</tr>
									<tr>
										<th scope="col">기술분류</th>
										<td class="ta_left">
											<select id="selStdClassCd1" name="selStdClassCd1" onChange="fncChangeStd(this, 'mid');" title="기술분류1" style="width: 32%;">
												<option title="기술분류1" value="">선택</option>
												<c:forEach var="data" items="${codeList1}" varStatus="status">
													<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option> 
												</c:forEach>
											</select>
											<select id="selStdClassCd2" name="selStdClassCd2" onChange="fncChangeStd(this, 'sub');" title="기술분류2" style="width: 32%;">
												<option title="기술분류2" value="">선택</option>
												<c:forEach var="data" items="${codeList2}" varStatus="status">
													<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option> 
												</c:forEach>
											</select>
											<select id="selStdClassCd3" name="selStdClassCd3" disabled title="기술분류3" style="width: 32%;">
												<option title="기술분류3" value="">선택</option>
												<c:forEach var="data" items="${codeList3}" varStatus="status">
													<option title="${data.code_name}" value="${data.code_key}">${data.code_name}</option>
												</c:forEach>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="col">키워드</th>
										<td class="ta_left">
											<div class="form-control" style="max-width:100%;max-height:100%">
												<input type="text" id="keyword1" name="keyword1" style="text-align : center; width:18%; text-indent: 0;" title="키워드1" />
												<input type="text" id="keyword2" name="keyword2" style="text-align : center; width:18%; text-indent: 0;" title="키워드2" />
												<input type="text" id="keyword3" name="keyword3" style="text-align : center; width:18%; text-indent: 0;" title="키워드3" />
												<input type="text" id="keyword4" name="keyword4" style="text-align : center; width:18%; text-indent: 0;" title="키워드4" />
												<input type="text" id="keyword5" name="keyword5" style="text-align : center; width:18%; text-indent: 0;" title="키워드5" /> 
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
							<h4>국가 과제 수행 이력</h4>
						</div>
						<div class="tbl_comm tbl_public">
							<table class="tbl" id="tbl2">
								<caption class="caption_hide">국가 과제 수행 이력</caption>
								<colgroup>
									<col>
									<col>
									<col>
								</colgroup>
								<thead>
									<tr>
										<th>과제명</th>
										<th>과제관리기관</th>
										<th>연구기간</th>
									</tr>
								</thead>
								<tbody id="proData" name="proData">
								<c:choose>
									<c:when test="${not empty proData[0].re_project_nm }">
									<c:forEach var="projectData" items="${proData}" end="4">
										<tr>
											<td class="ta_left">${projectData.re_project_nm}</td>
											<td>${projectData.re_institu_nm}</td>
											<td>${projectData.re_start_date} ~ ${projectData.re_end_date}</td>
										</tr>
									</c:forEach>
									</c:when>
									<c:otherwise>
										<td colspan="3">국가 과제 수행 이력이 확인되지 않았습니다.</td>
									</c:otherwise>
								</c:choose>
								</tbody>
							</table>
							<a href="javascript:void(0);" onclick="moreProContens();" id="moreProButton" title="더보기" class="btn-more">+ 더보기</a>
							<a href="javascript:void(0);" onclick="lessProContens();" id="lessProButton" title="줄이기" class="btn-more">- 줄이기</a>
						</div>
					</div>
					
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>연구 히스토리</h4>
						</div>
						<div class="tbl_comm tbl_public history_tbl_wrap">
							<table class="tbl history_tbl" id="tbl_history">
								<caption class="caption_hide">연구 히스토리</caption>
								<c:choose>
									<c:when test="${not empty dataHis[0].his_date}">
										<c:forEach var="listHis" items="${dataHis}">
										<colgroup>
											<col>
										</colgroup>
											<thead>
												<tr>
												<c:set var="his_date" value="${listHis.re_start_date}" />
													<th style="width: 100%;">${fn:substring(his_date,0,4)}</th>
												</tr>
											</thead>
											<tbody>
												<tr>
													<td>${listHis.keyword}</td>
												</tr>
											</c:forEach>
									</c:when>
									<c:otherwise>
										등록된 연구 히스토리가 없습니다.
									</c:otherwise>
								</c:choose>
								</tbody>
							</table>
							</div>
					</div>
					
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>유사분야 연구자</h4>
						</div>
						<div class="cont_list2">
							<div class="row col-box col3">
							<c:choose>
								<c:when test="${not empty similData }">
								<c:forEach var="similData" items="${similData}" end="2">
									<div class="col">
				                         <span class="row_txt_num blind">1</span>
				                         <span class="txt_left row_txt_tit">${ similData. research_nm } 연구자</span>
				                         <span class="re_beloong">${ similData. applicat_nm }</span>
				                         <ul class="tag_box">
				                             <li>${ similData. keyword }</li>
				                         </ul>
				                         <ul class="step_tech">
				                             <li><span class="mr txt_grey tech_nm ">${ similData. tech_nm1 }</span></li>
				                             <li><span class="mr txt_grey tech_nm ">${ similData. tech_nm2 }</span></li>
				                             <li><span class="mr txt_grey tech_nm ">${ similData. tech_nm3 }</span></li>
				                         </ul>
				                     </div>
								</c:forEach>
								</c:when>
								<c:otherwise>
									유사분야 연구자가 확인되지 않았습니다.
								</c:otherwise>
							</c:choose>
							</div>
						</div>
					</div>
					
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>특허리스트</h4>
						</div>
						<div class="tbl_comm tbl_public">
							<table class="tbl" id="tbl3">
								<caption class="caption_hide">특허리스트</caption>
								<colgroup>
									<col style='width:60%'/>
									<col>
									<col>
								</colgroup>
								<thead>
									<tr>
										<th>발명의 명칭</th>
										<th>출원번호</th>
										<th>출원일</th>
									</tr>
								</thead>
								<tbody>
								<c:choose>
									<c:when test="${not empty invent[0].invent_nm }">
									<c:forEach var="invent" items="${invent}" end="4">
										<tr>
											<td class="ta_left">
												<input type="hidden" id="invent_research_seqno" name="invent_research_seqno" value="${invent.research_seqno}">
												<input type="text" id="invent_nm" name="invent_nm" title="발명의 명칭" value="${invent.invent_nm}"/>
											</td>
											<td><input type="text" id="applicant_no" name="applicant_no" title="출원번호" value="${invent.application_no}"/></td>
											<td><input type="date" id="applicant_dt" name="applicant_dt" class="form-control" title="출원일" value="${invent.applicant_date}"/></td>			
										</tr>
									</c:forEach>
									</c:when>
									<c:otherwise>
										<td colspan="3">특허리스트가 확인되지 않았습니다.</td>
									</c:otherwise>
								</c:choose>
								</tbody>
							</table>
							<a href="javascript:void(0);" onclick="morePatentContens();" id="morePatentButton" class="btn-more">+ 더보기</a>
							<a href="javascript:void(0);" onclick="lessPatentContens();" id="lessPatentButton"  class="btn-more">- 줄이기</a>
						</div>
					</div>
					<!-- //page_content e:  -->
					<div class="tbl_public">
                	<div style="text-align:center;margin-top:40px;">
                		<button type="button" onClick="doUpdate();" class="btn_step" title="수 정">수정</button>
                		<button type="button" onClick="$('.dim-layer').fadeOut();" class="btn_step" title="취소">취소</button>
                	</div>
				</div>
				</div>
			</div>
		</div>       
    </div>
</div>