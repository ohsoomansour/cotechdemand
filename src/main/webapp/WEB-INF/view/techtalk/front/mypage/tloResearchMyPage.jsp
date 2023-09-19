<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script>
var invent = new Array();
var proData = new Array();

$(document).ready(function() {
	//체크박스 변경 - 2023/09/18
    $("input:checkbox").change(function(){
      if(this.checked){
        $(this).attr('value', 'Y');
      }else{
        $(this).attr('value', 'N');    
      }
    });

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

	for(var i = 0; i < proData.length; i++) {
		var item ={};
		item.re_project_nm = proData[i].re_project_nm;
		item.re_institu_nm = proData[i].re_institu_nm;
		item.re_start_date = proData[i].re_start_date;
		item.re_end_date = proData[i].re_end_date;
		list.push(item);
	}
	
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

	for(var i = 0; i < proData.length; i++) {
		var item ={};
		item.re_project_nm = proData[i].re_project_nm;
		item.re_institu_nm = proData[i].re_institu_nm;
		item.re_start_date = proData[i].re_start_date;
		item.re_end_date = proData[i].re_end_date;
		list.push(item);
	}
	
	proContens(5);
}

//특허리스트 더보기 이벤트
function morePatentContens(){
	list = new Array();
	
	for(var i = 0; i < invent.length; i++) {
		var item ={};
		item.research_seqno = invent[i].research_seqno;
		item.invent_nm = invent[i].invent_nm;
		item.applicant_no = invent[i].application_no;
		item.applicant_dt = invent[i].applicant_date;
		list.push(item);
	}
	
	patentContens(list.length);
}

//특허리스트 줄이기 이벤트
function lessPatentContens(){
	list = new Array();

	for(var i = 0; i < invent.length; i++) {
		var item ={};
		item.research_seqno = invent[i].research_seqno;
		item.invent_nm = invent[i].invent_nm;
		item.applicant_no = invent[i].application_no;
		item.applicant_dt = invent[i].applicant_date;
		list.push(item);
	}
	
	patentContens(5);
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
						ahtml +=	"<td class='ta_left'><input type='text' id='applicant_dt' name='applicant_dt' title='출원일' value='"+list[i].applicant_dt+"'/></td>"
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

//목록저장 - 2023/09/18 
function doSave(e) {
	var researcher_list = $('input:checkbox[name="chk"]').length;

	var researcher_seqno = new Array(researcher_list);
	var view_yn = new Array(researcher_list);

	for(var i=0; i<researcher_list; i++){                          
		researcher_seqno[i] = $('input:checkbox[name="chk"]').eq(i).attr('id');
		view_yn[i] = $('input:checkbox[name="chk"]').eq(i).val();
	}
	
	$.ajax({
		type : 'POST',
		url : '/techtalk/doSaveList.do',
		data : {
			researcher_seqno : researcher_seqno,
			view_yn : view_yn
		},
		dataType : 'json',
		success : function(res) {
			alert("저장되었습니다.");
			location.href = "/techtalk/tloResearchMyPage.do";
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

//상세보기 layer - 2023/09/15 
function layer_popup(el, type){
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

//이메일 도메인변경 - 2023/09/15
function fncChangeEmail(obj){
	var selValue = obj.value;
	if(selValue == "직접입력" || selValue == ""){
		$('#manager_mail2').val("");
	}else{
		$('#manager_mail2').val(selValue);
	}
}

//기술분류 변경 - 2023/09/15
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
			url : '/techtalk/deGetCodeList.do',
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

function detail(seq) {
	invent = new Array();
	proData = new Array();
	
	$.ajax({
		type : 'POST',
		url : '/techtalk/tloDetail.do',
		data : {
			researcher_seqno : seq
		},
		dataType : 'json',
		success : function(res) {
			var result = res;
			invent = result.invent;
			proData = result.proData;
			
			console.log(result.dataHis);
			//연구자 이름
			$('#re_name').empty();
			$('#re_name').append(result.data.researcher_nm);

			//기술분류
			$("#selStdClassCd3").attr("disabled","disabled");
			
		    $('#selStdClassCd1').val(result.data.tech_code1);
		    $('#selStdClassCd2').val(result.data.tech_code2);   
		    $('#selStdClassCd3').val(result.data.tech_code3);
			
			//연구자소개
			$('#re_intro_field').empty();
			$('#re_intro_field').val(result.data.re_intro_field);
			
			//키워드
			$('#keyword1').empty();
			$('#keyword1').val(result.data.keyword1.trim());
			$('#keyword2').empty();
			$('#keyword2').val(result.data.keyword2.trim());
			$('#keyword3').empty();
			$('#keyword3').val(result.data.keyword3.trim());
			$('#keyword4').empty();
			$('#keyword4').val(result.data.keyword4.trim());
			$('#keyword5').empty();
			$('#keyword5').val(result.data.keyword5.trim());

			//국가과제수행이력
			if(result.proData.length > 0) {
				var count = (result.proData.length > 5) ? 5 : result.proData.length;
				var aHtml = "";

				for(var i=0; i < count; i++) {
					aHtml +="<tr>"
					aHtml +=	"<td class='ta_left'>" + proData[i].re_project_nm +"</td>"
					aHtml +=	"<td>" + proData[i].re_institu_nm + "</td>"
					aHtml +=	"<td>" + proData[i].re_start_date + " ~ " +  proData[i].re_end_date + "</td>"
					aHtml +="<tr>";
					
					$('#proData').empty();
			    	$('#proData').append(aHtml);
				}
			}

			//연구히스토리
			if(result.dataHis.length > 0) {	
				var aHtml = "";	
				$.each(result.dataHis, function(key, dataHis){
					aHtml += "<thead>"
					aHtml += "<tr><th style='width: 100%;'>" + dataHis.his_date + "</th></tr>"
					aHtml += "</thead>"
					aHtml += "<tbody>"
					aHtml += "<tr><td>" + dataHis.keyword + "</td></tr>"	
					aHtml += "</tbody>"
						
					$('#tbl_history').empty();
					$('#tbl_history').append(aHtml);
				});
			}
			
			//유사연구자
			if(result.similData.length > 0) {	
				var aHtml = "";	
				$.each(result.similData, function(key, simil){
					aHtml += "<div class='col'>"
					aHtml += "<span class='row_txt_num blind'>11111</span>"
					aHtml += "<span class='txt_left row_txt_tit'>" + simil.research_nm + "</span>"
					aHtml += "<span class='re_beloong'>"+ simil.applicant_nm + "</span>"
					aHtml += "<ul class='tag_box'>"
					aHtml += "<li>"+ simil.keyword  +"</li>"
					aHtml += "</ul>"
					aHtml += "<ul class='step_tech'>"
					aHtml += "<li><span class='mr txt_grey tech_nm'>" + simil.tech_nm1 + "</span></li>"
					aHtml += "<li><span class='mr txt_grey tech_nm'>" + simil.tech_nm2 + "</span></li>"
					aHtml += "<li><span class='mr txt_grey tech_nm'>" + simil.tech_nm3 + "</span></li>"
					aHtml += "</ul>"
					aHtml += "</div>";	
						
					$('#simil').empty();
					$('#simil').append(aHtml);
				});
			}
		
			//특허리스트
			if(result.invent.length > 0) {
				var count = (result.invent.length > 5) ? 5 : result.invent.length;
				var aHtml = "";

				for(var i=0; i < count; i++) {
					aHtml +="<tr>"
					aHtml +=	"<td class='ta_left'><input type='hidden' id='invent_research_seqno' name='invent_research_seqno' title='발명의 명칭' value='"+invent[i].research_seqno+"'/><input type='text' id='invent_nm' name='invent_nm' title='발명의 명칭' value='"+invent[i].invent_nm+"'/></td>"
					aHtml +=	"<td class='ta_left'><input type='text' id='applicant_no' name='applicant_no' title='출원번호' value='"+invent[i].application_no+"'/></td>"
					aHtml +=	"<td class='ta_left'><input type='text' id='applicant_dt' name='applicant_dt' title='출원일' value='"+invent[i].applicant_date+"'/></td>"
					aHtml +="<tr>";
					
					$('#invent').empty();
			    	$('#invent').append(aHtml);
				}
			}
			
			//담당자 정보
			$('#manager_demand').empty();
			$('#manager_demand').val(result.data.manager_demand);

			$('#manager_rank').empty();
			$('#manager_rank').val(result.data.manager_rank);
			
			$('#manager_name').empty();
			$('#manager_name').val(result.data.manager_name);
			
			$('#manager_tel1').empty();
			$('#manager_tel1').val(result.data.manager_mobile_no.split('-')[0]);

			$('#manager_tel2').empty();
			$('#manager_tel2').val(result.data.manager_mobile_no.split('-')[1]);

			$('#manager_tel3').empty();
			$('#manager_tel3').val(result.data.manager_mobile_no.split('-')[2]);
			
			$('#manager_mail1').empty();
			$('#manager_mail1').val(result.data.manager_email.split('@')[0]);

			$('#manager_mail2').empty();
			$('#manager_mail2').val(result.data.manager_email.split('@')[1]);
			
			layer_popup('#layer2');
		},
		error : function() {
			
		},
		complete : function() {
			
		}
	});	
}	
</script>
<!-- compaVcContent s:  -->
<form action="#" id="frm" name="frm" method="post">
<input type="hidden" name="page" id="page" value="${paraMap.page}" />
<input type="hidden" name="sidx" id="sidx" value="${paraMap.sidx}" />
<input type="hidden" name="sord" id="sord" value="${paraMap.sord}" />
<input type="hidden" name="list" id="list" />
<div id="compaVcContent" class="cont_cv">
	<div id="mArticle" class="assig_app">
		<h2 class="screen_out">본문영역</h2>
		<div class="wrap_cont">
            <!-- page_title s:  -->
			<div class="area_tit">
				<h3 class="tit_corp">연구자 목록</h3>
                <div class="belong_box">
	                <dl class="belong_box_inner">
	                    <dt>소속</dt>
	                    <dd>${biz_name}</dd>
	                </dl>
	            </div>
			</div>
			<div class="area_cont">
				<div class="list_panel" id="tbl">
					<div class="cont_list">
						<div class="list_top">
							<p>count : ${totalCount}건</p>
							<div class="list_top_util ">
								<div class="search_box_inner">
									<div class="btn_box">
										<button type="button" class="btn_default" onClick="javascript:filter();" title="필터">
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
							<c:when test="${not empty data[0].researcher_seqno}">
								<c:forEach var="data" items="${data}">
								<div class="row" onclick="<c:if test="${paraMap.list ne 'all'}">detail(${data.researcher_seqno});</c:if>">
									<c:if test="${paraMap.list eq 'all'}">
										<span class="box_checkinp">
				            				<input type="checkbox" class="inp_check" value="${data.view_yn}" id="${data.researcher_seqno}" name="chk" title="표출유무" <c:if test="${data.view_yn eq 'Y'}">checked</c:if>>
				                		</span>
			                		</c:if>
									<span class="txt_left row_txt_tit">${data.researcher_nm} 연구자 </span>
									<span class="update_date">최근 업데이트 일자 : ${data.applicant_date}</span>
									<span class="re_beloong">${data.biz_name}</span>
									<ul class="tag_box">
					            	   	<li>${data. keyword}</li>
					               	</ul>
									<ul class="step_tech">
										<li><span class="mr txt_grey tech_nm ">${data.code_name1}</span></li>
										<li><span class="mr txt_grey tech_nm ">${data.code_name2}</span></li>
										<li><span class="mr txt_grey tech_nm ">${data.code_name3}</span></li>
									</ul>
								</div>
								</c:forEach>
							</c:when>
							<c:otherwise>
									<span>연구자가 없습니다.</span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<!-- paging -->
				<div class="paging_comm">${sPageInfo}</div>
           	</div>
			<!-- //page_content e:  -->
		</div>
	</div>
</div>
</form>
<!-- //compaVcContent e:  -->
<div class="wrap-loading" style="display:none;">
    <div><img src="/images/loading.gif" alt="로딩"/></div>
</div>
<div class="dim-layer">
    <div class="dimBg"></div>
    <div id="layer2" class="pop-layer" style="width:65%; height:70%; overflow: auto;">
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
											<div class="form-control" style="max-width:100%;max-height:100%" id="re_name"></div>
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
										<td colspan="3">국가 과제 수행 이력이 확인되지 않았습니다.</td>
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
								<tbody>
									<tr>
										<td>연구히스토리가 없습니다.</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>유사분야 연구자</h4>
						</div>
						<div class="cont_list2">
							<div class="row col-box col3" id="simil">	
								<div>유사분야 연구자가 없습니다.</div>
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
								<tbody id="invent">
									<td colspan='3'>특허리스트가 확인되지 않았습니다.</td>
								</tbody>
							</table>
							<a href="javascript:void(0);" onclick="morePatentContens();" id="morePatentButton" class="btn-more">+ 더보기</a>
							<a href="javascript:void(0);" onclick="lessPatentContens();" id="lessPatentButton"  class="btn-more">- 줄이기</a>
						</div>
					</div>
					
					<div class="area_cont area_cont2">
						<div class="subject_corp">
							<h4>담당자 정보</h4>
						</div>
						<div class="tbl_view tbl_public">
							<table class="tbl">
								<caption style="position:absolute !important;  width:1px;  height:1px; overflow:hidden; clip:rect(1px, 1px, 1px, 1px);" >담당자 정보</caption>
								<colgroup>
									<col style="width: 10%">
									<col>
								</colgroup>
								<thead></thead>
								<tbody class="view">
									<tr>
										<th scope="col"><label for="re_belong">소속</label></th>
										<td class="ta_left">
											<div class="form-control" style="max-width:100%;max-height:100%"><input type="text" style="width: 50%;" id="manager_demand" name="manager_demand" title="담당자 소속"/></div>
										</td>
									</tr>
									<tr>
										<th scope="col">직책</th>
										<td class="ta_left"><input type="text" style="width: 50%;" id="manager_rank" name="manager_rank" title="담당자 직책"/></td>
									</tr>
									<tr>
										<th scope="col">이름</th>
										<td class="ta_left"><input type="text" style="width: 50%;" id="manager_name" name="manager_name" title="담당자 이름"/></td>
									</tr>
									<tr>
										<th scope="col">연락처</th>
										<td class="ta_left">
											<div class="form-control" style="max-width:100%;max-height:100%">
												<input type="text" style="width: 16%;" id="manager_tel1" name="manager_tel1" title="담당자 번호1"/> -
												<input type="text" style="width: 16%;" id="manager_tel2" name="manager_tel2" title="담당자 번호2"/> - 
												<input type="text" style="width: 16%;" id="manager_tel3" name="manager_tel3" title="담당자 번호3"/>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="col">이메일</th>
										<td class="ta_left">
											<div class="form-control" style="max-width:100%;max-height:100%">
												<input type="text" id="manager_mail1" name="manager_mail1" style="width: 15%;" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" maxlength="30" title="이메일아이디"> @
			                                    <input type="text" id="manager_mail2" name="manager_mail2" style="width: 20%;" onkeyup="this.value=this.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');" maxlength="30" title="이메일 도메인 직접입력">
			                                    <select class="form-control form_email3" id="manager_mail3" name="manager_mail3" onChange="fncChangeEmail(this);" title="이메일 도메인 선택">
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
					<!-- //page_content e:  -->
					<div class="tbl_public">
                	<div style="text-align:center;margin-top:40px;">
                		<form id="uploadForm" enctype="multipart/form-data">
                			<input type="file" id="excelFile" name="excelFile" accept=".xls,.xlsx,.csv">
                		</form>
                		<button type="button" id="updateExcel" name=updateExcel"" onClick="doupdateExcel();" class="btn_step" title="엑셀데이터 입력">엑셀데이터 입력</button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                		<button type="button" onClick="doUpdate();" class="btn_step" title="수 정">수정</button>
                		<button type="button" onClick="$('.dim-layer').fadeOut();" class="btn_step" title="취소">취소</button>
                	</div>
				</div>
				</div>
			</div>
		</div>       
    </div>
</div>